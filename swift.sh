#! /bin/bash

set -e

SWIFT_SIGNING_KEY=A62AE125BBBFBB96A6E042EC925CC1CCED3D1561
SWIFT_PLATFORM=ubuntu18.04
SWIFT_BRANCH=swift-5.2.3-release
SWIFT_VERSION=swift-5.2.3-RELEASE
SWIFT_WEBROOT=https://swift.org/builds/

SWIFT_WEBDIR="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)/"
SWIFT_BIN_URL="$SWIFT_WEBDIR/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz"
SWIFT_SIG_URL="$SWIFT_BIN_URL.sig"

GNUPGHOME="$(mktemp -d)"

apt-get -q update
apt-get -q install -y \
	binutils \
    libatomic1 \
    libc6-dev \
    libcurl4 \
    libedit2 \
    libgcc-5-dev \
    libpython2.7 \
    libsqlite3-0 \
    libstdc++-5-dev \
    libxml2 \
    pkg-config \
    tzdata \
    zlib1g-dev

curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz "$SWIFT_SIG_URL" -o swift.tar.gz.sig

gpg --batch --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$SWIFT_SIGNING_KEY"
gpg --batch --verify swift.tar.gz.sig swift.tar.gz

tar -xzf swift.tar.gz --directory / --strip-components=1

chmod -R o+r /usr/lib/swift

rm -rf "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz

apt-get autoremove
rm -r /var/lib/apt/lists/*