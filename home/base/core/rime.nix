{
  pkgs,
  lib,
  config,
  myvars,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;

  dotfiles = "${config.home.homeDirectory}/${myvars.dotfilePath}";
  rimeConfig = "${dotfiles}/rime";

  fcitx5Config = pkgs.fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "main";
    sha256 = "sha256-YtZS4B82VLty/j4d0SIdjLw040/sdLdSw6VE3B5kWtQ=";
  };

  cleanedFcitx5Config =
    pkgs.runCommand "cleaned-fcitx5-config" {
      buildInputs = [pkgs.coreutils];
    } ''
      mkdir -p $out

      find ${fcitx5Config} -name "*.yaml" \
          -not -name "README*.yaml" \
          -not -name "*terra*.yaml" \
          -not -name "*wubi*.yaml" \
          -not -name "*ibus*.yaml" \
          -not -name "*double_pinyin*.yaml" \
          -not -name "*t9*.yaml" \
          -exec cp -r -t $out {} +

      cp -r ${fcitx5Config}/dicts $out/
      cp -r ${fcitx5Config}/lua $out/
      cp -r ${fcitx5Config}/opencc $out/
      cp -r ${fcitx5Config}/plum $out/
      cp -r ${fcitx5Config}/preview $out/
      cp -r ${fcitx5Config}/tools $out/

    '';
in {
  home.file =
    lib.mkIf isDarwin {
      "Library/Rime/default.custom.yaml" = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${rimeConfig}/default.custom.yaml";
      };
      "Library/Rime/squirrel.custom.yaml" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          "${rimeConfig}/squirrel.custom.yaml";
      };
    }
    // lib.mkIf (!isDarwin) {
      ".local/share/fcitx5/rime" = {
        source = cleanedFcitx5Config;
        recursive = true;
      };
      ".local/share/fcitx5/themes" = {
        source = config.lib.file.mkOutOfStoreSymlink "${rimeConfig}/themes";
        recursive = true;
      };
      ".local/share/fcitx5/rime/fcitx5.custom.yaml" = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${rimeConfig}/fcitx5.custom.yaml";
      };
      ".local/share/fcitx5/rime/default.custom.yaml" = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${rimeConfig}/default.custom.yaml";
      };
    };

  xdg.configFile = lib.mkIf (!isDarwin) {
    "fcitx5/profile" = {
      source = "${rimeConfig}/profile";
      force = true;
    };
    "fcitx5/conf/classicui.conf" = {
      source = "${rimeConfig}/classicui.conf";
      force = true;
    };
    "fcitx5/conf/rime.conf" = {
      source = "${rimeConfig}/rime.conf";
      force = true;
    };
  };

  i18n.inputMethod = lib.mkIf (!isDarwin) {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      # librime
      fcitx5-rime
      fcitx5-lua
      fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;
  };
}
