# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info user

DESCRIPTION="Purely experimental playground for Go implementation of AppImage\
tools"
HOMEPAGE="https://github.com/probonopd/go-appimage"
LICENSE="MIT" # go-appimage project's default license
# dependencies of go various micropackages
LICENSE+=" Apache-2.0 BSD BSD-2 EPL-1.0 GPL-3 ISC MPL-2.0"
# Static executables follow below
# aid = included in appimaged ; ait = included in appimagetool
# LICENSE is already handled and accepted in other packages when
# system-binaries USE is enabled.
LICENSE+=" !system-binaries? ( BSD BSD-2 BSD-4 public-domain )" # libarchive aid
LICENSE+=" !system-binaries? ( GPL-2 )" # squashfs-tools ait aid
LICENSE+=" !system-binaries? ( GPL-2+ )" # desktop-file-utils ait
LICENSE+=" !system-binaries? ( GPL-3 )" # patchelf # ait
LICENSE+=" !system-binaries? ( all-rights-reserved MIT )" # \
# The runtime archive comes from runtime.c from AppImageKit \
# MIT license does not have all rights reserved
LICENSE+=" MIT" # upload tool
LICENSE+=" !system-binaries? ( MIT LGPL-2 GPL-2 )" # from musl libc package

# Live ebuilds don't get keyworded.

IUSE+=" -appimaged -appimagetool disable_watching_desktop_folder \
disable_watching_downloads_folder firejail gnome kde openrc overlayfs \
+system-binaries systemd travis-ci"
RDEPEND="
	appimaged? ( !app-arch/appimaged )
	appimagetool? ( app-arch/AppImageKit[-appimagetool] )
	firejail? ( sys-apps/firejail )
	gnome? ( gnome-base/gvfs[udisks] )
	kde? ( kde-frameworks/solid )
	openrc? ( sys-apps/openrc )
	sys-apps/dbus
	>=sys-fs/squashfs-tools-4.4:=
	sys-fs/udisks[daemon]
	system-binaries? (
		app-arch/AppImageKit[runtime]
		>=app-arch/libarchive-3.3.2:=
		>=dev-util/desktop-file-utils-0.15:=
		>=dev-util/patchelf-0.9:=
		>=sys-fs/squashfs-tools-4.4:=
	)
	systemd? ( sys-apps/systemd )
	travis-ci? (
		dev-libs/openssl
		dev-vcs/git
	)"
DEPEND="${RDEPEND}
	>=dev-lang/go-1.13.4:="
REQUIRED_USE="
	|| ( appimaged appimagetool )
	|| ( gnome kde )
	openrc? ( appimaged )
	systemd? ( appimaged )"
SLOT="0/${PV}"

gen_go_dl_gh_url()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local tag="${3}"
	unset tag_split
	readarray -d - -t tag_split <<<"${tag}"
	local tag_commit="${tag_split[2]}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"

	if [[ -n "${tag_commit}" ]] ; then
		echo "
https://codeload.github.com/${uri_frag}/tar.gz/${tag_commit}
	-> ${dest_name}.tar.gz"
	else
		echo "
https://github.com/${uri_frag}/archive/refs/tags/${tag//+incompatible}.tar.gz
	-> ${dest_name}.tar.gz"
	fi

}

# The github.com/probonopd/go-appimage is the main line.
# Versioning is based on that.  Dating off by 1.
EGIT_COMMIT="1d57e84e82e82d9fd11bd148dc9257988147187c" # Same as the 8 char hash below

