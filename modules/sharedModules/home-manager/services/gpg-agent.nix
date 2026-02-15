{
  pkgs,
  config,
  ...
}:
{

  programs.gpg = {
    enable = true;
    settings = {
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = config.programs.zsh.enable;
    pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
    defaultCacheTtlSsh = 3600;
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
    maxCacheTtlSsh = 7200;
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

}
