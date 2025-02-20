{
  pkgs,
  myvars,
  ...
}: {
  services.ollama = {
    enable = myvars.packages.ollama;
    acceleration = "rocm";
  };
}
