# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=EDGE
ARG RELEASE=0

########################################
# Final stage
########################################
FROM alpine:3 AS final

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

# Create user
ARG UID
RUN adduser -g "" -D $UID -u $UID -G root

# Create directories with correct permissions
RUN install -d -m 775 -o $UID -g 0 /download && \
    install -d -m 775 -o $UID -g 0 /licenses

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/Dockerfile.LICENSE
COPY --link --chown=$UID:0 --chmod=775 streamlink/LICENSE /licenses/streamlink.LICENSE

RUN --mount=type=cache,id=apk-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apk \
    --mount=from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1,source=/ffmpeg,target=/ffmpeg,rw \
    --mount=from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1,source=/ffprobe,target=/ffprobe,rw \
    --mount=from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1,source=/dumb-init,target=/dumb-init,rw \
    apk update && apk add -u \
    # These branches follows the streamlink release
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/main" \
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/community" \
    streamlink && \
    # Copy the compressed ffmpeg and ffprobe and overwrite the apk installed ones
    cp /ffmpeg /usr/bin/ && \
    cp /ffprobe /usr/bin/ && \
    cp /dumb-init /usr/bin/

# Remove these to prevent the container from executing arbitrary commands
RUN rm /bin/echo /bin/ln /bin/rm /bin/sh

WORKDIR /download

VOLUME [ "/download" ]

USER $UID

STOPSIGNAL SIGINT

# Use dumb-init as PID 1 to handle signals properly
ENTRYPOINT [ "dumb-init", "--", "streamlink" ]
CMD ["--help"]

ARG VERSION
ARG RELEASE
LABEL name="jim60105/docker-streamlink" \
    # Authors for streamlink
    vendor="Christopher Rosell, Streamlink Team" \
    # Maintainer for this docker image
    maintainer="jim60105" \
    # Dockerfile source repository
    url="hhttps://github.com/jim60105/docker-streamlink" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name="streamlink" \
    summary="Streamlink is a CLI utility which pipes video streams from various services into a video player" \
    description="A Python library and command-line interface which pipes streams from various services into a video player. Avoid resource-heavy and unoptimized websites, and still enjoy streamed content. For more information about this tool, please visit the following website: https://github.com/streamlink/streamlink"
