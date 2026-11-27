{
  # GUI development applications are enabled only by Linux desktop hosts.
  flake.aspects."development.gui"."homeManager" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      home.packages = lib.optional config.programs.go.enable pkgs.goland;
    };

  flake.aspects."development.go"."homeManager" =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        gcc
        gopls
        gofumpt
        delve
        golangci-lint
        # goimports-reviser
      ];

      programs.neovim = {
        plugins = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (p: [
            p.go
            p.gomod
            p.gowork
            p.gosum
          ]))
        ];
      };

      programs = {
        vscode = {
          profiles = {
            default = {
              extensions = with pkgs.vscode-extensions; [
                # golang
                golang.go
              ];
            };
          };
        };
      };

      programs.go = {
        enable = true;
        env =
          let
            goPath = "${config.xdg.userDirs.projects}/golang";
          in
          {
            GOPATH = goPath;
            GOBIN = "${goPath}/bin";
            GOMODCACHE = "${goPath}/pkg/mod";
            # GOENV = "${goPath}/env";
            GOPROXY = "https://goproxy.cn,direct";
            GOSUMDB = "sum.golang.google.cn";
            GOTELEMETRY = "off";
            # GOTELEMETRYDIR = "${goPath}/telemetry";
          };
      };
    };
}
