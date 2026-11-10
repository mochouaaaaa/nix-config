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
            if pkgs.stdenv.hostPlatform.isDarwin then
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
          $DRY_RUN_CMD mkdir -p "${targetDir}"

          $DRY_RUN_CMD mkdir -p "${rimePath}"

          if [ -f "${targetFile}" ]; then
            # 如果存在 sync_dir，则替换
            if grep -q "^sync_dir:" "${targetFile}"; then
              $DRY_RUN_CMD sed -i 's|^sync_dir:.*|sync_dir: "${targetDir}"|' "${targetFile}"
            else
              $DRY_RUN_CMD echo 'sync_dir: "${targetDir}"' >> "${targetFile}"
            fi
            
            if grep -q "^installation_id:" "${targetFile}"; then
              $DRY_RUN_CMD sed -i 's|^installation_id:.*|installation_id: "${targetId}"|' "${targetFile}"
            else
              $DRY_RUN_CMD echo 'installation_id: "${targetId}"' >> "${targetFile}"
            fi
            
            echo "Rime: Updated sync configuration in ${targetFile}"
          else
            $DRY_RUN_CMD echo 'sync_dir: "${targetDir}"' > "${targetFile}"
            $DRY_RUN_CMD echo 'installation_id: "${targetId}"' >> "${targetFile}"
            echo "Rime: Created ${targetFile} with sync configuration"
          fi
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
