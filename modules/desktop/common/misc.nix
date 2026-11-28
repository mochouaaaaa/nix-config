{
  flake.aspects.desktop-base.nixos = {
    services.printing.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput"
    '';
  };
}
