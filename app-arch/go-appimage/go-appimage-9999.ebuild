# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 lcnr linux-info user-info

if ! [[ ${PV} =~ 9999 ]] ; then
	export OFFLINE="1"
fi

# GEN_EBUILD=1 # Uncomment to generate ebuild

if ! [[ ${PV} =~ 9999 ]] ; then
	# See also
	# https://pkg.go.dev/github.com/probonopd/go-appimage?tab=versions
	export EGIT_COMMIT="bb5081a46c15ebb828b5cb0bb0445e1e2f6484ad" # Dec 17, 2022 # Same as the 8 char hash below

	# From:
	# wget -q -O - \
	#	https://github.com/probonopd/go-appimage/commit/${EGIT_COMMIT}.patch \
	#	| grep "^Date:" \
	#	| head -n 1 \
	#	| cut -f 2- -d " "
	export EGIT_COMMIT_TIMESTAMP="Sat, 17 Dec 2022 13:18:55 +0100"

	TIMESTAMP_YYMMDD="20221217"
	TIMESTAMP_HHMMSS="121855" # UTC
	MY_PV="v0.0.0-${TIMESTAMP_YYMMDD}${TIMESTAMP_HHMMSS}-${EGIT_COMMIT:0:12}"
	# Live ebuilds do not get KEYWORDS.  Distro policy.
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi


DESCRIPTION="Purely experimental playground for Go implementation of AppImage \
tools"
HOMEPAGE="https://github.com/probonopd/go-appimage"

THIRD_PARTY_LICENSES="
	(
		BSD
		CC-BY-SA-1.0
		CC-BY-SA-2.0
		CC-BY-SA-2.5
		CC-BY-SA-3.0
	)
	(
		BSD-2
		ISC
	)
	(
		BSD
		EPL-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		BSD
		BSD-2
		|| (
			BSD
			EPL-2.0
		)
	)
	Apache-2.0
	BSD
	BSD-2
	CC-BY-3.0
	CC0-1.0
	custom
	GO-PATENTS
	GPL-2
	GPL-3
	MIT
	MPL-2.0
	W3C-Test-Suite-Licence
	musl? (
		(
			Apache-2.0
			Apache-2.0-with-LLVM-exceptions
			MIT
			|| (
				BSD-2
				CC0-1.0
				MIT
			)
		)
		(
			Apache-2.0-with-LLVM-exceptions
			|| (
				MIT
				UoI-NCSA
			)
		)
		(
			(
				all-rights-reserved
				HPND
			)
			BSD
			BSD-4
			HPND
			inner-net
			ISC
			LGPL-2.1+
			PCRE
			totd
		)
		(
			custom
			public-domain
		)
		(
			BSD
			BSD-2
			MIT
			public-domain
		)
		Apache-2.0-with-LLVM-exceptions
		ZPL
	)
"

LICENSE="
	${THIRD_PARTY_LICENSES}
	MIT
"

# ( Apache-2.0 || ( CC0-1.0 BSD-2 MIT ) Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT ) - work/go_build/src/zig/lib/libc/wasi/LICENSE
# ( Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT ) ) - go_build/src/zig/lib/libcxx/LICENSE.TXT
# ( BSD CC-BY-SA-1.0 CC-BY-SA-2.0 CC-BY-SA-2.5 CC-BY-SA-3.0 ) - go_build/src/golang.org/x/text/unicode/norm/normalize_test.go
# ( BSD-2 ISC ) - go_build/src/github.com/emirpasic/gods/LICENSE
# ( BSD-4 HPND ISC BSD inner-net totd ( all-rights-reserved HPND ) PCRE LGPL-2.1+ ) - go_build/src/zig/lib/libc/glibc/LICENSES
# ( custom public-domain ) - go_build/src/zig/lib/libc/musl/src/crypt/crypt_blowfish.c
# ( EPL-2.0 BSD ) - go_build/src/github.com/eclipse/paho.mqtt.golang/LICENSE
# ( MIT BSD BSD-2 public-domain ) - go_build/src/zig/lib/libc/musl/COPYRIGHT
# ( MIT all-rights-reserved ) - go_build/src/github.com/xrash/smetrics/LICENSE
# ( || ( EPL-2.0 BSD ) BSD-2 BSD ) - go_build/src/github.com/eclipse/paho.mqtt.golang/NOTICE.md
# BSD - go_build/src/github.com/ulikunitz/xz/cmd/gxz/licenses.go
# BSD-2 - go_build/src/zig/lib/libc/wasi/libc-bottom-half/cloudlibc/LICENSE
# MIT - go_build/src/zig/lib/libc/wasi/LICENSE-MIT
# MIT - go_build/src/github.com/CalebQ42/squashfs/LICENSE
# Apache-2.0 - go_build/src/github.com/prometheus/procfs/scripts/check_license.sh
# Apache-2.0-with-LLVM-exceptions - go_build/src/zig/lib/libc/wasi/LICENSE-APACHE-LLVM
# custom - go_build/src/github.com/srwiley/oksvg/testdata/sportsIcons/readme.txt
# custom BSD W3C-Test-Suite-Licence - go_build/src/golang.org/x/net/html/charset/testdata/README
# CC-BY-3.0 - go_build/src/github.com/srwiley/oksvg/testdata/LICENSE
# CC0-1.0 - go_build/src/github.com/therootcompany/xz/LICENSE
# GPL-3 - go_build/src/github.com/probonopd/go-zsyncmake/LICENSE
# GPL-2 - go_build/src/github.com/rasky/go-lzo/LICENSE.gpl
# GO-PATENTS - go_build/src/golang.org/x/image/PATENTS
# GO-PATENTS - go_build/src/golang.org/x/sync/PATENTS
# GO-PATENTS - go_build/src/golang.org/x/text/PATENTS
# GO-PATENTS - go_build/src/golang.org/x/sys/PATENTS
# GO-PATENTS - go_build/src/golang.org/x/crypto/PATENTS
# GO-PATENTS - go_build/src/golang.org/x/net/PATENTS
# MPL-2.0 - go_build/src/github.com/hashicorp/go-version/LICENSE
# ZPL - go_build/src/zig/lib/libc/mingw/COPYING

