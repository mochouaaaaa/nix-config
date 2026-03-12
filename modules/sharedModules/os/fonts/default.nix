{
  inputs,
  lib,
  pkgs,
  isNixos,
  isNixDarwin,
  ...
}:
{

  imports = lib.optionals isNixos [ ./_nixos.nix ] ++ lib.optionals isNixDarwin [ ./_darwin.nix ];

  fonts.packages = with pkgs; [
    inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.fonts.monaco
    maple-mono.CN

    # UI
    inter

    # Icon fonts
    nerd-fonts.symbols-only

    # General purpose fonts from former os/fonts.nix
    fira-code
    noto-fonts
    noto-fonts-cjk-sans
    source-sans
    source-serif
    source-han-sans
    source-han-serif
  ];

  home-manager.sharedModules = [
    {
      config.profiles.fonts = {
        enable = lib.mkForce false;
        default = lib.mkForce "Monaco Fira Nerd";
      };
    }
  ];

}
