FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  git autoconf automake bison bzip2 flex g++ gawk gcc git \
  gperf help2man libncurses5-dev libstdc++6 libtool libtool-bin make patch \
  python3-dev texinfo unzip wget xz-utils

RUN groupadd -g 200 ctng
RUN useradd -d /home/ctng -m -g 200 -u 200 -s /bin/bash ctng

WORKDIR /build
RUN chown -R ctng:ctng /build
USER ctng
RUN wget -O - http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz | tar Jxf - && ln -s crosstool-ng-1.24.0 ct
WORKDIR /build/ct
RUN mkdir /build/src && ./configure --enable-local && make
COPY --chown=ctng:ctng ct/.config /build/ct/
RUN ./ct-ng build

