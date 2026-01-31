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

              # font
              "font.name.serif.zh-CN" = "${config.profiles.fonts.serif}";
              "font.name.sans-serif.zh-CN" = "${config.profiles.fonts.sansSerif}";
              "font.name.monospace.zh-CN" = "${config.profiles.fonts.monospace}";

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
              default = "ddg";
              force = true;

              engines = {
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };

                "Nix Options" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@no" ];
                };

                "NixOS Wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                  iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                  definedAliases = [ "@nw" ];
                };

                "NUR" = {
                  urls = [
                    {
                      template = "https://nur.nix-community.org/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "https://nur.nix-community.org/images/logonur.png";
                  definedAliases = [ "@nur" ];
                };

                "Nixpkgs PRs" = {
                  urls = [ { template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; } ];
                  icon = "https://nixos.org/favicon.png";
                  definedAliases = [ "@npr" ];
                };

                "GitHub" = {
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
                  definedAliases = [ "@gh" ];
                };

                "Google Translate" = {
                  urls = [
                    { template = "https://translate.google.com/?sl=auto&tl=zh-CN&text={searchTerms}&op=translate"; }
                  ];
                  definedAliases = [ "@tr" ];
                };

                "baidu".metaData.hidden = true;
                "wikipedia".metaData.hidden = true;
                "bing".metaData.hidden = true;
                "google".metaData.hidden = true; # 建议也把 Google 加上，防止它抢占默认
                "amazondotcom-us".metaData.hidden = true;
                "ebay".metaData.hidden = true;
              };
              order = [
                "ddg"
                "GitHub"
                "Nix Packages"
                "Nix Options"
              ];
            };
          };
        };
      };
    };
  };
}
