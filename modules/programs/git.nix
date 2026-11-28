{
  flake.aspects.cli.provides.git.homeManager =
    {
      config,
      pkgs,

      username,
      myvars,
      ...
    }:
    {

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

      programs.neovim = {
        plugins = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (p: [
            p.git_config
            p.gitcommit
            p.git_rebase
            p.gitignore
            p.gitattributes
          ]))
        ];
      };

    };
}
