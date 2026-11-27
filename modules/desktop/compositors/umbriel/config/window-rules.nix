{
  flake.aspects."desktop.umbriel".homeManager = {

    programs.umbriel.settings.window_rule = [
      # ==============global===============
      {
        opacity = 0.78;
        blur = true;
        blur_optimized = false;
      }

      {
        match.app_id = "^firefox$";
        default_workspace = 2;
      }
      {
        match.app_id = "^com.obsproject.Studio$";
        default_workspace = 3;
        default_floating = true;
        default_floating_size = {
          width = 0.7;
          height = 0.8;
        };
      }
      {
        match.app_id = [
          "^org.telegram.desktop$"
          "^io.github.kukuruzka165.materialgram$"
        ];
        # default_scratchpad = "tg";
      }
      {
        match.app_id = [ "^(discord|equibop|vesktop|whatsapp|qq|dingtalk)$" ];
        # default_scratchpad = "wechat";
      }
      {
        match.app_id = [
          "^org.gnome.Fractal$"
          "^fluffychat$"
          "^Element$"
        ];
        # default_scratchpad = "matrix";
      }
      {
        match.app_id = [
          "^feishin$"
          "^Spotify$"
          "^Supersonic$"
          "^SPlayer$"
        ];
        # default_scratchpad = "music";
      }
      {
        match.app_id = "^Todoist$";
        # default_scratchpad = "todo";
      }
      {
        match.app_id = "^Thunar$";
        default_floating = true;
        default_floating_size = {
          width = 0.6;
          height = 0.7;
        };
      }
      {
        match.app_id = [
          "^org.gnome.Nautilus$"
          "^pcmanfm$"
          "^dolphin$"
          "dev.noctalia.luciole"
        ];
        default_floating = true;
        default_floating_size = {
          width = 0.6;
          height = 0.7;
        };
      }
      {
        match.app_id = [
          "^mpv$"
          "^com.github.rafostar.Clapper$"
        ];
        default_floating = true;
        default_floating_size = {
          width = 0.86;
          height = 0.86;
        };
      }
      {
        match.title = "Picture(-| )in(-| )[Pp]icture";
        default_floating = true;
        default_pinned = true;
        default_position = {
          x = 20;
          y = 20;
          anchor = "bottom_right";
        };
      }
      {
        match.app_id = [
          "^imv$"
          "^equibop$"
          "^swappy$"
          "dev.noctalia.UmbrielSharePicker"
        ];
        default_floating = true;
      }
      {
        match.app_id = "^VirtualBox$";
        default_floating = true;
      }
      {
        match.app_id = [
          "^org.pulseaudio.pavucontrol$"
          "^yad$"
          "^zenity$"
          "^wev$"
          "^org.gnome.FileRoller$"
          "^file-roller$"
          "^evince$"
          "^baobab$"
          "^font-manager$"
          "^qt6ct$"
        ];
        default_floating = true;
        default_floating_size = {
          width = 0.6;
          height = 0.7;
        };
      }
    ];
  };
}
