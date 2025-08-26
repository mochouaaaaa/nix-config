self: super: {
  goland =
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

      goland = super.jetbrains.goland.override {
        inherit vmopts;
        forceWayland = true;
        jdk = super.openjdk21;
      };

    in
    if src != null then
      goland.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      goland;
}
