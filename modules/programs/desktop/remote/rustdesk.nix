{
  flake.modules.nixos."desktop.programs.remote" = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.rustdesk-flutter
    ];
  };

  flake.modules.darwin."desktop.programs.remote" = {
    homebrew.casks = [ "rustdesk" ];
  };
}
