#!/bin/bash

set -e

generate_ssh_key () {
    local ssh_passphrase=$1

    keys_dir=airootfs/root/keys
    mkdir -p "$keys_dir"

    ssh-keygen -t ed25519 -a 10000 -C restoreiso -N "$ssh_passphrase" \
        -f "$keys_dir/remote-backup"

    mkdir -p build
    cp "$keys_dir"/remote-backup.pub build/restoreiso.pub
}

build_docker_image () {
    local luks_passphrase=$1

    docker build -t restoreiso-builder .
}

build_iso () {
    docker run --rm -v build:/mnt/build \
        --cap-add=SYS_CHROOT --cap-add=SYS_ADMIN \
        restoreiso-builder \
        mkarchiso -v -w /tmp/archiso-tmp -o /mnt/build . '&&' \
            chown "$(id -u):$(id -g)" /mnt/build/archlinux-*.iso
}

passphrase_prompt () {
    local prompt=$1

    read -rs -p "$prompt" passphrase
    1>&2 echo
    read -rs -p "Confirm $prompt" passphrase_confirm
    1>&2 echo
    if [[ "$passphrase" != "$passphrase_confirm" ]]; then
        1>&2 echo "Error: Passphrases don't match."
        exit 1
    fi

    echo "$passphrase"
}

cd "$(dirname "$0")"

ssh_passphrase=$(passphrase_prompt 'SSH key passphrase: ')
luks_passphrase=$(passphrase_prompt 'Key store passphrase: ')

generate_ssh_key "$ssh_passphrase"
build_docker_image "$luks_passphrase"
build_iso
