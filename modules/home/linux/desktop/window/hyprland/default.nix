{
  lib,
  ...
}:
{
  imports = [
    ./options.nix
  ]
  ++ (
    lib.importModule' ./.
    ++ [
      ../../component
    ]
  );
}
