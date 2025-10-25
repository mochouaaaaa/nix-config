self: super: {
  clion =
    {
      src ? null,
      ...
    }:
    let

      clion = super.jetbrains.clion.override {
        # jdk = super.jetbrains.jdk;
      };

    in

    if src != null then
      clion.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      clion;
}
