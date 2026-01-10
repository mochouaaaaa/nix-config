{
  config,
  lib,
  pkgs,
  username,
  inputs,
  ...
}:
let
  cfg = config.profiles.packages.firefox;
  firefoxConfig = config.programs.firefox.profiles."${username}";
in
{

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # about:debugging#/runtime/this-firefox
  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {

    home.file = {
      ".zen/${username}/zen-keyboard-shortcuts.json".source = ./zen-shortcuts.json;
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
              "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
              "{2f67aecb-5dac-4f76-9378-0ac4f2bedc9c}" = "no-chat";
              "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = "imagus";
              "firefox@fehelper.com" = "fehelper";
              "{72bd91c9-3dc5-40a8-9b10-dec633c0873f}" = "Enhanced GitHub";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "Bitwarden";
              "addon@bewlybewly.com" = "bewlybewly";
              "firefox@tampermonkey.net" = "tampermonkey";
              "{5efceaa7-f3a2-4e59-a54b-85319448e305}" = "__MSG_brandName__";
            };
          };

        nativeMessagingHosts = [ pkgs.firefoxpwa ];
        inherit (config.programs.firefox) languagePacks;

        profiles."${username}" = rec {
          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.animate-sidebar" = false;
            "zen.welcome-screen.seen" = true;
          }
          // firefoxConfig.settings;
          extensions = {
            packages = firefoxConfig.extensions.packages;
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

          inherit (firefoxConfig)
            isDefault
            # search
            ;

        };
      };
    };
  };
}
