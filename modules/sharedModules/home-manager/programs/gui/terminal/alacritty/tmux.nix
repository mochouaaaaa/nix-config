{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.terminal.alacritty;
in
{

  config = lib.mkIf (cfg.enable && config.programs.tmux.enable && config.profiles.desktop.enable) {
    programs.alacritty = {
      settings = {
        font = {
          offset = {
            y = -1;
          };

        };
        keyboard.bindings = [
          # --- 窗口与标签管理 ---
          {
            key = "Return";
            mods = "Command";
            chars = "\\u0001z";
          }
          {
            key = "T";
            mods = "Command";
            chars = "\\u0001c";
          } # cmd+t -> tmux new-window
          {
            key = "W";
            mods = "Command";
            chars = "\\u001b[119;137u";
          } # cmd+w -> tmux kill-pane (关闭)
          {
            key = "LBracket";
            mods = "Command";
            chars = "\\u0001p";
          } # cmd+[ -> 上一个窗口
          {
            key = "RBracket";
            mods = "Command";
            chars = "\\u0001n";
          } # cmd+] -> 下一个窗口

          # --- 面板分割 (Command + Control + HJKL) ---
          {
            key = "H";
            mods = "Command|Control";
            chars = "\\u001b[104;141u";
          } # 垂直分割 (左右)
          {
            key = "L";
            mods = "Command|Control";
            chars = "\\u001b[108;141u";
          } # 垂直分割 (左右)
          {
            key = "J";
            mods = "Command|Control";
            chars = "\\u001b[106;141u";
          } # 水平分割 (上下)
          {
            key = "K";
            mods = "Command|Control";
            chars = "\\u001b[107;141u";
          } # 水平分割 (上下)
          {
            key = "h";
            mods = "Control|Shift";
            chars = "\\u001b[104;134u";
          }
          {
            key = "j";
            mods = "Control|Shift";
            chars = "\\u001b[106;134u";
          }
          {
            key = "k";
            mods = "Control|Shift";
            chars = "\\u001b[107;134u";
          }
          {
            key = "l";
            mods = "Control|Shift";
            chars = "\\u001b[108;134u";
          }

          {
            key = "H";
            mods = "Command";
            chars = "\\u001b[104;137u"; # Left
          }
          {
            key = "J";
            mods = "Command";
            chars = "\\u001b[106;137u"; # Down
          }
          {
            key = "K";
            mods = "Command";
            chars = "\\u001b[107;137u"; # Up
          }
          {
            key = "L";
            mods = "Command";
            chars = "\\u001b[108;137u"; # Right
          }
          {
            key = "F";
            mods = "Command";
            chars = "\\u001b[102;137u";
          }
          {
            key = "R";
            mods = "Command";
            chars = "\\u001b[114;137u";
          }

          # ===========neovim===============
          {
            key = "E";
            mods = "Command";
            chars = "\\u001b[101;137u";
          }
          {
            key = "S";
            mods = "Command";
            chars = "\\u001b[115;137u";
          }
          {
            key = "F";
            mods = "Command|Shift";
            chars = "\\u001b[102;138u";
          }
          {
            key = "/";
            mods = "Command";
            chars = "\\u001b[47;137u";
          }
        ];
      };
    };
  };
}
