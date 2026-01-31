{
  lib,
  isNixos,
  isNixDarwin,
  ...
}:
{
  imports = lib.optionals isNixos [ ./_nixos.nix ] ++ lib.optionals isNixDarwin [ ./_darwin.nix ];
}
