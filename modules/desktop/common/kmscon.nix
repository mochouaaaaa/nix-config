{
  flake.modules.nixos."desktop.common" = {

    services.kmscon = {
      enable = true;
      # package = kmscon;
      extraOptions = "--term xterm-256color";
      config = {
        font-name = "Source Code Pro";
        font-size = 18;
        hwaccel = true;
      };
    };

  };
}
