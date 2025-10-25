self: super: {
  goland =
    {
      src ? null,
      ...
    }:
    let

      goland = super.jetbrains.goland.override {
        # jdk = super.jetbrains.jdk;
      };

    in
    if src != null then
      goland.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      goland;
}
