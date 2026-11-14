{
  flake.modules.homeManager."cli.git" =
    {
      lib,
      pkgs,
      config,

      username,
      myvars,
      ...
    }:
    {
      home.activation.git_allowed_signers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

      programs = {
        gh.enable = true;

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

            # Applications
            "venv/"
            "node_modules/"
            ".sass-cache"

            # Temporary files
            "*.swp"
            "*.swa"
            "*.swo"
            "*.orig"

            # Editors
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
}
