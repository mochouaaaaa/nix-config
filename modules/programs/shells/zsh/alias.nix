{
  flake.modules.homeManager.programs = { lib, pkgs, ... }: {

    home.shellAliases = {
      du = lib.getExe pkgs.dust;
      bak = "cp -iv";
      ".." = "cd ..";

      desktop = "cd $HOME/Desktop";
      downloads = "cd $HOME/Downloads";
      documents = "cd $HOME/Documents";
      videos = "cd $HOME/Videos";
      music = "cd $HOME/Music";
      pictures = "cd $HOME/Pictures";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      movies = "cd $HOME/Movies";
    };
  };

}
