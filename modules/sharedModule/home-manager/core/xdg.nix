{ config, ... }:
rec {
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  programs.zsh.envExtra = ''
    export CARGO_HOME="${xdg.dataHome}/cargo";
    export RUSTUP_HOME="${xdg.dataHome}/rustup";
  '';
}
