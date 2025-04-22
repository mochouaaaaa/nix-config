{
  lib,
  inputs,
  ...
}@args:
let
  data = builtins.mapAttrs (_: v: v args) (import ./src);

  datawithoutPaths = builtins.attrValues data;

  outputs = {
    darwinConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.darwinConfigurations or { }) datawithoutPaths
    );
  };
in
outputs // { inherit data; }
