{
  system = {
    defaults = {
      # customize trackpad
      trackpad = {
        ActuationStrength = 0; # 静默点击
        # tap - 轻触触摸板, click - 点击触摸板
        Clicking = true; # enable tap to click(轻触触摸板相当于点击)
        FirstClickThreshold = 0;
        SecondClickThreshold = 0; # 用于力触摸:0用于轻点击,1为介质,2为坚定。 默认值为1。
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
    };
  };
}
