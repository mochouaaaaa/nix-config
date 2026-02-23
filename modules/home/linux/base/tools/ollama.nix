{ pkgs, pkgs-stable, ... }:
{
  services.ollama = {
    package = pkgs-stable.ollama-rocm.override {
      rocmGpuTargets = [ "gfx1030" ];
    };
    # acceleration = "rocm";
  };
}
