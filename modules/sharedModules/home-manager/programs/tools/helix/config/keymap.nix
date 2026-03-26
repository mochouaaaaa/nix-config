{
  programs.helix = {
    settings = {
      keys = {
        normal = {
          "q" = ":q";
          "Q" = ":wq";
          "Cmd-s" = ":write";

          "Cmd-f" = "file_picker";
          "Cmd-S-f" = "global_search";
        };
        insert = {
          up = "no_op";
          down = "no_op";
          left = "no_op";
          right = "no_op";
          pageup = "no_op";
          pagedown = "no_op";
          home = "no_op";
          end = "no_op";
        };
      };
    };
  };
}
