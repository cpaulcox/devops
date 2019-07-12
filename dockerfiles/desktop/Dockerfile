FROM debian:buster-slim

#Default password!!!
ARG PASS=password1

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies xrdp

EXPOSE 3389

RUN useradd -d /home/ubuntu -ms /bin/bash -g root -G sudo ubuntu
RUN echo "ubuntu:password1" | chpasswd


CMD /etc/init.d/xrdp start \
    && tail -f /dev/null

#CMD ["tail","-f","/dev/null"]

