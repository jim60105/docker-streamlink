# syntax=docker/dockerfile:1
ARG UID=1001

FROM alpine:3 as final

ARG UID

RUN apk add -u --no-cache \
    -X "http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    streamlink

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /usr/bin/

# Create user
RUN addgroup -g $UID $UID && \
    adduser -H -g "" -D $UID -u $UID -G $UID

# Remove these to prevent the container from executing arbitrary commands
RUN rm /bin/echo /bin/ln /bin/rm /bin/sh

# Run as non-root user
USER $UID
WORKDIR /download
VOLUME [ "/download" ]

STOPSIGNAL SIGINT
ENTRYPOINT [ "streamlink" ]
CMD [ "--help" ]