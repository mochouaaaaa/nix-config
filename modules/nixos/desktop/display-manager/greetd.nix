{
  config,
  lib,
  username,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.profiles.display-manager.greetd;
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  options.profiles.display-manager.greetd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable greetd.";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.noctalia-greeter = {
      enable = true;

      # Optional configuration
      greeter-args = "";
      # Full declarative greeter.toml (overwritten on each activation).
      # See examples/greeter.toml for every key (appearance.palette, output, …).
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
        };
      };
    };
    profiles.persistent.osDirectories = [
      "/var/lib/noctalia-greeter"
    ];

    # services = {
    #   greetd = {
    #     enable = true;
    #     settings = rec {
    #       terminal.vt = 1;
    #       default_session = {
    #         command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${cfg.command}";
    #         # command = "${cfg.command}";
    #         user = username;
    #       };
    #       initial_session = default_session;
    #     };
    #   };
    # };

  };
}
