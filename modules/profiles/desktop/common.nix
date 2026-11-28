_: {
  flake.aspects = { aspects, ... }: {
    desktop-common =
      {
        browsers ? [
          "chromium"
          "firefox"
        ],
        security ? [
          "authenticator"
          "bitwarden"
        ],
        communication ? [
          "discord"
          "materialgram"
          "tencent"
        ],
        email ? "evolution",
        databases ? [
          "mysql"
          "postgresql"
          "redis"
        ],
        networking ? [
          "openvpn"
          "wireshark"
        ],
      }:
      {
        includes = [
          aspects.desktop-base
          aspects.desktop-hardware
          aspects.desktop-user
          (aspects.desktop-programs._.configured {
            inherit
              browsers
              security
              communication
              email
              databases
              networking
              ;
          })
        ];

        nixos = _: { };
        homeManager = _: { };
      };
  };
}
