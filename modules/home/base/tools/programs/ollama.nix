{
  pkgs,
  myvars,
  ...
}: {
  services.ollama = {
    enable = myvars.packages.ollama && pkgs.stdenv.isLinux;
    acceleration = "rocm";
  };
}
