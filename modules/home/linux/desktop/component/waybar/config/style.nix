{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
in
{
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      style = ''
        * {
          font-family:
            Roboto,
            Helvetica,
            Arial,
            sans-serif FantasqueSansMono Nerd Font;
          font-size: 15px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 3px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 3px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.3rem;
        }

        #workspaces button.active {
          color: @sky;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @sapphire;
          border-radius: 1rem;
        }

        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        /* #pulseaudio.microphone, */
        #custom-lock,
        #custom-power {
          background-color: @surface0;
          padding: 0.3rem 1rem;
          margin: 3px 0;
        }

        #clock {
          color: @blue;
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 0.8rem;
        }

        #battery {
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #backlight,
        #battery {
          border-radius: 0;
        }

        #pulseaudio {
          color: @maroon;
          padding: 0.3rem 0.4rem;
          margin: 3px 0;
          border-radius: 1rem 0px 0px 1rem;
        }

        #pulseaudio.microphone {
          color: @maroon;
          padding: 0.3rem 0.4rem;
          border-radius: 0px 0rem 0rem 0px;
          margin-left: 0rem;
        }

        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }

        #custom-lock {
          border-radius: 1rem 0px 0px 1rem;
          color: @lavender;
        }

        #custom-power {
          margin-right: 1rem;
          border-radius: 0px 1rem 1rem 0px;
          color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }

      '';
    };
  };
}