SRC_URI+=" "$(gen_go_dl_gh_url github.com/acobaugh/osrelease acobaugh/osrelease v0.0.0-20181218015638-a93a0a55a249)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/adrg/xdg adrg/xdg v0.2.3)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/alokmenghrajani/gpgeez alokmenghrajani/gpgeez v0.0.0-20161206084504-1a06f1c582f9)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/CalebQ42/squashfs CalebQ42/squashfs v0.3.12)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/cenkalti/backoff cenkalti/backoff v1.1.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/cenkalti/backoff cenkalti/backoff v2.2.1+incompatible)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/coreos/go-systemd/v22 coreos/go-systemd v22.1.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/cpuguy83/go-md2man/v2 cpuguy83/go-md2man v2.0.0-20190314233015-f79a8a8ca69d)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/eclipse/paho.mqtt.golang eclipse/paho.mqtt.golang v1.3.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/emirpasic/gods emirpasic/gods v1.12.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/esiqveland/notify esiqveland/notify v0.9.1)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/godbus/dbus/v5 godbus/dbus v5.0.3)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/google/go-github google/go-github v17.0.0+incompatible)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/google/go-querystring google/go-querystring v0.0.0-20170111101155-53e6ce116135)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/go-ole/go-ole go-ole/go-ole v1.2.4)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/gorilla/websocket gorilla/websocket v1.4.2)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/grandcat/zeroconf grandcat/zeroconf v1.0.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/h2non/go-is-svg h2non/go-is-svg v0.0.0-20160927212452-35e8c4b0612c)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/hashicorp/go-version hashicorp/go-version v1.2.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/jbenet/go-context jbenet/go-context v0.0.0-20150711004518-d14ea06fba99)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/kevinburke/ssh_config kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/klauspost/compress klauspost/compress v1.11.6)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/miekg/dns miekg/dns v1.1.27)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/mitchellh/go-homedir mitchellh/go-homedir v1.1.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/otiai10/copy otiai10/copy v1.4.1)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/pierrec/lz4/v4 pierrec/lz4 v4.1.3)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/probonopd/go-appimage probonopd/go-appimage v0.0.0-20210430065939-1d57e84e82e8)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/probonopd/go-zsyncmake probonopd/go-zsyncmake v0.0.0-20181008012426-5db478ac2be7)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/prometheus/procfs prometheus/procfs v0.2.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/rjeczalik/notify rjeczalik/notify v0.9.2)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/russross/blackfriday/v2 russross/blackfriday v2.0.1)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/sabhiram/png-embed sabhiram/png-embed v0.0.0-20180421025336-149afe9a3ccb)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/sabhiram/pngr sabhiram/pngr v0.0.0-20180419043407-2df49b015d4b)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/sergi/go-diff sergi/go-diff v1.0.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/shirou/gopsutil shirou/gopsutil v3.20.11+incompatible)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/shuheiktgw/go-travis shuheiktgw/go-travis v0.3.1)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/shurcooL/sanitized_anchor_name shurcooL/sanitized_anchor_name v1.0.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/src-d/gcfg src-d/gcfg v1.4.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/srwiley/oksvg srwiley/oksvg v0.0.0-20200311192757-870daf9aa564)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/srwiley/rasterx srwiley/rasterx v0.0.0-20200120212402-85cb7272f5e9)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/StackExchange/wmi StackExchange/wmi v0.0.0-20190523213315-cbe66965904d)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/ulikunitz/xz ulikunitz/xz v0.5.9)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/urfave/cli/v2 urfave/cli v2.3.0)
SRC_URI+=" "$(gen_go_dl_gh_url github.com/xanzy/ssh-agent xanzy/ssh-agent v0.2.1)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/crypto golang/crypto v0.0.0-20201221181555-eec23a3978ad)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/image golang/image v0.0.0-20201208152932-35266b937fa6)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/net golang/net v0.0.0-20200425230154-ff2c4b7c35a0)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/sys golang/sys v0.0.0-20201221093633-bc327ba9c2f0)
SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/text golang/text v0.3.2)
SRC_URI+=" "$(gen_go_dl_gh_url go.lsp.dev/uri go-language-server/uri v0.3.0)
SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/ini.v1 go-ini/ini v1.62.0)
SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/src-d/go-billy.v4 src-d/go-billy v4.3.2)
SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/src-d/go-git.v4 src-d/go-git v4.13.1)
SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/warnings.v0 go-warnings/warnings v0.1.2)

# These must be inspected and updated on every ebuild update since
# they are live upstream.  No known way to reference them statically.
# The continuous git tag below in gen_static_tools_uris() changes.
COMMIT_STATIC_TOOLS="eda9edf025235f272ed1aca27679c65b3907e6bf"
TAG_AIK="12"
COMMIT_UPLOADTOOL="433273417b250707bab53c36e890e3eb68006bf3"

