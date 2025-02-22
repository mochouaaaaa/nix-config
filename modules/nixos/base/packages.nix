{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # system call monitoring
    coreutils
    strace # system call monitoring
    ltrace # library call monitoring
    tcpdump # network sniffer
    lsof # list open files

    # ebpf related tools
    # https://github.com/bpftrace/bpftrace
    #bpftrace # powerful tracing tool
    bpftop # monitor BPF programs
    bpfmon # BPF based visual packet rate monitor

    # system monitoring
    sysstat
    iotop
    iftop
    nmon
    sysbench
    # grimblast

    # system tools
    # (chntpw.overrideAttrs (oldAttrs: {
    #   patches =
    #     oldAttrs.patches
    #     ++ [
    #       (fetchpatch {
    #         url = "https://git.launchpad.net/ubuntu/+source/chntpw/plain/debian/patches/17_hexdump-pointer-type.patch";
    #         sha256 = "ir9LFl8FJq141OwF5SbyVMtjQ1kTMH1NXlHl0XZq7m8=";
    #       })
    #     ];
    # }))
    psmisc # killall/pstree/prtstat/fuser/...
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    udisks
    hdparm # for disk performance, command
    dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
    parted

    icu

    #  export env
    clang
    cmake
    llvmPackages.libcxx
    xz.dev
    tcl-9_0
    (tcl-8_5.overrideAttrs (oldAttrs: rec {
      configureFlags = oldAttrs.configureFlags ++ ["ac_cv_header_stdc=yes"];
    }))

    # tk-9_0
    sqlite.dev
    zlib.dev
    libffi.dev
    readline.dev
    libedit.dev
    bzip2.dev
    openssl.dev
    ncurses.dev
    pkg-config
  ];

  # environment.variables = with pkgs; {
  #   XDG_TERMINAL = "${kitty}/bin/kitty '$@'";
  #
  #   SQLITE_CLIB_PATH = "${sqlite.out}/lib/libsqlite3.so.0";
  #
  #   PKG_CONFIG_PATH = lib.concatStringsSep ":" [
  #     "${readline.dev}/lib/pkgconfig"
  #     "${ncurses.dev}/lib/pkgconfig"
  #     "${libedit.dev}/lib/pkgconfig"
  #   ];
  #
  #   LDFLAGS = pkgs.lib.makeLibraryPath [
  #     zlib
  #     xz
  #     sqlite
  #     tcl-9_0
  #     tk-9_0
  #     readline
  #     libffi
  #     bzip2
  #     ncurses
  #     libedit
  #     openssl
  #   ];
  #
  #   TCL_LIBRARY = "${tcl-9_0}/lib/tcl${tcl.version}";
  #   TK_LIBRARY = "${tk-9_0}/lib/tk${tk.version}";
  #
  #   CPPFLAGS =
  #     "-I${pkgs.zlib.dev}/include -I${pkgs.ncurses.dev}/include  -I${pkgs.tk-9_0.dev}/include -I${pkgs.xz.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.tk-9_0.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
  #   CXXFLAGS =
  #     "-I${pkgs.zlib.dev}/include -I${pkgs.ncurses.dev}/include -I${pkgs.xz.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.tk-9_0.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
  #   CFLAGS = "-I${pkgs.openssl.dev}/include";
  #   CONFIGURE_OPTS = "-with-openssl=${pkgs.openssl.dev}";
  # };

  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  programs.bcc.enable = true;
}
