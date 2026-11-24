{
  flake.modules.homeManager."desktop.shell.noctalia" = {
    programs.noctalia = {

      settings = {
        shell = {
          clipboard_enabled = false;
          clipboard_keep_from_closed_apps = false;
          polkit_agent = true;
          password_style = "random";
          polkit_colorize_icons = true;
          popup_shadows = false;
          settings_expand_all_groups = true;
          settings_window_translucent = true;
          shadow = {
            alpha = 0.65;
          };
          screenshot = {
            confirm_region = true;
            remember_last_region = true;
            copy_on_close = true;
            region_border_width = 1.5;
            region_modifier = "super";
          };
          panel = {
            transparency_mode = "glass";
          };
          greeter_sync = {
            auto_sync = false;
          };
        };
      };

    };
  };
}