gen_static_tools_uris()
{
	local garch="${1}"
	local arch="${2}"
	echo "
system-binaries? (
	${garch}? (
https://github.com/probonopd/static-tools/releases/download/continuous/desktop-file-validate-${arch}
	-> probonopd-desktop-file-validate-${arch}-${COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/mksquashfs-${arch}
	-> probonopd-mksquashfs-${arch}-${COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/patchelf-${arch}
	-> probonopd-patchelf-${arch}-${COMMIT_STATIC_TOOLS:0:7}
https://github.com/AppImage/AppImageKit/releases/download/${TAG_AIK}/runtime-${arch}
	-> AppImageKit-runtime-${arch}-${TAG_AIK}
https://github.com/probonopd/static-tools/releases/download/continuous/bsdtar-${arch}
	-> bsdtar-${arch}-${COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/unsquashfs-${arch}
	-> unsquashfs-${arch}-${COMMIT_STATIC_TOOLS:0:7}
	)
)"
}

SRC_URI+=" "$(gen_static_tools_uris amd64 x86_64)
SRC_URI+=" "$(gen_static_tools_uris x86 i686)
SRC_URI+=" "$(gen_static_tools_uris arm armhf)
SRC_URI+=" "$(gen_static_tools_uris amd64 aarch64)
SRC_URI+="
https://raw.githubusercontent.com/probonopd/uploadtool/${COMMIT_UPLOADTOOL}/upload.sh
	-> probonopd-upload.sh-${COMMIT_UPLOADTOOL:0:7}"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-${PV}-gentooize.patch" )

# See scripts/build.sh

pkg_setup() {
	# Re-enable if you need the dependency graph
#	if has network-sandbox $FEATURES ; then
#		die \
#"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
#micropackages."
#	fi
	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
		die \
"You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
	fi
	if ! linux_chkconfig_builtin BINFMT_MISC \
		&& ! linux_chkconfig_module BINFMT_MISC ; then
		die \
"You need to change your kernel .config to CONFIG_BINFMT_MISC=y or \
CONFIG_BINFMT_MISC=m"
	fi

	if ! linux_chkconfig_builtin SQUASHFS \
		&& ! linux_chkconfig_module SQUASHFS ; then
		die \
"You need to change your kernel .config to CONFIG_SQUASHFS=y or \
CONFIG_SQUASHFS=m"
	fi

	local found_appimage_type=0
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ]] \
		&& grep -F -e "enabled" \
			"${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ; then
		found_appimage_type=1
		eerror \
"You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type1"
		die
	fi
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ]] \
		&& grep -F -e "enabled" \
			"${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ; then
		eerror \
"You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type2"
		die
	fi

	if [[ "${found_appimage_type}" == "1" ]] ; then
		eerror \
"See issue: https://github.com/probonopd/go-appimage/issues/7"
		eerror
		eerror "See also:"
		eerror \
"https://github.com/probonopd/go-appimage/blob/\
4ac0e102e05507f43c82beef558d0eedba0e50ae/src/appimaged/prerequisites.go#L216"
		eerror \
"https://www.kernel.org/doc/Documentation/admin-guide/binfmt-misc.rst"
		die
	fi

	if [[ -f "${EROOT}/usr/bin/AppImageLauncher" ]] ; then
		die \
"AppImageLauncher is not compatible and needs to be uninstalled."
	fi
	if use firejail ; then
		if ! linux_chkconfig_builtin BLK_DEV_LOOP \
			&& ! linux_chkconfig_module BLK_DEV_LOOP ; then
			die \
"You need to change your kernel .config to CONFIG_BLK_DEV_LOOP=y or \
CONFIG_BLK_DEV_LOOP=m"
		fi
		if use overlayfs && ! linux_chkconfig_builtin OVERLAY_FS \
			&& ! linux_chkconfig_module OVERLAY_FS ; then
			die \
