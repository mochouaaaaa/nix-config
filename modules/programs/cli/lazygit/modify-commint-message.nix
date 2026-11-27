{
  flake.aspects."programs.lazygit"."homeManager" = { pkgs, ... }: {
    programs.lazygit =
      let
        aiRewordScript = pkgs.writeShellScript "lazygit-ai-reword" ''
          set -euo pipefail

          hash="$1"
          if [ -z "$hash" ]; then
          echo "No commit selected"
          exit 1
          fi

          # 限制 diff 长度（约 12KB），防止大提交撑爆本地 7B 模型上下文
          diff_content=$(git show "$hash" --stat -p | head -c 12000)

          prompt="Generate ONLY a concise Conventional Commits message (type(scope): subject) for the following git commit diff. Output ONLY the commit message text, no markdown code blocks, no quotes, no explanations:

          $diff_content"

          # 调用本地 Ollama 生成（如想改用 Gemini API，可替换为 curl 请求）
          msg=$(printf "%s" "$prompt" | ollama run qwen2.5-coder:7b | sed -e 's/^```.*//' -e 's/```$//' -e '/^[[:space:]]*$/d' | head -n 5)

          if [ -z "$msg" ]; then
          echo "AI returned empty message"
          exit 1
          fi

          # 写入临时文件并用编辑器打开确认，防止直接覆盖重要历史
          tmp_file=$(mktemp /tmp/git-reword-XXXXXX.txt)
          printf "%s\n" "$msg" > "$tmp_file"
          ''${EDITOR:-nvim} "$tmp_file"

          final_msg=$(cat "$tmp_file")
          rm -f "$tmp_file"

          if [ -z "$final_msg" ]; then
          echo "Aborted: empty commit message"
          exit 1
          fi

          # 情况 1：如果是最新提交（HEAD），直接 amend（最快且不触发 rebase）
          if [ "$hash" = "$(git rev-parse HEAD)" ]; then
          git commit --amend -m "$final_msg"
          else
          # 情况 2：如果是更早的历史提交，用非交互式 sequence editor + message editor 精准重写该提交
          msg_file=$(mktemp /tmp/git-reword-msg-XXXXXX.txt)
          printf "%s\n" "$final_msg" > "$msg_file"
          short_hash=$(git rev-parse --short "$hash")

          GIT_SEQUENCE_EDITOR="sed -i '0,/^pick $short_hash/s/^pick /reword /'" \
          GIT_EDITOR="cp '$msg_file'" \
          git rebase -i "$hash~"

          rm -f "$msg_file"
          fi
        '';
      in
      {
        settings.customCommands = [
          {
            key = "<c-g>";
            context = "commits";
            description = "Regenerate commit message with AI and reword";
            loadingText = "Generating AI commit message...";
            command = "${aiRewordScript} {{.SelectedLocalCommit.Hash}}";
            output = "terminal";
          }
        ];
      };
  };
}
