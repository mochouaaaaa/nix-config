{
  pkgs,
  pkgs-stable,
  self,
  nixpkgs,
  lib,
  inputs,
  ...
}@args:
{
  nixpkgs.overlays = [
    inputs.nuenv.overlays.default
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ] ++ (import ../../overlays args);

  environment.variables.EDITOR = "nvim --clean";

  environment.systemPackages = with pkgs-stable; [
    # fusuma # 手势触控板
    git # used by nix flakes
    git-lfs # used by huggingface models

    # archives
    gnutar
    zip
    unzip
    ouch
    unrar
    bzip2
    xz
    gzip
    zstd
    unzipNLS
    p7zip

    # vsftpd
    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    gnused # GNU sed, very powerful(mainly for replacing text in files)
    gawk # GNU awk, a pattern scanning and processing language

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    wget
    curl
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    findutils
    which
    rsync
    pango

    # extra tools
    clang
    cmake
    opencc
    ccache
  ];
}
