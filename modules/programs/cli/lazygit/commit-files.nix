{
  flake.aspects."programs.lazygit"."homeManager" = { lib, pkgs, ... }: {
    programs.lazygit = {
      settings = {
        customCommands = [
          {
            key = "f";
            context = "commitFiles";
            description = "Difftool selected commit file against working copy";
            output = "terminal";
            command = "${lib.getExe pkgs.git} difftool -y {{.SelectedLocalCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
          }
        ];
      };
    };
  };
}
