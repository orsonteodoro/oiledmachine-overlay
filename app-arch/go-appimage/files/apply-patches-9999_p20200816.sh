#!/bin/bash
set -e
set -x
pushd "${WORKDIR}"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200816-skip-livecd-check.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200816-skip-binfmt-checks.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200816-git-root-envvar.patch"
popd
