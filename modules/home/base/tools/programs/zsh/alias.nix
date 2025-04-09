{
  programs.zsh = {
    shellAliases = {

      ".." = "cd ..";
      "~" = "cd ~";
      "--" = "cd -";

      du = "dust";
      ps = "procs";
    };
    initExtra = ''

      hash -d desktop="$HOME/Desktop"
      hash -d downloads="$HOME/Downloads"
      hash -d documents="$HOME/Documents"
      hash -d videos="$HOME/Videos"
      hash -d music="$HOME/Music"
      hash -d pictures="$HOME/Pictures"
      hash -d movies="$HOME/Movies"
      hash -d trash="$HOME/.Trash"

    '';
  };
}
