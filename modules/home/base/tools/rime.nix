{
  self,
  pkgs,
  lib,
  config,
  nvfetcherSources,
  ...
}:
let
  defaultConfig = ''
    patch:
      "menu/page_size": 9
      "style/candidate_list_layout": linear
      "style/translucency": true

      schema_list:
        - schema: rime_mint # 薄荷拼音
        - schema: rime_mint_flypy # 薄荷拼音-小鹤混输方案
  '';

  RimeMintConfig = ''
    patch:
      "menu/page_size": 9
      "key_binder/bindings":
        - { when: has_menu, accept: Super_L+k, send: Page_Up } # 翻页
        - { when: has_menu, accept: Super_L+j, send: Page_Down }
        - {accept: "Super+h", send: Down, when: composing}
        - {accept: "Super+l", send: Left, when: composing}

      # 语言模型
      "grammar/language": wanxiang-lts-zh-hans
      "grammar/collocation_max_length": 5
      "grammar/collocation_min_length": 2

      # translator 内加载
      "translator/contextual_suggestions": true
      "translator/max_homophones": 7
      "translator/max_homographs": 7
  '';

  RimeLMDG = nvfetcherSources.rime-lmdg.src;
  oh-my-rime = nvfetcherSources.oh-my-rime.src;

  cfg = config.modules.packages.rime;

  makeRimeData = pkgs.stdenv.mkDerivation {
    pname = "my-rime-data";
    version = "1.0";

    srcs = [
      RimeLMDG
      oh-my-rime
    ];

    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/rime-data

      cp ${RimeLMDG} $out/share/rime-data/wanxiang-lts-zh-hans.gram
      cp -r ${oh-my-rime}/* $out/share/rime-data/

      # 写入自定义文件（如果有）
      ${pkgs.lib.concatStringsSep "\n" (
        map (
          file: "echo -n ${pkgs.lib.escapeShellArg file.data} > $out/share/rime-data/${file.name}"
        ) cfg.extraFiles
      )}
    '';
  };
in
{
  config = {
    modules.packages.rime.extraFiles = lib.mkBefore [
      {
        name = "default.custom.yaml";
        data = defaultConfig;
      }
      {
        name = "rime_mint.custom.yaml";
        data = RimeMintConfig;
      }
    ];
  };

  options.modules.packages.rime = {
    extraFiles = lib.mkOption {
      default = [ ];
      description = "Extra files to be included in the Rime data package.";
    };
    data-package = lib.mkOption {
      default = makeRimeData;
      description = "The Rime data package.";
    };
  };
}
