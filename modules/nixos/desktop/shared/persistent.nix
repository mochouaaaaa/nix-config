{ config, lib, ... }:
{
  config = lib.mkIf (config.profiles.desktop.enable) {

    profiles.persistent.hmDirectories = [
      ".icons"

      # ======================================
      # Security
      # ======================================
      {
        directory = ".config/Bitwarden";
        mode = "0700";
      }
      {
        directory = ".local/share/authenticator";
        mode = "0755";
      }

      # ======================================
      # IDE / Editors
      # ======================================
      ".config/kitty"

      # jetbrains
      ".config/JetBrains"
      ".cache/JetBrains"
      ".local/share/JetBrains"
      ".config/.jetbra-free"

      # vscode
      ".vscode"
      ".config/Code"
      ".vscode-insiders" # open source
      ".config/Code - Insiders"

      # zed
      ".local/share/zed"
      ".local/state/zed"

      # ======================================
      # Instant Messaging
      # ======================================
      ".config/QQ"
      ".local/share/materialgram"
      ".local/share/TelegramDesktop"
      ".local/share/fractal"
      ".cache/fractal"

      # ======================================
      # Remote
      # ======================================
      ".config/remmina"
      ".local/share/remmina"

      ".config/freerdp"
      ".zoom"

      # ======================================
      # Browser
      # ======================================
      ".mozilla"
      ".cache/mozilla"
      ".config/zen"
      ".cache/zen"
      ".config/google-chrome"
      ".cache/google-chrome"
      ".config/chromium"
      ".cache/chromium"

      # ======================================
      # Email
      # ======================================
      ".config/evolution"
      ".local/share/evolution"
      ".cache/evolution"

      # ======================================
      # Containers
      # ======================================
      ".local/share/containers"

      ".local/share/flatpak"
      ".var/app"

      ".local/share/vicinae"

      # ======================================
      # custom packages
      # ======================================
      ".config/obs-studio"
      # ".config/wiliwili"
      ".local/share/com.example.piliplus"

      # spotify
      ".config/spicetify"
      ".config/spotify"
      ".cache/spotify"
      ".config/SPlayer"

    ];

  };

}