# Found third-party in static-tools:
# Artistic-2.0beta4 - zsync-0.6.2/COPYING
# BSD-2 - squashfuse-e51978cd6bb5c4d16fae9eee43d0b258f570bb0f/LICENSE
# BSD BSD-2 public-domain - libarchive-3.3.2/COPYING
# GPL-2 - desktop-file-utils-56d220dd679c7c3a8f995a41a27a7d6f3df49dea/COPYING
# GPL-2 - appstream-0.12.9/LICENSE.GPLv2
# GPL-2 - squashfs-tools-4.5.1/COPYING
# GPL-3 - patchelf-0.9/COPYING
# LGPL-2.1 - appstream-0.12.9/LICENSE.LGPLv2.1
# MIT - static-tools-9999/LICENSE
# OPENLDAP - openldap-LMDB_0.9.29/libraries/liblmdb/LICENSE

# Static executables follow below
# aid = included in appimaged ; ait = included in appimagetool
# LICENSE is already handled and accepted in other packages when the musl USE
# flag is disabled.
LICENSE+=" musl? ( OPENLDAP GPL-2 LGPL-2.1 )" # appstreamcli # ait
LICENSE+=" musl? ( BSD BSD-2 BSD-4 public-domain )" # libarchive (bsdtar) aid
LICENSE+=" musl? ( GPL-2 )" # squashfs-tools ait aid
LICENSE+=" musl? ( GPL-2+ )" # desktop-file-utils ait
LICENSE+=" musl? ( GPL-3 )" # patchelf # ait
LICENSE+=" musl? ( all-rights-reserved MIT )" # \
# The runtime archive comes from runtime.c from the AppImageKit project. \
# The MIT license template does not have all rights reserved, but the BSD \
# template does.
LICENSE+=" MIT" # upload tool
LICENSE+=" musl? ( MIT LGPL-2 GPL-2 )" # From the musl libc package

