{
  flake.modules.darwin.homebrew =
    { self, username, ... }:
    {
      imports = [ self.modules.darwin.programs ];

      # Homebrew mirrors are only relevant when Homebrew is enabled.
      environment.variables = {
        HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
        HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
        HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
      };

      # Homebrew need to be installed manually, see https://brew.sh
      # https://github.com/LnL7/nix-darwin/blob/master/modules/homebrew.nix
      homebrew = {
        enable = true; # Disable Homebrew for fast deploy.

        onActivation = {
          autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo.
          upgrade = false; # Upgrade outdated casks, formulae, and App Store apps.
          # 'zap': uninstalls all formulae (and related files) not listed in the generated Brewfile.
          cleanup = "none";
        };

        # Applications to install from Mac App Store using mas.
        # Install these Apps manually first so that your Apple account has records for them.
        # Otherwise Apple Store may refuse to install them.
        # For details, see https://github.com/mas-cli/mas
        masApps = {
          # Wechat = 836500024;
          # WeCom = 1189898970; # Wechat for Work
          # TecentMeeting = 1484048379;
        };

        taps = [
          # "homebrew/cask-fonts"
          "hashicorp/tap"
          "FelixKratz/formulae" # janky borders - highlight active window borders.
        ];

        brews = [
          # `brew install`
          # "openssl"
          # "readline"
          # "zlib"
        ];

        # `brew install --cask`
        casks = [
          # "neovide-app"
          "ente-auth"
          "openinterminal-lite"
          "appcleaner"
          "neteasemusic"
          # "adguard"

          "google-chrome"
        ];

        caskArgs = {
          appdir = "/Users/${username}/Applications";
          no_quarantine = true;
        };
      };
    };
}
