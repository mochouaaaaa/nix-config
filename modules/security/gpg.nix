{
  flake.aspects.security.provides.gpg.homeManager = { pkgs, config, ... }: {
    programs.gpg.enable = true;

    services = {
      ssh-agent.enable = false;

      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableExtraSocket = true;
        enableZshIntegration = config.programs.zsh.enable;
        pinentry.package = pkgs.pinentry-gnome3;
        defaultCacheTtlSsh = 3600;
        defaultCacheTtl = 3600;
        maxCacheTtl = 7200;
        maxCacheTtlSsh = 7200;
        extraConfig = ''
          allow-loopback-pinentry
          allow-preset-passphrase
        '';
      };
    };
  };

  # GCR's D-Bus services are only needed on NixOS hosts that enable GPG.
  flake.aspects."services.base"."nixos" =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    {
      services.dbus.packages = lib.optionals config.home-manager.users.${username}.programs.gpg.enable [
        pkgs.gcr_3
      ];
    };

  # Keep Linux-specific GPG agent behavior in the platform role while exposing
  # the reusable security configuration under its own module identifier.
  flake.aspects."linux"."homeManager" = { aspects, ... }: {
    imports = [ aspects.security._.gpg ];
  };
}
