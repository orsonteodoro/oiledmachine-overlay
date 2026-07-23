# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-libs/libffi-9999"
	"dev-libs/pugixml-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="7d935bb54674aa0fbd327d2a6888bd0630079ed0"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprwire.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
fi

DESCRIPTION="A fast and consistent wire protocol for IPC"
HOMEPAGE="https://github.com/hyprwm/hyprwire"
LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SOVER="3"
SLOT="0/${SOVER}"
IUSE="
test
ebuild_revision_1
"
RDEPEND="
	>=dev-libs/libffi-${LIBFFI_PV}:=
	>=dev-libs/pugixml-${PUGIXML_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=gui-libs/hyprutils-0.11.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=x11-libs/pixman-${PIXMAN_PV}:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.19
	dev-cpp/gtest[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	dev-cpp/gtest:=
	virtual/pkgconfig
"
DOCS=( "README.md" )

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
	local actual_sover=$(grep -z -o -E "SOVERSION[[:space:]]+[0-9]+" "${S}/CMakeLists.txt" | grep -z -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
