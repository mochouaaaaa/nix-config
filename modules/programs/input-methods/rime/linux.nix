{
  flake.modules.homeManager."desktop.common" =
    { pkgs, config, ... }:
    let
      rimeConfig = config.profiles.rime;
    in
    {

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          fcitx5-with-addons = pkgs.kdePackages.fcitx5-with-addons;
          addons = [
            (pkgs.fcitx5-rime.override {
              rimeDataPkgs = [ rimeConfig.data-package ];
            })
          ];
          waylandFrontend = true;
          settings = {
            inputMethod = {
              GroupOrder."0" = "Other";
              "Groups/0" = {
                Name = "Other";
                "Default Layout" = "us";
                DefaultIM = "rime";
              };
              "Groups/0/Items/0".Name = "rime";
            };
            addons = {
              notifications = {
                sections = {
                  "HiddenNotifications" = {
                    "0" = "fcitx-rime-deploy";
                  };
                };
              };
              rime = {
                globalSection = {
                  PreeditMode = "Commit preview";
                  PreeditInApplication = "True";
                  InputState = "No";
                  PreeditCursorPositionAtBeginning = "True";
                  SwitchInputMethodBehavior = "Commit commit preview";
                  Deploy = "";
                  Synchronize = "";
                };
              };
              classicui = {
                globalSection = {
                  "Vertical Candidate List" = "False";
                  "PerScreenDPI" = "True";
                  "WheelForPaging" = "True";
                  "Font" = "${config.profiles.fonts.default} 10";
                  "MenuFont" = "inter 11";
                  "TrayFont" = "Maple Mono 11";
                  "TrayOutlineColor" = "#000000";
                  "TrayTextColor" = "#ffffff";
                  "PreferTextIcon" = "True";
                  "ShowLayoutNameInIcon" = "True";
                  "UseInputMethodLanguageToDisplayText" = "True"; # 保持原拼写错误
                  "Theme" = rimeConfig.themes.light;
                  "DarkTheme" = rimeConfig.themes.dark;
                  "UseDarkTheme" = "True";
                  "ForceWaylandDPI" = "0";
                  "EnableFractionalScale" = "True";
                };
              };
            };
          };
        };
      };

      profiles.rime.fcitx5CustomYaml =
        let
          ascii = {
            ascii_mode = true;
            ascii_punct = true;
          };
        in
        {
          # dbus-send --print-reply=literal --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.DebugInfo
          patch = {
            "menu/page_size" = 9;
            "style/candidate_list_layout" = "linear";
            "style/translucency" = true;

            "app_options/gcr-prompter" = ascii;
            "app_options/org.wezfurlong.wezterm" = ascii;
            "app_options/kitty" = ascii;
            "app_options/Alacritty" = ascii;
            "app_options/com.mitchellh.ghostty" = ascii;
            "app_options/foot" = ascii;
            "app_options/code" = ascii;
            "app_options/dev.zed.Zed" = ascii;
            "app_options/neovide" = ascii;
            "app_options/firefox" = ascii;
            "app_options/.vicinae-wrapped" = ascii;
            "app_options/.intellij-wrapped" = ascii;
            "app_options/jetbrains-intellij" = ascii;
            "app_options/.pycharm-wrapped" = ascii;
            "app_options/jetbrains-pycharm" = ascii;
            "app_options/.goland-wrapped" = ascii;
            "app_options/jetbrains-goland" = ascii;
            "app_options/webstorm-wrapped" = ascii;
            "app_options/.datagrip-wrapped" = ascii;
            "app_options/jetbrains-datagrip" = ascii;
            "app_options/.albert-wrapped" = ascii;
          };
        };

    };
}
