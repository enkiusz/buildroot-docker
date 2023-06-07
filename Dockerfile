FROM debian:bullseye

LABEL org.opencontainers.image.authors="enki@fsck.pl"

ARG buildroot_branch

WORKDIR /buildroot

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y build-essential \
git curl xz-utils file wget cpio unzip \
bc rsync file libncurses-dev libssl-dev \
python3

RUN git clone git://git.buildroot.net/buildroot --depth=1 --branch=${buildroot_branch} /buildroot

# Download cache
VOLUME /buildroot/dl

# Output and build dir
VOLUME /output

ENTRYPOINT [ "/usr/bin/make", "O=/output" ]

