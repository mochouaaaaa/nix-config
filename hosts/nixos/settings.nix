{
  modules' = {
    network.proxy.clash-party.enable = true;
    virtual = {
      virtualbox.enable = false;
      vmware.enable = false;
      qemu.enable = true;
      docker.enable = true;
    };
    packages = {
      database-suite.enable = true;
      steam = {
        enable = true;
      };
    };
  };
}
