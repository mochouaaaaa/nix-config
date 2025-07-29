self: super:
let

in
{
  goland =
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

      goland = super.jetbrains.goland.override {
        inherit vmopts;
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
