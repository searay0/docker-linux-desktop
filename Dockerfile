FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && \
  apt-get install -y \
  curl \
  gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/firefox.gpg] https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu noble main" >> /etc/apt/sources.list.d/nodesource.list && \
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0ab215679c571d1c8325275b9bdb3d89ce49ec21" | gpg --batch --yes --dearmor -o "/etc/apt/keyrings/firefox.gpg" && \
  echo -e "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 900\n" > /etc/apt/preferences.d/99mozillateam && \
  apt-get -y update && \
  apt-get install -y \
  tzdata \
  less \
  vim \
  gcc \
  xfce4 \
  xfce4-taskmanager \
  xfce4-terminal \
  firefox \
  xorgxrdp \
  xrdp \
  dbus-x11 && \
  apt remove -y light-locker xscreensaver && \
  apt autoremove -y && \
  rm -rf /var/cache/apt /var/lib/apt/lists


RUN echo "xfce4-session" >> /etc/skel/.Xsession && \
  sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
COPY --chmod=0544 ./xrdp.sh /xrdp.sh

# USER 1000:1000
WORKDIR /z
ENV TZ="Asia/Singapore"
SHELL ["/bin/sh", "-c"]
ENTRYPOINT ["/xrdp.sh"]
