{
  self,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${self.myvars.username}" = {
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              vimium
            ];
          };
        };
      };
    };
  };
}
