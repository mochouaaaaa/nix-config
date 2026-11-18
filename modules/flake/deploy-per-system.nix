{
  inputs,
  self,
  ...
}:
{
  perSystem =
    { system, lib, ... }:
    let
      deploySupported = system != "x86_64-darwin" && builtins.hasAttr system inputs.deploy-rs.packages;
    in
    {
      devShell.packages = lib.optional deploySupported inputs.deploy-rs.packages.${system}.deploy-rs;

      checks =
        if deploySupported && builtins.getEnv "NIX_CONFIG_CHECK" != "1" then
          inputs.deploy-rs.lib.${system}.deployChecks self.deploy
        else
          { };
    };
}
