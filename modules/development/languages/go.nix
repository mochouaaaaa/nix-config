{
  flake.modules.homeManager.development = { self, ... }: {
    imports = [ self.modules.homeManager."development.go" ];
  };

  # GUI development applications are enabled only by Linux desktop hosts.
  flake.modules.homeManager."development.gui" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      home.packages = lib.optional config.programs.go.enable pkgs.goland;
    };

  flake.modules.homeManager."development.go" =
    { pkgs, config, ... }:
    let
      goPath =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Volumes/Code/Projects/golang"
        else
          "${config.home.homeDirectory}/Code/Projects/golang";
    in
    {
      home.packages = with pkgs; [
        gcc
        gopls
        gofumpt
        delve
        golangci-lint
        goimports-reviser
      ];
      programs.go = {
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
    };
}
