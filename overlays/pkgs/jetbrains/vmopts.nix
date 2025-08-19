{ dataPath, ... }:
{
  data = ''
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

    -javaagent:${dataPath}/.jetbra-free/static/ja-netfilter/ja-netfilter.jar=jetbrains
    -Dawt.toolkit.name=WLToolkit
  '';
}
