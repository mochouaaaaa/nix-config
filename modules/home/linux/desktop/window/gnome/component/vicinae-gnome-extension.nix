{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfgGnome = config.modules'.desktop.gnome;

  vicinae_extension = pkgs.stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-vicinae";
    version = "v1.4.0";
    src = pkgs.fetchzip {
      url = "https://github.com/dagimg-dot/vicinae-gnome-extension/releases/download/${version}/vicinae@dagimg-dot.shell-extension-${version}.zip";
      sha256 = "sha256-bsR2YvkbzZN850XQalc7AKtToGEUL5uHgoTze4ptBjk=";
      stripRoot = false;
    };

    nativeBuildInputs = with pkgs; [ buildPackages.glib ];
    buildPhase = ''
      runHook preBuild
      if [ -d schemas ]; then
        glib-compile-schemas --strict schemas
      fi
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
       mkdir -p $out/share/gnome-shell/extensions/
       cp -r -T . $out/share/gnome-shell/extensions/vicinae@dagimg-dot
       runHook postInstall
    '';
  };

in
{

  config = lib.mkIf cfgGnome.enable {

    programs.gnome-shell = {
      extensions = [
        {
          package = vicinae_extension;
          id = "vicinae@dagimg-dot";
        }
      ];
    };

  };

}
