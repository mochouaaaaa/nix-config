self: super: {
  ty = super.ty.overrideAttrs (oldAttrs: rec {
    version = "0.0.12";
    src = super.fetchFromGitHub {
      owner = "astral-sh";
      repo = "ty";
      tag = version;
      fetchSubmodules = true;
      hash = "sha256-HbIntp5dhJgR3WdX3mtxhghHo5twQFiGfbHprWSsei8=";
    };
    cargoDeps = super.rustPlatform.importCargoLock {
      lockFile = src + "/ruff/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
  });
}
