{ config, lib, ... }:
let
  cfg = config.modules.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      powerdevil = {
        general = {
          pausePlayersOnSuspend = true;
        };
        batteryLevels = {
          # 笔记本电池设置
          lowLevel = null; # 低电量
          criticalLevel = null; # 临界电量
          criticalAction = null; # 临界电量时执行的动作
        };
      };
    };
  };
}
