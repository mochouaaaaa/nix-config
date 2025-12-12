{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
  cfgNoctaliaTemplates = config.programs.noctalia-shell.user-templates;
in
{

  imports = lib.importModule' ./. ++ [
    inputs.noctalia.homeModules.default
  ];

  options.modules'.desktop.shell.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Noctalia Shell module";
    };
    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "configuration value";
            };
        in
        valueType;
      default = { };
    };
  };

  options.programs.noctalia-shell.user-templates =
    let
      inherit (lib) mkOption types;
    in
    {
      config = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "General [config] section for Matugen’s TOML config file.";
      };
      templates = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              inputPath = mkOption {
                type = types.path;
                description = "Template input path for Matugen";
              };

              outputPath = mkOption {
                type = types.path;
                description = "Output path where the generated file will be written";
              };

              postHook = mkOption {
                type = types.nullOr types.str;
                default = "";
                description = "Command to run after file is generated";
              };
            };
          }
        );

        default = { }; # 默认无模板
        description = ''
          Template definitions for Matugen. Each attribute corresponds to a template
          such as "neovim", "kitty", "btop".
        '';
      };
    };

  config = lib.mkIf (cfgNoctalia.enable) {

    home.packages = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    services.cliphist.enable = lib.mkForce false;

    systemd.user.services = {
      noctalia-shell = {
        Service = {
          Environment = [
            "QT_QPA_PLATFORMTHEME=gtk3"
            "QT_QPA_PLATFORM=wayland"
          ];
        };
      };
    };

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = cfgNoctalia.settings;
    };

    xdg.configFile."noctalia/user-templates.toml".source =
      let
        toToml = pkgs.formats.toml { };
      in
      toToml.generate "user-templates.toml" {
        config = cfgNoctaliaTemplates.config;

        templates = lib.mapAttrs (_: t: {
          input_path = t.inputPath;
          output_path = t.outputPath;
          post_hook = t.postHook;
        }) cfgNoctaliaTemplates.templates;
      };

  };

}
