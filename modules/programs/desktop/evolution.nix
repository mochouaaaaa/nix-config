{
  flake.modules.nixos."programs.evolution" = { pkgs, username, ... }: {
    programs.evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    profiles.preservation.users.${username}.directories = [
      ".config/evolution"
      ".local/share/evolution"
      ".cache/evolution"
    ];
  };

}
