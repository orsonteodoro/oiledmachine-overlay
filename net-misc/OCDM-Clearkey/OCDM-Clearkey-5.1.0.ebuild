# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/OCDM-Clearkey.git"
	FALLBACK_COMMIT="5b671d82ee3c66fd995101e1f9124dc8506d550f" # Sep 30, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/OCDM-Clearkey/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="ClearKey OpenCDM(i) plugin"
HOMEPAGE="
	https://github.com/rdkcentral/OCDM-Clearkey
"
LICENSE="
	Apache-2.0
	BSD-2
	BSD
	MIT
	ZLIB
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
-optee-aes-decryptor
ebuild-revision-1
"
RDEPEND+="
	~net-libs/Thunder-${PV}
	~net-misc/ThunderInterfaces-${PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=()

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DOPTEE_AES_DECRYPTOR=$(usex optee-aes-decryptor)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "NOTICE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD