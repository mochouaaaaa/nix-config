{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.packages.google-chrome;
in
{
  options.profiles.packages.google-chrome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Google Chrome.";
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [
        { id = "bkdgflcldnnnapblkhphbgpggdiikppg"; } # duckduckgo
        { id = "ffabmkklhbepgcgfonabamgnfafbdlkn"; } # gzip github
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "immpkjjlgappgfkkfieppnmlhakdmaab"; } # imagus
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        { id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; } # 沉浸式翻译
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "bbbiejemhfihiooipfcjmjmbfdmobobp"; } # BewlyBewly
        { id = "pkgccpejnmalmdinmhkkfafefagiiiad"; } # 前端助手
        { id = "lcbjdhceifofjlpecfpeimnnphbcjgnc"; } # xBrowserSync
      ];
      description = "List of Google Chrome extensions to install.";
    };
  };

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    programs.chromium = {
      enable = true;
      extensions = cfg.extensions;
    };
  };
}
