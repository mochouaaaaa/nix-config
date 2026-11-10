{
  flake.modules.nixos."services.dns" =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    let
      v2dat = inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.v2dat;

      geoipDat = "${pkgs.v2ray-rules-dat}/share/v2ray/geoip.dat";
      geositeDat = "${pkgs.v2ray-rules-dat}/share/v2ray/geosite.dat";

      mosdnsRules =
        pkgs.runCommand "mosdns-rules"
          {
            nativeBuildInputs = [ v2dat ];
          }
          ''
            mkdir -p "$out/share/mosdns"

            v2dat unpack geoip -o "$out/share/mosdns" -f private "${geoipDat}"
            v2dat unpack geoip -o "$out/share/mosdns" -f cn "${geoipDat}"

            v2dat unpack geosite -o "$out/share/mosdns" -f cn "${geositeDat}"
            v2dat unpack geosite -o "$out/share/mosdns" -f gfw "${geositeDat}"
            v2dat unpack geosite -o "$out/share/mosdns" -f category-ads-all "${geositeDat}"
            v2dat unpack geosite -o "$out/share/mosdns" -f 'geolocation-!cn' "${geositeDat}"
          '';
    in
    {
      profiles.services.dns = {
        settings = {
          plugins = lib.mkBefore [
            {
              tag = "geoip_private";
              type = "ip_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geoip_private.txt" ];
              };
            }
            {
              tag = "geoip_cn";
              type = "ip_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geoip_cn.txt" ];
              };
            }

            {
              tag = "geosite_cn";
              type = "domain_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geosite_cn.txt" ];
              };
            }
            {
              tag = "geosite_gfw";
              type = "domain_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geosite_gfw.txt" ];
              };
            }
            {
              tag = "geosite_location-!cn";
              type = "domain_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geosite_geolocation-!cn.txt" ];
              };
            }
            {
              tag = "geosite_ads-all";
              type = "domain_set";
              args = {
                files = [ "${mosdnsRules}/share/mosdns/geosite_category-ads-all.txt" ];
              };
            }
          ];
        };
      };
    };
}
