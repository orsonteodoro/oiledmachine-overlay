# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

inherit toolchain-funcs multilib-minimal

S="${WORKDIR}/${PN}-${PN}-v${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

DESCRIPTION="Audio processing system for plugins to extract information from audio data"
HOMEPAGE="https://www.vamp-plugins.org"
SRC_URI="https://github.com/c4dm/${PN}/archive/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE="doc"
RDEPEND="
	media-libs/libsndfile:0[${MULTILIB_USEDEP}]
	media-libs/libsndfile:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
	)
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	MAKEOPTS+=" -j1" # bug #943866

	# Multilib for default search paths
	local libdir=$(get_libdir)
	sed -i \
		-e "s:/usr/lib/vamp:${EPREFIX}/usr/${libdir}/vamp:" \
		"src/vamp-hostsdk/PluginHostAdapter.cpp" \
		|| die
	econf
}

multilib_src_compile() {
	emake \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"

	if multilib_is_native_abi && use doc; then
		cd "build" || die
		doxygen || die "creating doxygen doc failed"
		HTML_DOCS=( "${BUILD_DIR}/build/doc/html/." )
	fi
}

multilib_src_install() {
	local libdir=$(get_libdir)
	emake \
		DESTDIR="${D}" \
		INSTALL_SDK_LIBS="${EPREFIX}/usr/${libdir}" \
		INSTALL_PKGCONFIG="${EPREFIX}/usr/${libdir}/pkgconfig" \
		INSTALL_PLUGINS="${EPREFIX}/usr/${libdir}/vamp" \
		install

	# Fix .pc files
	sed -Ei "s/lib$/${libdir}/g" "${D}/usr/${libdir}/pkgconfig/"*".pc" || die
}

multilib_src_install_all() {
	einstalldocs

	# We don't want static archives, #474768
	find "${D}" -name '*.a' -delete || die
}

pkg_postinst() {
elog "See media-plugins/vamp-* for Vamp plugins."
}
