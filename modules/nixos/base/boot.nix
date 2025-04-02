{ inputs, pkgs, ... }:
{
  imports = [ inputs.honkai-railway-grub-theme.nixosModules.${builtins.currentSystem}.default ];
  honkai-railway-grub-theme = {
    enable = true;
    # Remember
    theme = "RuanMei";
  };
}
