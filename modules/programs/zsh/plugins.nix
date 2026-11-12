{
  flake.modules.homeManager.programs =
    { lib, pkgs, ... }:
    let
      fzf-tab-source = pkgs.fetchFromGitHub {
        owner = "Freed-Wu";
        repo = "fzf-tab-source";
        rev = "main";
        sha256 = "sha256-ar025RTlDFWEnE9Ql8WBz4tiBmz1B2tsZiRI2/mVCDI=";
      };
    in
    {

      programs.zsh = {
        autosuggestion.enable = true;
        initContent = lib.mkAfter ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${./p10k.zsh}

          # source ${fzf-tab-source}/fzf-tab-source.plugin.zsh
          # source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

          # source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          # ZSH_AUTOSUGGEST_STRATEGY=(history)

          # source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        '';
        plugins = [
          {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
          }
        ];
      };

    };
}
