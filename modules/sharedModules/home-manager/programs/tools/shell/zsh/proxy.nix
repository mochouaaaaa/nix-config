let
  proxy_config = ''
    proxy() {
        case "$1" in
            on)
                export http_proxy="http://127.0.0.1:7890"
                export https_proxy="http://127.0.0.1:7890"
                export all_proxy="socks5://127.0.0.1:7891"
                echo -e "\033[91mProxy is enabled\033[0m"
            ;;
            off)
                unset http_proxy https_proxy all_proxy
                echo -e "\033[93mProxy is disabled\033[0m"
            ;;
            *)
                echo "Usage: proxy on|off"
            ;;
        esac
    }
  '';
in
{
  programs = {
    zsh = {
      envExtra = proxy_config;
    };
    bash = {
      initExtra = proxy_config;
    };
  };
}
