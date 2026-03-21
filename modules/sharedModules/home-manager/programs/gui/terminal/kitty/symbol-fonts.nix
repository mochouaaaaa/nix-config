{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.packages.terminal.kitty;

  generated-symbols = pkgs.writeText "generate-symbol-map.js" ''
    const fs = require("fs");

    const rows = fs.readFileSync("${./test-fonts.sh}", "utf8").split("\n");

    let symbolMap = "";
    let isCapturing = false;
    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      if (row.includes("function test-fonts() {")) {
        isCapturing = true;
        continue;
      } else if (isCapturing) {
        if (row.includes(`echo "`)) {
          const [, title] = row.match(/"(.*)"/);
          symbolMap += `# ''${title}\n`;
        } else if (row.includes(`print-unicode-ranges`)) {
          let [, codes] = row.match(/print-unicode-ranges (.*)/) || [];
          codes = codes.split(" ");
          let ranges = [];
          for (let j = 0; j < codes.length; j += 2) {
            ranges.push([codes[j], codes[j + 1]]);
          }
          ranges = ranges.map(([first, last]) => {
            return `U+''${first}-U+''${last}`;
          });
          symbolMap += `symbol_map ''${ranges.join (",")} Symbols Nerd Font\n\n`;
        } else if (row.includes("}")) {
          break;
        }
      }
    }

    // fs.writeFileSync("${config.xdg.configHome}/kitty/symbol-map.conf", symbolMap);
    process.stdout.write(symbolMap);
  '';

  symbol-map-conf =
    pkgs.runCommand "symbol-map.conf"
      {
        buildInputs = [ pkgs.nodejs ];
      }
      ''
        node ${generated-symbols} > $out
      '';
in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {

    profiles.packages.terminal.kitty.extraConfig = lib.mkAfter [
      # "include symbol-map.conf"
      "include ${symbol-map-conf}"
    ];

    # xdg.configFile."kitty/symbol-map.conf".source = symbol-map-conf;

    # home.activation = {
    #   generate-symbol-map = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     ${pkgs.nodejs}/bin/node ${generated-symbols} \
    #       "${config.xdg.configHome}/kitty/symbol-map1.conf"
    #   '';
    # };

  };

}
