{
  # Optional performance profile; hosts opt in explicitly.
  flake.modules.nixos."profiles.zram" = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      priority = 50;
      memoryPercent = 40;
    };
  };
}
