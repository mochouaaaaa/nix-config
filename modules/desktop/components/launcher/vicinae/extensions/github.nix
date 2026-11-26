{
  flake.modules.homeManager."desktop.launcher.vicinae" =
    { config, ... }:
    let
      extensions = config.profiles.vicinae.extensions;
    in
    {

      programs.vicinae = {
        extensions = with extensions; [
          github
        ];
      };
    };
}
