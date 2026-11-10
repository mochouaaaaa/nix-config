{
  flake.modules.nixos.programs = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.rustdesk-flutter
    ];
  };

  flake.modules.darwin.programs = {
    homebrew.casks = [ "rustdesk" ];
  };

}
