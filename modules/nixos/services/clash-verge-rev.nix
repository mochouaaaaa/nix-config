{pkgs, ...}: {
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev.overrideAttrs (oldAttrs: {
      version = "2.2.2";
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
    configFile = "/home/mochou/.local/share/io.github.clash-verge-rev.clash-verge-rev";
  };
}
