{
  pkgs,
  username,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${username}" = {
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
