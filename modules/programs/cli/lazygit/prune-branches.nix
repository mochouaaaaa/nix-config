{
  flake.aspects = { cli.provides.lazygit.homeManager = { lib, pkgs, ... }: {
    programs.lazygit = {
      settings = {
        customCommands = [
          {
            key = "<c-d>";
            context = "localBranches";
            description = "Prune local branches whose upstream is gone";
            output = "terminal";
            command = ''
              ${lib.getExe pkgs.git} fetch -p && \
              for branch in $(${lib.getExe pkgs.git} for-each-ref --format '%(refname) %(upstream:track)' refs/heads | ${lib.getExe pkgs.gawk} '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do
                ${lib.getExe pkgs.git} branch -D "$branch"
              done
            '';
          }
        ];
      };
    };
  };
};
}
