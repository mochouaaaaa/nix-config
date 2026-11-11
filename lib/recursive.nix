{ lib }:

{
  mkDefaultRecursive =
    attrs:
    lib.mapAttrsRecursive (
      _: value:
      if
        builtins.isString value || builtins.isInt value || builtins.isBool value || builtins.isFloat value
      then
        lib.mkDefault value
      else
        value
    ) attrs;

  mkForceRecursive =
    attrs:
    lib.mapAttrsRecursive (
      _: value:
      if
        builtins.isString value || builtins.isInt value || builtins.isBool value || builtins.isFloat value
      then
        lib.mkForce value
      else
        value
    ) attrs;
}
