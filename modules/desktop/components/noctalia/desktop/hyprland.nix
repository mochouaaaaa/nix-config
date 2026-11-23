{

  flake.modules.homeManager."desktop.hyprland" = { mylib, ... }: {
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
