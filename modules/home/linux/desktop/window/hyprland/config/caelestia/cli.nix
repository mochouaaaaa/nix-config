{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

    xdg.configFile."caelestia/cli.json" = {
      text = ''
        {
          "theme": {
            "enableTerm": true,
            "enableHypr": true,
            "enableDiscord": true,
            "enableSpicetify": true,
            "enableFuzzel": true,
            "enableBtop": false,
            "enableGtk": true,
            "enableQt": true
          },
          "toggles": {
            "communication": {
              "discord": {
                "enable": true,
                "match": [{ "class": "discord" }],
                "command": ["discord"],
                "move": true
              },
              "whatsapp": {
                "enable": true,
                "match": [{ "class": "whatsapp" }],
                "move": true
              }
            },
            "music": {
              "spotify": {
                "enable": true,
                "match": [
                  { "class": "Spotify" },
                  { "initialTitle": "Spotify" },
                  { "initialTitle": "Spotify Free" }
                ],
                "command": ["spicetify", "watch", "-s"],
                "move": true
              },
              "feishin": {
                "enable": true,
                "match": [{ "class": "feishin" }],
                "move": true
              }
            },
            "sysmon": {
              "btop": {
                "enable": false
              }
            },
            "todo": {
              "todoist": {
                "enable": true,
                "match": [{ "class": "Todoist" }],
                "command": ["todoist"],
                "move": true
              }
            }
          }
        }

      '';
    };
  };
}
