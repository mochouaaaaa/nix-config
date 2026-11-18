{ inputs, self, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
    ../modules/security/agenix/config.nix
  ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      system,
      ...
    }:
    let
      installVm = pkgs.writeShellApplication {
        name = "install-vm";
        runtimeInputs = [ inputs.nixos-anywhere.packages.${system}.nixos-anywhere ];
        text = ''
          target_host="${INSTALL_HOST:-root@192.168.122.246}"

          printf '\nWARNING: nixos-anywhere will repartition and format the target disk.\n'
          printf 'Target: %s\n' "$target_host"
          printf 'This destroys existing data on the target machine.\n\n'
          read -r -p "Type the target host exactly to continue: " confirmation
          if [[ "$confirmation" != "$target_host" ]]; then
            printf 'Confirmation did not match; installation cancelled.\n' >&2
            exit 1
          fi

          exec nixos-anywhere \
            --flake "${self.outPath}#mochou@vm" \
            --target-host "$target_host" \
            "$@"
        '';
      };

      deploySupported =
        system != "x86_64-darwin"
        && builtins.hasAttr system inputs.deploy-rs.packages;

      checkOnly = builtins.getEnv "NIX_CONFIG_CHECK" == "1";

      # Validate only the lightweight host registry. Evaluating system toplevel
      # or Home Manager activation derivations would traverse host packages and
      # unnecessarily force evaluation of external package flakes.
      hostMetadata = inputs.self.lib.hostMetadata;
      checkedHostMetadata = builtins.deepSeq hostMetadata hostMetadata;

      hostsForSystem = lib.filterAttrs (
        _name: host:
        host.system == system
        && builtins.elem host.class [
          "nixos"
          "darwin"
        ]
      ) hostMetadata;

      homeHostsForSystem = lib.filterAttrs (
        _name: host: host.system == system && host.class == "home"
      ) hostMetadata;

      hostToplevelDrvPaths =
        if checkOnly then
          { }
        else
          lib.mapAttrs (
            name: host:
            let
              hostConfig =
                if host.class == "nixos" then
                  inputs.self.nixosConfigurations.${name}
                else
                  inputs.self.darwinConfigurations.${name};
            in
            builtins.addErrorContext "while evaluating ${host.class} host '${name}' toplevel" (
              builtins.unsafeDiscardStringContext hostConfig.config.system.build.toplevel.drvPath
            )
          ) hostsForSystem;

      homeActivationDrvPaths =
        if checkOnly then
          { }
        else
          lib.mapAttrs (
            name: _host:
            builtins.addErrorContext "while evaluating standalone Home Manager host '${name}' activation" (
              builtins.unsafeDiscardStringContext inputs.self.homeConfigurations.${name}.activationPackage.drvPath
            )
          ) homeHostsForSystem;
    in
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
        devShell.packages =
          (with pkgs; [
            just
            statix
            deadnix
          ])
          ++ lib.optional deploySupported inputs.deploy-rs.packages.${system}.deploy-rs;

        devShell.inputsFrom = [ config.pre-commit.devShell ];

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

        packages.default = pkgs.hello;

        apps = lib.optionalAttrs
          (builtins.elem system [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
          ])
          {
            install-vm = {
              type = "app";
              program = "${installVm}/bin/install-vm";
            };
          };

        treefmt = {
          projectRootFile = "flake.nix";

          programs.nixfmt.enable = true;
          programs.deadnix.enable = true;
          programs.statix.enable = true;

          settings.global = {
            "no-cache" = true;
            excludes = [
              ".git/**"
              ".direnv/**"
              "result"
              "result/**"
              "flake.lock"
              "secrets/**"
            ];
          };
        };

        pre-commit.settings.hooks.treefmt = {
          enable = true;
          name = "treefmt";
          entry = "${lib.getExe config.treefmt.build.wrapper} --no-cache";
          language = "system";
          pass_filenames = true;
          files = "\\.nix$";
        };

        checks = {
          # treefmt-nix registers its formatting check automatically.
          devshell = config.devShells.default;
          host-evaluations = pkgs.writeText "host-evaluations.json" (builtins.toJSON checkedHostMetadata);
        }
        // lib.optionalAttrs (!checkOnly && builtins.attrNames hostsForSystem != [ ]) {
          # Evaluating drvPath checks module options and assertions without building
          # the system closure. NIX_CONFIG_CHECK=1 keeps the metadata-only path fast.
          host-toplevels = pkgs.writeText "host-toplevels.json" (builtins.toJSON hostToplevelDrvPaths);
        }
        // lib.optionalAttrs (!checkOnly && builtins.attrNames homeHostsForSystem != [ ]) {
          home-activations = pkgs.writeText "home-activations.json" (builtins.toJSON homeActivationDrvPaths);
        }
        // (
          if deploySupported && !checkOnly then
            inputs.deploy-rs.lib.${system}.deployChecks self.deploy
          else
            { }
        );
      };
    };
