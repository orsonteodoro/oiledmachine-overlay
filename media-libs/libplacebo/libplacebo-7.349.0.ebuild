# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=20
PYTHON_COMPAT=( "python3_"{10..13} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}"
)

inherit libcxx-slot libstdcxx-slot meson-multilib python-any-r1

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/libplacebo.git"
	inherit git-r3
else
	FASTFLOAT_PV="5.2.0"
	GLAD_PV="2.0.4"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
	SRC_URI="
https://code.videolan.org/videolan/libplacebo/-/archive/v${PV}/libplacebo-v${PV}.tar.bz2
https://github.com/fastfloat/fast_float/archive/refs/tags/v${FASTFLOAT_PV}.tar.gz
	-> fast_float-${FASTFLOAT_PV}.tar.gz
opengl? (
	https://github.com/Dav1dde/glad/archive/refs/tags/v${GLAD_PV}.tar.gz
		-> ${PN}-glad-${GLAD_PV}.tar.gz
	)
https://github.com/haasn/libplacebo/commit/056b852018db04aa2ebc0982e27713afcea8106b.patch
	-> libplacebo-056b852-commit.patch
	"
fi

DESCRIPTION="Reusable library for GPU-accelerated image processing primitives"
HOMEPAGE="
	https://libplacebo.org/
	https://code.videolan.org/videolan/libplacebo/
"
LICENSE="
	LGPL-2.1+
	|| (
		Apache-2.0
		Boost-1.0
		MIT
	)
	opengl? (
		MIT
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/"$(ver_cut "2" "${PV}.9999") # soname
IUSE="
glslang +lcms libdovi llvm-libunwind +opengl +shaderc test unwind +vulkan
+xxhash
"
REQUIRED_USE="
	vulkan? (
		shaderc
	)
"

# dlopen: libglvnd (glad)
RDEPEND="
	lcms? (
		>=media-libs/lcms-2.9:2[${MULTILIB_USEDEP}]
	)
	libdovi? (
		>=media-libs/libdovi-1.6.7[${MULTILIB_USEDEP}]
		media-libs/libdovi:=
	)
	opengl? (
		media-libs/libglvnd[${MULTILIB_USEDEP}]
	)
	shaderc? (
		>=media-libs/shaderc-2019.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		media-libs/shaderc:=
	)
	unwind? (
		!llvm-libunwind? (
			sys-libs/libunwind[${MULTILIB_USEDEP}]
			sys-libs/libunwind:=
		)
		llvm-libunwind? (
			llvm-runtimes/libunwind[${MULTILIB_USEDEP}]
		)
	)
	vulkan? (
		media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	)
"
# vulkan-headers is required even with USE=-vulkan for the stub (bug #882065)
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
	xxhash? (
		dev-libs/xxhash[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-5.229.1-llvm-libunwind.patch"
	"${DISTDIR}/libplacebo-056b852-commit.patch"
)

python_check_deps() {
	python_has_version "dev-python/jinja2[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		local EGIT_SUBMODULES=(
			"3rdparty/fast_float"
			$(usev opengl "3rdparty/glad")
		)
		git-r3_src_unpack
	else
		default

		rmdir "${S}/3rdparty/fast_float" || die
		mv \
			"fast_float-${FASTFLOAT_PV}" \
			"${S}/3rdparty/fast_float" \
			|| die

		if use opengl ; then
			rmdir "${S}/3rdparty/glad" || die
			mv \
				"glad-${GLAD_PV}" \
				"${S}/3rdparty/glad" \
				|| die
		fi
	fi
}

src_prepare() {
	default
	# Typically, these are auto-skipped.   It may assume a usable
	# opengl/vulkan; then, it hangs.
	sed -i \
		-e "/tests += 'opengl_surfaceless.c'/d" \
		"src/opengl/meson.build" \
		|| die
	sed -i \
		-e "/tests += 'vulkan.c'/d" \
		"src/vulkan/meson.build" \
		|| die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature glslang)
		$(meson_feature lcms)
		$(meson_feature libdovi)
		$(meson_feature opengl)
		$(meson_feature opengl gl-proc-addr)
		$(meson_feature shaderc)
		$(meson_feature unwind)
		$(meson_feature vulkan)
		$(meson_feature vulkan vk-proc-addr)
		$(meson_feature xxhash)
		$(meson_use test tests)
		-Ddemos=false #851927
		-Dvulkan-registry="${ESYSROOT}/usr/share/vulkan/registry/vk.xml"
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
	# Prevent vulkan from leaking into the .pc here for now.  (bug #951125)
	if ! use vulkan && has_version "media-libs/vulkan-loader" ; then
		sed -E \
			-i \
			-e '/^Requires/s/vulkan[^,]*,? ?//;s/, $//;/^Requires[^:]*: $/d' \
			"${ED}/usr/$(get_libdir)/pkgconfig/libplacebo.pc" \
			|| die
	fi
}
