{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.packages.envs.goenv;

  goenv = pkgs.stdenv.mkDerivation rec {
    name = "goenv";
    version = "2.2.22";

    src = pkgs.fetchFromGitHub {
      owner = "go-nv";
      repo = "goenv";
      tag = "${version}";
      hash = "sha256-cNPf7pRnhTxW5Px8YjJFYhp/Z8WhJPB43Reu+ixWKEQ=";
    };

    phases = [ "installPhase" ];
    # config
    installPhase = ''

      mkdir -p "$out"

      cp $src/APP_VERSION "$out/APP_VERSION"
      cp -R $src/bin "$out/bin"
      cp -R $src/libexec "$out/libexec"
      cp -R $src/plugins "$out/plugins"
      cp -R $src/completions "$out/completions"

      substituteInPlace "$out/libexec/goenv-version-name" \
        --replace-fail "/bin/ls" "ls"
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "env/goenv" = {
        source = goenv;
        recursive = true;
        force = true;
      };
    };

    home.sessionVariables =
      let
        gopath = config.home.sessionVariables.GOPATH;
      in
      {
        GOBIN = "${gopath}/bin";
        GOPROXY = "https://goproxy.cn,direct";
        GOSUMDB = "sum.golang.google.cn";
        GOENV_DISABLE_GOPATH = 1;
        GOENV = "${gopath}/env";
        GOTELEMETRYDIR = "${gopath}/telemetry";
      };

    programs = {
      go = {
        enable = true;
      };
      zsh.initContent = lib.mkOrder 2050 ''
        export GOENV_ROOT="$HOME/.config/env/goenv"
        export PATH="$GOENV_ROOT/bin:$GOENV_ROOT/shims:$PATH"

        if (( $+commands[goenv] )) &>/dev/null; then
            _sukka_lazyload_command_goenv() {
                eval "$(goenv init -)"
            }

            _sukka_lazyload_completion_goenv() {
                source "$GOENV_ROOT/completions/goenv.zsh"
            }

            _lazyload_add_command goenv
            _lazyload_add_completion goenv
        fi
      '';
    };
  };
}
