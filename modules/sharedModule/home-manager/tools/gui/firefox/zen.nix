{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules'.packages.firefox;
in
{

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # about:debugging#/runtime/this-firefox
  config = lib.mkIf (cfg.enable && config.programs.desktop.enable) {

    home.file = {
      ".zen/default/zen-keyboard-shortcuts.json".text = builtins.readFile ./zen-shortcuts.json;
    };

    programs = {

      zen-browser = {
        enable = true;

        policies =
          let
            mkLockedAttrs = builtins.mapAttrs (
              _: value: {
                Value = value;
                Status = "locked";
              }
            );

            mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

            mkExtensionEntry =
              {
                id,
                pinned ? false,
              }:
              let
                base = {
                  install_url = mkPluginUrl id;
                  installation_mode = "force_installed";
                };
              in
              if pinned then base // { default_area = "navbar"; } else base;

            mkExtensionSettings = builtins.mapAttrs (
              _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
            );
          in
          {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true; # save webs for later reading
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            ExtensionSettings = mkExtensionSettings {
              "wappalyzer@crunchlabz.com" = mkExtensionEntry {
                id = "wappalyzer";
                pinned = true;
              };
              "uBlock0@raymondhill.net" = mkExtensionEntry {
                id = "ublock-origin";
                pinned = true;
              };
              "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
              "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
              "github-no-more@ihatereality.space" = "github-no-more";
              "github-repository-size@pranavmangal" = "gh-repo-size";
              "firefox-extension@steamdb.info" = "steam-database";
              "@searchengineadremover" = "searchengineadremover";
              "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
              "trackmenot@mrl.nyu.edu" = "trackmenot";
              "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
              "sponsorBlocker@ajay.app" = "sponsorblock";
            };
            Preferences = mkLockedAttrs {
              "browser.aboutConfig.showWarning" = false;
              "browser.tabs.warnOnClose" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
              # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
              "browser.gesture.swipe.left" = "";
              "browser.gesture.swipe.right" = "";
              "browser.tabs.hoverPreview.enabled" = true;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.topsites.contile.enabled" = false;

              "privacy.resistFingerprinting" = true;
              "privacy.firstparty.isolate" = true;
              "network.cookie.cookieBehavior" = 5;
              "dom.battery.enabled" = false;

              "gfx.webrender.all" = true;
              "network.http.http3.enabled" = true;
              "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0

              "browser.startup.homepage" = "about:home";
              "browser.startup.page" = 3;

              "intl.locale.requested" = "zh-CN";
              "intl.multilingual.enabled" = true;
              "general.useragent.locale" = "zh-CN";

              "browser.disableresetprompt" = true;
              "browser.download.panel.shown" = true;
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
              # "browser.newtabpage.activity-stream.feeds.topsites" = false;
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

            };
          };

        profiles.default = rec {
          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.animate-sidebar" = false;
            "zen.welcome-screen.seen" = true;
          };

          bookmarks = {
            force = true;
            settings = [
              {
                name = "Nix sites";
                toolbar = true;
                bookmarks = [
                  {
                    name = "homepage";
                    url = "https://nixos.org/";
                  }
                  {
                    name = "wiki";
                    tags = [
                      "wiki"
                      "nix"
                    ];
                    url = "https://wiki.nixos.org/";
                  }
                ];
              }
            ];
          };

          pinsForce = true;
          pins = {
            "GitHub" = {
              id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
              workspace = spaces."Rendezvous".id;
              url = "https://github.com";
              position = 101;
              isEssential = false;
            };
            "WhatsApp Web" = {
              id = "1eabb6a3-911b-4fa9-9eaf-232a3703db19";
              workspace = spaces."Rendezvous".id;
              url = "https://web.whatsapp.com/";
              position = 102;
              isEssential = false;
            };
            "Telegram Web" = {
              id = "5065293b-1c04-40ee-ba1d-99a231873864";
              url = "https://web.telegram.org/k/";
              position = 103;
              isEssential = true;
            };
          };

          containersForce = true;
          containers = {
            Shopping = {
              color = "yellow";
              icon = "dollar";
              id = 2;
            };
          };

          spacesForce = true;
          spaces = {
            "Rendezvous" = {
              id = "572910e1-4468-4832-a869-0b3a93e2f165";
              icon = "🎭";
              position = 1000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 216;
                    green = 204;
                    blue = 235;
                    algorithm = "floating";
                    type = "explicit-lightness";
                  }
                ];
                opacity = 0.8;
                texture = 0.5;
              };
            };
            "Research" = {
              id = "ec287d7f-d910-4860-b400-513f269dee77";
              icon = "💌";
              position = 1001;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 171;
                    green = 219;
                    blue = 227;
                    algorithm = "floating";
                    type = "explicit-lightness";
                  }
                ];
                opacity = 0.2;
                texture = 0.5;
              };
            };
            "Shopping" = {
              id = "2441acc9-79b1-4afb-b582-ee88ce554ec0";
              icon = "💸";
              container = containers."Shopping".id;
              position = 1002;
            };
            "Big Big Big Problem" = {
              id = "8ed24375-68d4-4d37-ab7e-b2e121f994c1";
              icon = "😫";
              position = 1003;
            };
          };

          search = {
            force = true;
            default = "google";
            engines =
              let
                nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              in
              {
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
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
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "np" ];
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
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "nop" ];
                };
                "Home Manager Options" = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master"; # unstable
                        }
                      ];
                    }
                  ];
                  icon = nixSnowflakeIcon;
                  definedAliases = [ "hmop" ];
                };
                bing.metaData.hidden = "true";
              };
          };
        };
      };
    };
  };
}
