{
  flake.modules.homeManager."desktop.common" = { pkgs, username, ... }: {
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

  flake.modules.nixos."desktop.common" = { username, ... }: {

    profiles.preservation.users.${username}.directories = [
      # ======================================
      # Security
      # ======================================
      {
        directory = ".config/Bitwarden";
        mode = "0700";
      }
      {
        directory = ".local/share/authenticator";
        mode = "0755";
      }
      {
        directory = ".local/share/io.ente.auth";
        mode = "0755";
      }
    ];

  };

}
