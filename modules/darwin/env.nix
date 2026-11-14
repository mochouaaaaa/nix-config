{
  flake.modules.darwin.env = {
    # Resolve the active Xcode SDK when the shell starts; environment.variables
    # treats values as literals and does not evaluate command substitutions.
    environment.extraInit = ''
      export SDKROOT="$(/usr/bin/xcrun --sdk macosx --show-sdk-path)"
      export CGO_CFLAGS="-isysroot $SDKROOT"
      export CGO_LDFLAGS="-isysroot $SDKROOT"
    '';
  };
}
