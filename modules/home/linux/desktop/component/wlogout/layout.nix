[
  {
    label = "shutdown";
    action = "systemctl poweroff";
    text = "Shutdown";
    keybind = "s";
  }
  {
    label = "reboot";
    action = "systemctl reboot";
    text = "Reboot";
    keybind = "r";
  }
  {
    label = "logout";
    action = "loginctl kill-sesion $XDG_SESSION_ID";
    text = "Logout";
    keybind = "l";
  }
  {
    label = "hibernate";
    action = "systemctl suspend";
    text = "Suspend";
    keybind = "d";
  }
  {
    label = "lock";
    action = "hyprlock";
    text = "Lock Screen";
    keybind = "k";
  }
]
