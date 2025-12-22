{
  pkgs,
  username,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    services = {
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
    };
    security = {
      polkit = {
        enable = true;
      };
      pam = {
        services = {
          sddm.enableGnomeKeyring = true;
          sddm-greeter.enableGnomeKeyring = true;
          sddm-autologin.enableGnomeKeyring = true;
          greetd.enableGnomeKeyring = true;
          swaylock = { };
          hyprlock = { };
          "${username}" = {
            kwallet.enable = false;
            enableGnomeKeyring = true;
          };
        };
      };
      pki = {
        certificates = [
          ''
            -----BEGIN CERTIFICATE-----
            MIIDNTCCAh2gAwIBAgIUOVlh9TYm7JlgXX/GRCfStBVYPi8wDQYJKoZIhvcNAQEL
            BQAwKDESMBAGA1UEAwwJbWl0bXByb3h5MRIwEAYDVQQKDAltaXRtcHJveHkwHhcN
            MjUwNDIwMDgwMjIyWhcNMzUwNDIwMDgwMjIyWjAoMRIwEAYDVQQDDAltaXRtcHJv
            eHkxEjAQBgNVBAoMCW1pdG1wcm94eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
            AQoCggEBAK2saprfgMcXU1+stTenjNmn9J3oVUXT1/IyPnGtEnLQuIR9TV20B7of
            ZvVg80/tOKHESbz0DlmXkesuz1Sz2MJqMrwv3oi2sBAcfQNcHcRkSo8zqSS/agGa
            rqFBADZ9vDKf0fQhD2fKQNLqa1bFyJkEN+Sary6cUdfqPjA2sEivBNVCHhS7dzlK
            11HW51Z31QhCt+l5wlItncjWFPvV4u4LScwLbOoh1IZSjfQUtOVmhnx/YVIPwQ/e
            DebkNFlyxyHwdA0debV78CiM5DwIe4bki38NFXNSpucfX9fnRs2jH0x75uVTOA7r
            S/nXKK2ioVWNVOvJEP7C95RiKKEnzHcCAwEAAaNXMFUwDwYDVR0TAQH/BAUwAwEB
            /zATBgNVHSUEDDAKBggrBgEFBQcDATAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYE
            FNC4jmsnkdGzLTNihh4r5tJKZPlGMA0GCSqGSIb3DQEBCwUAA4IBAQBiA6upgdiH
            y7btA7yWNnQANXjZcnmxp1YklioMq3+y0Pjp4ubgf0BfB0XgDfLTYmU2BpDheGpo
            g8S4f4BoOO5e2iQRyzajhfHiVR/8MkWn6W0T8Ajycve7Kw5IUQ6VSBXP6pD4OCPj
            xJSFQLtimk54b/p36lN4m+g3TncYlb9xoDN5han11nuizEdqcuYRctItibXwtpQV
            LgNyoXp6Xa7qqHFJStv+MarggrbJutt/PiuKqZVe4U+/HrjlV2AMIQFExeWJIClR
            DjDdQyIjVojuGfATqqNGCN5Bw7Rwi4QwsthyfVbz+2BIlig8q2T5c5FBcjr3aDl6
            fdR2vYbZ065t
            -----END CERTIFICATE-----
          ''
        ];
      };
    };

    # gpg agent with pinentry
    programs.gnupg.agent = {
      pinentryPackage = pkgs.pinentry-qt;
      settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
    };

  };
}
