# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 134.0.6998.88 -> 135.0.7049.84
# 135.0.7049.84 -> 135.0.7049.114
# 135.0.7049.114 -> 136.0.7103.59
# 136.0.7103.59 -> 136.0.7103.92
# 136.0.7103.92 -> 137.0.7151.55
# 137.0.7151.68 -> 138.0.7204.49

MY_PV="chromium-${PV}"

TARBALL_FLAVOR="lite" # full or lite

# For lite versus full tarball see:
# https://github.com/OSSystems/meta-browser/issues/763
# https://groups.google.com/a/chromium.org/g/chromium-packagers/c/oE60kVFFMyQ/m/T26AJMc7AgAJ
# Added dirs:   https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.py;l=291
# Pruned dirs:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipe_modules/chromium/resources/export_tarball.py;l=28
# Pruned list:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.expected/basic.json

# The lite prunes the following:
# .git folders
# Build tools and source code (closure-compiler, llvm, node, rust)
# Debian sysroots
# Debug libraries
# NaCl
# Proprietary platform support
# Testing support (apache-linux, blink web tests, test samples, fuzzing data)

inherit dhms

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
# https://gsdview.appspot.com/chromium-browser-official/?marker=chromium-137.0.7151.0.tar.x%40
# https://commondatastorage.googleapis.com/chromium-browser-official/chromium-137.0.7151.55.tar.xz
if [[ "${TARBALL_FLAVOR}" == "lite" ]] ; then
	SRC_URI="
https://gsdview.appspot.com/chromium-browser-official/chromium-${PV}-lite.tar.xz
	"
else
	SRC_URI="
https://gsdview.appspot.com/chromium-browser-official/chromium-${PV}.tar.xz
	"
fi

DESCRIPTION="Chromium sources"
HOMEPAGE="https://www.chromium.org/"
LICENSE="
	chromium-$(ver_cut 1-3 ${PV}).x.html
"
RESTRICT="binchecks mirror strip test"
SLOT="0/${PV}"
IUSE+=" ebuild_revision_4"
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
	mv $(find "${WORKDIR}/chromium-${PV}/" -maxdepth 1 -name ".*" -type f) "/usr/share/chromium/sources" || die
# Completion time:  0 days, 0 hrs, 26 mins, 22 secs
}

src_install() {
	keepdir "/usr/share/chromium/sources"
	addwrite "/usr/share/chromium/sources"
	_method1
}

pkg_postinst() {
	dhms_end
ewarn "When emerge runs after the speedup changes it will wipe some files.  Please re-emerge again."
	local count=$(find "/usr/share/chromium/sources/" -type f | wc -l)
	echo "${count}" > "/usr/share/chromium/sources/file-count"
einfo "Files merged:"
	find "/usr/share/chromium/sources"
einfo "QA:  Update chromium ebuild with sources_count_expected=${count}"
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/usr/share/chromium/sources"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
