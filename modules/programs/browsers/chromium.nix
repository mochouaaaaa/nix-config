_: {
  flake.aspects = { aspects, ... }: {
    desktop-programs.provides.browsers.provides.chromium = {
      includes = [
        aspects."programs.chromium"
      ];

      homeManager = {
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
    };

    "darwin".homeManager = { lib, ... }: {
      programs.chromium.enable = lib.mkForce false;
    };

    desktop-kde.homeManager = { pkgs, ... }: {
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

    "programs.chromium".homeManager = {
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

    preservation.nixos =
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
  };
}
