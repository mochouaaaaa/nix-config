{
  flake.modules.homeManager.programs = {
    programs = {
      fd = {
        enable = true;
        ignores = [
          ".git/"
          "*.bak"
          ".backup/"
        ];
      };
    };
  };
}
