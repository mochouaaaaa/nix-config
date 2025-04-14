{
  environment.variables = {
    # set clang -lresolv for linker XCode
    SDKROOT = "$(xcrun --sdk macosx --show-sdk-path)";
    CGO_CFLAGS = "-isysroot $SDKROOT";
    CGO_LDFLAGS = "-isysroot $SDKROOT";
  };
}
