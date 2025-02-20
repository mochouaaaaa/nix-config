final: prev: {
  # overlay 函数，接收 final 和 prev 两个参数
  ja-netfilter = prev.stdenv.mkDerivation {
    # 使用 prev.stdenv.mkDerivation 定义 ja-netfilter 包
    pname = "ja-netfilter";
    version = "240701";

    src = prev.fetchFromGitHub {
      # 使用 prev.fetchFromGitHub 从 GitHub 下载源代码
      owner = "LostAttractor";
      repo = "jetbra";
      rev = "94585581c360862eab1843bf7edd8082fdf22542";
      sha256 = "sha256-9jeiF9QS4MCogIowu43l7Bqf7dhs40+7KKZML/k1oWo=";
    };

    dontBuild = true; # 不进行构建
    dontFixup = true; # 不进行修复

    installPhase = ''
      # 安装阶段
          runHook preInstall
          mkdir -p $out  # 创建输出目录

          # 解压源代码（如果需要）
          # tar -xzf $src -C $out

          cp ja-netfilter.jar $out  # 复制可执行文件
          cp -r config-jetbrains $out  # 复制配置文件目录
          cp -r plugins-jetbrains $out  # 复制插件目录

          runHook postInstall
    '';

    meta = {
      description = "Jetbrains IDEs crack";
      homepage = "https://3.jetbra.in";
    };
  };
}
