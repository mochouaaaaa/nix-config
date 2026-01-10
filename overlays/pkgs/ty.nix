self: super: {
  ty = super.ty.overrideAttrs (oldAttrs: rec {
    version = "0.0.11";
    src = super.fetchFromGitHub {
      owner = "astral-sh";
      repo = "ty";
      tag = version;
      fetchSubmodules = true;
      hash = "sha256-lelhsc6zl6Qe7W7YsXviqB3NEOuJAzewnOgFPtsCYGA=";
    };
    cargoDeps = super.rustPlatform.importCargoLock {
      lockFile = src + "/ruff/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
  });
}
