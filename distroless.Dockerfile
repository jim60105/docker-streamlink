# syntax=docker/dockerfile:1
ARG VERSION=6.10.0
ARG RELEASE=0

########################################
# Build stage
########################################
FROM python:3.12-bookworm AS build

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /app

# Install under /root/.local
ENV PIP_USER="true"
ARG PIP_NO_WARN_SCRIPT_LOCATION=0
ARG PIP_ROOT_USER_ACTION="ignore"
ARG PIP_NO_COMPILE="true"
ARG PIP_DISABLE_PIP_VERSION_CHECK="true"

# Ensure the cache is not reused when installing streamlink
ARG RELEASE

ARG VERSION
RUN --mount=type=cache,id=pip-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/root/.cache/pip \
    pip install -U --force-reinstall pip setuptools wheel && \
    pip install streamlink==$VERSION && \
    # Cleanup
    find "/root/.local" -name '*.pyc' -print0 | xargs -0 rm -f || true ; \
    find "/root/.local" -type d -name '__pycache__' -print0 | xargs -0 rm -rf || true ; \
    \
    # Make an empty directory for final stage
    mkdir -p /newdir

########################################
# Final stage
# Distroless image use monty(1000) for non-root user
########################################
FROM al3xos/python-distroless:3.12-debian12 AS final

ARG UID=1000

# Create directories with correct permissions
COPY --link --chown=$UID:0 --chmod=775 --from=build /newdir /download
COPY --link --chown=$UID:0 --chmod=775 --from=build /newdir /licenses

# ffmpeg
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffmpeg /usr/bin/
# COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffprobe /usr/bin/

# dumb-init
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /dumb-init /usr/bin/

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/Dockerfile.LICENSE
COPY --link --chown=$UID:0 --chmod=775 streamlink/LICENSE /licenses/streamlink.LICENSE

# Copy dist and support arbitrary user ids (OpenShift best practice)
# https://docs.openshift.com/container-platform/4.14/openshift_images/create-images.html#use-uid_create-images
COPY --link --chown=$UID:0 --chmod=775 --from=build /root/.local /home/monty/.local

ENV PATH="/home/monty/.local/bin:$PATH"

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
