{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "albert/config".text = ''
        [General]
        frontend=widgetsboxmodel
        hotkey=
        telemetry=true

        [application]
        enabled=true

        [applications]
        enabled=true
        use_exec=true
        use_generic_name=true
        use_keywords=true
        use_non_localized_name=true

        [chromium]
        enabled=true

        [clipboard]
        enabled=true
        persistent=true

        [datetime]
        enabled=true
        show_date_on_empty_query=true

        [files]
        enabled=true

        [github]
        enabled=true

        [hash]
        enabled=true

        [path]
        enabled=true

        [spotify]
        enabled=true

        [ssh]
        enabled=true

        [system]
        enabled=true

        [timezones]
        enabled=true

        [urlhandler]
        enabled=true

        [calculator_qalculate]
        enabled=true
        functions_in_global_query=true
        units_in_global_query=true


        [vpn]
        enabled=false

        [websearch]
        enabled=true

        [widgetsboxmodel]
        alwaysOnTop=true
        clearOnHide=true
        clientShadow=true
        darkTheme=Default Dark
        displayScrollbar=false
        followCursor=true
        hideOnFocusLoss=true
        historySearch=true
        itemCount=5
        lightTheme=Default Light
        quitOnClose=false
        showCentered=true
        systemShadow=true

        [widgetsboxmodel-ng]
        alwaysOnTop=true
        clearOnHide=true
        displayScrollbar=false
        followCursor=true
        hideOnFocusLoss=true
        historySearch=true
        itemCount=5
        quitOnClose=false
        showCentered=true

      '';
      "albert/websearch/enginer.json".text = ''
         [
            {
                "fallback": false,
                "iconPath": ":amazon",
                "id": "033102b8",
                "name": "Amazon",
                "trigger": "ama",
                "url": "http://www.amazon.com/s/?field-keywords=%s"
            },
            {
                "fallback": true,
                "iconPath": ":gpt",
                "id": "66e593a7",
                "name": "Chat GPT",
                "trigger": "gpt",
                "url": "https://chat.openai.com/?q=%s"
            },
            {
                "fallback": true,
                "iconPath": ":duckduckgo",
                "id": "fda277b1",
                "name": "DuckDuckGo",
                "trigger": "dd",
                "url": "https://duckduckgo.com/?q=%s"
            },
            {
                "fallback": false,
                "iconPath": ":ebay",
                "id": "8ec21cfe",
                "name": "Ebay",
                "trigger": "eb",
                "url": "http://www.ebay.com/sch/i.html?_nkw=%s"
            },
            {
                "fallback": true,
                "iconPath": ":github",
                "id": "3ebc4318",
                "name": "GitHub",
                "trigger": "gh",
                "url": "https://github.com/search?utf8=✓&q=%s"
            },
            {
                "fallback": true,
                "iconPath": ":google",
                "id": "912294d1",
                "name": "Google",
                "trigger": "gg",
                "url": "https://www.google.com/search?q=%s"
            },
            {
                "fallback": false,
                "iconPath": ":maps",
                "id": "7f52049d",
                "name": "Google Maps",
                "trigger": "maps",
                "url": "https://www.google.com/maps/search/%s/"
            },
            {
                "fallback": false,
                "iconPath": ":scholar",
                "id": "869edbb5",
                "name": "Google Scholar",
                "trigger": "scholar",
                "url": "https://scholar.google.com/scholar?q=%s"
            },
            {
                "fallback": false,
                "iconPath": ":google_translate",
                "id": "ab93aee0",
                "name": "Google Translate",
                "trigger": "gt",
                "url": "https://translate.google.com/?text=%s"
            },
            {
                "fallback": false,
                "iconPath": ":wolfram",
                "id": "414db647",
                "name": "Wolfram Alpha",
                "trigger": "wa",
                "url": "https://www.wolframalpha.com/input/?i=%s"
            },
            {
                "fallback": true,
                "iconPath": ":youtube",
                "id": "847c46e0",
                "name": "YouTube",
                "trigger": "yt",
                "url": "https://www.youtube.com/results?search_query=%s"
            }
        ]
      '';
    };
  };
}
