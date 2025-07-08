{
  pkgs,
  myvars,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${myvars.username}" = {
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              enhanced-github
            ];
          };
        };
      };
    };
  };
}
