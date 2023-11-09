FROM archlinux:base-devel

RUN useradd builder
RUN pacman -Syu --noconfirm \
        archiso \
        git \
        python-build \
        python-installer \
        python-hatchling \
        python-hatch-fancy-pypi-readme

USER builder
WORKDIR /aur
RUN git clone https://aur.archlinux.org/python-argon2-cffi.git && \
    git clone https://aur.archlinux.org/obscura.git && \
    git clone https://aur.archlinux.org/sedutil.git && \
    cd /aur/python-argon2-cffi && makepkg --nocheck --nodeps && \
    cd /aur/obscura && makepkg --nocheck --nodeps && \
    cd /aur/sedutil && makepkg --nocheck --nodeps && \
    mv /aur/**/*.pkg.tar.zst /aur/ && \
    repo-add /aur/aur.db.tar.gz /aur/*.pkg.tar.zst

USER root
WORKDIR /usr/share/archiso/configs/releng
COPY airootfs airootfs

RUN cat >> pacman.conf <<EOF
[aur]
SigLevel = Optional TrustAll
Server = file:///aur/
EOF

RUN cat >> packages.x86_64 <<EOF
bash
borg
python-argon2-cffi
obscura
keepassxc
sedutil
EOF
