{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.profiles.desktop.enable {

    # home.activation = {
    #   clearRimeBuild =
    #     let
    #       rimePath = if pkgs.stdenv.isDarwin then "$HOME/Library/Rime" else "$HOME/.local/share/fcitx5/rime";
    #     in
    #     lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    #       rm -rf ${rimePath}/build
    #     '';
    # };

    profiles.packages.rime = {
      defaultCustomYaml = {
        patch = {
          "__include" = "wanxiang_suggested_default:/";

          "menu/page_size" = 9;
          "style/candidate_list_layout" = "linear";
          "style/translucency" = true;
          "select_keys" = "123456789";

        };
      };
    };

  };

}
