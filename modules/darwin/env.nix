{
  flake.modules.darwin.env = {
    environment.variables = rec {
      # Set clang -lresolv for the Xcode SDK.
      SDKROOT = "$(xcrun --sdk macosx --show-sdk-path)";
      CGO_CFLAGS = "-isysroot ${SDKROOT}";
      CGO_LDFLAGS = "-isysroot ${SDKROOT}";
    };
  };
}
