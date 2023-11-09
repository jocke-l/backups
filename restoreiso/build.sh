#!/bin/bash

set -e

generate_ssh_key () {
    local ssh_passphrase=$1

    local tmp
    tmp=$(mktemp -d -t restoreiso-XXXX)
    trap 'rm -rf $tmp' EXIT QUIT INT ERR

    keys_dir=airootfs/root/keys
    mkdir -p "$keys_dir"

    ssh-keygen -t ed25519 -C restoreiso -N "$ssh_passphrase" \
        -f "$tmp/remote-backup"
    printf "%s" "$ssh_passphrase" | obscura --argon2-time-cost=100 \
        --argon2-parallellism=16 \
        --argon2-memory-cost=4194304 \
        "$tmp/remote-backup" > "$keys_dir/remote-backup.obscura"

    mkdir -p build
    cp "$tmp/remote-backup.pub" build/restoreiso.pub
}

build_docker_image () {
    docker build --ulimit 'nofile=1024:1048576' -t restoreiso-builder .
}

build_iso () {
    docker run --rm -v ./build:/mnt/build \
        --cap-add=SYS_CHROOT --cap-add=SYS_ADMIN \
        restoreiso-builder \
        /bin/sh -c \
        "mkarchiso -v -w /tmp/archiso-tmp -o /mnt/build . && \
            chown $(id -u):$(id -g) /mnt/build/archlinux-*.iso"
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


#ssh_passphrase=$(passphrase_prompt 'SSH key passphrase: ')

#generate_ssh_key "$ssh_passphrase"

build_docker_image
build_iso
