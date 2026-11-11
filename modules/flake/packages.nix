_:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        # 自定义包
        # my-app = pkgs.callPackage ../../pkgs/my-app { };

        default = pkgs.hello;
      };
    };
}

# nix build .#hello