"You need to change your kernel .config to CONFIG_OVERLAY_FS=y or \
CONFIG_OVERLAY_FS=m"
		fi
	fi
	ewarn \
"This package is a Work In Progress (WIP) upstream."
	if use appimaged ; then
		ewarn \
"The appimaged in this package is not production quality and may random quit \
at random times.  An auto-restart for this daemon has not been implemented.  \
Use the appimaged package instead."
	fi
	# server only
	enewgroup appimaged
	enewuser appimaged -1 -1 /var/lib/appimaged appimaged

	if ! use system-binaries ; then
		ewarn "This ebuild may fail when checking checksums since"
		ewarn "there is no way to download a specific version/commit"
		ewarn "or cached older server builds."
		ewarn
		ewarn "It is recommended to use the system-binaries USE flag if downloading"
		ewarn "is a problem."
	fi
}

unpack_go_pkg()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local proj_name="${2#*/}"
	local tag="${3}"
	local dest="${S_GO}/src/${pkg_name}"
	#local dest="${S_GO}/pkg/mod/$(dirname ${pkg_name})/${proj_name}@${tag}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"
	einfo "Unpacking ${dest_name}.tar.gz"
	mkdir -p "${dest}" || die
#	if [[ "${pkg_name}" == "golang.org/x/tools" ]] ; then
#		tar --strip-components=1 -x -C "${dest}" \
#			-f "${DISTDIR}/${dest_name}.tar.gz" \
#			--exclude=tools-${tag##*-}/gopls || die
#	elif [[ "${pkg_name}" == "golang.org/x/tools/gopls" ]] ; then
#		tar --strip-components=2 -x -C "${dest}" \
#			-f "${DISTDIR}/${dest_name}.tar.gz" \
#			tools-gopls-v${GOPLS_V}/gopls || die
#	else
		tar --strip-components=1 -x -C "${dest}" \
			-f "${DISTDIR}/${dest_name}.tar.gz" || die
#	fi
}

