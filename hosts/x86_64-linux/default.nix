{
  lib,
  inputs,
  ...
}@args:
let
  data = builtins.mapAttrs (_: v: v args) (import ./src);

  datawithoutPaths = builtins.attrValues data;

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) datawithoutPaths
    );

    homeConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.homeConfigurations or { }) datawithoutPaths
    );
  };
in
outputs // { inherit data; }
