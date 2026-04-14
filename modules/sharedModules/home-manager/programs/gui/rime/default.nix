{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.profiles.desktop.enable {

    home.activation = {
      RimeSync =
        let
          platformConfig =
            if pkgs.stdenv.isDarwin then
              {
                rimePath = "${config.home.homeDirectory}/Library/Rime";
                syncDir = "/Volumes/Code/rime-sync";
                id = "rime-darwin";
              }
            else
              {
                rimePath = "${config.home.homeDirectory}/.local/share/fcitx5/rime";
                syncDir = "${config.home.homeDirectory}/Code/rime-sync";
                id = "rime-linux";
              };

          targetId = platformConfig.id;
          targetDir = platformConfig.syncDir;
          targetFile = "${platformConfig.rimePath}/installation.yaml";
          rimePath = platformConfig.rimePath;
        in
        lib.hm.dag.entryBefore [ "writeBoundary" ] ''
            if [ -f "${targetFile}" ]; then
            if grep -q "sync_dir:" "${targetFile}"; then
              $DRY_RUN_CMD sed -i 's|^sync_dir:.*|sync_dir: "${targetDir}"|' "${targetFile}"
              $DRY_RUN_CMD sed -i 's|^installation_id:.*|installation_id: "${targetId}"|' "${targetFile}"
              echo "Rime: Updated sync_dir to ${targetDir}"
            else
              $DRY_RUN_CMD echo 'sync_dir: "${targetDir}"' >> "${targetFile}"
              echo "Rime: Added sync_dir configuration"
            fi
          else
            $DRY_RUN_CMD mkdir -p "${rimePath}"
            $DRY_RUN_CMD echo 'sync_dir: "${targetDir}"' > "${targetFile}"
            echo "Rime: Created ${targetFile} with sync_dir"
          fi
        '';
    };

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
