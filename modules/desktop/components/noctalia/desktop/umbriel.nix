{

  flake.aspects."desktop.umbriel".homeManager = { config, mylib, ... }: {
    programs.noctalia = mylib.mkForceRecursive {
      systemd.enable = false;
      settings = {
        bar.widgets = {
          radius = 0;
        };
        theme = {
          templates = {
            builtin_ids = [
              "umbriel"
            ];
          };
        };

        shell = {
          umbriel_audio_provider_enabled = true;
          umbriel_overview_close_on_launch_enabled = true;
          umbriel_overview_type_to_launch_enabled = false;
        };
      };
    };
    programs.umbriel.settings = {
      include.optional.files = [ "${config.xdg.configHome}/umbriel/noctalia.toml" ];
      general = {
        autostart = [ "noctalia" ];
      };
      appearance = mylib.mkDefaultRecursive {
        prefer_no_csd = true;
        border_width = 2;
        corner_radius = 10;
        blur = {
          enabled = true;
          optimized = true;
          passes = 2;
          radius = 3;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
      };
      window_rule = [
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = true;
          default_floating_size_px = {
            width = 1080;
            height = 920;
          };
        }
      ];
      layer_rule = [
        {
          match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
          blur = true;
          blur_ignore_alpha = 0.6;
          blur_optimized = false;
        }
      ];
    };
  };

}
