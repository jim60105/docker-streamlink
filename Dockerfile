# syntax=docker/dockerfile:1
ARG UID=1001

FROM alpine:3 as final

ARG UID

RUN apk add -u --no-cache \
    # These branches follows the latest release
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/main" \
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/community" \
    streamlink

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /usr/bin/

# Create user
RUN addgroup -g $UID $UID && \
    adduser -H -g "" -D $UID -u $UID -G $UID

# Run as non-root user
RUN install -d -m 775 -o $UID -g 0 /download
VOLUME [ "/download" ]

# Remove these to prevent the container from executing arbitrary commands
RUN rm /bin/echo /bin/ln /bin/rm /bin/sh

WORKDIR /download
USER $UID

STOPSIGNAL SIGINT
ENTRYPOINT [ "streamlink" ]
CMD [ "--help" ]