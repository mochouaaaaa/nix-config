{
  flake.aspects = { aspects, ... }: {
    "desktop.programs.api-clients".includes = [
      aspects."desktop.programs"._.api-clients
    ];

    "desktop.programs.browsers".includes = [
      aspects."desktop.programs"._.browsers.chromium
      aspects."desktop.programs"._.browsers.firefox
    ];

    "desktop.programs.audio".includes = [
      aspects."desktop.programs"._.audio.tools
    ];

    "desktop.programs.security".includes = [
      aspects."desktop.programs"._.security.authenticator
      aspects."desktop.programs"._.security.bitwarden
    ];

    "desktop.programs.communication".includes = [
      aspects."desktop.programs"._.communication.discord
      aspects."desktop.programs"._.communication.materialgram
      aspects."desktop.programs"._.communication.tencent
    ];

    "desktop.programs.email".includes = [
      aspects."desktop.programs"._.email.thunderbird
    ];

    "desktop.programs.media".includes = [
      aspects."desktop.programs"._.media.live
      aspects."desktop.programs"._.media.mpv
      aspects."desktop.programs"._.media.splayer
    ];

    "desktop.programs.notes".includes = [
      aspects."desktop.programs"._.notes.joplin
      aspects."desktop.programs"._.notes.obsidian
    ];

    "desktop.programs.remote".includes = [
      aspects."desktop.programs"._.remote.remmina
      aspects."desktop.programs"._.remote.rustdesk
    ];

    "desktop.programs.office".includes = [
      aspects."desktop.programs"._.office.wps
    ];

    "desktop.programs.database".includes = [
      aspects."desktop.programs"._.database.clients
    ];

    "desktop.programs.gaming".includes = [
      aspects."desktop.programs"._.gaming.steam
    ];

    "desktop.programs.networking" = {
      includes = [
        aspects."desktop.programs"._.networking.openvpn
        aspects."desktop.programs"._.networking.wireshark
      ];

      # Export this group as a NixOS module for host-level imports.
      nixos = _: { };
    };
  };
}
