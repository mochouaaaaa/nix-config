{
  users.extraGroups.vboxusers.members = ["user-with-access-to-virtualbox"];

  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };
  };
}
