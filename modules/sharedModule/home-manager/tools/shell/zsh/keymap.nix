{
  programs = {
    zsh = {
      initContent = ''
        bindkey '^?' backward-delete-char # Ctrl+退格
        bindkey '^h' beginning-of-line    # Ctrl+h 移动到行首
        bindkey '^l' end-of-line        # Ctrl+l 移动到行尾
      '';
    };
    bash = {
      initExtra = '''';
    };
  };
}
