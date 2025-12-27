{
  lib,
  ...
}:
{

  options.modules'.packages.envs = {
    python.enable = lib.mkEnableOption "Enable Python environment";
    goenv.enable = lib.mkEnableOption "Enable Go environment";
    node.enable = lib.mkEnableOption "Enable Node environment";
    rust.enable = lib.mkEnableOption "Enable Rust environment";
  };

  imports = lib.importModule' ./.;

}
