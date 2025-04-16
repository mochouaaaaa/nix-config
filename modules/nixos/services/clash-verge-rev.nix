{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  mihomo-partyOver = pkgs.mihomo-party.overrideAttrs (oldAttrs: { });
in
{
  programs.clash-verge = {
    enable = true;
    autoStart = true;
  };

  environment.systemPackages = [
    # pkgs.mihomo-party
    # (pkgs.makeAutostartItem {
    #   name = "mihomo-party";
    #   package = pkgs.mihomo-party;
    # })
  ];

  # systemd.services.mihomo-party = {
  #   enable = true;
  #   serviceConfig = {
  #     ExecStart = "${pkgs.mihomo-party}/opt/mihomo-party/resources/sidecar/mihomo";
  #     Restart = "on-failure";
  #   };
  #   description = "Mihomo Party";
  #   wantedBy = [ "multi-user.target" ];
  # };

  services.mihomo = {
    enable = false;
    tunMode = true;
    webui = pkgs.nur.repos.linyinfeng.yacd;
  };
}
