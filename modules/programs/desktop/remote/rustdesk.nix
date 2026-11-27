{
  flake.aspects."desktop.programs.remote"."nixos" = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.rustdesk-flutter
    ];
  };

  flake.aspects."desktop.programs.remote"."darwin" = {
    homebrew.casks = [ "rustdesk" ];
  };
}
