let
  mkNixdConfig =
    { configuration }:
    {
      username,
      hostName,
      class,
      ...
    }:
    let
      systemOptionName =
        if class == "darwin" then "nix-darwin" else class;

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
  # Install nixd and nixfmt through the Neovim module already imported by hosts.
  flake.modules.homeManager."programs.neovim" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };

  # Host type is provided by modules/hosts.nix through Home Manager specialArgs.
  flake.modules.homeManager.darwin = mkNixdConfig {
    configuration = "darwinConfigurations";
  };

  flake.modules.homeManager.linux = mkNixdConfig {
    configuration = "nixosConfigurations";
  };
}
