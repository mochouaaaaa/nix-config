{
  flake.aspects =
    {
      lib,
      self,
      ...
    }:
    {
      "services.databases".nixos =
        {
          mysql ? true,
          postgresql ? true,
          redis ? true,
          ...
        }:
        {
          imports =
            lib.optionals mysql [
              self.modules.nixos."services.mysql"
            ]
            ++ lib.optionals postgresql [
              self.modules.nixos."services.postgresql"
            ]
            ++ lib.optionals redis [
              self.modules.nixos."services.redis"
            ];
        };
    };
}
