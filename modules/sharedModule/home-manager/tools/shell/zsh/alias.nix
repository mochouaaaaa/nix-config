{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dust
    procs
  ];

  programs =
    let
      shellAliases = {
        du = "dust";
        # ps = "procs";
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

      bashDirAliases = builtins.mapAttrs (name: path: "cd ${path}") dirHashes;

    in
    {
      zsh = {
        shellAliases = shellAliases // {
          ".." = "cd ..";
          "~" = "cd ~";
          "--" = "cd -";
        };
        dirHashes = dirHashes;
      };
      bash = {
        shellAliases = shellAliases // bashDirAliases;
      };
    };
}