[[ ${PV} =~ 9999 ]] && IUSE+=" fallback-commit"
IUSE+="
firejail -musl gnome kde
"
REQUIRED_USE+="
	|| (
		gnome
		kde
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"
TRAVIS_CI_DEPENDS="
	>=dev-libs/openssl-1.1.1f
	>=dev-vcs/git-2.43.0
"
# U 20.04 for go-appimage project
# Upstream uses A 3.15 for static-tools aka !musl section
RDEPEND+="
	${TRAVIS_CI_DEPENDS}
	!app-arch/appimaged
	!app-arch/AppImageKit
	>=sys-fs/squashfs-tools-4.4:=
	>=sys-apps/dbus-1.12.16
	>=sys-fs/udisks-2.8.4[daemon]
	>=sys-apps/systemd-245.4
	!musl? (
		app-arch/static-tools
	)
	firejail? (
		>=sys-apps/firejail-0.9.62
	)
	gnome? (
		>=gnome-base/gvfs-1.44.1[udisks]
	)
	kde? (
		>=kde-frameworks/solid-5.68.0
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-lang/go-1.18.10:=
"

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
	-> ${dest_name}.tar.gz
		"
	else
		echo "
https://github.com/${uri_frag}/archive/refs/tags/${tag//+incompatible}.tar.gz
	-> ${dest_name}.tar.gz
		"
	fi

}

if [[ -z "${GEN_EBUILD}" ]] && ! [[ ${PV} =~ 9999 ]] ; then
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/probonopd/go-appimage probonopd/go-appimage ${MY_PV})
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/CalebQ42/squashfs CalebQ42/squashfs v0.6.2)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/acobaugh/osrelease acobaugh/osrelease v0.1.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/adrg/xdg adrg/xdg v0.4.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/alokmenghrajani/gpgeez alokmenghrajani/gpgeez v0.0.0-20161206084504-1a06f1c582f9)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/coreos/go-systemd/v22 coreos/go-systemd v22.4.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/eclipse/paho.mqtt.golang eclipse/paho.mqtt.golang v1.4.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/esiqveland/notify esiqveland/notify v0.11.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/godbus/dbus/v5 godbus/dbus v5.1.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/google/go-github google/go-github v17.0.0+incompatible)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/grandcat/zeroconf grandcat/zeroconf v1.0.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/h2non/go-is-svg h2non/go-is-svg v0.0.0-20160927212452-35e8c4b0612c)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/hashicorp/go-version hashicorp/go-version v1.6.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/mgord9518/imgconv mgord9518/imgconv v0.0.0-20211227113402-4a8e0ad15713)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/otiai10/copy otiai10/copy v1.7.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/probonopd/go-zsyncmake probonopd/go-zsyncmake v0.0.0-20181008012426-5db478ac2be7)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/prometheus/procfs prometheus/procfs v0.8.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/rjeczalik/notify rjeczalik/notify v0.9.2)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/sabhiram/png-embed sabhiram/png-embed v0.0.0-20180421025336-149afe9a3ccb)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/shirou/gopsutil shirou/gopsutil v3.21.11+incompatible)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/shuheiktgw/go-travis shuheiktgw/go-travis v0.3.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/srwiley/oksvg srwiley/oksvg v0.0.0-20221002174631-3742d547bf3c)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/srwiley/rasterx srwiley/rasterx v0.0.0-20220730225603-2ab79fcdd4ef)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/urfave/cli/v2 urfave/cli v2.17.1)
	SRC_URI+=" "$(gen_go_dl_gh_url go.lsp.dev/uri go-language-server/uri v0.3.0)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/crypto golang/crypto v0.0.0-20221005025214-4161e89ecf1b)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/sys golang/sys v0.0.0-20221006211917-84dc82d7e875)
	SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/ini.v1 go-ini/ini v1.67.0)
	SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/src-d/go-git.v4 src-d/go-git v4.13.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/cenkalti/backoff cenkalti/backoff v2.2.1+incompatible)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/cpuguy83/go-md2man/v2 cpuguy83/go-md2man v2.0.2)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/emirpasic/gods emirpasic/gods v1.12.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/gabriel-vasile/mimetype gabriel-vasile/mimetype v1.4.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/go-ole/go-ole go-ole/go-ole v1.2.6)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/google/go-querystring google/go-querystring v0.0.0-20170111101155-53e6ce116135)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/gorilla/websocket gorilla/websocket v1.4.2)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/jbenet/go-context jbenet/go-context v0.0.0-20150711004518-d14ea06fba99)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/kevinburke/ssh_config kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/klauspost/compress klauspost/compress v1.15.9)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/miekg/dns miekg/dns v1.1.27)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/mitchellh/go-homedir mitchellh/go-homedir v1.1.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/pierrec/lz4/v4 pierrec/lz4 v4.1.15)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/rasky/go-lzo rasky/go-lzo v0.0.0-20200203143853-96a758eda86e)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/russross/blackfriday/v2 russross/blackfriday v2.1.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/rustyoz/Mtransform rustyoz/Mtransform v0.0.0-20190224104252-60c8c35a3681)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/rustyoz/genericlexer rustyoz/genericlexer v0.0.0-20190224115003-eb82fd2987bd)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/rustyoz/svg rustyoz/svg v0.0.0-20200706102315-fe1aeca2ba20)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/sabhiram/pngr sabhiram/pngr v0.0.0-20180419043407-2df49b015d4b)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/sergi/go-diff sergi/go-diff v1.0.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/src-d/gcfg src-d/gcfg v1.4.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/therootcompany/xz therootcompany/xz v1.0.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/tklauser/go-sysconf tklauser/go-sysconf v0.3.10)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/tklauser/numcpus tklauser/numcpus v0.4.0)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/ulikunitz/xz ulikunitz/xz v0.5.10)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/xanzy/ssh-agent xanzy/ssh-agent v0.2.1)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/xrash/smetrics xrash/smetrics v0.0.0-20201216005158-039620a65673)
	SRC_URI+=" "$(gen_go_dl_gh_url github.com/yusufpapurcu/wmi yusufpapurcu/wmi v1.2.2)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/image golang/image v0.0.0-20211028202545-6944b10bf410)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/net golang/net v0.0.0-20220624214902-1bab6f366d9e)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/sync golang/sync v0.0.0-20220601150217-0de741cfad7f)
	SRC_URI+=" "$(gen_go_dl_gh_url golang.org/x/text golang/text v0.3.7)
	SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/src-d/go-billy.v4 src-d/go-billy v4.3.2)
	SRC_URI+=" "$(gen_go_dl_gh_url gopkg.in/warnings.v0 go-warnings/warnings v0.1.2)
fi

# These must be inspected and updated on every ebuild update since
# they are live upstream.  No known way to reference them statically.
# The continuous git tag below in gen_binary_uris() changes.
EGIT_COMMIT_STATIC_TOOLS="6e1f76764d334490ddedeb1075a8cd66c270e8e2" # Oct 15, 2022
EGIT_COMMIT_UPLOADTOOL="58f20d2b86197faddd7ffb531a2fab0dad28dedd" # Jul 23, 2022
TAG_AIK="13" # Dec 31, 2020
ZIG_LINUX_PV="0.10.0" # Oct 31, 2022 ; musl 1.2.3 (Apr 7, 2022) from zig programming language project

