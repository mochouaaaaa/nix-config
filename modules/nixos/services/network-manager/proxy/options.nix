{ lib, ... }: {

  options.profiles.services.proxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the Proxy(dae && mihomo) service.";
    };
  };

}
