{ username, ... }:
{
  system.stateVersion = "6";
  home-manager.users.${username}.home.stateVersion = "24.11";

}
