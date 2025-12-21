{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.matugen;
  tomlFormat = pkgs.formats.toml { };

  cfgNoctalia = config.modules'.desktop.shell.noctalia;
  cfgDarkMaterial = config.programs.dankMaterialShell;

  # Centralized definitions for all matugen templates.
  # They are conditionally included based on whether the target program is enabled.
  allTemplates =
    lib.optionalAttrs config.programs.btop.enable {
      btop = {
        inputPath = "${config.xdg.configHome}/matugen/templates/btop.theme";
        outputPath = "${config.xdg.configHome}/btop/themes/matugen.theme";
      };
    }
    // lib.optionalAttrs config.programs.cava.enable {
      cava = {
        inputPath = "${config.xdg.configHome}/matugen/templates/cava.ini";
        outputPath = "${config.xdg.configHome}/cava/themes/matugen";
        postHook = "pkill -USR1 cava || true";
      };
    }
    // lib.optionalAttrs config.wayland.windowManager.hyprland.enable {
      hyprland = {
        inputPath = "${config.xdg.configHome}/matugen/templates/hyprland-colors.conf";
        outputPath = "${config.xdg.configHome}/hypr/colors.conf";
        postHook = "hyprctl reload";
      };
    }
    // lib.optionalAttrs config.programs.tmux.enable {
      tmux = {
        inputPath = "${config.xdg.configHome}/matugen/templates/tmux.conf";
        outputPath = "${config.xdg.configHome}/tmux/generated.conf";
        postHook = "tmux source-file ${config.xdg.configHome}/tmux/generated.conf";
      };
    }
    // lib.optionalAttrs config.programs.yazi.enable {
      yazi = {
        inputPath = "${config.xdg.configHome}/matugen/templates/yazi.toml";
        outputPath = "${config.xdg.configHome}/yazi/flavors/matugen.yazi/flavor.toml";
      };
    }
    // lib.optionalAttrs (cfgNoctalia.enable && cfgNoctalia.settings.templates.neovim) {
      neovim = {
        inputPath = "${config.xdg.configHome}/matugen/templates/template.lua";
        outputPath = "${config.xdg.configHome}/nvim/generated.lua";
        postHook = "pkill -SIGUSR1 nvim";
      };
    }
    // lib.optionalAttrs (cfgDarkMaterial.enable && config.services.vicinae.enable) {
      inputPath = "${config.xdg.configHome}/matugen/templates/vicinae.toml";
      outputPath = "${config.xdg.dataHome}/vicinae/themes/matugen.toml";
      postHook = "vicinae theme set matugen";
    };

  # Filter templates relevant for Noctalia (excluding Vicinae)
  noctaliaFilteredTemplates = lib.filterAttrs (_: v: v ? inputPath) (
    lib.removeAttrs allTemplates [
      "vicinae"
      "cava"
      "yazi"
    ]
  );

  # Filter templates relevant for DankMaterialShell (excluding Neovim)
  darkMaterialFilteredTemplates = lib.filterAttrs (_: v: v != { }) (
    lib.removeAttrs allTemplates [ "neovim" ]
  );

in
{
  imports = lib.importModule' ./.;

  options.programs.matugen = {
    enable = lib.mkEnableOption "matugen configuration";
    user-templates = lib.mkOption {
      type = lib.types.submodule {
        options = {
          config = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "General [config] section for Matugen’s TOML config file.";
          };
          templates = lib.mkOption {
            default = { };
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  inputPath = lib.mkOption {
                    type = lib.types.path;
                    description = "Template input path for Matugen";
                  };
                  outputPath = lib.mkOption {
                    type = lib.types.path;
                    description = "Output path where the generated file will be written";
                  };
                  postHook = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = "";
                    description = "Command to run after file is generated";
                  };
                };
              }
            );
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          templates = {
            neovim = {
              inputPath = "~/.config/matugen/templates/template.lua";
              outputPath = "~/.config/nvim/generated.lua";
              postHook = "pkill -SIGUSR1 nvim";
            };
          };
        }
      '';
      description = ''
        Template definitions for Matugen. Each attribute corresponds to a template
        such as "neovim", "kitty", "btop".
      '';
    };
  };

  config = lib.mkMerge [
    {
      # Enable the matugen program itself only if one of the shells that uses it is active.
      programs.matugen.enable = cfgNoctalia.enable || cfgDarkMaterial.enable;

      # Set the programs.matugen.user-templates.templates option based on the active shell
      # This ensures `programs.matugen.user-templates.templates` is populated correctly
      # for nix-repl queries and the matugen program's `config.toml`.
      programs.matugen.user-templates.templates =
        if cfgNoctalia.enable then
          noctaliaFilteredTemplates
        else if cfgDarkMaterial.enable then
          darkMaterialFilteredTemplates
        else
          { };

      # This part still generates the final config.toml for matugen to consume.
      xdg.configFile."matugen/config.toml" = {
        source = tomlFormat.generate "user-templates.toml" {
          config = cfg.user-templates.config;
          templates = lib.mapAttrs (_: t: {
            input_path = t.inputPath;
            output_path = t.outputPath;
            post_hook = t.postHook;
          }) cfg.user-templates.templates;
        };
      };
    }

    # Conditionally apply all relevant templates to the active shell.
    # This ensures `noctalia-shell` still receives its copy of templates if it's active.
    (lib.mkIf cfgNoctalia.enable {
      programs.noctalia-shell.user-templates = {
        config = { };
        templates = lib.mapAttrs (
          _: t:
          {
            input_path = t.inputPath;
            output_path = t.outputPath;
          }
          // lib.optionalAttrs (t ? postHook && t.postHook != "") {
            post_hook = t.postHook;
          }
        ) cfg.user-templates.templates;
      };
    })
  ];
}
