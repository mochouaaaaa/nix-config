{ pkgs, username, ... }:
{

  users.users.${username} = {
    shell = pkgs.zsh;
    description = "${username}. up up up!";
  };

  # Default shell
  programs = {
    zsh.enable = true;
  };
  environment.shells = [
    pkgs.zsh
  ];
}
