{
  flake.aspects."desktop.launcher.vicinae".homeManager =
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
