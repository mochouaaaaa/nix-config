{
  flake.modules.homeManager."desktop.shell.noctalia" = {
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
      };
    };
  };
}
