self: super: {
  pycharm =
    {
      username ? null,
      src ? null,
      ...
    }:
    let
      vmopts =
        let
          vmoptsData = if username != null then (import ./vmopts.nix { inherit username; }).data else null;
        in
        vmoptsData;

      pycharm-professional = super.jetbrains.pycharm-professional.override {
        inherit vmopts;
        jdk = super.openjdk21;
      };

    in
    if src != null then
      pycharm-professional.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      pycharm-professional;
}
