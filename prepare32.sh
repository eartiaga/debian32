#!/bin/sh

set -e
set -x

export OUTFILE="$1"
[ -n "$OUTFILE" ] || export OUTFILE="debian32.tgz"
export OUTFILE="$(readlink -f "$OUTFILE")"
export TSTAMP=$(date "+%s")

export ARCH=i386
export SUITE=sid
export MIRROR="http://deb.debian.org/debian"
#export MIRROR="http://debian.grn.cat/debian"
export IMAGEDIR="/tmp/chroot.${TSTAMP}.$$"
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

#DEBOOTSTRAP=$(command -v "debootstrap")
DEBOOTSTRAP=$(readlink -f "./scripts/debootstrap")
if [ -z "$DEBOOTSTRAP" -o ! -x "$DEBOOTSTRAP" ]; then
    echo "missing debootstrap command"
    exit 1
fi

TAR=$(command -v "tar")
if [ -z "$TAR" -o ! -x "$TAR" ]; then
    echo "missing tar command"
    exit 1
fi

mkdir -p "$IMAGEDIR/image"
$DEBOOTSTRAP --arch $ARCH \
    --include=apt,aptitude,libgcc-s1 \
    --exclude=libgcc1 \
    $SUITE "$IMAGEDIR/image" $MIRROR 

$TAR czf "$OUTFILE" -C "$IMAGEDIR/image" .

