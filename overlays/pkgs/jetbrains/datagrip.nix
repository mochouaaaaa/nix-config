self: super: {
  datagrip =
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
