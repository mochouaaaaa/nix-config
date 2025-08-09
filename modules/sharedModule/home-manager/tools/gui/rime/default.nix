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

in
{

  imports = [ ./options.nix ];

  config = {
    modules'.packages.rime.extraFiles = [
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

}
