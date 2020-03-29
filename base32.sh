#!/bin/sh

set -e
set -x

export INFILE="$1"
[ -n "$INFILE" ] || export INFILE="debian32.tgz"
export INFILE="$(readlink -f "$INFILE")"

export ARCH=i386
export SUITE=sid
export IMAGE="eartiaga/debian32-base:$SUITE"

if [ ! -f "$INFILE" ]; then
    echo "input file does not exist"
    exit 1
fi

cat "$INFILE" | docker import - "$IMAGE"
