#!/bin/bash
set -e
set -x
pushd "${WORKDIR}"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-livecd-check.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-binfmt-checks.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-git-root-envvar.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-check-systemd-installed.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-change-sem-limit.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-watching-mountpoints-not-owned.patch"
patch -p0 -i "${FILESDIR}/go-appimage-9999_p20200829-change-path-to-appimaged-in-desktop-files.patch"
popd