gen_binary_uris()
{
	local garch="${1}"
	local arch="${2}"
	local zigarch="${3}"
	echo "
		musl? (
			${garch}? (
https://github.com/probonopd/static-tools/releases/download/continuous/appstreamcli-${arch}
	-> static-tools-appstreamcli-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/bsdtar-${arch}
	-> static-tools-bsdtar-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/desktop-file-validate-${arch}
	-> static-tools-desktop-file-validate-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/mksquashfs-${arch}
	-> static-tools-mksquashfs-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/patchelf-${arch}
	-> static-tools-patchelf-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/runtime-fuse2-${arch}
	-> static-tools-runtime-fuse2-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
https://github.com/probonopd/static-tools/releases/download/continuous/unsquashfs-${arch}
	-> static-tools-unsquashfs-${arch}-${EGIT_COMMIT_STATIC_TOOLS:0:7}
			)
		)
		musl? (
			${garch}? (
https://ziglang.org/download/0.10.0/zig-linux-${zigarch}-${ZIG_LINUX_PV}.tar.xz
			)
		)
	"
}

if [[ ${PV} =~ 9999 ]] ; then
	S="${WORKDIR}/${PN}-9999"
elif [[ -z "${GEN_EBUILD}" ]] && ! [[ ${PV} =~ 9999 ]] ; then
	SRC_URI+=" "$(gen_binary_uris amd64 x86_64 x86_64)
	SRC_URI+=" "$(gen_binary_uris x86 i686 i386)
	SRC_URI+=" "$(gen_binary_uris arm armhf armv7a)
	SRC_URI+=" "$(gen_binary_uris amd64 aarch64 aarch64)
	SRC_URI+="
https://raw.githubusercontent.com/probonopd/uploadtool/${EGIT_COMMIT_UPLOADTOOL}/upload.sh
	-> uploadtool-upload.sh-${EGIT_COMMIT_UPLOADTOOL:0:7}
	"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

RESTRICT="mirror"
PATCHES=(
	"A${FILESDIR}/${PN}-0.0.0.20221217121855-gentooize.patch"
)

get_build_sh_arch()
{
	use amd64 && echo "amd64"
	use arm && echo "arm"
	use arm64 && echo "arm64"
	use x86 && echo "386"
}

get_appimage_arch()
{
	use amd64 && echo "x86_64"
	use arm && echo "armhf"
	use arm64 && echo "aarch64"
	use x86 && echo "i686"
}

get_distro_arch()
{
	use amd64 && echo "amd64"
	use arm && echo "arm"
	use arm64 && echo "arm64"
	use x86 && echo "x86"
}

get_zig_arch() {
	use amd64 && echo "x86_64"
	use arm && echo "armv7a"
	use arm64 && echo "aarch64"
	use x86 && echo "i386"
}

pkg_setup() {
	if [[ ${PV} =~ 9999 ]] && has network-sandbox $FEATURES ; then
eerror
eerror "${PN} requires network-sandbox to be disabled in FEATURES in order to"
eerror "download micropackages."
eerror
		die
	fi
	linux-info_pkg_setup
	linux_config_exists
	if ! linux_chkconfig_builtin INOTIFY_USER ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_INOTIFY_USER=y"
ewarn
	fi
	if ! linux_chkconfig_builtin BINFMT_MISC \
		&& ! linux_chkconfig_module BINFMT_MISC ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_BINFMT_MISC=y or"
ewarn "CONFIG_BINFMT_MISC=m"
ewarn
	fi

	local found_appimage_type=0
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ]] \
	&& grep -F -e "enabled" "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type1" ; then
		found_appimage_type=1
