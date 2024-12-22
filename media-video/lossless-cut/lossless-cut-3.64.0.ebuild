# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="31.3.1"
NPM_AUDIT_FIX=0
NODE_VERSION="20"
YARN_LOCKFILE_SOURCE="ebuild"
YARN_SLOT=8

inherit electron-app yarn

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mifi/lossless-cut.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
$(electron-app_gen_electron_uris)
https://github.com/mifi/lossless-cut/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="The swiss army knife of lossless video/audio editing"
HOMEPAGE="
	https://github.com/mifi/lossless-cut
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=sys-apps/yarn-4:${YARN_SLOT}
"
DOCS=( "README.md" )

pkg_setup() {
	yarn_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
#		unpack ${A}
		touch "${HOME}/.yarnrc"
		yarn_src_unpack
	fi
}

src_compile() {
	yarn_hydrate
	yarn --version || die
	electron-app_cp_electron
	eyarn icon-gen
	electron-vite build || die
	electron-builder --linux || die
	die "lol"
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
