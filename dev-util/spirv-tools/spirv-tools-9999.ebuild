# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="SPIRV-Tools"
INTERNAL_SPIRV_HEADERS_SLOT="1.6.7" # See https://github.com/KhronosGroup/SPIRV-Headers/blob/main/include/spirv/unified1/spirv.core.grammar.json#L12

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CXX_STANDARD=17
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-util/spirv-headers-9999"
)

inherit cflags-hardened chkl cmake-multilib libcxx-slot libstdcxx-slot secure-version python-any-r1

if [[ "${PV}" == *"9999"* ]]; then
	FALLBACK_COMMIT="a665e21f3061f34064b39937cf00fe8d8769f4ef"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	EGIT_COMMIT="vulkan-sdk-${PV}"
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86"
	S="${WORKDIR}"/${MY_PN}-${EGIT_COMMIT}
fi

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE+="
test
ebuild_revision_1
"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-util/spirv-headers-${SPIRV_HEADERS_PV}:=
	|| (
		dev-util/spirv-headers:0/${INTERNAL_SPIRV_HEADERS_SLOT}
	)
"
# RDEPEND=""
BDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == *"9999"* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local p="/usr/include/spirv/unified1/spirv.core.grammar.json"
	local spirv_headers_pv_c1=$(grep "major_version" "${p}" | grep -E -o -e "[0-9]+")
	local spirv_headers_pv_c2=$(grep "minor_version" "${p}" | grep -E -o -e "[0-9]+")
	local spirv_headers_pv_c3=$(grep "revision" "${p}" | grep -E -o -e "[0-9]+")
	local actual_spirv_headers_pv="${spirv_headers_pv_c1}.${spirv_headers_pv_c2}.${spirv_headers_pv_c3}"
	local expected_spirv_headers_pv="${INTERNAL_SPIRV_HEADERS_SLOT}"
	if ver_test "${actual_spirv_headers_slot}" "-ne" "${expected_spirv_headers_slot}" ; then
eerror "QA:  The slot spirv-headers is inconsistent with this release."
eerror "Actual spirv-headers slot:  ${actual_spirv_headers_slot}"
eerror "Expected spirv-headers slot:  ${expected_spirv_headers_slot}"
eerror "Use the fallback-commit USE flag or update the spirv-headers header package."
		die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		-DSPIRV-Headers_SOURCE_DIR="${ESYSROOT}"/usr/
		-DSPIRV_WERROR=OFF
		-DSPIRV_SKIP_TESTS=$(usex !test)
		-DSPIRV_TOOLS_BUILD_STATIC=OFF
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	)

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# Not relevant for us downstream
		spirv-tools-copyrights
		# Tests fail upon finding symbols that do not match a regular expression
		# in the generated library. Easily hit with non-standard compiler flags
		spirv-tools-symbol-exports.*
	)

	multilib-minimal_src_test
}
