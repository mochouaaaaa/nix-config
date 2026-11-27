{
  flake.aspects = { cli.provides.lazygit.homeManager = { lib, pkgs, ... }: {
    programs.lazygit = {
      settings = {
        customCommands = [
          {
            key = "P";
            context = "commits";
            description = "Push up to selected commit to origin";
            command = "${lib.getExe pkgs.git} push origin {{.SelectedLocalCommit.Sha}}:{{.CheckedOutBranch.Name}}";
            loadingText = "Pushing commit...";
          }
        ];
      };
    };
  };
};
}
