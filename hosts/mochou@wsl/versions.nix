{ username, ... }: {
  system.stateVersion = "25.05";
  home-manager.users.${username}.home.stateVersion = "24.11";
}
