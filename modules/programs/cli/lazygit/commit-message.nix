{
  flake.aspects = { cli.provides.lazygit.homeManager = { lib, pkgs, ... }: {
    programs.lazygit = {
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
                    MODEL="''${OLLAMA_COMMIT_MODEL:-"qwen3.5:9b"}"
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
                    cat <<'EOF'
                    You are a git commit message generator.
                    Analyze the staged git diff and write a concise Conventional Commits message.

                    Type selection rules (choose the most accurate one):
                    - feat: adding new functionality, new options/features, or new workflows (even in config or scripts).
                    - fix: fixing a bug, error, crash, or broken behavior.
                    - refactor: restructuring code or configuration without changing external behavior or adding features.
                    - chore: maintenance, dependencies, formatting, or minor tweaks with no functional change.
                    - docs: documentation or comments only.

                    Formatting rules:
                    - Output ONLY the commit message text. Do NOT wrap in markdown code blocks or backticks.
                    - First line: <type>(<scope>): <concise summary in imperative mood>, ideally <= 72 characters.
                    - Describe the actual purpose/effect (e.g. "disable thinking and cap output tokens..."), not just "add options".
                    - Add a blank line followed by short bullet points ONLY if there are multiple distinct changes.

                    Staged diff:
                    EOF
                    )
                    PROMPT="$PROMPT"$'\n'"$DIFF_TRIMMED"

                    PAYLOAD=$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" '{
                      model: $model,
                      prompt: $prompt,
                      stream: false,
                      think: false,
                      options: {
                        temperature: 0.2,
                        num_predict: 120
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

};
}
