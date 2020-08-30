#!/bin/bash
set -e
set -x
pushd "${WORKDIR}"

BASE_LOCATIONS=( "go_build/src/github.com/probonopd/go-appimage" "go-appimage-${EGIT_COMMIT}" )

for b in ${BASE_LOCATIONS[@]} ; do
	pushd "${b}"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-livecd-check.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-binfmt-checks.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-git-root-envvar.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-check-systemd-installed.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-change-sem-limit.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-skip-watching-mountpoints-not-owned.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-change-path-to-appimaged-in-desktop-files.patch"
	patch -p1 -i "${FILESDIR}/go-appimage-9999_p20200829-add-watch-opt-appimage.patch"
	if [[ -n "${USE_DISABLE_WATCHING_DOWNLOADS_FOLDER}" && "${USE_DISABLE_WATCHING_DOWNLOADS_FOLDER}" == "1" ]] ; then
		echo "Modding appimaged.d (for disable_watching_download_folder USE flag)"
		sed -i -e "/xdg.UserDirs.Download/d" "src/appimaged/appimaged.go"
	fi
	if [[ -n "${USE_DISABLE_WATCHING_DESKTOP_FOLDER}" && "${USE_DISABLE_WATCHING_DESKTOP_FOLDER}" == "1" ]] ; then
		echo "Modding appimaged.d (for disable_watching_desktop_folder USE flag)"
		sed -i -e "/xdg.UserDirs.Desktop/d" "src/appimaged/appimaged.go"
	fi
	popd
done

popd
