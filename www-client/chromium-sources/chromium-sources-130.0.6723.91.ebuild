# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dhms

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
# The URI for 130.0.6723.91 came from the distro chromium ebuild.
# I don't personally like when the distro passes out tarballs.
SRC_URI="
	https://chromium-tarballs.syd1.cdn.digitaloceanspaces.com/chromium-${PV}.tar.xz
"
#	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV}.tar.xz

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
ewarn
ewarn "Distro message:"
ewarn
ewarn "  This uses a gentoo-created tarball due to Google CI Failures."
ewarn "  Use 132 as a base for new official tarballs."
ewarn
ewarn
ewarn "Ebuild developer message:"
ewarn
ewarn "The domain chromium-tarballs.syd1.cdn.digitaloceanspaces.com is doubious and not an official domain."
ewarn "The URI in question is https://chromium-tarballs.syd1.cdn.digitaloceanspaces.com/chromium-${PV}.tar.xz"
ewarn "The URI was obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-client/chromium/chromium-130.0.6723.91.ebuild#n37"
ewarn "The URI was accepted and displayed by the distro."
ewarn
ewarn "Options"
ewarn
ewarn "(1) Press Control C to cancel and wait for the official URI on the next release cycle."
ewarn "(2) Wait 60 seconds to continue to allow to download and merge."
ewarn
	sleep 60
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
	#mv "${WORKDIR}/chromium-${PV}/."* "/usr/share/chromium/sources" || true
# Completion time:  0 days, 0 hrs, 26 mins, 22 secs
}

src_install() {
	addwrite "/usr/share/chromium/sources"
	_method1
}

pkg_postinst() {
	dhms_end
ewarn "When emerge runs after the speedup changes it will wipe some files.  Please re-emerge again."
	local count=$(find "/usr/share/chromium/sources/" -type f | wc -l)
einfo "QA:  Update chromium ebuild with sources_count_expected=${count}"
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/sources"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
