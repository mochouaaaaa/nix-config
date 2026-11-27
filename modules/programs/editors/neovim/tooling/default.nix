{ self, ... }:
{
  flake.aspects."cli.neovim.tooling"."homeManager" = {
    imports = [
      self.modules.homeManager."cli.neovim.tooling.languages"
      self.modules.homeManager."cli.neovim.tooling.rules.rustfmt"
    ];
  };
}
