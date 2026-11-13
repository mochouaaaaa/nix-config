{
  flake.modules.generic.zsh = { pkgs, username, ... }: {
    users.users.${username}.description = "${username}. up up up!";
    programs.zsh = {
      enable = true;
      enableCompletion = false;
      enableBashCompletion = false;
    };
    environment.shells = [ pkgs.zsh ];
  };

  flake.modules.homeManager.core = {
    systemd.user.startServices = "sd-switch";
  };

  flake.modules.nixos.users =
    {
      lib,
      pkgs,
      config,
      myvars,
      username,
      ...
    }:
    {
      users = {
        mutableUsers = false;
        defaultUserShell = pkgs.zsh;
        groups = {
          "${username}" = { };
          docker = { };
          wireshark = { };
          adbusers = { };
          dialout = { };
          plugdev = { };
          uinput = { };
        };
      };

      services.userborn.passwordFilesLocation = "/var/lib/nixos";

      users.users."${username}" = {
        inherit (myvars) initialHashedPassword;
        home = "/home/${username}";
        isNormalUser = true;
        extraGroups = [
          username
          "users"
          "networkmanager"
          "wheel"
          "wireshark"
          "adbusers"
          "libvirtd"
          "input"
          "uinput"
          "video"
          "plugdev"
        ];
      };

      users.users.root = {
        inherit (myvars) initialHashedPassword;
        openssh.authorizedKeys.keys = config.users.users."${username}".openssh.authorizedKeys.keys;
      };

      environment.etc =
        let
          autosubs = lib.pipe config.users.users [
            lib.attrValues
            (lib.filter (u: u.uid != null && u.isNormalUser))
            (lib.concatMapStrings (u: "${toString u.uid}:${toString (100000 + u.uid * 65536)}:65536\\n")
          ];
        in
        lib.optionalAttrs config.services.userborn.enable {
          subuid.text = autosubs;
          subgid.text = autosubs;
        };
    };

  flake.modules.nixos.core = { self, ... }: {
    imports = [
      self.modules.generic.zsh
      self.modules.nixos.users
    ];
  };

  flake.modules.darwin.core = { self, username, ... }: {
    imports = [ self.modules.generic.zsh ];
    users.users."${username}".home = "/Users/${username}";
  };
}