unpack_go()
{
	unpack_go_pkg github.com/acobaugh/osrelease acobaugh/osrelease v0.0.0-20181218015638-a93a0a55a249
	unpack_go_pkg github.com/adrg/xdg adrg/xdg v0.2.3
	unpack_go_pkg github.com/alokmenghrajani/gpgeez alokmenghrajani/gpgeez v0.0.0-20161206084504-1a06f1c582f9
	unpack_go_pkg github.com/CalebQ42/squashfs CalebQ42/squashfs v0.3.12
	unpack_go_pkg github.com/cenkalti/backoff cenkalti/backoff v1.1.0
	unpack_go_pkg github.com/cenkalti/backoff cenkalti/backoff v2.2.1+incompatible
	unpack_go_pkg github.com/coreos/go-systemd/v22 coreos/go-systemd v22.1.0
	unpack_go_pkg github.com/cpuguy83/go-md2man/v2 cpuguy83/go-md2man v2.0.0-20190314233015-f79a8a8ca69d
	unpack_go_pkg github.com/eclipse/paho.mqtt.golang eclipse/paho.mqtt.golang v1.3.0
	unpack_go_pkg github.com/emirpasic/gods emirpasic/gods v1.12.0
	unpack_go_pkg github.com/esiqveland/notify esiqveland/notify v0.9.1
	unpack_go_pkg github.com/godbus/dbus/v5 godbus/dbus v5.0.3
	unpack_go_pkg github.com/google/go-github google/go-github v17.0.0+incompatible
	unpack_go_pkg github.com/google/go-querystring google/go-querystring v0.0.0-20170111101155-53e6ce116135
	unpack_go_pkg github.com/go-ole/go-ole go-ole/go-ole v1.2.4
	unpack_go_pkg github.com/gorilla/websocket gorilla/websocket v1.4.2
	unpack_go_pkg github.com/grandcat/zeroconf grandcat/zeroconf v1.0.0
	unpack_go_pkg github.com/h2non/go-is-svg h2non/go-is-svg v0.0.0-20160927212452-35e8c4b0612c
	unpack_go_pkg github.com/hashicorp/go-version hashicorp/go-version v1.2.0
	unpack_go_pkg github.com/jbenet/go-context jbenet/go-context v0.0.0-20150711004518-d14ea06fba99
	unpack_go_pkg github.com/kevinburke/ssh_config kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd
	unpack_go_pkg github.com/klauspost/compress klauspost/compress v1.11.6
	unpack_go_pkg github.com/miekg/dns miekg/dns v1.1.27
	unpack_go_pkg github.com/mitchellh/go-homedir mitchellh/go-homedir v1.1.0
	unpack_go_pkg github.com/otiai10/copy otiai10/copy v1.4.1
	unpack_go_pkg github.com/pierrec/lz4/v4 pierrec/lz4 v4.1.3
	unpack_go_pkg github.com/probonopd/go-appimage probonopd/go-appimage v0.0.0-20210430065939-1d57e84e82e8
	unpack_go_pkg github.com/probonopd/go-zsyncmake probonopd/go-zsyncmake v0.0.0-20181008012426-5db478ac2be7
	unpack_go_pkg github.com/prometheus/procfs prometheus/procfs v0.2.0
	unpack_go_pkg github.com/rjeczalik/notify rjeczalik/notify v0.9.2
	unpack_go_pkg github.com/russross/blackfriday/v2 russross/blackfriday v2.0.1
	unpack_go_pkg github.com/sabhiram/png-embed sabhiram/png-embed v0.0.0-20180421025336-149afe9a3ccb
	unpack_go_pkg github.com/sabhiram/pngr sabhiram/pngr v0.0.0-20180419043407-2df49b015d4b
	unpack_go_pkg github.com/sergi/go-diff sergi/go-diff v1.0.0
	unpack_go_pkg github.com/shirou/gopsutil shirou/gopsutil v3.20.11+incompatible
	unpack_go_pkg github.com/shuheiktgw/go-travis shuheiktgw/go-travis v0.3.1
	unpack_go_pkg github.com/shurcooL/sanitized_anchor_name shurcooL/sanitized_anchor_name v1.0.0
	unpack_go_pkg github.com/src-d/gcfg src-d/gcfg v1.4.0
	unpack_go_pkg github.com/srwiley/oksvg srwiley/oksvg v0.0.0-20200311192757-870daf9aa564
	unpack_go_pkg github.com/srwiley/rasterx srwiley/rasterx v0.0.0-20200120212402-85cb7272f5e9
	unpack_go_pkg github.com/StackExchange/wmi StackExchange/wmi v0.0.0-20190523213315-cbe66965904d
	unpack_go_pkg github.com/ulikunitz/xz ulikunitz/xz v0.5.9
	unpack_go_pkg github.com/urfave/cli/v2 urfave/cli v2.3.0
	unpack_go_pkg github.com/xanzy/ssh-agent xanzy/ssh-agent v0.2.1
	unpack_go_pkg golang.org/x/crypto golang/crypto v0.0.0-20201221181555-eec23a3978ad
	unpack_go_pkg golang.org/x/image golang/image v0.0.0-20201208152932-35266b937fa6
	unpack_go_pkg golang.org/x/net golang/net v0.0.0-20200425230154-ff2c4b7c35a0
	unpack_go_pkg golang.org/x/sys golang/sys v0.0.0-20201221093633-bc327ba9c2f0
	unpack_go_pkg golang.org/x/text golang/text v0.3.2
	unpack_go_pkg go.lsp.dev/uri go-language-server/uri v0.3.0
	unpack_go_pkg gopkg.in/ini.v1 go-ini/ini v1.62.0
	unpack_go_pkg gopkg.in/src-d/go-billy.v4 src-d/go-billy v4.3.2
	unpack_go_pkg gopkg.in/src-d/go-git.v4 src-d/go-git v4.13.1
	unpack_go_pkg gopkg.in/warnings.v0 go-warnings/warnings v0.1.2
}

get_arch()
{
	if use amd64 ; then
		echo "x86_64"
	elif use x86 ; then
		echo "x86"
	elif use arm ; then
		echo "armhf"
	elif use arm64 ; then
		echo "aarch64"
	fi
}

