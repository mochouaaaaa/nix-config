{
  system = {
    defaults = {
      # customize dock
      dock = {
        autohide = true; # automatically hide and show the dock
        show-recents = false; # do not show recent apps in dock
        # do not automatically rearrange spaces based on most recent use.
        mru-spaces = false;
        expose-group-apps = true; # Group windows by application

        # customize Hot Corners(触发角, 鼠标移动到屏幕角落时触发的动作)
        # wvous-tl-corner = 2; # top-left - Mission Control
        # wvous-tr-corner = 4; # top-right - Desktop
        # wvous-bl-corner = 3; # bottom-left - Application Windows
        # wvous-br-corner = 13; # bottom-right - Lock Screen
      };
    };
  };
}
