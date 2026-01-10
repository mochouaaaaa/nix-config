{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.profiles.packages.firefox;
in
{

  # about:debugging#/runtime/this-firefox
  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    programs = {
      firefox = {
        enable = true;
        languagePacks = [ "zh-CN" ];
        nativeMessagingHosts = [ ];
        profiles = {
          "${username}" = {
            isDefault = true;
            settings = {
              "extensions.autodisablescopes" = 0;

              "browser.startup.homepage" = "about:home";
              "browser.startup.page" = 3;

              "intl.locale.requested" = "zh-CN";
              "intl.multilingual.enabled" = true;
              "general.useragent.locale" = "zh-CN";

              # disable irritating first-run stuff
              "browser.disableresetprompt" = true;
              "browser.download.panel.shown" = true;
              "browser.link.open_newwindow" = 3;
              browser.tabs.loadInBackground = true;
              "browser.feeds.showfirstrunui" = false;
              "browser.messaging-system.whatsnewpanel.enabled" = false;
              "browser.rights.3.shown" = true;
              "browser.shell.checkdefaultbrowser" = false;
              "browser.shell.defaultbrowsercheckcount" = 1;
              "browser.startup.homepage_override.mstone" = "ignore";
              "browser.uitour.enabled" = false;
              "startup.homepage_override_url" = "";
              "trailhead.firstrun.didseeaboutwelcome" = true;
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.bookmarks.addedimportbutton" = true;

              # don't ask for download dir
              "browser.download.usedownloaddir" = false;

              # disable crappy home activity stream page
              "browser.newtabpage.activity-stream.showsponsoredtopsites" = false;
              "browser.newtabpage.activity-stream.improvesearch.topsitesearchshortcuts" = false;
              "browser.newtabpage.blocked" = lib.genAttrs [
                # youtube
                "26ubzfj7qt9/4dhodhka1q=="
                # facebook
                "4gppjkxgzzxpvtueoal9ig=="
                # wikipedia
                "ev8/wsslxhadrtl1gaxhug=="
                # reddit
                "glv0ja2ryvgxkdp0i5qwva=="
                # amazon
                "k00ilyscaeq8+beqv/3nuw=="
                # twitter
                "t9njot5purhjsy8n038xga=="
              ] (_: 1);

              # disable some telemetry
              "app.shield.optoutstudies.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "browser.ping-centre.telemetry" = false;
              "datareporting.healthreport.service.enabled" = false;
              "datareporting.healthreport.uploadenabled" = false;
              "datareporting.policy.datasubmissionenabled" = false;
              "datareporting.sessions.current.clean" = true;
              "devtools.onboarding.telemetry.logged" = false;
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.bhrping.enabled" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.firstshutdownping.enabled" = false;
              "toolkit.telemetry.hybridcontent.enabled" = false;
              "toolkit.telemetry.newprofileping.enabled" = false;
              "toolkit.telemetry.prompted" = 2;
              "toolkit.telemetry.rejected" = true;
              "toolkit.telemetry.reportingpolicy.firstrun" = false;
              "toolkit.telemetry.server" = "";
              "toolkit.telemetry.shutdownpingsender.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.unifiedisoptin" = false;
              "toolkit.telemetry.updateping.enabled" = false;

              # ui
              "ui.key.textcontrol.prefer_native_key_bindings_over_builtin_shortcut" = false;
              "browser.tabs.drawintitlebar" = true;

              # network
              "network.trr.mode" = 5;
              "network.trr.disable_public_resolvers" = true;
              "network.cookie.CHIPS.lastMigrateDatabase" = 2;
              "network.dns.disablePrefetch" = true;
              "network.http.speculative-parallel-limit" = 0;
              "network.prefetch-next" = false;

              "browser.aboutConfig.showWarning" = false;
              "browser.tabs.warnOnClose" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
              # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
              # "browser.gesture.swipe.left" = "";
              # "browser.gesture.swipe.right" = "";
              "browser.tabs.hoverPreview.enabled" = true;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.topsites.contile.enabled" = false;

              "privacy.resistFingerprinting" = false; # 会让主题不跟随系统改变
              "privacy.firstparty.isolate" = true;
              "network.cookie.cookieBehavior" = 5;
              "dom.battery.enabled" = false;

              "gfx.webrender.all" = true;
              "network.http.http3.enabled" = true;
              "network.socket.ip_addr_any.disabled" = false; # disallow bind to 0.0.0.0

            };
            search = {
              default = "duckduckgo";
              force = true;
              engines = {
                GitHub = {
                  urls = [
                    {
                      template = "https://github.com/search";
                      params = [
                        {
                          name = "q";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  definedAliases = [ "gh" ];
                };
                nix-packages = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchterms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedaliases = [ "@np" ];
                };
                nixpkgs-prs = {
                  urls = [ { template = "https://nixpk.gs/pr-tracker.html?pr={searchterms}"; } ];
                  icon = "https://nixos.org/favicon.png";
                  updateinterval = 24 * 60 * 60 * 1000; # every day
                  definedaliases = [ "@npr" ];
                };
                nixos-wiki = {
                  name = "NixOS Wiki";
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                  iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                  definedAliases = [ "@nw" ];
                };
                nix-nur = {
                  urls = [
                    {
                      template = "https://nur.nix-community.org/";
                      params = [
                        {
                          name = "query";
                          value = "{searchterms}";
                        }
                      ];
                    }
                  ];
                  icon = "https://nur.nix-community.org/images/logonur.png";
                  updateinterval = 24 * 60 * 60 * 1000;
                  definedaliases = [ "@nur" ];
                };
                bing.metadata.hidden = true;
                duckduckgo.metadata.hidden = true;
                amazonnl.metadata.hidden = true;
              };
            };
          };
        };
      };
    };
  };
}
