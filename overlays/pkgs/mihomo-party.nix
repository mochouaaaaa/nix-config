{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  nss,
  nspr,
  alsa-lib,
  openssl,
  webkitgtk_4_1,
  udev,
  libayatana-appindicator,
  libGL,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "clash-party";
  version = "1.8.6";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/mihomo-party-org/${pname}/releases/download/v${version}/${pname}-linux-${version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-nLX8c1Y71bTgDm0ebKJs4lWN0CrxWfq/NocPaE1NGXw=";
        aarch64-linux = "sha256-3x6xueQS81IWutY0BH52wRdb8Fh2kTQF7QgwZACE6kk=";
      };
    };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk_4_1
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace-fail "/opt/mihomo-party/mihomo-party" "mihomo-party"
    ln -s $out/opt/mihomo-party/mihomo-party $out/bin/mihomo-party

      wrapProgram $out/bin/mihomo-party \
         --set ELECTRON_OZONE_PLATFORM_HINT auto \
         --set NIXOS_OZONE_WL 1 \
         --set GTK_IM_MODULE "fcitx" \
         --add-flags "--enable-features=UseOzonePlatform --ozone-platform=x11 --enable-wayland-ime --use-gl=swiftshader --disable-gpu"

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          udev
          libayatana-appindicator
        ]
      } $out/opt/mihomo-party/mihomo-party
  '';

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/mihomo-party-org/mihomo-party";
    mainProgram = "mihomo-party";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
  };
}
