{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.terminal.alacritty;

  family = config.profiles.fonts.default;

in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        font = {
          size = 16;
          offset = {
            y = lib.mkDefault 0;
          };
          glyph_offset = {
            y = 0;
          };
          normal = {
            inherit family;
            style = "Regular";
          };
          bold = {
            inherit family;
            style = "Bold";
          };
          italic = {
            inherit family;
            style = "Italic";
          };
          bold_italic = {
            inherit family;
            style = "Bold Italic";
          };
        };

        window = {
          decorations = "buttonless";
          dynamic_padding = false;
          opacity = 0.78;
          padding = {
            x = 8;
            y = 2;
          };
        };
        scrolling = {
          history = 10000;
        };
        selection = {
          save_to_clipboard = true;
        };

        keyboard.bindings = [
          {
            key = "c";
            mods = "Super";
            action = "Copy";
          }
          {
            key = "v";
            mods = "Super";
            action = "Paste";
          }
          {
            key = "-";
            mods = "Super";
            action = "DecreaseFontSize";
          }
          {
            key = "=";
            mods = "Super";
            action = "IncreaseFontSize";
          }
          {
            key = "0";
            mods = "Super";
            action = "ResetFontSize";
          }
        ];
      };
    };
  };
}
