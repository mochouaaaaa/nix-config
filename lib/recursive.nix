{ lib }:

{
  mkDefaultRecursive = attrs: lib.mapAttrsRecursive (_: value: lib.mkDefault value) attrs;

  mkForceRecursive = attrs: lib.mapAttrsRecursive (_: value: lib.mkForce value) attrs;
}
