{

  flake.modules.nixos."desktop.common" = {

    services.accounts-daemon.enable = true;

  };
}
