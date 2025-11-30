# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CXX_STANDARD=20
CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( "python3_12" )
VULKAN_PV="1.3.275.0"

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_6[@]}"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit check-compiler-switch cmake dep-prepare flag-o-matic libcxx-slot libstdcxx-slot python-single-r1 toolchain-funcs xdg

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
ebuild_revision_8
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		wayland
		X
	)
"
RDEPEND+="
	>=media-libs/vulkan-loader-${VULKAN_PV}
	dev-qt/qttools:6[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},linguist,qml,widgets]
	dev-qt/qttools:=
	dev-qt/qtbase:6[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},gui,widgets,wayland?,X?]
	dev-qt/qtbase:=
	~media-video/video2x-6.2.0:0/stable[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS},${PYTHON_SINGLE_USEDEP}]
	media-video/video2x:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-${VULKAN_PV}
	dev-util/vulkan-headers:=
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
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
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

src_configure() {
	# Force GCC to simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	append-flags "-DSPDLOG_NO_EXCEPTIONS"
	append-flags "-I${S}_build/libvideo2x_install/include"

	ffmpeg_src_configure

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
