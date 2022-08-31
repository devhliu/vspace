#----------------------------------------------------------------------------------------------
# base system
#----------------------------------------------------------------------------------------------

FROM registry.united-imaging.com/mirecon/umic-vspace-ubuntu-xfce:0.0.1 as system

# Avoid prompts for time zone
ENV DEBIAN_FRONTEND noninteractive
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

# timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt autoclean -y \
    && apt autoremove -y \
    && apt purge -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

#----------------------------------------------------------------------------------------------
# builder
#----------------------------------------------------------------------------------------------

FROM ubuntu:20.04 as builder

# using USTC mirror in CN
RUN cp /etc/apt/sources.list /etc/apt/sources.list.nomirror
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#http://mirrors.ustc.edu.cn/ubuntu/#' /etc/apt/sources.list

RUN apt autoremove -y && apt autoclean -y

#----------------------------------------------------------------------------------------------
# merge
#----------------------------------------------------------------------------------------------
FROM system

LABEL maintainer="hui.liu02@united-imaging.com"

COPY rootfs/startup.sh /startup.sh
EXPOSE 80
# WORKDIR /home/vspace
# ENV HOME=/home/vspace \
#     SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]