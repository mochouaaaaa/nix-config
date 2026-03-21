{ pkgs, lib, ... }:
{
  home.shellAliases = {

    du = "${lib.getExe pkgs.dust}";
    ".." = "cd ..";
    "~" = "cd ~";
    bak = "cp -iv --";

    desktop = "cd $HOME/Desktop";
    downloads = "cd $HOME/Downloads";
    documents = "cd $HOME/Documents";
    videos = "cd $HOME/Videos";
    music = "cd $HOME/Music";
    pictures = "cd $HOME/Pictures";
    movies = "cd $HOME/Movies";
  };

}
