self: super: {
  datagrip =
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

      datagrip = super.jetbrains.datagrip.override {
        inherit vmopts;
        jdk = super.openjdk21;
      };

    in
    if src != null then
      datagrip.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      datagrip;
}
