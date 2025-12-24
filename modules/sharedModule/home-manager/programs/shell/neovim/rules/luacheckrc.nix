{
  xdg.configFile."rules/.luacheckrc" = {
    force = true;
    text = ''
      -- Rerun tests only if their modification time changed.
      cache = true

      ignore = {
      	"631", -- max_line_length
          "211",
      	"212/_.*", -- unused argument, for vars with "_" prefix
      	"214", -- used variable with unused hint ("_" prefix)
      	"121", -- setting read-only global variable 'vim'
      	"122", -- setting read-only field of global variable 'vim'
      }
    '';
  };
}
