{
  home = {
    shellAliases = {
      projects = "cd /Volumes/Code";
    };
    sessionVariables = rec {
      GOPATH = "/Volumes/Code/Projects/golang";
      GOBIN = "${GOPATH}/bin";
    };
  };

}
