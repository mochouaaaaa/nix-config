{
  inputs,
  lib,
  self,
  config,
  ...
}:

let
  hostsDir = ../hosts;

  # 自动发现所有主机目录
  hostNames = lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir);

  # 解析 username@platform
  parseHost =
    name:
    let
      parts = lib.splitString "@" name;
      valid = builtins.length parts == 2 && builtins.all (part: part != "") parts;
    in
    assert lib.assertMsg valid "Invalid host directory '${name}', expected username@platform";

    {
      username = builtins.elemAt parts 0;
      platform = builtins.elemAt parts 1;
      inherit name;
      path = hostsDir + "/${name}";
    };

  hosts = lib.mapAttrs (name: _: parseHost name) hostNames;

  # 根据平台筛选主机
  selectHosts = platforms: lib.filterAttrs (_: host: builtins.elem host.platform platforms) hosts;

  # NixOS 和 NixOS-WSL
  nixosHosts = selectHosts [
    "nixos"
    "nixos-wsl"
  ];

  # Darwin
  darwinHosts = selectHosts [ "darwin" ];

  # Standalone Home Manager
  homeHosts = selectHosts [ "wsl" ];

  # 公共主机参数
  hostArgs = host: {
    inherit inputs self;
    inherit (host) username platform;
    hostName = host.name;
    myvars = config.myvars;
  };

  # Standalone HM 使用的 nixpkgs
  mkHomePkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

in
{
  flake = {
    # NixOS / NixOS-WSL
    nixosConfigurations = lib.mapAttrs (
      name: host:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.home-manager.nixosModules.home-manager
          self.modules.nixos.core
          self.modules.nixos."services.base"
          self.modules.nixos.agenix
          self.modules.nixos.nix-settings
        ]
        ++ lib.optional (host.platform == "nixos-wsl") inputs.nixos-wsl.nixosModules.default
        ++ [
          (inputs.import-tree host.path)
        ];
      }
    ) nixosHosts;

    # Darwin
    darwinConfigurations = lib.mapAttrs (
      name: host:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.home-manager.darwinModules.home-manager
          self.modules.darwin.core
          self.modules.darwin.agenix
          self.modules.darwin.home-manager
          self.modules.darwin.nix-settings

          (inputs.import-tree host.path)
        ];
      }
    ) darwinHosts;

    # Standalone Home Manager
    homeConfigurations = lib.mapAttrs (
      name: host:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = mkHomePkgs "x86_64-linux";

        extraSpecialArgs = hostArgs host;

        modules = [
          self.modules.homeManager.agenix
          self.modules.homeManager.nix-settings

          (inputs.import-tree host.path)

          { programs.home-manager.enable = true; }
        ];
      }
    ) homeHosts;
  };
}
