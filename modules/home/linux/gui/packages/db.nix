{ pkgs, config, ... }:
let
  cfg = config.modules.packages;

  tiny-rdb = pkgs.stdenv.mkDerivation rec {
    pname = "tiny-rdb";
    version = "1.2.3";

    src = pkgs.fetchurl {
      url = "https://github.com/tiny-craft/tiny-rdm/releases/download/v${version}/tiny-rdm_${version}_linux_amd64.deb";
      sha256 = "sha256-I1mr5dL2JImB6tqOnrbJoBSb50EyrC/hMJ0KxQPU9XM=";
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    buildInputs = [ pkgs.webkitgtk_4_0 ];
    propagatedBuildInputs = [ pkgs.webkitgtk_4_0 ];
    hardeningSandbox = [ "sandbox" ];
    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/bin
      cp usr/local/bin/tiny-rdm $out/bin/

      mkdir -p $out/share
      mkdir -p $out/share/applications
      substitute usr/share/applications/tiny-rdm.desktop $out/share/applications/tiny-rdm.desktop \
          --replace "/usr/local/bin/tiny-rdm" "$out/bin/tiny-rdm"

      cp -r usr/share/icons $out/share/
      # cp -r usr/share/applications $out/share/
    '';
  };
in
{
  config = {
    home.packages = with pkgs; [
      tiny-rdb
      # navicat-premium
    ];
  };
}
