{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.importModule' ./.;

  home.packages = with pkgs; [
    # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim
    gitleaks

    # ++ lib.optionals myvars.packages.flameshot [
    #   (flameshot.overrideAttrs (oldAttrs: rec {
    #     name = "flameshot-with-grim"; # 修改包名，避免冲突
    #     enableWlrSupport = true;
    #     buildInputs = oldAttrs.buildInputs ++ [
    #       grim
    #       slurp
    #     ]; # 确保 grim 和 slurp 是构建依赖
    #     cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DUSE_WAYLAND_GRIM=ON" ]; # 启用 USE_WAYLAND_GRIM
    #   }))
    # ];
  ];
}
