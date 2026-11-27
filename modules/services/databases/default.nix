{
  flake.aspects =
    {
      aspects,
      lib,
      ...
    }:
    {
      "services.databases" =
        {
          mysql ? true,
          postgresql ? true,
          redis ? true,
        }:
        {
          includes =
            lib.optionals mysql [
              aspects."services.mysql"
            ]
            ++ lib.optionals postgresql [
              aspects."services.postgresql"
            ]
            ++ lib.optionals redis [
              aspects."services.redis"
            ];

          nixos = { };
        };
    };
}
