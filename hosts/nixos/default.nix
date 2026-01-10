let
  hostName = "nixos"; # Define your hostname.
in
{

  networking = {
    inherit hostName;
    # desktop need its cli for status bar
    networkmanager.enable = true;
  };

}
