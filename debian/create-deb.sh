#!/bin/bash

SOURCE=$(dpkg-parsechangelog --show-field Source)
VERSION=$(git describe --tags --long | cut -c 2-)
SHORT_VERSION=$(echo "$VERSION" | cut -d '-' -f 1,2)
DEBEMAIL="Jerome Quere <jerome.quere@indigen.com>"
DEBEMAIL=$DEBEMAIL dch -v $VERSION "Release $VERSION"
DEBEMAIL=$DEBEMAIL dch -r $VERSION

tar -cJf ../${SOURCE}_${SHORT_VERSION}.orig.tar.xz *

debuild
debuild clean

rm -f ../${SOURCE}_${VERSION}*.build
rm -f ../${SOURCE}_${VERSION}*.changes
rm -f ../${SOURCE}_${VERSION}*.tar.xz
rm -f ../${SOURCE}_${VERSION}*.dsc
rm -f ../${SOURCE}_${SHORT_VERSION}.orig.tar.xz

popd > /dev/null
