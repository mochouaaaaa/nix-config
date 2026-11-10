{
  flake.modules.homeManager.programs = { pkgs, config, ... }: {

    programs.gpg = {
      enable = true;
      settings = {
      };
    };

    services = {
      ssh-agent = {
        enable = false;
      };
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableExtraSocket = true;
        enableZshIntegration = config.programs.zsh.enable;
        pinentry.package = pkgs.pinentry-gnome3;
        # if pkgs.stdenv.hostPlatform.isDarwin pkgs.pinentry-gnome3;then pkgs.pinentry_mac else pkgs.pinentry-qt;
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

  flake.modules.nixos."services.base" = { pkgs, ... }: {
    services.dbus.packages = [ pkgs.gcr_3 ];
  };

  flake.modules.darwin.services = { pkgs, ... }: {
    # services.gpg-agent.pinentry.package = pkgs.pinentry_mac;
  };
}
