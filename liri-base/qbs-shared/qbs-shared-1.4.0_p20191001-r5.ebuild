# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils git-r3

DESCRIPTION="Shared imports and modules for projects using the qbs build system"
HOMEPAGE="https://github.com/lirios/qbs-shared"
LICENSE="BSD"

# Live/snapshots do not get KEYWORDed

SLOT="0/$(ver_cut 1-3 ${PV})"
# Upstream requires qbs 1.11 in README, but qbs file requires 1.10
# If building qbs fails with 1.12, try with 1.15 which works.
BDEPEND+=" >=dev-util/qbs-1.11"
SRC_URI=""
EGIT_BRANCH="develop"
EGIT_REPO_URI="https://github.com/lirios/${PN}.git"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
QBS_CONFIG=( --settings-dir "${S}/qbs-config" )
PROPERTIES="live"

# Based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=liri-qbs-shared-git

pkg_setup() {
	"${EROOT}/usr/bin/qbs" list-products 2>&1 | grep -q -F -e "Cannot mix incompatible"
	if [[ "$?" == "0" ]] ; then
		die "Re-emerge dev-util/qbs"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	local v_live=$(grep -r -e "VERSION \"" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d "\"")
	local v_expected=$(ver_cut 1-3 ${PV})
	if ver_test ${v_expected} -ne ${v_live} ; then
		eerror
		eerror "Version bump required."
		eerror
		eerror "v_expected=${v_expected}"
		eerror "v_live=${v_live}"
		eerror
		die
	else
		einfo
		einfo "v_expected=${v_expected}"
		einfo "v_live=${v_live}"
		einfo
	fi
}

src_compile() {
	qbs setup-toolchains ${QBS_CONFIG[@]} --type gcc /usr/bin/g++ gcc || die
	qbs setup-qt ${QBS_CONFIG[@]} /usr/bin/qmake qt5 || die
	qbs config ${QBS_CONFIG[@]} profiles.qt5.baseProfile gcc || die
	qbs build ${QBS_CONFIG[@]} -d build --no-install  -v \
		config:release \
		installPrefix:/ \
		profile:qt5 \
		project.prefix:/usr/share/qbs \
		project.qbsModulesDir:/usr/share/qbs/modules \
		project.qbsImportsDir:/usr/share/qbs/imports \
		|| die
}

src_install() {
	qbs install ${QBS_CONFIG[@]} -d build --no-build -v \
		--install-root "${ED}" \
		config:release \
		profile:qt5 \
		|| die
	docinto licenses
	dodoc LICENSE.BSD
}
