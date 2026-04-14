{
  pkgs,
  lib,
  config,
  inputs,
  nvfetcherSources,
  ...
}:
let
  cfg = config.profiles.packages.jetbrains;
  jetbrainsConfig = enable: {
    pycharm = enable && cfg.pycharm.enable;
    goland = enable && cfg.goland.enable;
    datagrip = enable && cfg.datagrip.enable;
    clion = enable && cfg.clion.enable;
  };

  initjetbrains = jetbrainsConfig (cfg.enable && config.profiles.desktop.enable);
  vmoptsPath = "${config.xdg.configHome}/JetBrains/vmopts.vmoptions";
  propertiesPath = "${config.xdg.configHome}/JetBrains/idea.properties";

  pluginList = [
    "com.intellij.plugins.macoskeymap"
  ];

  buildPlugins =
    with inputs.nix-jetbrains-plugins.lib;
    lib.mkMerge [
      (lib.mkIf initjetbrains.pycharm [
        (buildIdeWithPlugins pkgs cfg.pycharm.package pluginList)
      ])
      (lib.mkIf initjetbrains.goland [
        (buildIdeWithPlugins pkgs cfg.goland.package pluginList)
      ])
      (lib.mkIf initjetbrains.datagrip [
        (buildIdeWithPlugins pkgs cfg.datagrip.package pluginList)
      ])
      (lib.mkIf initjetbrains.clion [
        (buildIdeWithPlugins pkgs cfg.clion.package pluginList)
      ])
    ];
in
{
  options.profiles.packages.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs";
    pycharm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.pycharm {
            src = nvfetcherSources.pycharm.src;
          }
        );
      };
    };
    goland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.goland {
            src = nvfetcherSources.goland.src;
          }
        );
      };
    };
    datagrip = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.datagrip {
            src = nvfetcherSources.datagrip.src;
          }
        );
      };
    };
    clion = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.clion {
            src = nvfetcherSources.clion.src;
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {

    programs.java.enable = true;

    home = {

      sessionVariables = {
        PYCHARM_VM_OPTIONS = vmoptsPath;
        GOLAND_VM_OPTIONS = vmoptsPath;
        DATAGRIP_VM_OPTIONS = vmoptsPath;
        CLION_VM_OPTIONS = vmoptsPath;
        GOLAND_PROPERTIES = propertiesPath;
        PYCHARM_PROPERTIES = propertiesPath;
        DATAGRIP_PROPERTIES = propertiesPath;
        CLION_PROPERTIES = propertiesPath;
      };

      activation = {
        initProperties =
          let
            propertiesContent = ''
              # custom GoLand properties (expand/override 'bin/idea.properties')


              keymap.windows.as.meta=true
            '';
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ -f "${propertiesPath}" ]; then
              echo "properties file already exists, skipping creation"
            else
              mkdir -p ${config.xdg.configHome}/JetBrains
              echo "${propertiesContent}" > "${propertiesPath}"
            fi
          '';
        initVmoptions =
          let
            vmOptionsContent = ''
              --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
              --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

              -Dsun.java2d.uiScale=1.5
              -Dhidpi=true
              -Dawt.toolkit.name=WLToolkit
              -javaagent:${config.xdg.configHome}/.jetbra-free/static/ja-netfilter/ja-netfilter.jar=jetbrains
            '';
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ -f "${vmoptsPath}" ]; then
              echo "vmoptions file already exists, skipping creation"         
            else
              mkdir -p ${config.xdg.configHome}/JetBrains
              echo "${vmOptionsContent}" > "${vmoptsPath}"
            fi
          '';

      };

    };

    home.packages = buildPlugins;

  };

}
