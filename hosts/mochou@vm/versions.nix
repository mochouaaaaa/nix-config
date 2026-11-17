{ username, ... }:
{
  system.stateVersion = "26.05";
  home-manager.users.${username}.home.stateVersion = "26.05";
}
