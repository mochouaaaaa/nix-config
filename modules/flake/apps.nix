{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      installVm = pkgs.writeShellApplication {
        name = "install-vm";
        runtimeInputs = [ inputs.nixos-anywhere.packages.${system}.nixos-anywhere ];
        text = ''
          target_host="''${INSTALL_HOST:-root@192.168.122.246}"

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
    in
    {
      apps =
        lib.optionalAttrs
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
    };
}
