# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"
MY_P="${MY_PN}_${PV}"

CXX_STANDARD=17 # Compiler default

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit flag-o-matic toolchain-funcs libcxx-slot libstdcxx-slot portability multilib-minimal

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://www.ladspa.org/download/${MY_P}.tgz"
DESCRIPTION="The Linux Audio Developer's Simple Plugin API"
HOMEPAGE="https://www.ladspa.org/"
LICENSE="LGPL-2.1"
SLOT="0"
RDEPEND="
	media-libs/libsndfile[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}/${P}-properbuild.patch"
)

HTML_DOCS="doc/*.html"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# bug #911262
	append-lfs-flags
}

multilib_src_compile() {
	emake -C src \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		DYNAMIC_LD_LIBS="$(dlopen_lib)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		targets
}

multilib_src_test() {
	emake -C src test
}

multilib_src_install() {
	emake -C src \
		INSTALL_PLUGINS_DIR="/usr/$(get_libdir)/ladspa" \
		DESTDIR="${ED}" \
		MKDIR_P="mkdir -p" \
		install
}

multilib_src_install_all() {
	einstalldocs

	# Needed for apps like rezound
	dodir "/etc/env.d"
	echo "LADSPA_PATH=${EPREFIX}/usr/$(get_libdir)/ladspa" > "${ED}/etc/env.d/60ladspa"
}
