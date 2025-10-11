{
  config,
  ...
}:
let
  cfg = config.modules'.packages.rime;
  rime-data = cfg.data-package;
in
{
  config = {

    modules'.packages.rime.squirrelCustomYaml =
      let
        ascii = {
          ascii_mode = true;
          ascii_punct = true;
        };
      in
      {
        patch = {
          "menu/page_size" = 9;
          "style/candidate_list_layout" = "linear";
          "style/translucency" = true;

          app_options = {
            com.apple.Spotligh = ascii;
            com.runningwithcrayons.Alfred = ascii;
            com.apple.Terminal = ascii;
            com.github.wez.wezterm = ascii;
            net.kovidgoyal.kitty = ascii;
            com.microsoft.VSCode = ascii;
            com.neovide.neovide = ascii;
            com.tencent.Lemon = ascii;
            com.apple.dt.Xcode = ascii;
            com.nektony.App-Cleaner-SII = ascii;
            com.xunyong.hapigo = ascii;
            com.termius-dmg.mac = ascii;
            com.raycast.macos = ascii;
            com.postmanlabs.mac = ascii;
            com.jetbrains.intellij = ascii;
            com.jetbrains.pycharm = ascii;
          };
        };
      };

    home.file = {
      "Library/Rime" = {
        source = "${rime-data}/share/rime-data";
        recursive = true;
        force = true;
      };
    };
  };
}