eerror
eerror "You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type1"
eerror
		die
	fi
	if [[ -f "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ]] \
	&& grep -F -e "enabled" "${EROOT}/proc/sys/fs/binfmt_misc/appimage-type2" ; then
eerror
eerror "You need to:  echo \"-1\" > /proc/sys/fs/binfmt_misc/appimage-type2"
eerror
		die
	fi

	if [[ "${found_appimage_type}" == "1" ]] ; then
eerror
eerror "See issue: https://github.com/probonopd/go-appimage/issues/7"
eerror
eerror "See also:"
eerror
eerror "https://github.com/probonopd/go-appimage/blob/4ac0e102e05507f43c82beef558d0eedba0e50ae/src/appimaged/prerequisites.go#L216"
eerror "https://www.kernel.org/doc/Documentation/admin-guide/binfmt-misc.rst"
eerror
		die
	fi

	if [[ -f "${EROOT}/usr/bin/AppImageLauncher" ]] ; then
eerror
eerror "AppImageLauncher is not compatible and needs to be uninstalled."
eerror
		die
	fi
	if use firejail ; then
		if ! linux_chkconfig_builtin BLK_DEV_LOOP \
			&& ! linux_chkconfig_module BLK_DEV_LOOP ; then
ewarn
ewarn "You need to change your kernel .config to CONFIG_BLK_DEV_LOOP=y or"
ewarn "CONFIG_BLK_DEV_LOOP=m"
ewarn
			die
		fi
	fi
ewarn
ewarn "This package is a Work In Progress (WIP) upstream."
ewarn
ewarn
ewarn "The appimaged in this package is not production quality and may random"
ewarn "quit at random times.  An auto-restart for this daemon has not been"
ewarn "implemented.  Use the appimaged package instead."
ewarn
	# Server only

	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -d /var/lib/${PN}"
eerror
		die
	fi

	if use musl ; then
ewarn
ewarn "This ebuild may fail when checking checksums since there is no way to"
ewarn "download a specific version/commit or cached older server builds."
ewarn
ewarn "It is recommended to disable the musl USE flag if downloading"
ewarn "is a problem."
ewarn
	fi
	export S_GO="${WORKDIR}/go_build"
}

unpack_go_pkg()
{
	local pkg_name="${1}"
	local uri_frag="${2}"
	local proj_name="${2#*/}"
	local tag="${3}"
	local dest="${S_GO}/src/${pkg_name}"
	local dest_name="${pkg_name//\//-}-${tag//\//-}"
einfo "Unpacking ${dest_name}.tar.gz"
	mkdir -p "${dest}" || die
	tar --strip-components=1 -x -C "${dest}" \
		-f "${DISTDIR}/${dest_name}.tar.gz" || die
}

unpack_go()
{
	unpack_go_pkg github.com/probonopd/go-appimage probonopd/go-appimage ${MY_PV}
	unpack_go_pkg github.com/CalebQ42/squashfs CalebQ42/squashfs v0.6.2
	unpack_go_pkg github.com/acobaugh/osrelease acobaugh/osrelease v0.1.0
	unpack_go_pkg github.com/adrg/xdg adrg/xdg v0.4.0
	unpack_go_pkg github.com/alokmenghrajani/gpgeez alokmenghrajani/gpgeez v0.0.0-20161206084504-1a06f1c582f9
	unpack_go_pkg github.com/coreos/go-systemd/v22 coreos/go-systemd v22.4.0
	unpack_go_pkg github.com/eclipse/paho.mqtt.golang eclipse/paho.mqtt.golang v1.4.1
	unpack_go_pkg github.com/esiqveland/notify esiqveland/notify v0.11.1
	unpack_go_pkg github.com/godbus/dbus/v5 godbus/dbus v5.1.0
	unpack_go_pkg github.com/google/go-github google/go-github v17.0.0+incompatible
	unpack_go_pkg github.com/grandcat/zeroconf grandcat/zeroconf v1.0.0
	unpack_go_pkg github.com/h2non/go-is-svg h2non/go-is-svg v0.0.0-20160927212452-35e8c4b0612c
	unpack_go_pkg github.com/hashicorp/go-version hashicorp/go-version v1.6.0
	unpack_go_pkg github.com/mgord9518/imgconv mgord9518/imgconv v0.0.0-20211227113402-4a8e0ad15713
	unpack_go_pkg github.com/otiai10/copy otiai10/copy v1.7.0
	unpack_go_pkg github.com/probonopd/go-zsyncmake probonopd/go-zsyncmake v0.0.0-20181008012426-5db478ac2be7
	unpack_go_pkg github.com/prometheus/procfs prometheus/procfs v0.8.0
	unpack_go_pkg github.com/rjeczalik/notify rjeczalik/notify v0.9.2
	unpack_go_pkg github.com/sabhiram/png-embed sabhiram/png-embed v0.0.0-20180421025336-149afe9a3ccb
	unpack_go_pkg github.com/shirou/gopsutil shirou/gopsutil v3.21.11+incompatible
	unpack_go_pkg github.com/shuheiktgw/go-travis shuheiktgw/go-travis v0.3.1
	unpack_go_pkg github.com/srwiley/oksvg srwiley/oksvg v0.0.0-20221002174631-3742d547bf3c
	unpack_go_pkg github.com/srwiley/rasterx srwiley/rasterx v0.0.0-20220730225603-2ab79fcdd4ef
	unpack_go_pkg github.com/urfave/cli/v2 urfave/cli v2.17.1
	unpack_go_pkg go.lsp.dev/uri go-language-server/uri v0.3.0
	unpack_go_pkg golang.org/x/crypto golang/crypto v0.0.0-20221005025214-4161e89ecf1b
	unpack_go_pkg golang.org/x/sys golang/sys v0.0.0-20221006211917-84dc82d7e875
	unpack_go_pkg gopkg.in/ini.v1 go-ini/ini v1.67.0
	unpack_go_pkg gopkg.in/src-d/go-git.v4 src-d/go-git v4.13.1
	unpack_go_pkg github.com/cenkalti/backoff cenkalti/backoff v2.2.1+incompatible
	unpack_go_pkg github.com/cpuguy83/go-md2man/v2 cpuguy83/go-md2man v2.0.2
	unpack_go_pkg github.com/emirpasic/gods emirpasic/gods v1.12.0
	unpack_go_pkg github.com/gabriel-vasile/mimetype gabriel-vasile/mimetype v1.4.1
	unpack_go_pkg github.com/go-ole/go-ole go-ole/go-ole v1.2.6
	unpack_go_pkg github.com/google/go-querystring google/go-querystring v0.0.0-20170111101155-53e6ce116135
	unpack_go_pkg github.com/gorilla/websocket gorilla/websocket v1.4.2
	unpack_go_pkg github.com/jbenet/go-context jbenet/go-context v0.0.0-20150711004518-d14ea06fba99
	unpack_go_pkg github.com/kevinburke/ssh_config kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd
	unpack_go_pkg github.com/klauspost/compress klauspost/compress v1.15.9
	unpack_go_pkg github.com/miekg/dns miekg/dns v1.1.27
	unpack_go_pkg github.com/mitchellh/go-homedir mitchellh/go-homedir v1.1.0
	unpack_go_pkg github.com/pierrec/lz4/v4 pierrec/lz4 v4.1.15
	unpack_go_pkg github.com/rasky/go-lzo rasky/go-lzo v0.0.0-20200203143853-96a758eda86e
	unpack_go_pkg github.com/russross/blackfriday/v2 russross/blackfriday v2.1.0
	unpack_go_pkg github.com/rustyoz/Mtransform rustyoz/Mtransform v0.0.0-20190224104252-60c8c35a3681
	unpack_go_pkg github.com/rustyoz/genericlexer rustyoz/genericlexer v0.0.0-20190224115003-eb82fd2987bd
	unpack_go_pkg github.com/rustyoz/svg rustyoz/svg v0.0.0-20200706102315-fe1aeca2ba20
	unpack_go_pkg github.com/sabhiram/pngr sabhiram/pngr v0.0.0-20180419043407-2df49b015d4b
	unpack_go_pkg github.com/sergi/go-diff sergi/go-diff v1.0.0
	unpack_go_pkg github.com/src-d/gcfg src-d/gcfg v1.4.0
	unpack_go_pkg github.com/therootcompany/xz therootcompany/xz v1.0.1
	unpack_go_pkg github.com/tklauser/go-sysconf tklauser/go-sysconf v0.3.10
	unpack_go_pkg github.com/tklauser/numcpus tklauser/numcpus v0.4.0
	unpack_go_pkg github.com/ulikunitz/xz ulikunitz/xz v0.5.10
	unpack_go_pkg github.com/xanzy/ssh-agent xanzy/ssh-agent v0.2.1
	unpack_go_pkg github.com/xrash/smetrics xrash/smetrics v0.0.0-20201216005158-039620a65673
	unpack_go_pkg github.com/yusufpapurcu/wmi yusufpapurcu/wmi v1.2.2
	unpack_go_pkg golang.org/x/image golang/image v0.0.0-20211028202545-6944b10bf410
	unpack_go_pkg golang.org/x/net golang/net v0.0.0-20220624214902-1bab6f366d9e
	unpack_go_pkg golang.org/x/sync golang/sync v0.0.0-20220601150217-0de741cfad7f
	unpack_go_pkg golang.org/x/text golang/text v0.3.7
	unpack_go_pkg gopkg.in/src-d/go-billy.v4 src-d/go-billy v4.3.2
	unpack_go_pkg gopkg.in/warnings.v0 go-warnings/warnings v0.1.2
}

get_col3() {
	local uri="${1}"
	local ver="${2}"
	if [[ "${uri}" =~ "github.com/probonopd/${PN}" ]] ; then
		echo "\${MY_PV}"
	else
		echo "${ver}"
	fi
}

get_col2_unpack() {
	local uri="${1}"
	unset REPO_URI_FRAG
	declare -A REPO_URI_FRAG=(
		# RVALUE Based on GH URI fragment as in org/project
		["golang.org/x/crypto"]="golang/crypto"
		["golang.org/x/image"]="golang/image"
		["golang.org/x/net"]="golang/net"
		["golang.org/x/sys"]="golang/sys"
		["golang.org/x/text"]="golang/text"
		["golang.org/x/sync"]="golang/sync"
		["go.lsp.dev/uri"]="go-language-server/uri"
		["gopkg.in/ini.v1"]="go-ini/ini"
		["gopkg.in/src-d/go-billy.v4"]="src-d/go-billy"
		["gopkg.in/src-d/go-git.v4"]="src-d/go-git"
		["gopkg.in/warnings.v0"]="go-warnings/warnings"
	)
	if [[ "${uri}" =~ "github.com/" ]] ; then
		echo "${uri}" | cut -f 2-3 -d "/"
	else
		local t="${REPO_URI_FRAG[${uri}]}"
		if [[ -z "${t}" ]] ; then
eerror "Missing get_col2_unpack() entry for ${uri}"
			die
		else
			echo "${t}"
		fi
	fi
}

generate_ebuild_snapshot() {
	wget -q -O "${T}/go.mod" https://raw.githubusercontent.com/probonopd/${PN}/${EGIT_COMMIT}/go.mod
	IFS=$'\n'
	L=(
		"github.com/probonopd/${PN} MY_PV"
		$(grep -E "/" "${T}/go.mod" | sed -e "1d" | sed -e "s|// indirect.*||g")
	)


einfo
einfo "Replace SRC_URI section:"
einfo
	for row in ${L[@]} ; do
		local c1=$(echo "${row}" | cut -f 1 -d " " | sed -E -e "s|[[:space:]]+||g")
		local c2=$(get_col2_unpack "${c1}")
		local ver=$(echo "${row}" | cut -f 2 -d " ")
		local c3=$(get_col3 "${c1}" "${ver}")
echo -e "\tSRC_URI+=\" \"\$(gen_go_dl_gh_url ${c1} ${c2} ${c3})"
	done

einfo
einfo "Replace unpack_go section:"
einfo
	for row in ${L[@]} ; do
		local c1=$(echo "${row}" | cut -f 1 -d " " | sed -E -e "s|[[:space:]]+||g")
		local c2=$(get_col2_unpack "${c1}")
		local ver=$(echo "${row}" | cut -f 2 -d " ")
		local c3=$(get_col3 "${c1}" "${ver}")
echo -e "\tunpack_go_pkg ${c1} ${c2} ${c3}"
	done
	IFS=$' \t\n'
einfo
einfo "Please update the ebuild with the following above information."
einfo
	die
}

verify_build_files() {
	local actual_build_files_fingerprint=$(sha512sum \
		$(find "${S_GO}" -name "go.mod" | sort) \
		| cut -f 1 -d " " \
		| sha512sum \
		| cut -f 1 -d " ")
	local expected_build_files_fingerprint="\
4f042a42e57b632d4ca72a6bf435813f4601f24d1a3f971eae6d30f9313b63e0\
403d847e7b0381033dd2f60d30329979a363a91ac99f0fd78085328c8dcaaaa6\
"
	if [[ "${actual_build_files_fingerprint}" != "${expected_build_files_fingerprint}" ]] ; then
eerror
eerror "A change in the build files has been detected."
eerror "These changes may affect the LICENSE, IUSE, *DEPENDs."
eerror
eerror "Expected build files fingerprint:\t${expected_build_files_fingerprint}"
eerror "Actual build files fingerprint:\t${actual_build_files_fingerprint}"
eerror
eerror "Use the fallback-commit USE flag to continue."
eerror
		die
	fi
}

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die

	[[ "${GEN_EBUILD}" == "1" ]] && generate_ebuild_snapshot

	if [[ ${PV} =~ 9999 ]] ; then
		if use fallback-commit ; then
			export EGIT_COMMIT="09fd0186774aefa2351c42b4bb22f92ce0c4f235"

	 # See the header Date: field for obtaining this.
			export EGIT_COMMIT_TIMESTAMP="Wed, 20 Dec 2023 22:55:40 +0100"
		fi
		EGIT_REPO_URI="https://github.com/probonopd/${PN}.git"
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${S_GO}/src/github.com/probonopd/${PN}"
		git-r3_fetch
		git-r3_checkout
		if ! use fallback-commit ; then
			#verify_build_files
			export EGIT_COMMIT=$(git ls-remote \
				https://github.com/probonopd/go-appimage.git \
                                | grep HEAD \
				| cut -c 1-40)
			export EGIT_COMMIT_TIMESTAMP=$(wget -q -O - \
				https://github.com/probonopd/go-appimage/commit/${EGIT_COMMIT}.patch \
				| grep "^Date:" \
				| head -n 1 \
				| cut -f 2- -d " ")
		fi

		wget -O "${DISTDIR}/uploadtool-upload.sh" "https://github.com/probonopd/uploadtool/raw/master/upload.sh"
	else
		unpack_go
	fi

	# go_build/src/github.com/probonopd/go-appimage/scripts/build.sh
	export S="${S_GO}/src/github.com/probonopd/${PN}"
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
	if [[ "${GO_APPIMAGE_DISABLE_WATCHDOG_DOWNLOADS_FOLDER:-1}" == "1" ]] ; then
		export USE_DISABLE_WATCHING_DOWNLOADS_FOLDER=1
	fi
	if [[ "${GO_APPIMAGE_DISABLE_WATCHDOG_DESKTOP_FOLDER:-1}" == "1" ]] ; then
		export USE_DISABLE_WATCHING_DESKTOP_FOLDER=1
	fi
	if ! use musl ; then
		if use elibc_glibc ; then
			export STATIC_TOOLS_LIBC="glibc"
		else
			export STATIC_TOOLS_LIBC="native"
		fi
		export GET_LIBDIR=$(get_libdir)
	else
		export STATIC_TOOLS_LIBC="musl" # Natively built.
		#export STATIC_TOOLS_LIBC="upstream-musl" # Prebuilt from upstream
	fi
	export EGIT_COMMIT_STATIC_TOOLS
	export EGIT_COMMIT_UPLOADTOOL
	export DISTDIR
	export EGIT_COMMIT
	export TAG_AIK
	export TRAVIS_BUILD_DIR="${S}"
}

