{ pkgs, username, ... }:
{

  users.users.${username} = {
    shell = "/run/current-system/sw/bin/zsh";
    description = "${username}. up up up!";
  };

  # Default shell
  programs = {
    zsh.enable = true;
  };
  environment = {
    shells = [
      pkgs.zsh
    ];
  };
}
