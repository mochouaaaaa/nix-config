{
  flake.aspects = { aspects, ... }: {
    "desktop.programs.api-clients".includes = [
      aspects."desktop.programs"._.api-clients
    ];

    "desktop.programs.browsers".includes = [
      aspects."desktop.programs"._.browsers._.chromium
      aspects."desktop.programs"._.browsers._.firefox
      aspects."desktop.programs"._.browsers._."google-chrome"
    ];

    "desktop.programs.audio".includes = [
      aspects."desktop.programs"._.audio._.tools
    ];

    "desktop.programs.security".includes = [
      aspects."desktop.programs"._.security._.authenticator
      aspects."desktop.programs"._.security._.bitwarden
    ];

    "desktop.programs.communication".includes = [
      aspects."desktop.programs"._.communication._.discord
      aspects."desktop.programs"._.communication._.materialgram
      aspects."desktop.programs"._.communication._.tencent
    ];

    "desktop.programs.email".includes = [
      aspects."desktop.programs"._.email._.thunderbird
    ];

    "desktop.programs.media".includes = [
      aspects."desktop.programs"._.media._.live
      aspects."desktop.programs"._.media._.mpv
      aspects."desktop.programs"._.media._.splayer
    ];

    "desktop.programs.notes".includes = [
      aspects."desktop.programs"._.notes._.joplin
      aspects."desktop.programs"._.notes._.obsidian
    ];

    "desktop.programs.remote".includes = [
      aspects."desktop.programs"._.remote._.remmina
      aspects."desktop.programs"._.remote._.rustdesk
    ];

    "desktop.programs.office".includes = [
      aspects."desktop.programs"._.office._.wps
    ];

    "desktop.programs.database".includes = [
      aspects."desktop.programs"._.database._.clients
    ];

    "desktop.programs.gaming".includes = [
      aspects."desktop.programs"._.gaming._.steam
    ];

    "desktop.programs.networking" = {
      includes = [
        aspects."desktop.programs"._.networking._.openvpn
        aspects."desktop.programs"._.networking._.wireshark
      ];

      nixos =
        { pkgs, username, ... }:
        {
          programs.wireshark.enable = true;
          environment.systemPackages = [ pkgs.wireshark-cli ];
          users.groups.wireshark = { };
          users.users.${username}.extraGroups = [ "wireshark" ];
        };
    };
  };
}
