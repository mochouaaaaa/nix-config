self: super: {
  pycharm =
    {
      src ? null,
      ...
    }:
    let

      pycharm-professional = super.jetbrains.pycharm.override {
        # jdk = super.jetbrains.jdk;
      };

    in

    if src != null then
      pycharm-professional.overrideAttrs (oldAttrs: {
        inherit src;
      })
    else
      pycharm-professional;
}
