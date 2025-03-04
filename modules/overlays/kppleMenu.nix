final: prev: {
  kpple-menu = prev.stdenvNoCC.mkDerivation {
    pname = "kppleMenu";
    version = "6.0.0"; # 根据实际版本修改

    src = prev.fetchFromGitHub {
      owner = "ChrTall";
      repo = "kppleMenu";
      # tag = "v${version}";
      tag = "v6.0.0";
      sha256 = "sha256-TLLvjZdGdT/8zVpPGwnRofr1NZVDvBUIUpp/kwk3kR4=";
    };

    propagatedUserEnvPkgs = with prev.kdePackages; [prev.kconf];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plasma/plasmoids/com.github.chrtall.kppleMenu
      cp -r package/* $out/share/plasma/plasmoids/com.github.chrtall.kppleMenu
      runHook postInstall
    '';

    passthru.updateScript = prev.nix-update-script {};
  };
}
