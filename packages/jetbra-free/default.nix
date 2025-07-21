{
  lib,
  stdenv,
  buildGoModule,

  go-bindata,
  go,

  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jetbra";
  version = "release";

  src = lib.cleanSource ./src;

  env = {
    CGO_ENABLED = 1;
  };

  nativeBuildInputs = [
    go-bindata
    go
  ];

  vendorHash = "sha256-ZL9Rxnj6Z4oEBeFxX13mnd6F7vSuOFq1R/Ja7OuRp6E=";

  checkPhase = "true";

  buildPhase =
    ''
      runHook preBuild
      go-bindata --version
      go-bindata -o internal/util/access.go -pkg util static/... templates/... cache/...
    ''
    + lib.optionalString (stdenv.isDarwin && stdenv.hostPlatform.system == "x86_64-darwin") ''
      make build-mac
    ''
    + lib.optionalString (
      stdenv.isDarwin && stdenv.hostPlatform.system == "aarch64-darwin"
    ) ''make build-mac-arm''
    + lib.optionalString (stdenv.isLinux) ''
      make build-linux
    ''
    + ''
      runHook postBuild
    '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString (stdenv.isLinux) ''
      install -Dm 0755 ./bin/jetbra-free-linux-amd64 $out/bin/jetbra-free
    ''
    + lib.optionalString (stdenv.isDarwin && stdenv.hostPlatform.system == "x86_64-darwin") ''
      install -Dm 0755 ./bin/jetbra-free-darwin-amd64 $out/bin/jetbra-free
    ''
    + lib.optionalString (
      stdenv.isDarwin && stdenv.hostPlatform.system == "aarch64-darwin"
    ) ''install -Dm 0755 ./bin/jetbra-free-darwin-arm64 $out/bin/jetbra-free''

    + ''
      mkdir $out/bin/.jetbra-free
      cp -r static $out/bin/.jetbra-free/
      cp -r cache/* $out/bin/.jetbra-free/

      make clean
      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

})
