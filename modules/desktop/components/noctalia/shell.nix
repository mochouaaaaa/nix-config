{
  flake.modules.homeManager."desktop.shell.noctalia" = {
    programs.noctalia = {

      settings = {
        shell = {
          clipboard_enabled = false;
          clipboard_keep_from_closed_apps = false;
          polkit_agent = true;
          popup_shadows = false;
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
