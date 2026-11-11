{
  flake.modules.nixos."services.console" = { pkgs, ... }: {

    fonts.packages = with pkgs; [
      hack-font
      dejavu_fonts
      noto-fonts-cjk-sans
    ];

    services.kmscon = {
      enable = true;
      extraOptions = "xterm-256color";
      config = {
        font-name = "Hack";
        font-size = 22;
        hwaccel = true;
      };
    };
  };

  flake.modules.nixos."services.base" = { self, ... }: {
    imports = [ self.modules.nixos."services.console" ];
  };

}
