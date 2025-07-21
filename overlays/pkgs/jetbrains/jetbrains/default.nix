{ stdenv, ... }:
stdenv.mkDerivation {
  name = "jetbra";
  src = ./jetbra-free;

  installPhase = ''
    mkdir -p $out/share
    cp -r * $out/share

    cat > $out/share/vmoptions << EOF
      --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
      --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

      -javaagent:$out/share/static/ja-netfilter/ja-netfilter.jar=jetbrains
      -Dawt.toolkit.name=WLToolkit
    EOF
  '';
}
