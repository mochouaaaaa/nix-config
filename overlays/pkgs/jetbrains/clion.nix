self: super:
let
  vmopts = super.callPackage ./jetbrains { };
in
{
  clion = super.jetbrains.clion.override {
    vmopts = builtins.readFile "${vmopts}/share/vmoptions";
  };
}
