{ self, ... }: {

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.services.gnome.gnome-keyring.enable
          [
            {
              directory = ".local/share/keyrings";
              mode = "0700"; # 密钥环目录仅用户可访问
            }
          ];
    };

  flake.aspects."desktop.keyring".nixos = _: {

    services = {
      gnome = {
        gnome-keyring.enable = true; # 非 KDE 桌面启用密钥环
        gcr-ssh-agent.enable = false; # 用独立 ssh-agent，不用 gcr 的
      };
    };

  };

  flake.aspects."desktop.hyprland".includes = [
    (flake.aspects."desktop.keyring")
  ];

  flake.aspects."desktop.niri".includes = [
    (flake.aspects."desktop.keyring")
  ];

}
