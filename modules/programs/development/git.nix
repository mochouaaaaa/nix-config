{
  flake.modules.homeManager.programs =
    {
      lib,
      pkgs,
      config,

      username,
      myvars,
      ...
    }:
    {

      home.activation = {
        git_allowed_signers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PUB_KEY="${config.home.homeDirectory}/.ssh/github.pub"
          PRIV_KEY="${config.home.homeDirectory}/.ssh/github"
          SIGNERS_FILE="${config.xdg.configHome}/git/allowed-signers"

          mkdir -p "${config.xdg.configHome}/git"

          if [ ! -f "$PUB_KEY" ] && [ -f "$PRIV_KEY" ]; then
            echo "Detection: github.pub missing. Generating from private key..."
            ${pkgs.openssh}/bin/ssh-keygen -y -f "$PRIV_KEY" > "$PUB_KEY"
            chmod 644 "$PUB_KEY"
          fi

          if [ -f "$PUB_KEY" ]; then
            echo "${myvars.useremail} $(cat "$PUB_KEY")" > "$SIGNERS_FILE"
          else
            echo "Warning: $PUB_KEY not found, skipping allowed-signers generation" >&2
          fi
        '';
      };

      programs = {
        gh = {
          enable = true;
        };

        git = {
          enable = true;
          lfs.enable = true;

          signing = {
            key = "${config.home.homeDirectory}/.ssh/github.pub";
            signByDefault = true;
            format = "ssh";
          };

          ignores = [
            # macOS
            ".AppleDouble"
            ".LSOverride"
            "._*"
            ".DS_Store"
            ".Spotlight-V100"
            ".Trashes"
            ".fseventsd"
            ".TemporaryItems"
            ".VolumeIcon.icns"
            ".com.apple.timemachine.donotpresent"
            ".AppleDB"
            ".AppleDesktop"
            "Network Trash Folder"
            "Temporary Items"
            ".apdisk"
            ".Trash-1000"
            ".DocumentRevisions-V100"

            # Windows
            "Desktop.ini"
            "Thumbs.db"

            # Python
            "__pycache__/"
            "*.pyc"

            # C++
            "*.out"

            # 应用
            "venv/"
            "node_modules/"
            ".sass-cache"

            # 临时文件
            "*.swp"
            "*.swa"
            "*.swo"
            "*.orig"

            # 编辑器
            ".vscode/"
            ".idea"

            # direnv
            ".direnv/"
          ];

          settings = {
            user = {
              name = username;
              email = myvars.useremail;
            };

            init.defaultBranch = "main";
            trim.bases = "develop,master,main";
            push.autoSetupRemote = true;
            pull.rebase = true;

            gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed-signers";

            # 把 GitHub 用户名变量用于 insteadOf，避免两处硬编码
            url = {
              "ssh://git@github.com/${myvars.githubUsername}" = {
                insteadOf = "https://github.com/${myvars.githubUsername}";
              };
            };
          };
        };

        delta = {
          enable = true;
          options = {
            side-by-side = true;
            line-numbers = true;
            true-color = "always";
          };
        };
      };

    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation =
        lib.optionalAttrs config.home-manager.users.${username}.programs.git.enable
          {
            users.${username}.directories = [
              ".config/github-copilot"
            ];
          };
    };

}
