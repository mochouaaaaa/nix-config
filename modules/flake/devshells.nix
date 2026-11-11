{
  perSystem =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.devShell = {
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages included in the default devShell.";
        };

        nativeBuildInputs = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };

        inputsFrom = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Development shells to inherit inputs from.";
        };

        env = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
        };

        shellHook = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      };

      config = {
        # 基础工具，作为普通定义参与列表合并
        devShell.packages = with pkgs; [
          just
          statix
          deadnix
        ];

        devShells.default = pkgs.mkShell {
          name = "nix flake";

          nativeBuildInputs = config.devShell.nativeBuildInputs;

          env = config.devShell.env;

          packages = config.devShell.packages;

          inputsFrom = config.devShell.inputsFrom;

          shellHook = ''
            echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
            ${config.devShell.shellHook}
          '';
        };
      };
    };
}
