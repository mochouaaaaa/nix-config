{
  flake.modules.homeManager.programs =
    {
      self,
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      inherit (lib) genAttrs;

      nixSearchEngine = name: template: alias: {
        ${name} = {
          urls = [
            {
              inherit template;
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
          definedAliases = [ alias ];
        };
      };

      blockedTopSites = [
        # YouTube
        "26ubzfj7qt9/4dhodhka1q=="
        # Facebook
        "4gppjkxgzzxpvtueoal9ig=="
        # Wikipedia
        "ev8/wsslxhadrtl1gaxhug=="
        # Reddit
        "glv0ja2ryvgxkdp0i5qwva=="
        # Amazon
        "k00ilyscaeq8+beqv/3nuw=="
        # Twitter
        "t9njot5purhjsy8n038xga=="
      ];

      settings = {
        # Startup
        "browser.startup.homepage" = "about:home";
        "browser.startup.page" = 3;
        "browser.startup.homepage_override.mstone" = "ignore";
        "startup.homepage_override_url" = "";

        # Locale
        "intl.locale.requested" = "zh-CN";
        "intl.multilingual.enabled" = true;
        "general.useragent.locale" = "zh-CN";

        # First-run experience
        "browser.disableresetprompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showfirstrunui" = false;
        "browser.messaging-system.whatsnewpanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkdefaultbrowser" = false;
        "browser.shell.defaultbrowsercheckcount" = 1;
        "browser.uitour.enabled" = false;
        "trailhead.firstrun.didseeaboutwelcome" = true;

        # Bookmarks
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedimportbutton" = true;

        # Downloads
        "browser.download.usedownloaddir" = false;

        # Tabs and navigation
        "browser.link.open_newwindow" = 3;
        "browser.tabs.loadInBackground" = true;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.hoverPreview.enabled" = true;

        # New tab
        "browser.newtabpage.activity-stream.showsponsoredtopsites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topsitesearchshortcuts" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.blocked" = genAttrs blockedTopSites (_: 1);
        "browser.topsites.contile.enabled" = false;

        # UI
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.drawInTitlebar" = true;
        "ui.key.textcontrol.prefer_native_key_bindings_over_builtin_shortcut" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;

        # Swipe gestures
        "browser.gesture.swipe.left" = "";
        "browser.gesture.swipe.right" = "";

        # Extensions
        "extensions.autodisablescopes" = 0;

        # Fonts
        "font.name.serif.zh-CN" = config.profiles.fonts.serif;
        "font.name.sans-serif.zh-CN" = config.profiles.fonts.default;
        "font.name.monospace.zh-CN" = config.profiles.fonts.monospace;

        # Network and DNS
        "network.trr.mode" = 5;
        "network.trr.disable_public_resolvers" = true;
        "network.cookie.CHIPS.lastMigrateDatabase" = 2;
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;
        "network.prefetch-next" = false;
        "network.http.http3.enabled" = true;
        "network.socket.ip_addr_any.disabled" = false;

        # Privacy
        "privacy.resistFingerprinting" = false;
        "privacy.firstparty.isolate" = true;
        "network.cookie.cookieBehavior" = 5;
        "dom.battery.enabled" = false;

        # Telemetry and studies
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

        # Graphics
        "gfx.webrender.all" = true;
      };

      searchEngines = {
        "DuckDuckGo (no CSDN)" = {
          urls = [
            {
              template = "https://duckduckgo.com/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms} -site:csdn.net";
                }
              ];
            }
          ];
          icon = "https://duckduckgo.com/favicon.ico";
          definedAliases = [ "@ddg" ];
        };

        "Google (no CSDN)" = {
          urls = [
            {
              template = "https://www.google.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms} -site:csdn.net";
                }
              ];
            }
          ];
          icon = "https://www.google.com/favicon.ico";
          definedAliases = [ "@gg" ];
        };
        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            }
          ];
          icon = "https://wiki.nixos.org/favicon.ico";
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
          urls = [
            {
              template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}";
            }
          ];
          icon = "https://nixos.org/favicon.png";
          definedAliases = [ "@npr" ];
        };

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
          icon = "https://github.com/favicon.ico";
          definedAliases = [ "@gh" ];
        };

        "Google Translate" = {
          urls = [
            {
              template = "https://translate.google.com/";
              params = [
                {
                  name = "sl";
                  value = "auto";
                }
                {
                  name = "tl";
                  value = "zh-CN";
                }
                {
                  name = "text";
                  value = "{searchTerms}";
                }
                {
                  name = "op";
                  value = "translate";
                }
              ];
            }
          ];
          definedAliases = [ "@tr" ];
        };

        "baidu".metaData.hidden = true;
        "wikipedia".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "google".metaData.hidden = true;
        "amazondotcom-us".metaData.hidden = true;
        "ebay".metaData.hidden = true;
      }
      // nixSearchEngine "Nix Packages" "https://search.nixos.org/packages" "@np"
      // nixSearchEngine "Nix Options" "https://search.nixos.org/options" "@no"
      // nixSearchEngine "homeManager Options" "https://home-manager-options.extranix.com" "@nh";

    in
    {
      imports = [
        self.modules.homeManager."appearance.font-options"
      ];

      programs.firefox = {
        enable = true;
        languagePacks = [ "zh-CN" ];

        profiles.${username} = {
          isDefault = true;
          containersForce = true;
          containers = {
            nix = {
              id = 1;
              name = "nix";
              icon = "briefcase";
              color = "blue";
            };
            github = {
              id = 2;
              name = "github";
              icon = "cart";
              color = "pink";
            };
            llm = {
              id = 3;
              name = "llm";
              icon = "dollar";
              color = "red";
            };
          };

          settings = settings // {
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;
            "extensions.quarantinedDomains.enabled" = true;
          };

          handlers = {
            mimeTypes = {
              "application/pdf" = {
                action = 1;
              };
              "application/zip" = {
                action = 1;
              };
            };
          };

          search = {
            default = "DuckDuckGo (no CSDN)";
            force = true;
            engines = searchEngines;
            order = [
              "DuckDuckGo (no CSDN)"
              "Google (no CSDN)"
              "GitHub"
              "Nix Packages"
              "Nix Options"
            ];
          };
        };
      };
    };
}
