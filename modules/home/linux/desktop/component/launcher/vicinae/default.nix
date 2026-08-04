{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.vicinae;
in
{

  # assertions = [
  #   {
  #     assertion = lib ? importService;
  #     message = "HM extendedLib is missing importService";
  #   }
  #   {
  #     assertion = lib ? services;
  #     message = "HM extendedLib is missing services";
  #   }
  #   {
  #     assertion = pkgs.lib ? importService;
  #     message = "HM pkgs.lib is missing importService";
  #   }
  # ];

}
