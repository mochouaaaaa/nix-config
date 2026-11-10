{ self, ... }: {

  flake.modules.homeManager."desktop.common" =
    {
      pkgs,
      config,
      username,
      ...
    }:
    let
      thunderbird-gnome-theme = pkgs.fetchFromGitHub {
        owner = "rafaelmardojai";
        repo = "thunderbird-gnome-theme";
        rev = "main";
        hash = "sha256-nSTxAMH+uGrjMWFv1EKhVOnL6QXmbvJByvtSkMJWeVU=";
      };
    in
    {

      imports = [ self.modules.homeManager.programs-email ];

      home.file.".thunderbird/${username}/chrome/thunderbird-gnome-theme".source =
        thunderbird-gnome-theme;

      xdg.mimeApps.defaultApplicationPackages = [ config.programs.thunderbird.package ];

    };

  flake.modules.homeManager.programs-email =
    {
      username,
      ...
    }:
    {

      programs.thunderbird = {
        enable = true;

        profiles.${username} = {
          isDefault = true;
          withExternalGnupg = true;

          userChrome = ''
            @import "thunderbird-gnome-theme/userChrome.css";
            @import "thunderbird-gnome-theme/theme/colors/dark.css";
          '';
          userContent = ''
            @import "thunderbird-gnome-theme/userContent.css";
          '';

          settings = {
            # 启用 userChrome/userContent
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;

            # 身份默认值
            "mail.identity.default.archive_enabled" = true;
            "mail.identity.default.archive_keep_folder_structure" = true;
            "mail.identity.default.compose_html" = false;
            "mail.identity.default.protectSubject" = true;
            "mail.identity.default.reply_on_top" = 1;
            "mail.identity.default.sig_on_reply" = false;
            "mail.identity.default.auto_quote" = true;
            "mail.identity.default.attachPgpKey" = true;

            # 显示
            "browser.display.use_system_colors" = true;
            "mail.show_headers" = 1;

            # 元数据
            "mailnews.headers.showMessageId" = true;
            "mailnews.headers.showOrganization" = true;
            "mailnews.headers.showReferences" = true;
            "mailnews.headers.showUserAgent" = true;

            # 排序
            "mailnews.default_sort_order" = 2;
            "mailnews.default_news_sort_order" = 2;
            "mailnews.default_sort_type" = 18;
            "mailnews.default_news_sort_type" = 18;
            "mailnews.sort_threads_by_root" = true;
            "mail.ui.display.dateformat.default" = 1;
            "mail.sanitize_date_header" = true;
          };
        };

        # 全局设置
        settings = {
          "mail.server.default.allow_utf8_accept" = true;
          "mail.server.default.max_articles" = 1000;
          "mail.server.default.check_all_folders_for_new" = true;

          "app.update.auto" = false;
          "privacy.donottrackheader.enabled" = true;
        };
      };

    };
}
