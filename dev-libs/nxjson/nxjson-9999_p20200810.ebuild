# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Very small JSON parser written in C."
HOMEPAGE="https://github.com/yarosla/nxjson"
LICENSE="LGPL-3+"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc \
~ppc64 ~riscv ~ppc-macos ~s390 ~sh ~sparc ~x64-macos ~x86 ~x86-macos"
# based on libtool versoning on linux
LIBRARY_CURRENT=0 # inc if interface changed
LIBRARY_AGE=0 # inc if backwards compatible LIBRARY_CURRENT, else 0
LIBRARY_REVISION=0 # increment with package version releases
SO_SUFFIX=$((${LIBRARY_CURRENT}-${LIBRARY_AGE}))
LIBRARY_SUFFIX="${SO_SUFFIX}.${LIBRARY_AGE}.${LIBRARY_REVISION}"
SO_NAME="libnxjson.${SO_SUFFIX}"
SLOT="${SO_SUFFIX}/${PV}"
IUSE="static test"
EGIT_COMMIT="d7445b645b0c05f862db8fa02848fd898c4c238c"
SRC_URI=\
"https://github.com/yarosla/nxjson/archive/${GIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
inherit eutils multilib-minimal toolchain-funcs
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/nxjson-9999.20141019-create-libs.patch" )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	local mycflags="-O0"
	local arch_cflags="CFLAGS_${ABI}"
	sed -i \
		-e "s|libnxjson.so|libnxjson.so.${LIBRARY_SUFFIX}|" \
		Makefile ||die
	sed -i -e "s|gcc|$(tc-getCC) ${!arch_cflags}|" Makefile || die
	#sed -i -e "s|-shared|-shared -Wl,-soname,${SO_NAME}|" Makefile || die
	emake || die
}

multilib_src_test() {
	if use test ; then
		nxjson || die
	fi
}

multilib_src_install() {
	dolib.so libnxjson.so.${LIBRARY_SUFFIX}
	pushd "${D}"/usr/$(get_libdir)/
		ln -s libnxjson.so.${LIBRARY_SUFFIX} \
			libnxjson.so || die
		ln -s libnxjson.so.${LIBRARY_SUFFIX} \
			libnxjson.so.${SO_SUFFIX} || die
		ln -s libnxjson.so.${LIBRARY_SUFFIX} \
			libnxjson.so.${SO_SUFFIX}.${LIBRARY_AGE} || die
	popd
	if use static ; then
		dolib.a libnxjson.a
	fi
	insinto /usr/include
	doins nxjson.h
}
