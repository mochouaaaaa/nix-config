{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      installVm = pkgs.writeShellApplication {
        name = "install-vm";
        runtimeInputs = [
          inputs.nixos-anywhere.packages.${system}.nixos-anywhere
          pkgs.jq
          pkgs.openssh
        ];
        text = ''
          target_host="''${INSTALL_HOST:-root@192.168.122.246}"

          printf '\nWARNING: nixos-anywhere will repartition and format the target disk.\n'
          printf 'Target: %s\n' "$target_host"
          printf 'This destroys existing data on the target machine.\n\n'
          read -r -p "Type the target host exactly to continue: " confirmation
          if [[ "$confirmation" != "$target_host" ]]; then
            printf 'Confirmation did not match; installation cancelled.\n' >&2
            exit 1
          fi

          printf '\nDetecting disks on %s...\n' "$target_host"
          disk_info="$(
            ssh "$target_host" \
              'lsblk --json --nodeps --paths --output PATH,SIZE,MODEL,TYPE' |
              jq -r '.blockdevices[] | select(.type == "disk") | [.path, .size, (.model // "")] | @tsv'
          )"

          if [[ -z "$disk_info" ]]; then
            printf 'No disks were detected on the target host. Installation cancelled.\n' >&2
            exit 1
          fi

          mapfile -t disks <<< "$disk_info"
          printf '\nAvailable disks:\n'
          for index in "''${!disks[@]}"; do
            IFS=$'\t' read -r device size model <<< "''${disks[$index]}"
            printf '  %d) %-24s %-10s %s\n' "$((index + 1))" "$device" "$size" "$model"
          done

          read -r -p "Select the disk to erase [1-''${#disks[@]}]: " disk_selection
          if [[ ! "$disk_selection" =~ ^[0-9]+$ ]] ||
            (( disk_selection < 1 || disk_selection > ''${#disks[@]} )); then
            printf 'Invalid disk selection; installation cancelled.\n' >&2
            exit 1
          fi

          IFS=$'\t' read -r selected_device selected_size selected_model \
            <<< "''${disks[$((disk_selection - 1))]}"

          disk_id="$(
            printf '%s\n' "$selected_device" |
            ssh "$target_host" '
            read -r selected_device
            for id in /dev/disk/by-id/*; do
                [ -L "$id" ] || continue
                [ "$(readlink -f "$id")" = "$selected_device" ] || continue
                case "$id" in *-part[0-9]*) continue ;; esac
                printf "%s\n" "$id"
            done | sort | head -n1
            '
          )"

          if [[ -n "$disk_id" ]]; then
            disk_device="$disk_id"
          else
            printf '\nWARNING: no /dev/disk/by-id link found; using %s.\n' "$selected_device" >&2
            disk_device="$selected_device"
          fi

          printf '\nSelected disk:\n'
          printf '  Device: %s\n  Size:   %s\n  Model:  %s\n' \
            "$disk_device" "$selected_size" "$selected_model"
          printf '\nALL DATA ON THIS DISK WILL BE DESTROYED.\n'
          read -r -p "Type the disk path exactly to continue: " disk_confirmation
          if [[ "$disk_confirmation" != "$disk_device" ]]; then
            printf 'Disk confirmation did not match; installation cancelled.\n' >&2
            exit 1
          fi

          export INSTALL_DISK_DEVICE="$disk_device"

          exec nixos-anywhere \
            --option pure-eval false \
            --option eval-cache false \
            --flake "${self.outPath}#mochou@vm" \
            --target-host "$target_host" \
            "$@"
        '';
      };
    in
    {
      apps =
        lib.optionalAttrs
          (builtins.elem system [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
          ])
          {
            install-vm = {
              type = "app";
              program = "${installVm}/bin/install-vm";
            };
          };
    };
}
