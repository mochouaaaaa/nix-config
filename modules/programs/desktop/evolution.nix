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

  flake.modules.nixos."desktop.common" = { self, ... }: {
    imports = [ self.modules.nixos."programs.evolution" ];
  };
}
