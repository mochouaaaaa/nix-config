{
  self,
  config,
  lib,
  pkgs,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  home.packages = with pkgs; [ emojify ];

  programs = {
    gh = {
      enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;

      userName = self.myvars.userfullname;
      userEmail = self.myvars.useremail;

      ignores = [
        "# General"
        ".AppleDouble"
        ".LSOverride"

        "# Thumbnails"
        "._*"

        "# Files that might appear in the root of a volume"
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
        "env/"

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

      extraConfig = {
        init.defaultBranch = "main";
        trim.bases = "develop,master,main"; # for git-trim
        push.autoSetupRemote = true;
        pull.rebase = true;

        # core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        pager.log = "emojify";

        # replace https with ssh
        url = {
          "ssh://git@github.com/${self.myvars.userfullname}" = {
            insteadOf = "https://github.com/mochouaaaaa";
          };
        };
      };

      # A syntax-highlighting pager in Rust(2019 ~ Now)
      delta = {
        enable = true;
        options = {
          diff-so-fancy = true;
          line-numbers = true;
          true-color = "always";
          # features => named groups of settings, used to keep related settings organized
          # features = "";
        };
      };
    };
  };
}
