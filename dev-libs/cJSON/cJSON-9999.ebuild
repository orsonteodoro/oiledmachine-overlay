# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO UAF"

inherit cflags-hardened cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="c859b25da02955fef659d658b8f324b5cde87be3"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/DaveGamble/cJSON.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
https://github.com/DaveGamble/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Ultralightweight JSON parser in ANSI C"
HOMEPAGE="https://github.com/DaveGamble/cJSON"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="
test
ebuild_revision_23
"
PATCHES=(
	"${FILESDIR}/${PN}-6d9f244-cmake4.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

}

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e '/-Werror/d' \
		"CMakeLists.txt" \
		|| die
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DENABLE_CJSON_TEST=$(usex test)
	)
	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (1.17.17, 20250503)
# test-suite:  passed
