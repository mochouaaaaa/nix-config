{ self, ... }:
{
  imports = self.importModule' ./.;

  # Add ability to used TouchID for sudo authentication
  security.pam.services = {
    sudo_local = {
      touchIdAuth = true;
      # 这修复了 Touch ID 的 sudo 无法在 tmux 和屏幕内工作
      reattach = true;
      # 将 Apple Watch 用于 sudo 身份验证,适用于无 Touch ID 的设备或 关闭盖子的笔记本电脑,考虑使用这个。
      # 启用后,您可以使用 Apple Watch 对 sudo 命令进行身份验证。 如果这不起作用,你可以进入 System Settings > Touch ID & Password 并切换 Apple Watch 的开关
      watchIdAuth = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    # activationScripts.postUserActivation.text = ''
    # activateSettings -u will reload the settings from the database and apply them to the current session,
    # so we do not need to logout and login again to make the changes take effect.
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    primaryUser = "${self.myvars.username}";

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
    };
  };

}
