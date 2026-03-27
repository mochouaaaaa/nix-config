{ pkgs, lib, ... }:
{
  services.ollama = {
    enable = lib.mkForce false;
    package = pkgs.ollama;
    # acceleration = "cuda";
  };
}
