{
  flake.modules.nixos."services.virtualisation.qemu" =
    {
      pkgs,
      ...
    }:
    {

      profiles.preservation.directories  = [
        "/var/lib/qemu"
      ];

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        swtpm
        # 如果需要跑非 x86_64 架构，才加 qemu；否则 qemu_kvm 已够
        # qemu
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
