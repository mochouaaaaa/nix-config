{
  pkgs,
  ...
}:
{

  environment.variables.EDITOR = "nvim --clean";

  environment.defaultPackages = with pkgs; [
    git
    git-lfs

    gnutar
    zip
    unzip
    bzip2
    xz
    gzip
    zstd
    p7zip

    gnugrep
    gnused
    gawk

    curl
    wget
    rsync

    coreutils
    findutils
    which
    file
  ];

  environment.systemPackages = with pkgs; [

    ########################
    # network tools
    ########################

    dnsutils
    socat
    mtr

    ########################
    # dev tools
    ########################

    cmake
    ccache
    gnumake

    ########################
    # optional archive tools
    ########################

    rar
    unrar

    ########################
    # optional tools
    ########################

    opencc

  ];

}
