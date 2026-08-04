{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        location = {
          address = "北京";
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          longitude = 39.904200000000003;
          name = "Beijing; China";
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
          weatherShowEffects = true;
        };
      };
    };
  };
}
