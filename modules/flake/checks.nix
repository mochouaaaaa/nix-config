{
  perSystem =
    { pkgs, config, ... }:
    {
      checks = {
        # 确保默认开发环境可以构建
        devshell = config.devShells.default;

        # 其他自定义检查可以放这里
      };
    };
}

# nix flake check
