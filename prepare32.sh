#!/bin/sh

set -e
set -x

export OUTFILE="$1"
[ -n "$OUTFILE" ] || export OUTFILE="debian32.tgz"
export OUTFILE="$(readlink -f "$OUTFILE")"

export ARCH=i386
export SUITE=sid
export MIRROR="http://debian.grn.cat/debian"
export IMAGEDIR="/tmp/chroot.$(date "+%z").$$"
cleanup() {
    rm -rf "$IMAGEDIR"
}
trap cleanup EXIT

export PATH="${PATH}:/sbin:/usr/sbin"
export DEBIAN_FRONTEND=noninteractive

if [ -e "$OUTFILE" ]; then
    echo "output file already exists"
    exit 1
fi

DEBOOTSTRAP=$(command -v "debootstrap")
if [ -z "$DEBOOTSTRAP" ]; then
    echo "missing debootstrap command"
    exit 1
fi

mkdir -p "$IMAGEDIR/image"
$DEBOOTSTRAP --arch $ARCH \
    --include=apt,aptitude \
    $SUITE "$IMAGEDIR/image" $MIRROR 

tar czf "$OUTFILE" -C "$IMAGEDIR/image" .

