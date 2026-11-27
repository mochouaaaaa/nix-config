{
  flake.aspects = { cli.provides.lazygit.homeManager = {
    programs.lazygit = {
      settings = {
        customCommands = [
          {
            key = "X";
            context = "commits";
            description = "Create fixup commit for selected commit";
            command = "git commit --fixup={{ .SelectedLocalCommit.Hash | quote }}";
            output = "none";
          }
        ];
      };
    };
  };
};
}
