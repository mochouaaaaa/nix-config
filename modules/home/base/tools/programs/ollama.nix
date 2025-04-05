{
  self,
  pkgs,
  ...
}:
{
  services.ollama = {
    enable = self.myvars.packages.ollama && pkgs.stdenv.isLinux;
    acceleration = "rocm";
  };
}
