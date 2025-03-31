{
  pkgs,
  myvars,
  ...
}: {
  home.packages = with pkgs; [
    lsd
    eza
    procs
    less
    lftp

    zoxide
    tree
    jq
    chafa
    ueberzugpp
    ffmpegthumbnailer
    tmux
    trash-cli

    # Misc
    tldr
    cowsay
    gnupg
    gnumake

    # Modern cli tools, replacement of grep/sed/...

    # Interactively filter its input using fuzzy searching, not limit to filenames.
    fzf
    luajitPackages.fzf-lua
    # search for files by name, faster than find
    fd
    # search for files by its content, replacement of grep
    (ripgrep.override {withPCRE2 = true;})

    # A fast and polyglot tool for code searching, linting, rewriting at large scale
    # supported languages: only some mainstream languages currently(do not support nix/nginx/yaml/toml/...)
    ast-grep

    sad # CLI search and replace, just like sed, but with diff preview.
    yq-go # yaml processor https://github.com/mikefarah/yq
    just # a command runner like make, but simpler
    delta # A viewer for git and diff output
    hyperfine # command-line benchmarking tool
    gping # ping, but with a graph(TUI)
    doggo # DNS client for humans
    duf # Disk Usage/Free Utility - a better 'df' alternative
    du-dust # A more intuitive version of `du` in rust
    gdu # disk usage analyzer(replacement of `du`)

    nix-output-monitor
    hydra-check # check hydra(nix's build farm) for the build status of a package
    nix-index # A small utility to index nix store paths
    nix-init # generate nix derivation from url
    # https://github.com/nix-community/nix-melt
    nix-melt # A TUI flake.lock viewer
    # https://github.com/utdemir/nix-tree
    nix-tree # A TUI to visualize the dependency graph of a nix derivation

    # productivity
    caddy # A webserver with automatic HTTPS via Let's Encrypt(replacement of nginx)
    croc # File transfer between computers securely and easily
    # ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)

    # dev env
    zinit

    emojify
  ];

  programs = {
    # Atuin replaces your existing shell history with a SQLite database,
    # and records additional context for your commands.
    # Additionally, it provides optional and fully encrypted
    # synchronisation of your history between machines, via an Atuin server.
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
