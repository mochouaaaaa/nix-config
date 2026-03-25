{
  lib,
  pkgs,
  config,
  myvars,
  username,
  ...
}:
{

  home.activation = {
    git_allowed_signers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PUB_KEY="${config.home.homeDirectory}/.ssh/github.pub"
      PRIV_KEY="${config.home.homeDirectory}/.ssh/github"

      if [ ! -f "$PUB_KEY" ] && [ -f "$PRIV_KEY" ]; then
        echo "Detection: github.pub missing. Generating from private key..."
        ${pkgs.openssh}/bin/ssh-keygen -y -f "$PRIV_KEY" > "$PUB_KEY"
        chmod 644 "$PUB_KEY"
      fi

      echo "${myvars.useremail} $(cat ~/.ssh/github.pub)" > ${config.xdg.configHome}/git/allowed-signers
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
        "# General"
        ".AppleDouble"
        ".LSOverride"

        "# Thumbnails"
        "._*"

        "# Files that might appear in the root of a volume"
        ".Trash-1000"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"

        "# Directories potentially created on remote AFP share"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"

        "# Folder view configuration files"
        ".DS_Store"
        "Desktop.ini"

        "# Thumbnail cache files"
        "._*"
        "Thumbs.db"

        "# Files that might appear on external disks"
        ".Spotlight-V100"
        ".Trashes"

        "# Compiled Python files"
        "__pycache__/"
        "*.pyc"

        "# Compiled C++ files"
        "*.out"

        "# Application specific files"
        "venv/"
        "node_modules/"
        ".sass-cache"

        "# Temp File"
        "*.swp"
        "*.swa"
        "*.swo"

        "# github merge file"
        "*.orig"

        "#vscode"
        ".vscode/"

        ".idea"

        "# direnv"
        ".direnv/"
      ];

      settings = {

        user = {
          name = username;
          email = myvars.useremail;
        };

        init.defaultBranch = "main";
        trim.bases = "develop,master,main"; # for git-trim
        push.autoSetupRemote = true;
        pull.rebase = true;

        gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed-signers";

        # replace https with ssh
        url = {
          "ssh://git@github.com/${username}" = {
            insteadOf = "https://github.com/mochouaaaaa";
          };
        };
      };

    };

    # A syntax-highlighting pager in Rust(2019 ~ Now)
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
      };
    };

  };
}
