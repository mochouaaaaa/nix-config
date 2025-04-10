{
  programs.zsh = {
    shellAliases = {

      ".." = "cd ..";
      "~" = "cd ~";
      "--" = "cd -";

      du = "dust";
      ps = "procs";
    };
    dirHashes = {
      desktop = "$HOME/Desktop";
      downloads = "$HOME/Downloads";
      documents = "$HOME/Documents";
      videos = "$HOME/Videos";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      movies = "$HOME/Movies";
      trash = "$HOME/.Trash";
    };
  };
}
