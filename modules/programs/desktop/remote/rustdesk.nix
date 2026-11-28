{
  flake.aspects."desktop.programs".provides.remote.provides.rustdesk.nixos = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.rustdesk-flutter
    ];
  };

  flake.aspects."desktop.programs.remote"."darwin" = {
    homebrew.casks = [ "rustdesk" ];
  };
}
