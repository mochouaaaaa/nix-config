{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.languages.envs.goenv;
  goPath = config.programs.go.GOPATH;
in
{

  options.programs.go.GOPATH = lib.mkOption {
    type = lib.types.nullOr lib.types.path;
    default = null;
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.gopls
      pkgs.gofumpt
      pkgs.delve
      pkgs.goimports-reviser
    ];

    programs = {
      go = {
        enable = true;
        env = {
          GOPATH = goPath;
          GOTELEMETRYDIR = "${goPath}/telemetry";
        }
        // lib.optionalAttrs (!config.programs.zsh.enable) {
          GOBIN = "${goPath}/bin";
          GOMODCACHE = "${goPath}/pkg/mod";
          GOENV = "${goPath}/env";
          GOENV_DISABLE_GOPATH = 1;
          GOPROXY = "https://goproxy.cn,direct";
          GOSUMDB = "sum.golang.google.cn";
        };
      };
      zsh.envExtra = ''
        export GOPATH=${goPath}
        export GOBIN="${goPath}/bin"
        export GOPROXY="https://goproxy.cn,direct"
        export GOSUMDB="sum.golang.google.cn"
        export GOENV_DISABLE_GOPATH=1
        export GOENV="${goPath}/env"
        export GOTELEMETRYDIR="${goPath}/telemetry"
      '';
    };

  };
}
