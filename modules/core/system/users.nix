{

  flake.modules.homeManager.core =
    {
      pkgs,
      config,
      username,
      ...
    }:
    {
      home =
        let
          rootName = if pkgs.stdenv.isDarwin then "Users" else "home";
        in
        {
          inherit username;
          homeDirectory = "/${rootName}/${config.home.username}";
        };
    };

  flake.modules.darwin.core = { username, ... }: {
    users.users.${username}.home = "/Users/${username}";
  };

  flake.modules.nixos.core =
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
          keys = { };
          adbusers = { };
          dialout = { };
          plugdev = { };
        };
      };

      services.userborn.passwordFilesLocation = "/var/lib/nixos";

      users.users."${username}" = {
        home = "/Users/${username}";

        inherit (myvars) initialHashedPassword;
        isNormalUser = true;
        extraGroups = [
          username
          "users"
          "networkmanager"
          "wheel"
          "adbusers"
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
            (lib.concatMapStrings (u: "${toString u.uid}:${toString (100000 + u.uid * 65536)}:65536\\n"))
          ];
        in
        lib.optionalAttrs config.services.userborn.enable {
          subuid.text = autosubs;
          subgid.text = autosubs;
        };
    };

}
