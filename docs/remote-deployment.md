# Remote NixOS deployment

This document explains what `remote` means in the Just recipes and how the
Linux and macOS deployment paths reach the same NixOS Host.

## Names used by the deployment

There are three different identifiers. They are related, but are not
interchangeable:

| Identifier | Example | Meaning |
| --- | --- | --- |
| Flake Host | `mochou@remote` | NixOS configuration output, defined under `hosts/mochou@remote/` |
| SSH alias | `remote` | A local SSH config nickname used by SSH and the macOS recipe |
| Network endpoint | `192.168.1.7:2222` | The actual address and port at which the target's SSH service is reachable |

In particular, `remote` is **not** a built-in Nix keyword, a hostname that
must resolve through DNS, or an IP address. It is simply the alias declared
in the SSH config of the machine running the deployment command.

## Configure the SSH alias

On the deployment machine, add an entry to `~/.ssh/config`:

```sshconfig
Host remote
    HostName 192.168.1.7
    User mochou
    Port 2222
```

Replace the address, user, and port if the target changes. The fields mean:

- `Host remote`: the alias typed after `ssh` and used in
  `ssh-ng://remote`.
- `HostName`: the target machine's reachable IP address or DNS name.
- `User`: the SSH login account.
- `Port`: the SSH server port. It is configured here, not appended to the
  SSH Store URI.

The alias is local to the deployment machine. The target does not need an
SSH config entry named `remote` for this client-side connection to work.

Test both ordinary SSH and the Nix SSH Store connection:

```bash
ssh remote
nix store ping --store ssh-ng://remote
```

The macOS deployment recipe assumes both commands can reach the intended
NixOS machine.

## Deployment recipes

Just applies platform attributes when selecting recipes. Therefore the
same recipe name, `remote_deploy`, has different implementations depending
on the operating system running Just:

| Running platform | Recipe | Deployment mechanism |
| --- | --- | --- |
| Linux | `remote_deploy_dry` | deploy-rs dry activation |
| Linux | `remote_deploy` | deploy-rs deployment |
| macOS | `remote_deploy` | Nix SSH Store build, then remote activation |

All paths target the Flake Host `mochou@remote`. The Linux deploy-rs node
uses its own node connection configuration; the macOS recipe uses the
client-side SSH alias `remote`.

### Linux: deploy-rs

The optional `ip` parameter is the target address passed to deploy-rs.
Its default is `192.168.122.62`.

```bash
# Preview activation without switching the target system.
just remote_deploy_dry
just remote_deploy_dry ip="192.168.1.7"

# Deploy and activate.
just remote_deploy
just remote_deploy ip="192.168.1.7"
```

The deploy-rs node is configured to connect as `root`. Make sure the
deployment machine has the appropriate SSH key authorized for root on the
target. The `ip` argument is an address/host value, not an SSH config alias
unless deploy-rs is configured to resolve that alias in the same way.

### macOS: SSH Store

The macOS recipe has no exposed parameters. It currently sets:

- SSH alias: `remote`
- Flake Host: `mochou@remote`
- Store URI: `ssh-ng://remote`

It performs these steps:

1. Evaluates and builds
   `nixosConfigurations."mochou@remote".config.system.build.toplevel`.
2. Uses `ssh-ng://remote` as the Nix store, so the build output is placed in
   the target machine's Nix store.
3. Connects with `ssh remote`.
4. Updates `/nix/var/nix/profiles/system` to the new toplevel.
5. Runs `switch-to-configuration switch` to activate the new system.

The SSH login user from the alias (shown as `mochou` above) must be able to
run the profile update and activation commands with `sudo`. The recipe uses
a TTY for SSH so sudo can prompt when required.

Run it with:

```bash
just remote_deploy
```

To change the macOS target's address, login user, or port, edit the
`Host remote` entry in `~/.ssh/config`; these are deliberately not separate
Just parameters.

## Installation is different from deployment

`remote_install` is the initial-installation path. It invokes
nixos-anywhere/Disko and can repartition or format the target disk, destroying
existing data. `remote_deploy` is for routine system updates and does not
reinstall or repartition the machine.

Do not use `remote_install` for ordinary configuration changes.
