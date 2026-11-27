{

  flake.aspects."desktop.hyprland".homeManager = { mylib, ... }: {
    programs.noctalia = mylib.mkForceRecursive {
      settings = {
        bar = {
          widgets = {
            concave_edge_corners = true;
          };
        };
        theme = {
          templates = {
            builtin_ids = [
              "hyprland"
            ];
          };
        };
      };
    };
  };

}
