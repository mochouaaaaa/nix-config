{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.kde;

  kde-control-station = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "kde-control-station";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "kde-control-station";
      rev = "plasma6";
      sha256 = "sha256-DDCDvALvn3IGRUc+CNrKyYI3tjqtBaqhaDtiLVt4s7c=";
    };

    propagatedUserEnvPkgs = with pkgs.kdePackages; [
      plasma-nm
      kdeplasma-addons
      plasma-pa
      powerdevil
      kdeconnect-kde
    ];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plasma/plasmoids/KdeControlStation
      cp -r package/* $out/share/plasma/plasmoids/KdeControlStation
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script { };
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ kde-control-station ];
  };
}
