{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    home.packages = with pkgs; [
      spotify
      spicetify-cli
      # lx-music-desktop
      splayer
      # (splayer.overrideAttrs (oldAttrs: rec {
      #   version = "3.0.0-beta.3";
      #
      #   src = fetchFromGitHub {
      #     owner = "imsyy";
      #     repo = "SPlayer";
      #     tag = "v${version}";
      #     fetchSubmodules = false;
      #     hash = "sha256-bfxIIp8Ma52SEhlQirxnqKwG2ivpEOlCZGoQ2rQldYQ=";
      #   };
      #
      #   pnpmDeps = oldAttrs.pnpm.fetchDeps {
      #     inherit (oldAttrs) pname;
      #     inherit version src;
      #     fetcherVersion = 2;
      #     hash = "sha256-tHz4RtXnoFbSXqV84e6FxHLRHeDyR5sCmVPL0vRNIY8=";
      #   };
      #
      #   buildPhase = ''
      #     runHook preBuild
      #
      #     pnpm build
      #
      #     runHook postBuild
      #   '';
      # }))
    ];

    xdg.configFile = {
      "spicetify/Themes/caelestia/user.css" = {
        text = ''
          /* Background buttons, main play/pause button and progress bar */
          .encore-bright-accent-set,
          .encore-inverted-light-set,
          .x-progressBar-fillColor {
              background-color: var(--spice-button-active) !important;
          }

          /* Left sidebar search button */
          .x-filterBox-expandButton {
              border-radius: 1000px !important;
          }

          /* Queue and recently played right sidebar buttons */
          .encore-text-body-small-bold {
              border-radius: 10px !important;
          }

          /* Hover animations for buttons, tracklist and context menu */
          button,
          .main-trackList-trackListRow,
          .main-contextMenu-menuItemButton {
              transition: color 200ms cubic-bezier(0, 0.55, 0.45, 1), background-color 200ms cubic-bezier(0, 0.55, 0.45, 1) !important;
          }

          /* Search bar and dropdown */
          .main-topBar-searchBar,
          #recent-searches-dropdown > div {
              background-color: var(--spice-main-elevated) !important;
          }

          /* Hide the main header on the home page */
          .main-home-homeHeader {
            display: none !important;
          }

          /* Remove any decorative pseudo-elements inside the home header */
          .search-searchCategory-contentArea::before,
          .search-searchCategory-contentArea::after {
            display: none !important;
            content: none !important;
          }

          /* Hide the gradient background bar that appears between the playlist/album header and the song list */
          .main-actionBarBackground-background {
            display: none !important;
          }

          .main-view-container__scroll-node-child div[style*="--background-base"]:not([style*="--background-base-min-contrast"]) {
            display: none !important;
          }
        '';
      };
    };

  };
}
