self: super: {
  vicinae = super.vicinae.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ self.makeWrapper ];
    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram $out/bin/vicinae \
        --prefix XDG_DATA_DIRS : /var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  });
}
