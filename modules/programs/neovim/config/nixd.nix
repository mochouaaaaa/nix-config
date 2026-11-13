let
  mkNixdConfig =
    {
      configuration,
      systemOptionName,
    }:
    {
      username,
      hostName,
      ...
    }:
    let
      flakeExpr = "(builtins.getFlake (builtins.toString ./.)).";
      hostExpr = "${flakeExpr}${configuration}.\"${username}@${hostName}\"";
      optionsExpr = "${hostExpr}.options";
      nixpkgsExpr = "${hostExpr}.pkgs";
      homeManagerOptionsExpr = "${optionsExpr}.home-manager.users.type.getSubOptions []";
    in
    {
      programs.neovim.initLua = ''
        vim.lsp.config("nixd", {
          cmd = { "nixd" },
          filetypes = { "nix" },
          root_markers = { "flake.nix", "flake.lock", ".git" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = ${builtins.toJSON nixpkgsExpr},
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                [${builtins.toJSON systemOptionName}] = {
                  expr = ${builtins.toJSON optionsExpr},
                },
                ["home-manager"] = {
                  expr = ${builtins.toJSON homeManagerOptionsExpr},
                },
              },
            },
          },
        })

        vim.lsp.enable("nixd")
      '';
    };
in
{
  # Shared nixd binaries for every Home Manager host using Neovim.
  flake.modules.homeManager.programs-neovim =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };

  # Platform selection is handled by the Home Manager module graph.
  # Read the final package set and options from the corresponding host output.
  flake.modules.homeManager.darwin = mkNixdConfig {
    configuration = "darwinConfigurations";
    systemOptionName = "nix-darwin";
  };

  flake.modules.homeManager.linux = mkNixdConfig {
    configuration = "nixosConfigurations";
    systemOptionName = "nixos";
  };
}
