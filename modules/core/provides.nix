{
  flake.aspects = { aspects, ... }: {
    core.includes = [
      aspects.core._.boot
      aspects.core._.locale
      aspects.core._.networking
      aspects.core._.tools
      aspects.core._.users
      aspects.core._.nixpkgs
    ];
  };
}
