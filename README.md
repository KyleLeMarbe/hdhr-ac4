# hdhr-ac4.js

This is a fork of [johnb-7/hdhr-ac4](https://github.com/johnb-7/hdhr-ac4), converted from python to nodejs.

## What does this do?

This is a docker container that proxies requests from an ATSC 3.0 compatible HDHomeRun tuner, but
uses the ffmpeg binary from Emby media server to transcode the AC4 audio to AC3 so Plex and other apps
can decode it. Read more on the original project: [johnb-7/hdhr-ac4](https://github.com/johnb-7/hdhr-ac4).

I've only tested with Plex and VLC.

## Changes in this fork

- Converted to javascript.
- Made the proxy more transparent to make it more resilient to changes.
- Supports not running on port 80 so it can run on a system like unraid.
- Always reverses the device ID (so the emulated tuner can coexist with the real one in Plex).
- Simplified configuration (only the `HDHR_IP` variable needs to be set).
- **FFmpeg is pre-installed in the container** - No more waiting for Emby download on startup.
- **Low-latency ffmpeg settings** - Faster channel switching with reduced buffering.

## How to use this docker container

```
docker run -p 5003:80 -p 5004:5004 -e HDHR_IP=192.168.0.123 ghcr.io/whichken/hdhr-ac4
```

The container includes ffmpeg pre-installed from the Emby release, supporting both amd64 and arm64 architectures.

> You can use any host port you want for port 80, but port 5004 can't be changed.

Now go to Plex and add a new tuner. Enter the container IP and your chosen port (ex. 192.168.0.234:5003)
as the tuner address. Plex should see and add it without issue.

## License

Like the original project, this is released under the Apache 2.0 license.
