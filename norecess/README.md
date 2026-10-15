# FFmpeg used by noRecess on macOS

This branch contains FFmpeg 8.1.2 with the noRecess OGG Vorbis compatibility
changes. Original FFmpeg history, copyright notices and licenses are retained.
It contains no noRecess application or Bleach engine source, credentials or keys.

## Source and changes

Upstream tag: `n8.1.2`, commit `38b88335f99e76ed89ff3c93f877fdefce736c13`.

The modifications in `libavformat/oggparsevorbis.c` skip duplicate Vorbis headers,
avoid metadata parsing against a different packet during page lookahead, and
reset packet flags while scanning. The separate patch is included for inspection;
it is already applied in this branch. The upstream release archive's `VERSION`
file is retained so Git builds use the release version string.

The `norecess/` directory contains build documentation added on 2026-10-15.
`build-inputs.json` records the upstream archive hash and the existing local SDK
library hashes before app packaging. App packaging changes install paths and
signatures, so installed app library hashes can differ.

## Build

Use an Apple Silicon Mac with Xcode command line tools, Python 3, make and the
assembler required by FFmpeg configure (the original build used Apple clang
21.0.0, clang-2100.1.1.101). Run from this checkout:

```sh
bash norecess/build-macos-arm64.sh
```

Optional arguments are an empty build directory and a staging directory. `JOBS`
sets parallel jobs (default 6). Defaults are under `out/`; the result is under
`out/stage/opt/radiotechnika/ffmpeg/`. No write to `/opt` is required.

`configure-8.1.2-macos-arm64.txt` was read from all four existing SDK libraries'
configuration APIs and matched their build configuration. It is deliberately
the configuration of those binaries, rather than a newer player build script.
A clean out-of-tree build with this script passed on 2026-10-15. Its enabled
components matched the existing build exactly, including GPL/nonfree/version3
disabled and shared-only arm64 output. This verifies the build recipe, not
byte-identical binaries or runtime acceptance of the rebuilt libraries.

It is a native arm64 build: the original command did not pass `--arch=arm64`.
The newer player script adds explicit architecture flags. When shipping new
binaries, record their actual configuration and source revision separately.

The configuration builds shared libraries and disables autodetection, static
libraries, programs, encoders and muxers. GPL, nonfree and version3 components
are disabled in the checked build. AAC decoding is disabled here because the
macOS player uses AVFoundation. Only the file protocol is enabled. This does
not describe Windows or Linux binaries.

## License and replacement

See `COPYING.LGPLv2.1`, `LICENSE.md` and the original source-file notices.
FFmpeg is not owned by noRecess. The application's proprietary source is not
part of this repository.

A procedure for running a copy of the final Mac App Store application with
modified, ABI-compatible libraries remains to be tested on that distributed
binary. Publishing this source does not claim that test or complete licensing
acceptance. Do not disable security entitlements merely to follow this README.
