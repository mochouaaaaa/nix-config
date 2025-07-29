self: super: {
  clion =
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

      clion = super.jetbrains.clion.override {
        inherit vmopts;
        jdk = super.openjdk21;
      };
    in
    if src != null then
      clion.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      clion;
}
