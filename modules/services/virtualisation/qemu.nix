{
  flake.aspects.preservation.nixos = { lib, config, ... }: {
    profiles.preservation.directories = lib.optionals config.virtualisation.libvirtd.enable [
      "/var/lib/libvirt"
    ];
  };

  flake.aspects.services.provides.virtualisation.provides.qemu.nixos =
    {
      pkgs,
      username,
      ...
    }:
    {
      users.users.${username}.extraGroups = [ "libvirtd" ];

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        swtpm
        # 如果需要跑非 x86_64 架构，才加 qemu；否则 qemu_kvm 已够
        # qemu
      ];

      networking.firewall.trustedInterfaces = [
        "virbr0"
      ];

      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu;
            runAsRoot = false;
            swtpm.enable = true;
            vhostUserPackages = [ pkgs.virtiofsd ];
          };
          onShutdown = "suspend";
        };
      };

      programs.dconf = {
        enable = true;
        # A "user" profile with a database
        profiles.user.databases = [
          {
            settings = {
              "org/virt-manager/virt-manager/connections" = {
                autoconnect = [ "qemu:///system" ];
                uris = [ "qemu:///system" ];
              };
            };
          }
        ];
      };
    };
}
