{
  environment.variables = rec {
    # set clang -lresolv for linker XCode
    SDKROOT = "$(xcrun --sdk macosx --show-sdk-path)";
    CGO_CFLAGS = "-isysroot ${SDKROOT}";
    CGO_LDFLAGS = "-isysroot ${SDKROOT}";

    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
  };
}
