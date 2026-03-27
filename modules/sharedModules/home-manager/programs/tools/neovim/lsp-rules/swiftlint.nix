{ pkgs, lib, ... }:
let
  settingsFormat = pkgs.formats.yaml { };

  settings = { };
in
{
  xdg.configFile."rules/swiftlint.yml" = lib.mkIf (settings != { }) {
    source = (settingsFormat.generate "swiftlint.yml" settings);
  };
}