get_arch2()
{
	if use amd64 ; then
		echo "amd64"
	elif use x86 ; then
		echo "x86"
	elif use arm ; then
		echo "arm"
	elif use arm64 ; then
		echo "arm64"
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die

	export S_GO="${WORKDIR}/go_build"

	unpack_go

	declare -Ax GARCH_TO_ARCH=(
		[amd64]="x86_64"
		[x86]="i686"
		[arm]="armhf"
		[arm64]="aarch64"
	)

	if ! use system-binaries ; then
		export USE_SYSTEM_DESKTOP_FILE_VALIDATE=0
		export USE_SYSTEM_MKSQUASH=0
		export USE_SYSTEM_PATCHELF=0
		export USE_SYSTEM_AIK_RUNTIME=0
		export USE_SYSTEM_BSDTAR=0
		export USE_SYSTEM_UNSQUASH=0
	else
		export USE_SYSTEM_DESKTOP_FILE_VALIDATE=1
		export USE_SYSTEM_MKSQUASH=1
		export USE_SYSTEM_PATCHELF=1
		export USE_SYSTEM_AIK_RUNTIME=1
		export USE_SYSTEM_BSDTAR=1
		export USE_SYSTEM_UNSQUASH=1
		mkdir -p "${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin" || die
		mkdir -p "${WORKDIR}/go_build/src/appimaged.AppDir/usr/bin" || die
		cp -a "${ESYSROOT}/usr/bin/desktop-file-validate" \
			"${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin/" || die
		cp -a "${ESYSROOT}/usr/bin/mksquashfs" \
			"${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin/" || die
		cp -a "${ESYSROOT}/usr/bin/patchelf" \
			"${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin/" || die
		einfo "Copying ${ESYSROOT}/usr/$(get_libdir)/AppImageKit/runtime-"$(get_arch2)" to ${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin/"
		cp -a "${ESYSROOT}/usr/$(get_libdir)/AppImageKit/runtime-"$(get_arch2) \
			"${WORKDIR}/go_build/src/appimagetool.AppDir/usr/bin/" || die
		cp -a "${ESYSROOT}/usr/bin/bsdtar" \
			"${WORKDIR}/go_build/src/appimaged.AppDir/usr/bin/" || die
		cp -a "${ESYSROOT}/usr/bin/unsquashfs" \
			"${WORKDIR}/go_build/src/appimaged.AppDir/usr/bin/" || die
	fi

	# go_build/src/github.com/probonopd/go-appimage/scripts/build.sh
	export S="${S_GO}/src/github.com/probonopd/go-appimage"
	cd "${S}" || die

	chmod +x "${S}/scripts/build.sh" || die
	eapply ${PATCHES[@]}
	# required for public key embedding
	git init || die
	git add . || die
	export GIT_ROOT="${S}"
	# required for mounting when calling:
	#   ./appimagetool-2020-08-17_00:47:34-amd64.AppImage ./appimaged.AppDir
	addwrite /dev/fuse
	if use disable_watching_downloads_folder ; then
		export USE_DISABLE_WATCHING_DOWNLOADS_FOLDER=1
	fi
	if use disable_watching_desktop_folder ; then
		export USE_DISABLE_WATCHING_DESKTOP_FOLDER=1
	fi
	if use system-binaries ; then
		export USE_SYSTEM_BINARIES=1
		export GET_LIBDIR=$(get_libdir)
	else
		export USE_SYSTEM_BINARIES=0
	fi
	export arch
	export APPLY_PATCHES_V="${PV}"
	export COMMIT_STATIC_TOOLS
	export COMMIT_UPLOADTOOL
	export DISTDIR
	export GO111MODULE=auto
	export EGIT_COMMIT
	export TAG_AIK
	export TRAVIS_BUILD_DIR="${S}"

}

src_prepare() {
	# fork to add patches
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"

	pushd "${WORKDIR}"

	BASE_LOCATIONS=( "go_build/src/github.com/probonopd/go-appimage" )

	for b in ${BASE_LOCATIONS[@]} ; do
		pushd "${b}"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-skip-livecd-check.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-skip-binfmt-checks.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-git-root-envvar.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-check-systemd-installed.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-change-sem-limit.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20200829-skip-watching-mountpoints-not-owned.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20210429-change-path-to-appimaged-in-desktop-files.patch"
		eapply "${FILESDIR}/go-appimage-9999_p20210429-add-watch-opt-appimage.patch"
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

}