_apply_patches() {
	eapply "${FILESDIR}/${PN}-9999_p20200829-skip-livecd-check.patch"
	eapply "${FILESDIR}/${PN}-9999_p20200829-skip-binfmt-checks.patch"
	eapply "${FILESDIR}/${PN}-9999_p20200829-git-root-envvar.patch"
	eapply "${FILESDIR}/${PN}-0.0.0.20221217121855-check-systemd-installed.patch"
#	eapply "${FILESDIR}/${PN}-0.0.0.20221217121855-skip-watching-mountpoints-not-owned.patch"
	eapply "${FILESDIR}/${PN}-9999_p20231220-add-watch-opt-appimage.patch"
	if [[ "${USE_DISABLE_WATCHING_DOWNLOADS_FOLDER}" == "1" ]] ; then
		echo "Modding appimaged.d (for disable_watching_download_folder USE flag)"
		sed -i -e "/xdg.UserDirs.Download/d" "src/appimaged/appimaged.go"
	fi
	if [[ "${USE_DISABLE_WATCHING_DESKTOP_FOLDER}" == "1" ]] ; then
		echo "Modding appimaged.d (for disable_watching_desktop_folder USE flag)"
		sed -i -e "/xdg.UserDirs.Desktop/d" "src/appimaged/appimaged.go"
	fi
}

