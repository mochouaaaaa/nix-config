self: super: {
  datagrip =
    {
      src ? null,
      ...
    }:
    let

      datagrip = super.jetbrains.datagrip.override {
        # jdk = super.jetbrains.jdk;
      };

    in
    if src != null then
      datagrip.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      datagrip;
}
