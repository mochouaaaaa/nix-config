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
  environment = {
    localBinInPath = true;
    shells = [
      pkgs.zsh
    ];
  };
}
