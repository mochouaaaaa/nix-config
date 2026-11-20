{
  flake.modules.homeManager."desktop.cosmic" =
    { cosmicLib, ... }:

    let
      # 无参数 RON 枚举：Disable、Maximize 等
      ronEnum = value: cosmicLib.cosmic.mkRON "enum" value;

      # 带一个参数的 RON 元组枚举：System(HomeFolder)、Move(Left) 等
      tupleEnum =
        variant: value:
        cosmicLib.cosmic.mkRON "enum" {
          inherit variant;
          value = [ (ronEnum value) ];
        };
    in
    {
      wayland.desktopManager.cosmic.shortcuts = [
        # ── Disable 类 ────────────────────────────────────────
        {
          action = ronEnum "Disable";
          key = "Super+Ctrl+Down";
        }
        {
          action = ronEnum "Disable";
          key = "Super+r";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Shift+r";
        }
        {
          action = ronEnum "Disable";
          key = "Super+o";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Ctrl+j";
        }
        {
          action = ronEnum "Disable";
          key = "Super+slash";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Alt+Shift+l";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Alt+Shift+Down";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Shift+Escape";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Ctrl+Shift+h";
        }
        {
          action = ronEnum "Disable";
          key = "Super+w";
        }
        {
          action = ronEnum "Disable";
          key = "Super+Shift+l";
        }

        # ── Focus 类 ──────────────────────────────────────────
        {
          action = tupleEnum "Focus" "Right";
          key = "Alt+l";
        }
        {
          action = tupleEnum "Focus" "Down";
          key = "Alt+k";
        }
        {
          action = tupleEnum "Focus" "Up";
          key = "Alt+j";
        }
        {
          action = tupleEnum "Focus" "Left";
          key = "Alt+h";
        }

        # ── System 类 ─────────────────────────────────────────
        {
          action = tupleEnum "System" "HomeFolder";
          key = "Super+Ctrl+e";
        }
        {
          action = tupleEnum "System" "Launcher";
          key = "Super+space";
        }
        {
          action = tupleEnum "System" "LockScreen";
          key = "Super+Ctrl+q";
        }
        {
          action = tupleEnum "System" "Screenshot";
          key = "Super+Ctrl+a";
        }
        {
          action = tupleEnum "System" "LogOut";
          key = "Super+Ctrl+Delete";
        }
        {
          action = tupleEnum "System" "Terminal";
          key = "Super+Ctrl+t";
        }

        # ── Move 类 ───────────────────────────────────────────
        {
          action = tupleEnum "Move" "Left";
          key = "Super+Shift+Left";
        }

        # ── Maximize 类 ───────────────────────────────────────
        {
          action = ronEnum "Maximize";
          key = "Ctrl+Alt+Return";
        }

        # ── 单独修饰键 ────────────────────────────────────────
        {
          action = ronEnum "Disable";
          key = "Super";
        }

        # ── 硬件键 / 无修饰键 ─────────────────────────────────
        {
          action = ronEnum "Disable";
          key = "Print";
        }
        {
          action = ronEnum "Disable";
          key = "XF86TouchpadToggle";
        }
      ];
    };
}
