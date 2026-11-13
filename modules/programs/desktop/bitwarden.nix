{
  flake.modules.homeManager."desktop.programs.security" = { pkgs, username, ... }: {
    home.packages = [
      # pkgs.bitwarden-cli
      pkgs.bitwarden-desktop
    ];

    # programs.rbw = {
    #   enable = true;
    # };

    programs.chromium = {
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      ];
    };

    programs.firefox.profiles."${username}" = {
      extensions = {
        force = true;
        packages = [
          pkgs.nur.repos.rycee.firefox-addons.bitwarden
        ];
        settings = {
          # bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".permissions = [
            "<all_urls>"
            "*://*/*"
            "alarms"
            "clipboardRead"
            "clipboardWrite"
            "contextMenus"
            "idle"
            "storage"
            "tabs"
            "unlimitedStorage"
            "webNavigation"
            "webRequest"
            "webRequestBlocking"
            "notifications"
            "file:///*"
          ];
        };
      };
    };

  };

  flake.modules.nixos.preservation =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.bitwarden-desktop homePackages)
          [
            {
              directory = ".config/Bitwarden";
              mode = "0700";
            }
          ];
    };

}
