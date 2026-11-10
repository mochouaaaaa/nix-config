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
