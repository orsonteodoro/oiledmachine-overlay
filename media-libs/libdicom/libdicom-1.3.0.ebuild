# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="UAF"

inherit cflags-hardened meson

if [[ "${PV}" == *"9999"* ]]; then
	INTERNAL_VERSION="1.3.0"
	SUBSLOT=$(ver_cut "1" "${INTERNAL_VERSION}")
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ImagingDataCommons/libdicom"
else
	SUBSLOT=$(ver_cut "1" "${PV}")
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
SLOT="0/${SUBSLOT}"
IUSE="
test
ebuild_revision_18
"
RDEPEND="
	dev-libs/uthash:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/meson-0.50
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

	local actual_subslot=$(grep -E "abi_version_major = [0-9]+" "${S}/meson.build" | cut -f 3 -d " ")
	local expected_subslot="${SUBSLOT}"
#einfo "Actual subslot:  ${actual_subslot}"
#einfo "Expected subslot:  ${expected_subslot}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "Bump INTERNAL_VERSION, PV"
eerror "Actual subslot:  ${actual_subslot}"
eerror "Expected subslot:  ${expected_subslot}"
		die
	fi
}

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
