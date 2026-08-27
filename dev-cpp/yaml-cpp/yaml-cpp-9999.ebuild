# Copyright 1999-2026 Gentoo Authors
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

inherit cmake-multilib libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_PV="0.9.0"
	SOVER=$(ver_cut "1-2" "${INTERNAL_PV}")
	FALLBACK_COMMIT="e5fe9f2cddbd1a9a8b423bbe40cca661aec6208a"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/jbeder/yaml-cpp.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
	S="${WORKDIR}/${PN}-${PV}"
else
	SOVER=$(ver_cut "1-2" "${PV}")
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://github.com/jbeder/yaml-cpp/archive/refs/tags/${P}.tar.gz"
	S="${WORKDIR}/yaml-cpp-${P}"
fi

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"

LICENSE="MIT"
SLOT="0/${SOVER}"
IUSE+=" test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/yaml-cpp-0.9.0-cxxstd.patch"
)

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
	local actual_sover=$(grep -e "project(YAML_CPP" "${S}/CMakeLists.txt" | cut -f 3 -d " " | cut -f 1-2 -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump SOVER"
eerror "Actual sover:  ${actual_sover}"
eerror "Expected sover:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	rm -r test/googletest-* || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
		-DYAML_USE_SYSTEM_GTEST=ON
		-DYAML_CPP_FORMAT_SOURCE=OFF
	)

	cmake-multilib_src_configure
}
