# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Shared imports and modules for projects using the qbs build system"
HOMEPAGE="https://github.com/lirios/qbs-shared"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
# Upstream requires qbs 1.11 in README, but qbs file requires 1.10
# If building qbs fails with 1.12, try with 1.15 which works.
BDEPEND+=" >=dev-util/qbs-1.11"
EGIT_COMMIT="c176452261a562a8f319fe068bd635adbdce141b"
SRC_URI=\
"https://github.com/lirios/qbs-shared/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
QBS_CONFIG=( --settings-dir "${S}/qbs-config" )

# Based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=liri-qbs-shared-git

pkg_setup() {
	"${EROOT}/usr/bin/qbs" list-products 2>&1 | grep -q -F -e "Cannot mix incompatible"
	if [[ "$?" == "0" ]] ; then
		die "Re-emerge dev-util/qbs"
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
