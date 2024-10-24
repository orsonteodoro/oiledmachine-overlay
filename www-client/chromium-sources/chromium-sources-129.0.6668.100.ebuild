# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dhms

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV}.tar.xz
"

DESCRIPTION="Chromium sources"
HOMEPAGE="https://www.chromium.org/"
LICENSE="
	chromium-$(ver_cut 1-3 ${PV}).x.html
"
RESTRICT="binchecks mirror strip test"
SLOT="0/${PV}"
IUSE+=" ebuild-revision-3"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

pkg_setup() {
	dhms_start
}

src_unpack() {
	unpack ${A}
}

# _method0() {
# Completion time:  0 days, 6 hrs, 46 mins, 52 secs
# Reasons for slowdown:
# 1. Output in console
# 2. cp -aT
# 3. scanelf
# 4. write to /var/db/pkg/.../CONTENTS
# 5. md5sum for each file for CONTENTS
# }

_method1() {
	rm -rf "/usr/share/chromium/sources"
	mkdir -p "/usr/share/chromium/sources"
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/chromium-${PV}/"* "/usr/share/chromium/sources" || die
	mv "${WORKDIR}/chromium-${PV}/."* "/usr/share/chromium/sources" || true
# Completion time:  0 days, 0 hrs, 26 mins, 22 secs
}

src_install() {
	addwrite "/usr/share/chromium/sources"
	_method1
}

pkg_postinst() {
	dhms_end
ewarn "When emerge runs after the speedup changes it will wipe some files.  Please re-emerge again."
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/sources"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
