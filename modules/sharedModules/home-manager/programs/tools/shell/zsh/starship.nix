{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$python"
        "$golang"
        "$rust"
        "$node"
        "$nix_shell"
        "$fill"
        "$cmd_duration $time"
        "$line_break"
        "$character"
      ];
      fill = {
        symbol = " ";
      };
      directory = {
        truncation_length = 8;
        truncate_to_repo = true;
        fish_style_pwd_dir_length = 0;
      };
      character = {
        success_symbol = "[➜](purple)";
        error_symbol = "[➜](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\)'';
        style = "bright-black";
      };
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style)";
        style = "yellow";
      };
      time = {
        disabled = false;
        format = "at [󱑒 $time]($style)"; # 显示为 "at 13:41:05"
        style = "bold yellow";
        use_12hr = false; # 使用 24 小时制
        utc_time_offset = "+8"; # 如果时区不对，可以手动指定
        time_format = "%T"; # %T 等同于 %H:%M:%S
      };
      python = {
        format = "[$virtualenv]($style)";
        style = "bright-black";
        detect_extensions = [ ];
        detect_files = [ ];
      };
      nix_shell = {
        symbol = "󱄅 ";
      };
    };
  };
}
