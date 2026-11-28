{
  # Optional performance profile; hosts opt in explicitly.
  flake.aspects."profiles.performance.zram"."nixos" = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      priority = 50;
      memoryPercent = 40;
    };
  };
}
