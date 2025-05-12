{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.packages.firefox;
in
{
  options = {
    modules.packages.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the firefox package.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        languagePacks = [ "zh-CN" ];
        profiles = {
          "${self.myvars.username}" = {
            isDefault = true;
            settings = {
              "extensions.autoDisableScopes" = 0;

              "browser.startup.homepage" = "about:home";
              "browser.startup.page" = 3;

              "intl.locale.requested" = "zh-CN";

              # Disable irritating first-run stuff
              "browser.disableResetPrompt" = true;
              "browser.download.panel.shown" = true;
              "browser.feeds.showFirstRunUI" = false;
              "browser.messaging-system.whatsNewPanel.enabled" = false;
              "browser.rights.3.shown" = true;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.shell.defaultBrowserCheckCount" = 1;
              "browser.startup.homepage_override.mstone" = "ignore";
              "browser.uitour.enabled" = false;
              "startup.homepage_override_url" = "";
              "trailhead.firstrun.didSeeAboutWelcome" = true;
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.bookmarks.addedImportButton" = true;

              # Don't ask for download dir
              "browser.download.useDownloadDir" = false;

              # Disable crappy home activity stream page
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
              "browser.newtabpage.blocked" = lib.genAttrs [
                # Youtube
                "26UbzFJ7qT9/4DhodHKA1Q=="
                # Facebook
                "4gPpjkxgZzXPVtuEoAL9Ig=="
                # Wikipedia
                "eV8/WsSLxHadrTL1gAxhug=="
                # Reddit
                "gLv0ja2RYVgxKdp0I5qwvA=="
                # Amazon
                "K00ILysCaEq8+bEqV/3nuw=="
                # Twitter
                "T9nJot5PurhJSy8n038xGA=="
              ] (_: 1);

              # Disable some telemetry
              "app.shield.optoutstudies.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "browser.ping-centre.telemetry" = false;
              "datareporting.healthreport.service.enabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.sessions.current.clean" = true;
              "devtools.onboarding.telemetry.logged" = false;
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.hybridContent.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.prompted" = 2;
              "toolkit.telemetry.rejected" = true;
              "toolkit.telemetry.reportingpolicy.firstRun" = false;
              "toolkit.telemetry.server" = "";
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.unifiedIsOptIn" = false;
              "toolkit.telemetry.updatePing.enabled" = false;

              # UI
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "browser.tabs.drawInTitlebar" = true;
              "browser.uidensity" = 0;
              "layers.acceleration.force-enabled" = true;
              "mozilla.widget.use-argb-visuals" = true;
              "widget.gtk.rounded-bottom-corners.enabled" = true;
              "svg.context-properties.content.enabled" = true;
            };
            extensions = {
              packages = with pkgs.nur.repos.rycee.firefox-addons; [
                bitwarden
                immersive-translate
                tampermonkey
                vimium
                enhanced-github
                ublock-origin
                imagus
                (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
                  pname = "BewlyBewly";
                  version = "0.41.1";
                  addonId = "addon@bewlybewly.com";
                  url = "https://addons.mozilla.org/firefox/downloads/file/4444303/bewlybewly-${version}.xpi";
                  sha256 = "sha256-/Gh4EJYvUf5blurfof1MGBhCD+9QKXRwYtMk9eYieu8=";
                  meta = with lib; {
                    homepage = "https://github.com/BewlyBewly/BewlyBewly";
                    description = "BewlyBewly is a browser extension for BiliBili that aims to enhance the user experience by redesigning the BiliBili UI. The design is inspired by YouTube, Vision OS, and iOS, resulting in a more visually appealing and user-friendly interface.Source Code: https://github.com/hakadao/BewlyBewly";
                    license = licenses.mit;
                    mozPermissions = [
                      "activeTab"
                      "tabs"
                      "<all_urls>"
                      "*://bilibili.com"
                      "*://hdslb.com"
                      "*://www.bilibili.com"
                      "*://search.bilibili.com"
                      "*://t.bilibili.com"
                      "*://space.bilibili.com"
                      "*://message.bilibili.com"
                      "*://member.bilibili.com"
                      "*://account.bilibili.com"
                      "*://www.hdslb.com"
                      "*://passport.bilibili.com"
                      "*://music.bilibili.com"
                    ];
                    platforms = platforms.all;
                  };
                })
              ];
            };
          };
        };
      };
    };
  };
}
