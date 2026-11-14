{ self, ... }: {

  flake.modules.nixos.common-keyring =
    {
      lib,
      config,
      username,
      ...
    }:
    {

      services = {
        gnome = {
          gnome-keyring.enable = true; # 非 KDE 桌面启用密钥环
          gcr-ssh-agent.enable = false; # 用独立 ssh-agent，不用 gcr 的
        };
      };

      profiles.preservation.users.${username}.directories =
        lib.optionals config.services.gnome.gnome-keyring.enable
          [
            {
              directory = ".local/share/keyrings";
              mode = "0700"; # 密钥环目录仅用户可访问
            }
          ];

    };

  flake.modules.nixos."desktop.hyprland" = {
    imports = [
      self.modules.nixos.common-keyring
    ];
  };

  flake.modules.nixos."desktop.niri" = {
    imports = [
      self.modules.nixos.common-keyring
    ];
  };

  flake.modules.nixos."desktop.gnome" = {
    imports = [
      self.modules.nixos.common-keyring
    ];
    services = {
      speechd.enable = true;
    };
  };
}
