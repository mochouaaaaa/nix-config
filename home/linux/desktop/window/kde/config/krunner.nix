{lib, ...}: {
  position = "center";
  activateWhenTypingOnDesktop = false; # 在桌面上输入时不激活
  historyBehavior = "enableSuggestions"; # 启用建议 enableAutoComplete
  shortcuts = {
    launch = lib.mkDefault "Meta+Space";
    runCommandOnClipboard = lib.mkDefault "Meta+Shift+Space";
  };
}
