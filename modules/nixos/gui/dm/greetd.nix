{
  pkgs,
  myvars,
  ...
}: {
  services = {
    greetd = {
      enable = true;
      settings = rec {
        terminal.vt = 1;
        default_session = {
          user = myvars.username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
        };
        initial_session = default_session;
      };
    };
  };
}
