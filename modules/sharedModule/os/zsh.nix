{ pkgs, myvars, ... }:
{

  users.users.${myvars.username} = {
    shell = pkgs.zsh;
    description = "${myvars.username}. up up up!";
  };

  # Default shell
  programs = {
    zsh.enable = true;
  };
  environment.shells = [
    pkgs.zsh
  ];
}
