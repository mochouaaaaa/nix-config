{
  flake.modules.nixos."services.virtualisation.vm" =
    {
      lib,
      pkgs,
      self,
      ...
    }:
    {
      # Keep VM builds in text mode without changing the host's desktop.
      virtualisation.vmVariant = {
        imports = [ self.modules.nixos.appearance ];

        # The VM store is mounted read-only; install Home Manager packages
        # through users.users.<name>.packages instead of nix profile.
        home-manager.useUserPackages = lib.mkForce true;

        virtualisation.forwardPorts = [
          {
            from = "host";
            host.address = "127.0.0.1";
            host.port = 2223;
            guest.port = 22;
          }
        ];

        programs.hyprland.enable = lib.mkForce false;
        services.xserver.enable = lib.mkForce false;
        services.displayManager.noctalia-greeter.enable = lib.mkForce false;

        environment.systemPackages = [ pkgs.bat ];

        fonts.packages = with pkgs; [
          noto-fonts-cjk-sans
          source-han-sans
          source-han-serif
        ];

        # Use harmless test credentials in the VM instead of host secrets.
        environment.etc."mosdns-vm.env".text = ''
          DNS_ID=vm-test
          DNS_V41=45.90.28.0
          DNS_V61=2a07:a8c0::
          DNS_V42=45.90.30.0
        '';

        environment.etc."mihomo-vm.env".text = ''
          subscription=https://example.invalid/subscription.yaml
        '';

        systemd.services.mosdns.serviceConfig.EnvironmentFile = lib.mkForce [
          "/etc/mosdns-vm.env"
        ];
        systemd.services.mihomo-config.serviceConfig.EnvironmentFile = lib.mkForce [
          "/etc/mihomo-vm.env"
        ];
      };
    };
}
