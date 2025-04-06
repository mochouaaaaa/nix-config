{ pkgs, ... }:
{
  services.ollama = {
    package = pkgs.ollama;
    # acceleration = "cuda";
  };
}
