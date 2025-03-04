{pkgs, ...}: let
  net-speed = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "net-speed";
    version = "v3.1";

    src = pkgs.fetchFromGitHub {
      owner = "dfaust";
      repo = "plasma-applet-netspeed-widget";
      tag = "${version}";
      sha256 = "sha256-lP2wenbrghMwrRl13trTidZDz+PllyQXQT3n9n3hzrg=";
    };

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plasma/plasmoids/org.kde.netspeedWidget
      cp -r package/* $out/share/plasma/plasmoids/org.kde.netspeedWidget
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [net-speed];
}
