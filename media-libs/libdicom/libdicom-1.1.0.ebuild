# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="UAF"

inherit cflags-hardened meson

if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ImagingDataCommons/libdicom"
else
	SRC_URI="
https://github.com/ImagingDataCommons/libdicom/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="C library for reading DICOM files"
HOMEPAGE="
	https://libdicom.readthedocs.io/
	https://github.com/ImagingDataCommons/libdicom
"
LICENSE="MIT"
SLOT="0"
IUSE="
test
ebuild_revision_7
"
RDEPEND="
	dev-libs/uthash
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/meson-0.50
"

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_use test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	find "${D}" -name "*.la" -type f -delete || die
	einstalldocs
}
