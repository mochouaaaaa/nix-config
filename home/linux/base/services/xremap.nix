{
  lib,
  myvars,
  ...
}: {
  services.xremap = {
    enable = true;
    withWlroots = true;
    watch = true;
    # debug = true;
    config = {
      modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Esc";
          }; # globally remap CapsLock to Esc
        }
      ];
      keymap = [
        {
          name = "Shortcuts";
          exact_match = true;
          remap = lib.mkMerge [
            {
            }
            (lib.mkIf myvars.packages.pot {
              "ALT-a" = {launch = ["curl" "127.0.0.1:60828/input_translate"];};
              "ALT-d" = {launch = ["curl" "127.0.0.1:60828/selection_translate"];};
              "ALT-s" = {
                launch = [
                  "bash"
                  "-c"
                  ''
                    # 删除旧截图文件（如果存在）
                     rm -f ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png

                     # 使用 grim 和 slurp 截图，并将结果保存到文件
                     grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png

                     # 使用 curl 进行 OCR 翻译
                     curl "127.0.0.1:60828/ocr_translate?screenshot=false"
                  ''
                ];
              };
            })
          ];
        }
        {
          name = "Replace Super/Command With Ctrl";
          exact_match = true;
          application.not = ["kitty"];
          remap = {
            "SUPER-c" = "C-c";
            "SUPER-v" = "C-v";
            "SUPER-x" = "C-x";
            "SUPER-w" = "C-w";
            "SUPER-a" = "C-a";
            "SUPER-z" = "C-z";
            "SUPER-t" = "C-t";
            "SUPER-f" = "C-f";
            "SUPER-r" = "C-r";
          };
        }
      ];
    };
  };
}
