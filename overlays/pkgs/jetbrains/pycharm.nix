self: super: {
  pycharm =
    {
      dataPath ? null,
      src ? null,
      ...
    }:
    let
      vmopts =
        let
          vmoptsData = if dataPath != null then (import ./vmopts.nix { inherit dataPath; }).data else null;
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
