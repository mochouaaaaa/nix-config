{

  flake.modules.homeManager."desktop.common" = { self, pkgs, ... }: {
    imports = [
      self.modules.homeManager.development-go
    ];
    home.packages = [
      pkgs.goland
    ];

  };

  flake.modules.homeManager.development-go =
    {
      pkgs,
      config,
      ...
    }:
    let
      goPath =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Volumes/Code/Projects/golang"
        else
          "${config.home.homeDirectory}/Code/Projects/golang";
    in
    {

      config = {

        home.packages = with pkgs; [
          gcc
          gopls
          gofumpt
          delve
          golangci-lint
          goimports-reviser
        ];

        programs = {
          go = {
            enable = true;
            env = {
              GOPATH = goPath;
              GOBIN = "${goPath}/bin";
              GOMODCACHE = "${goPath}/pkg/mod";
              GOENV = "${goPath}/env";
              GOENV_DISABLE_GOPATH = "1";
              GOPROXY = "https://goproxy.cn,direct";
              GOSUMDB = "sum.golang.google.cn";
              GOTELEMETRYDIR = "${goPath}/telemetry";
            };
          };
          # zsh.envExtra = ''
          #   export GOPATH=${goPath}
          #   export GOBIN="${goPath}/bin"
          #   export GOPROXY="https://goproxy.cn,direct"
          #   export GOSUMDB="sum.golang.google.cn"
          #   export GOENV_DISABLE_GOPATH=1
          #   export GOENV="${goPath}/env"
          #   export GOTELEMETRYDIR="${goPath}/telemetry"
          # '';
        };

      };

    };

}
