{
  lib,
  ...
}:
lib.makeExtensible (self: {
  macosSystem = import ./macosSystem.nix;
  nixosSystem = import ./nixosSystem.nix;
  otherSystem = import ./otherSystem.nix;

  attrs = import ./attrs.nix { inherit lib; };

  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  scanPathsAsAttrs =
    path:
    builtins.listToAttrs (
      map
        (name: {
          name = name;
          value = "./${name}"; # 确保是 Nix 路径，而不是字符串
        })
        (
          builtins.attrNames (
            lib.attrsets.filterAttrs (_name: type: type == "directory") (builtins.readDir path)
          )
        )
    );
})
