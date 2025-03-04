{pkgs, ...}: {
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev.overrideAttrs (oldAttrs: {
      version = "2.1.2";
      src =
        oldAttrs.src
        // {
          hash = "1";
        };
    });
  };

  services.mihomo = {
    enable = false;
    tunMode = true;
  };
}
