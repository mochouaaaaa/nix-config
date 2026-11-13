{
  # VS Code is installed outside Home Manager on Intel macOS.
  flake.modules.homeManager.darwin =
    { lib, pkgs, ... }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") {
      programs.vscode.package = null;
    };
}
