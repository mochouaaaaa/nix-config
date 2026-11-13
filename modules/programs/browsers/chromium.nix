{ self, ... }: {

  flake.modules.homeManager."desktop.programs.browsers" = {
    imports = [ self.modules.homeManager."programs.chromium" ];

    programs.chromium = {
      extensions = [
        { id = "padekgcemlokbadohgkifijomclgjgif"; } # Proxy SwitchyOmega
      ];

      commandLineArgs = [
        "--ozone-platform=wayland"
        "--lang=zh-CN"
      ];
    };

  };

  flake.modules.homeManager."desktop.gnome" = {
    programs.chromium.commandLineArgs = [
      "--gtk-version=4"
      "--password-store=gnome-libsecret"
    ];
  };

  flake.modules.homeManager."desktop.kde" = { pkgs, ... }: {
    programs.chromium = {
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
      commandLineArgs = [
        "--password-store=kde"
        "--wayland-text-input-version=1"
      ];
    };
  };

  flake.modules.homeManager."programs.chromium" = {

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "bkdgflcldnnnapblkhphbgpggdiikppg"; } # duckduckgo
        { id = "ffabmkklhbepgcgfonabamgnfafbdlkn"; } # gzip github
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "immpkjjlgappgfkkfieppnmlhakdmaab"; } # imagus
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        { id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; } # 沉浸式翻译
        { id = "bbbiejemhfihiooipfcjmjmbfdmobobp"; } # BewlyBewly
        { id = "pkgccpejnmalmdinmhkkfafefagiiiad"; } # 前端助手
        { id = "lcbjdhceifofjlpecfpeimnnphbcjgnc"; } # xBrowserSync
      ];
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
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.chromium.enable
          [
            ".config/chromium"
            ".cache/chromium"
            ".config/google-chrome"
            ".cache/google-chrome"
          ];
    };

}
