{
  flake.modules.homeManager.programs = { pkgs, lib, ... }: {
    programs.lazygit = {
      enable = true;
      shellWrapperName = "lazygit";
      settings = {
        customCommands = [
          {
            key = "<c-g>";
            context = "files";
            description = "AI generate commit message (Ollama)";
            output = "terminal";
            command =
              let
                lazygit-ai-commit = pkgs.writeShellApplication {
                  name = "lazygit-ai-commit";
                  runtimeInputs = with pkgs; [
                    curl
                    jq
                    git
                    gnused
                    coreutils
                  ];
                  text = ''
                    MODEL="''${OLLAMA_COMMIT_MODEL:-"qwen2.5-coder:7b-instruct-q8_0"}"
                    OLLAMA_URL="''${OLLAMA_HOST:-"http://localhost:11434"}/api/generate"

                    # 检查是否有暂存区改动
                    DIFF=$(git diff --cached -- . ':!*.lock' ':!*package-lock.json' ':!*pnpm-lock.yaml' ':!*yarn.lock' ':!*flake.lock')
                    if [ -z "$DIFF" ]; then
                        echo "没有已暂存（staged）的改动，请先在 lazygit 中用 Space 暂存文件。" >&2
                        exit 1
                    fi

                    # 防止超大 diff 把上下文撑爆（按需调整字符上限）
                    DIFF_TRIMMED=$(printf "%s" "$DIFF" | head -c 16000)

                    PROMPT=$(
                        cat <<EOF
                    You are a git commit message generator.
                    Analyze the staged git diff below and write a concise Conventional Commits message (e.g. feat:, fix:, refactor:, chore:, docs:).
                    Rules:
                    - Output ONLY the commit message text. Do NOT wrap in markdown code blocks or backticks.
                    - First line: clear summary in imperative mood, ideally <= 72 characters.
                    - Add a short body only if there are multiple distinct changes or non-obvious context.

                    Staged diff:
                    $DIFF_TRIMMED
                    EOF
                    )

                    PAYLOAD=$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" '{
                      model: $model,
                      prompt: $prompt,
                      stream: false,
                      options: {
                        temperature: 0.2
                      }
                    }')

                    MSG=$(
                    curl -sf "$OLLAMA_URL" -d "$PAYLOAD" \
                        | jq -r '
                            (.response // empty)
                            | gsub("^```[a-zA-Z]*\\n?|\\n?```$"; "")
                            | gsub("^\\s+|\\s+$"; "")
                        '
                    )

                    if [ -z "$MSG" ]; then
                        echo "Ollama 未返回有效 commit message，请检查 ollama 服务与模型是否可用。" >&2
                        exit 1
                    fi

                    TMP_MSG=$(mktemp)
                    trap 'rm -f "$TMP_MSG"' EXIT
                    printf "%s\n" "$MSG" >"$TMP_MSG"

                    git commit -e -F "$TMP_MSG"

                  '';
                };
              in
              "${lib.getExe lazygit-ai-commit}";
          }
        ];
      };
    };
  };
}
