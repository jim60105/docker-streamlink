# docker-streamlink

[![CodeFactor](https://www.codefactor.io/repository/github/jim60105/docker-streamlink/badge?style=for-the-badge)](https://www.codefactor.io/repository/github/jim60105/docker-streamlink) [![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/jim60105/docker-streamlink/scan.yml?label=IMAGE%20SCAN&style=for-the-badge)](https://github.com/jim60105/docker-streamlink/actions/workflows/scan.yml)

This is the docker image for [Streamlink: A CLI utility which pipes video streams from various services into a video player.](https://github.com/streamlink/streamlink) from the community.

Get the Dockerfile at [GitHub](https://github.com/jim60105/docker-streamlink), or pull the image from [ghcr.io](https://ghcr.io/jim60105/streamlink) or [quay.io](https://quay.io/repository/jim60105/streamlink?tab=tags).

## Usage Command

Mount the current directory as `/download` and run Streamlink with additional input arguments.  
The downloaded files will be saved to where you run the command.

```bash
docker run -it -v ".:/download" ghcr.io/jim60105/streamlink --progress force --output "{id}.ts" [options] [url] best
```

The `[options]`, `[url]` placeholder should be replaced with the options and arguments for Streamlink. Check the [Streamlink README](https://github.com/streamlink/streamlink?tab=readme-ov-file#-quickstart) for more information.

You can find all available tags at [ghcr.io](https://github.com/jim60105/docker-streamlink/pkgs/container/streamlink/versions?filters%5Bversion_type%5D=tagged) or [quay.io](https://quay.io/repository/jim60105/streamlink?tab=tags).

## LICENSE

> [!NOTE]  
> The main program, [streamlink/streamlink](https://github.com/streamlink/streamlink), is distributed under [BSD-2-Clause license](https://github.com/streamlink/streamlink/blob/main/LICENSE).  
> Please consult their repository for access to the source code and licenses.  
> The following is the license for the Dockerfiles and CI workflows in this repository.

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

<img src="https://github.com/jim60105/docker-streamlink/assets/16995691/2ab416c6-7f51-47d7-a8f3-d2ff38074e8b" alt="gplv3" width="300" />

[GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
