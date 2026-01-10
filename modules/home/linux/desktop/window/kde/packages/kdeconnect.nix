{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    services.kdeconnect = {
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };

    xdg.configFile = {
      "kdeconnect/config".text = ''
        [General]
        keyAlgorithm=EC
        name=nixos
      '';
      "kdeconnect/privateKey.pem".text = ''
        -----BEGIN EC PRIVATE KEY-----
        MHcCAQEEIPWc0CVGMrhshsXU3rIJAIuYm4ODsCmSyocpMgaDLdrVoAoGCCqGSM49
        AwEHoUQDQgAEeIHGX617aXhtGunJlnn4SXOwfMJeaeMZQyGs/fntEf2WyTJhWCff
        tFoRt8uL9fFKkgjM97sSSngWxepLq+Cyjw==
        -----END EC PRIVATE KEY-----
      '';
      "kdeconnect/certificate.pem".text = ''
        -----BEGIN CERTIFICATE-----
        MIIBqjCCAVCgAwIBAgIUKpIKWlrDY3bJJHqJWywp0RmS6dcwCgYIKoZIzj0EAwQw
        VTEvMC0GA1UEAwwmXzZkMTM3MDY2XzE0YjJfNGFiMF85NTc3Xzg5YWNmYzRhNTk1
        NV8xDDAKBgNVBAoMA0tERTEUMBIGA1UECwwLS0RFIENvbm5lY3QwHhcNMjQwMjI5
        MTMxNDA3WhcNMzUwMjI2MTMxNDA3WjBVMS8wLQYDVQQDDCZfNmQxMzcwNjZfMTRi
        Ml80YWIwXzk1NzdfODlhY2ZjNGE1OTU1XzEMMAoGA1UECgwDS0RFMRQwEgYDVQQL
        DAtLREUgQ29ubmVjdDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABHiBxl+te2l4
        bRrpyZZ5+ElzsHzCXmnjGUMhrP357RH9lskyYVgn37RaEbfLi/XxSpIIzPe7Ekp4
        FsXqS6vgso8wCgYIKoZIzj0EAwQDSAAwRQIhALSwK9IhovHaCV3OZ4utWRI5HTFY
        S4OMEbkOZPqYq+OsAiBpN0Ds5KFfEoLafqPfGVlaGpSEhrPa2QLXAb9gAHtt0Q==
        -----END CERTIFICATE-----
      '';
    };

  };
}
