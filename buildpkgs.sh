#!/bin/bash
REPODIR=./repository

test -n "$S3BUCKET" || exit "You must set S3BUCKET var"

# Step one: clone repos and build.
while read PACKAGE; do
    git clone --depth=1 https://aur.archlinux.org/$PACKAGE.git ./$PACKAGE
    pushd ./$PACKAGE; makepkg -sc; popd
done < ./aur-pkglist.dat

# Step two: find all build packages and add them to the repo
mkdir -p $REPODIR
find . -name '*.pkg*' -type f | while read FILE; do
    repo-add $REPODIR/gizmonicus.db.tar "$FILE"
    cp $FILE $REPODIR
done

# Step three: upload contents to a S3 bucket for hosting
pushd $REPODIR; aws s3 sync --delete . $S3BUCKET; popd
