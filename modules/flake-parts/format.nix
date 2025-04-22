{
  perSystem =
    { pkgs, ... }:
    {
      config = {
        formatter = pkgs.alejandra;
      };

    };
}
