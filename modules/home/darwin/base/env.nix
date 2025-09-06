{
  home = {
    shellAliases = {
      projects = "cd /Volumes/Code";
    };
    sessionVariables = rec {
      goPath = "/Volumes/Code/Projects/golang";
      goBin = "${goPath}/bin";
    };
  };

}
