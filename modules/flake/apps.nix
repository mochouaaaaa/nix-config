{
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
      deployVm = pkgs.writeShellApplication {
        name = "deploy-vm";
        runtimeInputs = [ pkgs.nixos-rebuild ];
        text = ''
          target_host="${DEPLOY_HOST:-root@192.168.122.246}"

          export NIXPKGS_ALLOW_UNFREE=1
          export NIXPKGS_ALLOW_INSECURE=1

          exec nixos-rebuild switch \
            --flake "${self.outPath}#mochou@vm" \
            --target-host "$target_host" \
            --impure \
            "$@"
        '';
      };
    in
    {
      apps = lib.optionalAttrs (system == "x86_64-linux") {
        deploy-vm = {
          type = "app";
          program = "${deployVm}/bin/deploy-vm";
        };
      };
    };
}
