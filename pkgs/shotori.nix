{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  libxkbcommon-x11,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "shotori";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "shotori-screenshot";
    repo = "shotori";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    libxkbcommon-x11
    wayland
  ];

  # 上游 cargo build 默认只构建根 package，
  # 不需要构建 tools workspace 成员。
  cargoBuildFlags = [
    "-p"
    "shotori"
  ];

  postInstall = ''
    DESTDIR="$out" \
      sh "$src/scripts/install-desktop.sh" /usr
  '';

  meta = {
    description = "Wayland-native screenshot tool with annotation and OCR";
    homepage = "https://github.com/shotori-screenshot/shotori";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "shotori";
  };
}
