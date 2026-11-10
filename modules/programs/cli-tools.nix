{
  flake.modules.homeManager.programs = { pkgs, ... }: {

    home.shellAliases = {
      rm = ''echo "请用 trash-put 代替 rm"; false'';
    };

    home.packages = with pkgs; [
      duf
      trash-cli
    ];

  };
}
