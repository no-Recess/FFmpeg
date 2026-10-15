#!/bin/bash
set -euo pipefail
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
    echo "This configuration reproduces the native macOS arm64 build only." >&2
    exit 1
fi
BUILD_DIR="${1:-${SOURCE_DIR}/out/norecess-macos-arm64}"
STAGING_DIR="${2:-${SOURCE_DIR}/out/stage}"
mkdir -p "$BUILD_DIR" "$STAGING_DIR"
BUILD_DIR="$(cd "$BUILD_DIR" && pwd)"
STAGING_DIR="$(cd "$STAGING_DIR" && pwd)"
cd "$BUILD_DIR"
"${SOURCE_DIR}/configure" \
    --prefix=/opt/radiotechnika/ffmpeg \
    --disable-all \
    --disable-autodetect \
    --disable-static \
    --enable-shared \
    --enable-pic \
    --enable-avcodec \
    --enable-avformat \
    --enable-avutil \
    --enable-swresample \
    --disable-programs \
    --enable-protocol=file \
    --enable-demuxer=wav,mp3,ogg,opus,flac,mov,m4a,mp4,aac,wv,ape,cue,webm,dsf,dts \
    --install-name-dir=@rpath \
    --extra-cflags=-mmacosx-version-min=11.0 \
    '--extra-ldflags=-mmacosx-version-min=11.0 -Wl,-headerpad_max_install_names' \
    --enable-decoder=pcm_u8,pcm_s16le,pcm_s16be,pcm_s24le,pcm_s32le,pcm_f32le,pcm_f32be,mp3,vorbis,opus,flac,alac,wavpack,ape,dsd_lsbf,dsd_msbf,dsd_lsbf_planar,dsd_msbf_planar,dca
make -j"${JOBS:-6}"
make DESTDIR="$STAGING_DIR" install
printf "Installed into %s/opt/radiotechnika/ffmpeg\n" "$STAGING_DIR"
