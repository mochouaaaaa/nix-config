{
  pkgs,
  lib,
  config,
  myvars,
  ...
}: let
  defaultConfig = ''
    patch:
      "menu/page_size": 9
      "style/candidate_list_layout": linear
      "style/translucency": true

      schema_list:
        - schema: rime_mint # 薄荷拼音
        - schema: rime_mint_flypy # 薄荷拼音-小鹤混输方案
  '';
  darwinImport = lib.mkIf pkgs.stdenv.isDarwin (import ./darwin.nix {inherit defaultConfig;});
  linuxImport = lib.mkIf pkgs.stdenv.isLinux (import ./linux.nix {inherit defaultConfig config myvars pkgs lib;});
in {
  imports = lib.flatten [darwinImport linuxImport];
}