src_prepare() {
	# Fork to add patches
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"

	cd "${WORKDIR}" || die

	BASE_LOCATIONS=(
		"${S_GO}/src/github.com/probonopd/${PN}"
	)

	for b in ${BASE_LOCATIONS[@]} ; do
		pushd "${b}" || die
			_apply_patches
		popd
	done
}

src_compile() {
	einfo "DISTDIR=${DISTDIR}"
	use amd64 && export GARCH="amd64"
	use x86 && export GARCH="x86"
	use arm64 && export GARCH="arm64"
	use arm && export GARCH="arm"
	use musl && export FORCE_MUSL="1"
	export GO_APPIMAGE_PV="${MY_PV}"
	export GOPATH="${WORKDIR}/go_build"
	export GO111MODULE=auto
	local args=()
	if ! [[ ${PV} =~ 9999 ]] ; then
		args+=(
			-o "${WORKDIR}/go_build/src"
		)
	fi
	cd "${S}" || die
	"${S}/scripts/build.sh" -dc ${args[@]} || die
}

src_install() {
	local ai_arch=$(get_appimage_arch)
	exeinto /usr/bin
	if [[ ${PV} =~ 9999 ]] ; then
		BUILD_DIR="${S_GO}/build"
	else
		BUILD_DIR="${S_GO}/src"
	fi
	# No support for multi go yet the other is false
	# Gentoo's Go is not multilib that's why.
	local timestamp=$(basename $(realpath "${BUILD_DIR}/appimaged-*-${ai_arch}.AppImage") \
		| cut -f 2-4 -d "-")
	local appimaged_fn="appimaged-${timestamp}-${ai_arch}.AppImage"
	local appimagetool_fn="appimagetool-${timestamp}-${ai_arch}.AppImage"
	local mkappimage_fn="mkappimage-${timestamp}-${ai_arch}.AppImage"
	doexe "${BUILD_DIR}/${appimaged_fn}"
	dosym ../../../usr/bin/${appimaged_fn} /usr/bin/appimaged
	doexe "${BUILD_DIR}/${appimagetool_fn}"
	dosym ../../../usr/bin/${appimagetool_fn} /usr/bin/appimagetool
	doexe "${BUILD_DIR}/${mkappimage_fn}"
	dosym ../../../usr/bin/${mkappimage_fn} /usr/bin/mkappimage
	LCNR_SOURCE="${BUILD_DIR}"
	lcnr_install_files
	docinto readme
	dodoc "${S}/README.md"
	cp \
		"${S}/src/appimaged/README.md" \
		"${T}/appimaged-README.md" \
		|| die
	cp \
		"${S}/src/appimagetool/README.md" \
		"${T}/appimagetool-README.md" \
		|| die
	dodoc "${T}/appimaged-README.md"
	dodoc "${T}/appimagetool-README.md"
}

pkg_postinst() {
einfo
einfo "You must run appimaged as non-root to generate the systemd service files"
einfo "in ~/."
einfo
einfo "You must \`systemctl --user enable appimaged\` inside the user account"
einfo "to add the service on login."
einfo
einfo "You can \`systemctl --user start appimaged\` to start it now."
einfo
einfo
einfo "The appimaged daemon will randomly quit when watching files and needs to"
einfo "be restarted."
einfo
einfo "The user may need to be added to the \"disk\" group in order for"
einfo "firejail rules to work."
einfo
einfo
einfo "SECURITY NOTICE:"
einfo
einfo "Do not download/run AppImages from untrusted sites."
einfo "Do not download/run AppImages with End of Life (EOL) libraries."
einfo "Do not download/run AppImages with critical vulnerabilities."
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
