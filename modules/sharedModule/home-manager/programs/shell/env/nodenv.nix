{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.envs.nodenv;
in
{

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yarn
      pnpm
      fnm

      (pkgs.writeShellScriptBin "fnm-unlock" ''
        rm $PWD/.node-version
      '')

      (pkgs.writeShellScriptBin "fnm-lock" ''
        set -euo pipefail

        fzf=${lib.getExe pkgs.fzf}
        fnm=${lib.getExe pkgs.fnm}

        versions=$($fnm list |
          sed -E 's/^[*[:space:]]*//; s/ ->.*//; s/ \(default\)//; s/ .*//' |
          grep '^v'
        )

        if [ -z "$versions" ]; then
          echo "No Node versions installed via fnm."
          exit 1
        fi

        selected=$(echo "$versions" | $fzf --prompt="Select Node version > ")
        if [ -z "$selected" ]; then
          echo "No version selected."
          exit 1
        fi

        echo "$selected" > .node-version
        echo "✅ Locked Node version to $selected"
      '')
    ];

    programs.zsh.initContent = lib.mkOrder 2150 ''
      export FNM_DIR="$HOME/.config/env/fnm"
      # FNM_PATH=FNM_DIR
      # if [ -d "$FNM_PATH" ]; then
        # export PATH="$FNM_PATH:$PATH"
        eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
      # fi
    '';
  };
}