src_compile() {
	einfo "DISTDIR=${DISTDIR}"
	use amd64 && export GARCH="amd64"
	use x86 && export GARCH="x86"
	use arm64 && export GARCH="arm64"
	use arm && export GARCH="arm"
#	mkdir -p "${WORKDIR}/go_build/src/github.com/probonopd/go-appimage"
	export GO_APPIMAGE_V="v0.0.0-20210430065939-1d57e84e82e8"
	"${S}/scripts/build.sh" || die # move to src_unpack if you need the dependency graph
}

# @FUNCTION: install_licenses
# @DESCRIPTION:
# Installs all licenses from main package and micropackages
# Standardizes the process.
install_licenses() {
	local source_dir="${1}"
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${source_dir}" \
	  -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -r -e "s|^${source_dir}||")
		else
			d=$(echo "${f}" | sed -r -e "s|^${source_dir}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}



src_install() {
	local goArch=$(go env GOHOSTARCH)
	exeinto /usr/bin
	BUILD_DIR="${WORKDIR}/go_build/src"
	# No support for multi go yet the other is false
	# Gentoo's Go is not multilib that's why.
	local aits=$(basename $(realpath "${BUILD_DIR}/appimaged-*-${goArch}.AppImage") \
		| cut -f 2-4 -d "-")
	local aid_fn="appimaged-${aits}-${goArch}.AppImage"
	local ait_fn="appimagetool-${aits}-${goArch}.AppImage"
	if use appimaged ; then
		doexe "${BUILD_DIR}/${aid_fn}"
		dosym ../../../usr/bin/${aid_fn} /usr/bin/appimaged
		if use openrc ; then
			cp "${FILESDIR}/${PN}-openrc" \
				"${T}/${PN}" || die
			exeinto /etc/init.d
			doexe "${T}/${PN}"
		fi
	fi
	if use appimagetool ; then
		doexe "${BUILD_DIR}/${ait_fn}"
		dosym ../../../usr/bin/${ait_fn} /usr/bin/appimagetool
	fi
	install_licenses "${BUILD_DIR}"
	docinto licenses
	dodoc "${S}/LICENSE"
	docinto readme
	dodoc "${S}/README.md"
	cp "${S}/src/appimaged/README.md" \
		"${T}/appimaged-README.md" || die
	dodoc "${T}/appimaged-README.md"
	cp "${S}/src/appimagetool/README.md" \
		"${T}/appimagetool-README.md" || die
	dodoc "${T}/appimagetool-README.md"
}

pkg_postinst() {
	if use openrc ; then
		einfo \
"\n\
OpenRC support is experimental.  It may or not work for encrypted home.\n\
Do \`rc-update add appimaged\` to run the service on boot.\n\
\n\
You can \`/etc/init.d/${PN} start\` to start it now.\n\
\n"
	fi
	if use systemd ; then
		einfo \
"\n\
You must run appimaged as non-root to generate the systemd service files in\n\
~/.\n\
\n\
You must \`systemctl --user enable appimaged\` inside the user account to add\n\
the service on login.\n\
\n\
You can \`systemctl --user start appimaged\` to start it now.\n\
\n"
	fi
	einfo
	einfo "The appimaged daemon will randomly quit when watching files"
	einfo "and needs to be restarted."
	einfo
	einfo "The user may need to be added to the \"disk\" group in order"
	einfo "for firejail rules to work."
	einfo
	einfo "Security:  Do not download AppImages from untrusted sites."
	einfo
	einfo "AppImageHub, a portal site for AppImage downloads mentioned in"
	einfo "appimagetool, can be found at https://appimage.github.io/"
	einfo
	einfo "Old appimages may have vulnerabilities.  Make sure you use"
	einfo "an up-to-date version or a well maintained alternative."
}
