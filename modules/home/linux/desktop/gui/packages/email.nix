{
  lib,
  username,
  config,
  pkgs,
  ...
}:
let
  thunderbird-gnome-theme = pkgs.firefox-gnome-theme.overrideAttrs (oldAttrs: {
    pname = "thunderbird-gnome-theme";
    version = config.programs.thunderbird.package.version;

    src = pkgs.fetchFromGitHub {
      owner = "rafaelmardojai";
      repo = "thunderbird-gnome-theme";
      rev = "main";
      hash = "sha256-nSTxAMH+uGrjMWFv1EKhVOnL6QXmbvJByvtSkMJWeVU=";
    };

    postPatch = ''
      patchShebangs ./scripts
      substituteInPlace ./scripts/auto-install.sh \
        --replace-fail \
          'installScript="./scripts/install.sh"' \
          'installScript="${placeholder "out"}/bin/install.sh"' \
        --replace-fail \
          'eval "chmod +x ''${installScript}"' \
          ""
      substituteInPlace ./scripts/install.sh \
        --replace-fail \
          'THEMEDIRECTORY=$(cd "$(dirname $0)" && cd ../.. && pwd)' \
          'THEMEDIRECTORY="${placeholder "out"}/share"' \
        --replace-fail \
          'cp -fR "$THEMEDIRECTORY/thunderbird-gnome-theme"' \
          'cp -fR --no-preserve=mode "$THEMEDIRECTORY/thunderbird-gnome-theme"' \
        --replace-fail \
          'mv chrome/thunderbird-gnome-theme/configuration/user.js' \
          'cp chrome/thunderbird-gnome-theme/configuration/user.js'
    '';

    installPhase =
      builtins.replaceStrings [ "firefox-gnome-theme" ] [ "thunderbird-gnome-theme" ]
        oldAttrs.installPhase;
  });
in
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.activation = {
      active-thunderbird-theme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${thunderbird-gnome-theme}/bin/auto-install.sh
      '';
    };

    programs.thunderbird = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        withExternalGnupg = true;
        settings = {
          "mail.identity.default.archive_enabled" = true;
          "mail.identity.default.archive_keep_folder_structure" = true;
          "mail.identity.default.compose_html" = false;
          "mail.identity.default.protectSubject" = true;
          "mail.identity.default.reply_on_top" = 1;
          "mail.identity.default.sig_on_reply" = false;

          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;

          "browser.display.use_system_colors" = true;
        };
      };

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;

        # Some general settings.
        "mail.server.default.allow_utf8_accept" = true;
        "mail.server.default.max_articles" = 1000;
        "mail.server.default.check_all_folders_for_new" = true;
        "mail.show_headers" = 1;

        # Show some metadata.
        "mailnews.headers.showMessageId" = true;
        "mailnews.headers.showOrganization" = true;
        "mailnews.headers.showReferences" = true;
        "mailnews.headers.showUserAgent" = true;

        # Sort mails and news in descending order.
        "mailnews.default_sort_order" = 2;
        "mailnews.default_news_sort_order" = 2;
        # Sort mails and news by date.
        "mailnews.default_sort_type" = 18;
        "mailnews.default_news_sort_type" = 18;

        # Sort them by the newest reply in thread.
        "mailnews.sort_threads_by_root" = true;
        # Show time.
        "mail.ui.display.dateformat.default" = 1;
        # Sanitize it to UTC to prevent leaking local time.
        "mail.sanitize_date_header" = true;

        # Email composing QoL.
        "mail.identity.default.auto_quote" = true;
        "mail.identity.default.attachPgpKey" = true;

        "app.update.auto" = false;
        "privacy.donottrackheader.enabled" = true;
      };
    };

    xdg.mimeApps.defaultApplicationPackages = [ config.programs.thunderbird.package ];
  };

}
