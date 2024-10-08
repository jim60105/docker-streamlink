# docker-streamlink

[![CodeFactor](https://www.codefactor.io/repository/github/jim60105/docker-streamlink/badge?style=for-the-badge)](https://www.codefactor.io/repository/github/jim60105/docker-streamlink) [![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/jim60105/docker-streamlink/scan.yml?label=IMAGE%20SCAN&style=for-the-badge)](https://github.com/jim60105/docker-streamlink/actions/workflows/scan.yml)

This is the docker image for [Streamlink: A CLI utility which pipes video streams from various services into a video player.](https://github.com/streamlink/streamlink) from the community.

Get the Dockerfile at [GitHub](https://github.com/jim60105/docker-streamlink), or pull the image from [ghcr.io](https://ghcr.io/jim60105/streamlink) or [quay.io](https://quay.io/repository/jim60105/streamlink?tab=tags).

## Usage Command

Mount the current directory as `/download` and run Streamlink with additional input arguments.  
The downloaded files will be saved to where you run the command.

```bash
docker run -it -v ".:/download" ghcr.io/jim60105/streamlink:alpine --progress force --output "{id}.ts" [options] [url] best
```

The `[options]`, `[url]` placeholder should be replaced with the options and arguments for Streamlink. Check the [Streamlink README](https://github.com/streamlink/streamlink?tab=readme-ov-file#-quickstart) for more information.

You can find all available tags at [ghcr.io](https://github.com/jim60105/docker-streamlink/pkgs/container/streamlink/versions?filters%5Bversion_type%5D=tagged) or [quay.io](https://quay.io/repository/jim60105/streamlink?tab=tags).

## Building the Docker Image

### Dockerfiles

This repository contains four Dockerfiles for building Docker images based on different base images:

| Dockerfile                                     | Base Image                                                                                                                         |
|------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| [Dockerfile](Dockerfile)                       | [Alpine official image](https://hub.docker.com/_/alpine/)                                                                          |
| [alpine.Dockerfile](alpine.Dockerfile)         | [Python official image 3.12-alpine](https://hub.docker.com/_/python/)                                                              |
| [ubi.Dockerfile](ubi.Dockerfile)               | [Red Hat Universal Base Image 9 Minimal](https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5) |
| [distroless.Dockerfile](distroless.Dockerfile) | [distroless-python](https://github.com/alexdmoss/distroless-python)                                                                |

### Build Arguments

The [alpine.Dockerfile](alpine.Dockerfile), [ubi.Dockerfile](ubi.Dockerfile), ans [distroless.Dockerfile](distroless.Dockerfile) are built using a build argument called `BUILD_VERSION`. This argument represents [the release version of streamlink](https://github.com/streamlink/streamlink/tags), such as `6.5.0` or `6.4.2`.

It is important to note that the [Dockerfile](Dockerfile) always builds with [the latest apk package source](https://pkgs.alpinelinux.org/package/edge/community/aarch64/streamlink), so it can't set the build version explicitly.

> [!NOTE]
>
> - The apk edge branch follows the latest release of streamlink.
> - The `alpine.Dockerfile` installs streamlink from pip source, so the image size may slightly different compared to the `Dockerfile` even when they have the same version.

### Build Command

```bash
docker build -t streamlink .
docker build --build-arg BUILD_VERSION=6.10.0 -f ./alpine.Dockerfile -t streamlink:alpine .
docker build --build-arg BUILD_VERSION=6.10.0 -f ./ubi.Dockerfile -t streamlink:ubi .
docker build --build-arg BUILD_VERSION=6.10.0 -f ./distroless.Dockerfile -t streamlink:distroless .
```

> [!TIP]
> I've notice that that both the UBI version and the Distroless version offer no advantages over the Alpine version. So _**please use the Alpine version**_ unless you have specific reasons not to. All of these base images are great, some of them were simply not that suitable for our project.

> [!NOTE]  
> If you are using an earlier version of the docker client, it is necessary to [enable the BuildKit mode](https://docs.docker.com/build/buildkit/#getting-started) when building the image. This is because I used the `COPY --link` feature which enhances the build performance and was introduced in Buildx v0.8.  
> With the Docker Engine 23.0 and Docker Desktop 4.19, Buildx has become the default build client. So you won't have to worry about this when using the latest version.

## LICENSE

> [!NOTE]  
> The main program, [streamlink/streamlink](https://github.com/streamlink/streamlink), is distributed under [BSD-2-Clause license](https://github.com/streamlink/streamlink/blob/master/LICENSE).  
> Please consult their repository for access to the source code and licenses.  
> The following is the license for the Dockerfiles and CI workflows in this repository.

<img src="https://github.com/jim60105/docker-streamlink/assets/16995691/2ab416c6-7f51-47d7-a8f3-d2ff38074e8b" alt="gplv3" width="300" />

[GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

> [!CAUTION]
> A GPLv3 licensed Dockerfile means that you _**MUST**_ **distribute the source code with the same license**, if you
>
> - Re-distribute the image. (You can simply point to this GitHub repository if you doesn't made any code changes.)
> - Distribute a image that uses code from this repository.
> - Or **distribute a image based on this image**. (`FROM ghcr.io/jim60105/streamlink` in your Dockerfile)
>
> "Distribute" means to make the image available for other people to download, usually by pushing it to a public registry. If you are solely using it for your personal purposes, this has no impact on you.
>
> Please consult the [LICENSE](LICENSE) for more details.