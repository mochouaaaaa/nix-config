{
  lib,
  pkgs,
  pkgs-unstable,
  isLinux,
  ...
}:
let
  homeExpr =
    if pkgs.stdenv.isLinux then
      "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []"
    else if pkgs.stdenv.isDarwin then
      "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.macos.options.home-manager.users.type.getSubOptions []"
    else
      "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.home.options";
in
{
  home.packages = with pkgs-unstable; [
    # nix
    # nil
    nixd
    nixfmt-rfc-style
  ];

  programs.nixvim.extraConfigLuaPost = ''
    local nvim_lsp = require("lspconfig")
    nvim_lsp.nixd.setup({
       cmd = { "nixd" },
       settings = {
          nixd = {
             nixpkgs = {
                expr = "import <nixpkgs> { }",
             },
             formatting = {
                command = { "nixfmt" },
             },
             options = {
                nixos = {
                   expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options',
                },
                home_manager = {
                   expr = "${homeExpr}",
                },
                nix_darwin = {
                   expr = '(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.macos.options',
                },
             },
          },
       },
    })
  '';
}
