#!/bin/bash
cat ~/aur-pkglist.dat | while read REPO DEST; do
    git clone $REPO $DEST
    pushd $DEST
    makepkg -src
    popd
done
