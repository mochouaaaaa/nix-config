{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "cli.neovim.tooling".includes = [
      aspects."cli.neovim.tooling.languages"
      aspects."cli.neovim.tooling.rules.rustfmt"
    ];
  };
}
