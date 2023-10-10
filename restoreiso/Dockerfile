FROM archlinux:latest

RUN pacman -Syu --noconfirm archiso

WORKDIR /usr/share/archiso/configs/releng
COPY airootfs airootfs

RUN echo borg >> packages.x86_6
