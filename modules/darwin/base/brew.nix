{ username, ... }:
{
  # homebrew need to be installed manually, see https://brew.sh
  # https://github.com/LnL7/nix-darwin/blob/master/modules/homebrew.nix
  homebrew = {
    enable = true; # disable homebrew for fast deploy

    onActivation = {
      autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # Wechat = 836500024;
      # WeCom = 1189898970; # Wechat for Work
      # TecentMeeting = 1484048379;
    };

    taps = [
      # "homebrew/cask-fonts"
      "hashicorp/tap"
      "FelixKratz/formulae" # janky borders - highlight active window borders
    ];

    brews = [
      # `brew install`
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "openssl"
      "readline"
      "zlib"
    ];

    # `brew install --cask`
    casks = [
      "kitty"
      "neovide-app"
      "ente-auth"
      "openinterminal-lite"
      "squirrel-app" # input method for Chinese, rime-squirrel
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
}
