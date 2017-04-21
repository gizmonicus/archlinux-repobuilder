FROM base/archlinux:latest

# Enable multilib for LMMS build
RUN echo -e '[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S \
        base-devel \
        git \
        python-pip \
        sudo \
        wine

RUN pip install awscli
RUN useradd -d /home/aur aur

ADD aur-pkglist.dat /home/aur/aur-pkglist.dat
ADD buildpkgs.sh /home/aur/buildpkgs.sh
RUN echo 'aur ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/aur


# Begin unprivileged mode
RUN chown -R aur:aur /home/aur
USER aur
WORKDIR /home/aur

CMD ["/home/aur/buildpkgs.sh"]
