{
  flake.modules.homeManager.rime =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.profiles.rime;

      yamkFormats = pkgs.formats.yaml { };
    in
    {

      profiles.rime.data-package =
        let
          genIfNotEmpty =
            name: value:
            lib.optional (value != { }) {
              inherit name;
              path = yamkFormats.generate name value;
            };

          extraFiles = lib.flatten (
            lib.mapAttrsToList genIfNotEmpty {
              "squirrel.custom.yaml" = cfg.squirrelCustomYaml;
              "default.custom.yaml" = cfg.defaultCustomYaml;
              "fcitx5.custom.yaml" = cfg.fcitx5CustomYaml;
            }
          );
        in
        pkgs.stdenv.mkDerivation {
          pname = "my-rime-data";
          version = "1.0";

          unpackPhase = "true";
          installPhase = ''
            mkdir -p $out/share/rime-data

            cp -r ${pkgs.rime-wanxiang}/share/rime-data/* $out/share/rime-data/

            ${lib.concatStringsSep "\n" (
              map (file: "ln -sf ${file.path} $out/share/rime-data/${file.name}") extraFiles
            )}
          '';
        };

      profiles.rime = {
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
