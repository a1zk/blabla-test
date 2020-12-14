FROM gcc:10 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y autoconf automake libtool groff-base perl

RUN git clone https://github.com/curl/curl.git \
&& cd curl \
&& git fetch --tags \
&& latestTag=$(git describe --tags `git rev-list --tags --max-count=1`) \
&& git checkout $latestTag
#** Do not use buildconf. Instead, just use: autoreconf -fi
RUN cd curl \
&& ./buildconf -fi \
&& ./configure --disable-shared --enable-static --disable-ldap --disable-sspi --without-librtmp --disable-ftp --disable-file --disable-dict --disable-telnet --disable-tftp --disable-rtsp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-smb --prefix=/app/bin CFLAGS='-Os' LDFLAGS="-static -Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections" \
&& make \
&& make install

FROM debian:buster-slim
WORKDIR /app
USER 1000
COPY --from=builder /app/bin/bin/curl .
ENTRYPOINT ["./curl"]