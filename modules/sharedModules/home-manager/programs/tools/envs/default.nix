{
  lib,
  ...
}:
{

  options.profiles.languages.envs = {
    python.enable = lib.mkEnableOption "Enable Python environment";
    goenv.enable = lib.mkEnableOption "Enable Go environment";
    node.enable = lib.mkEnableOption "Enable Node environment";
    rust.enable = lib.mkEnableOption "Enable Rust environment";
  };

}
