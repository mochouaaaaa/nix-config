{
  flake.modules.homeManager."programs.lazygit" = {
    programs.lazygit = {
      settings = {
        customCommands = [
          {
            key = "n";
            context = "localBranches";
            description = "Create feat/ or fix/ branch";
            prompts = [
              {
                type = "menu";
                title = "Branch prefix";
                options = [
                  {
                    name = "feat/";
                    value = "feat/";
                  }
                  {
                    name = "fix/";
                    value = "fix/";
                  }
                  {
                    name = "chore/";
                    value = "chore/";
                  }
                ];
              }
              {
                type = "input";
                title = "Branch name";
                initialValue = "";
              }
            ];
            command = "git checkout -b {{ index .PromptResponses 0 | quote }}{{ index .PromptResponses 1 }}";
            loadingText = "Creating branch...";
          }
        ];
      };
    };
  };

}
