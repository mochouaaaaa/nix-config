self: super: {
  "tiny-rdm-wrapper" = super.tiny-rdm.overrideAttrs (oldAttrs: {
    pname = "tiny-rdm-wrapper";

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ super.makeWrapper ];

    postInstall = ''
      wrapProgram "$out/bin/tiny-rdm" \
        --set GDK_BACKEND x11
    '';
  });
}
