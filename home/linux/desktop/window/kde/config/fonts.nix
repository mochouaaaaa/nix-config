_: let
  fontConfig = {
    family = "Monaco Nerd Font Mono";
    pointSize = 12;
  };
in {
  general = fontConfig;
  fixedWidth = fontConfig;
  small = fontConfig // {pointSize = 10;};
  toolbar = fontConfig;
  menu = fontConfig;
  windowTitle = fontConfig;
}
