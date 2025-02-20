{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-viewer
    libvirt
    bridge-utils # 如果需要桥接网络
    dnsmasq # 如果需要使用 dnsmasq 管理网络
    iptables # 防火墙规则
    ebtables # 网桥规则
    iproute2 # 网络工具
    swtpm # 用于虚拟 TPM 设备（可选）
    # quickemu

    # Need to add [File (in the menu bar) -> Add connection] when start for the first time
    virt-manager

    # QEMU/KVM(HostCpuOnly), provides:
    # qemu-storage-daemon
    # qemu-edid
    # qemu-ga
    # qemu-pr-helper
    # qemu-nbd
    # elf2dmp
    # qemu-img
    # qemu-io
    # qemu-kvm
    # qemu-system-x86_64
    # qemu-system-aarch64
    # qemu-system-i386
    qemu_kvm

    # Install QEMU(other architectures), provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    qemu
  ];
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = false;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
        ovmf = {
          enable = true;
          #packages = [(pkgs.unstable.OVMF.override {
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
  };
}
