{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      isDarwin = pkgs.stdenv.isDarwin;
      isNixos = pkgs.stdenv.isLinux;

      isHyprland = builtins.getEnv "DESKTOP" == "hyprland";
      isNiri = builtins.getEnv "DESKTOP" == "niri";
      isGnome = builtins.getEnv "DESKTOP" == "gnome";
      isKde = builtins.getEnv "DESKTOP" == "kde";
      isSway = builtins.getEnv "DESKTOP" == "sway";
      isServer = builtins.getEnv "SERVER" == "server";

      isDesktop = isHyprland || isNiri || isGnome || isKde || isSway || isDarwin;

    in
    {
      _module.args = {
        # extraModuleArgs = {

        profiles = {
          desktop = {
            enable = isDesktop;
            inherit
              system

              isHyprland
              isNiri
              isGnome
              isKde
              isSway
              isServer

              isNixos
              isDarwin
              ;
          };
        };

        # };
      };
    };
}
