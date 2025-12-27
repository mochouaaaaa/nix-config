{
  programs =
    let
      proxy_config = ''

        function proxy_on(){
           export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7891
           echo -e "\e[91m 已开启代理 \e[0m"
        }

        function proxy_off(){
           unset http_proxy https_proxy all_proxy
           echo -e "\e[93m 已关闭代理 \e[0m"
        }

      '';
    in
    {
      zsh = {
        envExtra = proxy_config;
      };
      bash = {
        initExtra = proxy_config;
      };
    };
}
