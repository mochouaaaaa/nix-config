{
  home.shellAliases = {
    projects = "cd /Volumes/Code";
  };

  programs = {
    go = rec {
      goPath = "/Volumes/Code/Projects/golang";
      goBin = "${goPath}/bin";
    };
  };

}
