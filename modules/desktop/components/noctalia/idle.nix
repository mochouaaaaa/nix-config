{
  flake.aspects."desktop.shell.noctalia".homeManager = {
    programs.noctalia = {
      settings = {
        idle.behavior = {
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 0; # 解锁状态下不因空闲而熄屏（按需设置）
            locked_timeout = 600; # 锁屏后，空闲 600 秒（10分钟）熄屏
          };
        };
        brightness = {
          enable_ddcutil = true;
          minimum_brightness = 0.3;
          sync_all_monitors = true;
        };
      };
    };
  };
}
