FROM debian:jessie

RUN apt-get -qq -y update && \
    apt-get install -y git flex bison build-essential libncurses5-dev curl zlib1g-dev python wget && \
    apt-get clean && \
    apt-get autoremove

# Volume location
VOLUME /root/build

WORKDIR /root/build

# CMD ["/root/build/compile-coreboot.sh"]
