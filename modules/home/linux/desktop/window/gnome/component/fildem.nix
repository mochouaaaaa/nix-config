{ pkgs, ... }:
let
  # fildem = pkgs.stdenv.mkDerivation rec {
  fildem = pkgs.python312Packages.buildPythonPackage rec {
    pname = "fildem";

    version = "latest";
    name = "${pname}-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "Sominemo";
      repo = "Fildem-Gnome-45";
      rev = "master"; # 你也可以改成最新的 commit hash
      sha256 = "sha256-VdcRJo0nQX8vQUYzu5zDrrWpHa5T5mpPQ8Gxa6kTtW4="; # 需要运行 `nix-prefetch-url` 获取正确值
    };

    pyproject = false;

    # nativeBuildInputs = with pkgs.python312Packages; [
    build-sysmte = with pkgs.python312Packages; [
      pkgs.python310
      setuptools
      wheel
    ];

    dependencies = with pkgs.python312Packages; [
      setuptools
      distutils
      pygobject3
    ];

    buildInputs = with pkgs; [
      gnome-shell
      gtk3
      bamf
      libdbusmenu
      keybinder3
    ];

    buildPhase = ''
      runHook preBuild
        find . -exec touch -d "2000-01-01" {} +
      python3 setup.py install --optimize=1 --prefix=$out
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions
      cp -r fildemGMenu@gonza.com $out/share/gnome-shell/extensions
    '';

    doCheck = false;
  };
in
{
  # programs.gnome-shell.extensions = (config.programs.gnome-shell.extensions) ++ [fildem];
  # programs.gnome-shell.extensions = config.programs.gnome-shell.extensions ++ [{package= fildem; id="fildemGMenu@gonza.com";} ];
  name = fildem;
  id = "fildemGMenu@gonza.com";
}
