# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot

DESCRIPTION="Small, safe and fast formatting library"
HOMEPAGE="https://fmt.dev/dev/ https://github.com/fmtlib/fmt"

if [[ ${PV} == *9999 ]] ; then
	INTERNAL_VERSION="12.2.1" # See https://github.com/fmtlib/fmt/blob/main/include/fmt/base.h
	SOVER=$(ver_cut "1" "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="e27cc20bd93a4e280fb9268d41cd131069a9c73f"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/fmtlib/fmt.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${PN}-${PV}"
	inherit git-r3
else
	SOVER=$(ver_cut "1" "${PV}")
	SRC_URI="https://github.com/fmtlib/fmt/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/fmt-${PV}"
fi

LICENSE="MIT"
SLOT="0/${SOVER}"
IUSE+="
test
ebuild_revision_1
"
RESTRICT="!test? ( test )"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -e "FMT_VERSION" "${S}/include/fmt/base.h" | head -n 1 | cut -f 3 -d " " | cut -c "1-2")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update PV or INTERNAL_VERSION"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

multilib_src_configure() {
	append-lfs-flags
	local mycmakeargs=(
		-DFMT_CMAKE_DIR="$(get_libdir)/cmake/fmt"
		-DFMT_LIB_DIR="$(get_libdir)"
		-DFMT_TEST=$(usex test)
	)
	cmake_src_configure
}
