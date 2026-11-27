{
  flake.aspects."hardware.wifi-tuning"."nixos" = {
    boot.extraModprobeConfig = ''
      options iwlwifi bt_coex_active=0 swcrypto=1 11n_disable=8
    '';
  };
}
