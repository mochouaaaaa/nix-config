{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  home.packages = with pkgs; [];

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = myvars.userfullname;
    userEmail = myvars.useremail;

    # includes = [
    # {
    # use different email & name for work
    # path = "~/work/.gitconfig";
    # condition = "gitdir:~/work/";
    # }
    # ];

    extraConfig = {
      init.defaultBranch = "main";
      trim.bases = "develop,master,main"; # for git-trim
      push.autoSetupRemote = true;
      pull.rebase = true;

      # replace https with ssh
      url = {
        "ssh://git@github.com/${myvars.userfullname}" = {
          insteadOf = "https://github.com/mochouaaaaa";
        };
        # "ssh://git@gitlab.com/" = {
        #   insteadOf = "https://gitlab.com/";
        # };
        # "ssh://git@bitbucket.com/" = {
        #   insteadOf = "https://bitbucket.com/";
        # };
      };
    };

    # signing = {
    #   key = "xxx";
    #   signByDefault = true;
    # };

    # A syntax-highlighting pager in Rust(2019 ~ Now)
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
        # features => named groups of settings, used to keep related settings organized
        # features = "";
      };
    };
  };
}
