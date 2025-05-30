# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CMAKE_MAKEFILE_GENERATOR="emake"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
PYTHON_COMPAT=( "python3_12" )

inherit cmake dep-prepare flag-o-matic python-single-r1 toolchain-funcs xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/k4yt3x/video2x-qt6.git"
	FALLBACK_COMMIT="d074be2f4bf96efbcb1b0becddfbea2aa822a1ba" # Dec 11, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/k4yt3x/video2x-qt6/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An AI video upscaler with a graphical user friendly Qt6 frontend"
HOMEPAGE="
	https://github.com/k4yt3x/video2x-qt6
"
LICENSE="
	ISC
"
# ISC - video2x-qt6
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
wayland X
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
RDEPEND+="
	>=media-libs/vulkan-loader-1.3.275.0
	dev-qt/qttools:6[linguist,qml,widgets]
	dev-qt/qttools:=
	dev-qt/qtbase:6[gui,widgets,wayland?,X?]
	dev-qt/qtbase:=
	~media-video/video2x-6.2.0:0/stable[${PYTHON_SINGLE_USEDEP}]
	media-video/video2x:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-1.3.275.0
"
BDEPEND+="
	>=dev-build/cmake-3.14
	dev-vcs/git
	sys-devel/gcc[openmp]
	virtual/pkgconfig
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-system-video2x.patch"
)

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e "1i #define _strdup strdup" \
		"src/mainwindow.cpp" \
		|| die
	sed -i \
		-e "s|libplacebo_config|libplaceboConfig|g" \
		"src/taskconfigdialog.cpp" \
		|| die
}

check_cxxabi() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local libstdcxx_cxxabi_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local libstdcxx_glibcxx_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_cxxabi_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_glibcxx_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	if ver_test ${libstdcxx_cxxabi_ver} -lt ${qt6core_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol."
eerror
eerror "Ensure that the qt6core was build with the same gcc version as the"
eerror "currently selected compiler."
eerror
eerror "libstdcxx CXXABI  - ${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "libstdcxx GLIBCXX - ${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "qt6core CXXABI    - ${qt6core_cxxabi_ver}"
eerror "qt6core GLIBCXX   - ${qt6core_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi
}

src_configure() {
	# Force GCC to simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	check_cxxabi

	append-flags -DSPDLOG_NO_EXCEPTIONS
	append-flags -I"${S}_build/libvideo2x_install/include"

	if has_version "media-video/ffmpeg:58.60.60" ; then
einfo "Using media-video/ffmpeg:58.60.60"
		PKG_CONFIG_PATH="/usr/lib/ffmpeg/58.60.60/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	else
einfo "Using media-video/ffmpeg:0/58.60.60"
	fi

	local mycmakeargs=(
		-DUSE_SYSTEM_VIDEO2X=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
ewarn
ewarn "Some broken videos may need to be fixed first by manually encoding"
ewarn "as ffv1 in a mkv container before upscaling.  For examples, see"
ewarn "https://github.com/k4yt3x/video2x/issues/1222#issuecomment-2466489582"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (6.2.0, 20241213)
# realesr-animevideov3 - passed
# realesrgan-plus - passed
# libplacebo - passed
