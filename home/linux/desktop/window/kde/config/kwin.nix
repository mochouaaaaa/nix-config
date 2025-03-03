{
  titlebarButtons.left = ["close" "minimize" "maximize"];
  effects = {
    shakeCursor.enable = true;
    translucency.enable = true;
    minimization = {
      animation = "magiclamp";
      duration = 100;
    };
    wobblyWindows.enable = true;
    fps.enable = false;
    cube.enable = false;
    desktopSwitching.animation = "slide";
    windowOpenClose.animation = "scale";
    fallApart.enable = false; # 关闭窗口碎片效果
    blur = {
      enable = true;
      strength = 15;
      noiseStrength = 8;
    };
    snapHelper.enable = false; # 禁用移动辅助定位线
    dimInactive.enable = false; # 禁用窗口失效时变暗效果
    dimAdminMode.enable = true; # 管理员模式下窗口变暗
    slideBack.enable = true; # 窗口滑动返回效果
  };

  virtualDesktops = {
    rows = 1;
    names = ["桌面 1" "桌面 2" "桌面 3" "桌面 4"];
    number = 4;
  };

  borderlessMaximizedWindows = true; # 无边框最大化窗口
  nightLight = {
    # 夜间模式
    enable = true;
    mode = "location"; # 位置模式 # constant, times
    location = {
      latitude = "39.9042";
      longitude = "116.4074";
    };
  };
  edgeBarrier = null; # 边缘屏障
  cornerBarrier = true; # 角落屏障
}
