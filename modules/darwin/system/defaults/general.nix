{
  flake.aspects."system.defaults"."darwin" =
    { username, ... }:
    {
      system.primaryUser = username;

      system.defaults = {
        menuExtraClock.Show24Hour = true;
        NSGlobalDomain = {
          "com.apple.sound.beep.volume" = 0.0;
          "com.apple.sound.beep.feedback" = 0;
        };
      };
    };
}
