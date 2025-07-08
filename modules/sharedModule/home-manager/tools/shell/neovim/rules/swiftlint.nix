{ pkgs, ... }:
let
  settingsFormat = pkgs.formats.yaml { };
in
{
  xdg.configFile."rules/swiftlint.yml".source =
    let
      settings = {
      };
    in
    settingsFormat.generate "swiftlint.yml" settings;
}
