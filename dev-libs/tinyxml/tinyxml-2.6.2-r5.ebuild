# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)

inherit flag-o-matic libstdcxx-slot toolchain-funcs multilib

DESCRIPTION="Simple and small C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="debug doc static-libs +stl"

BDEPEND="doc? ( app-text/doxygen )"

S="${WORKDIR}/${PN}"

DOCS=( "changes.txt" "readme.txt" )

pkg_setup() {
	libstdcxx-slot_verify
}

src_prepare() {
	local major_v=$(ver_cut 1)
	local minor_v=$(ver_cut 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
		-e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-3 > Makefile || die

	eapply -p0 "${FILESDIR}"/${PN}-2.6.1-entity.patch
	eapply -p0 "${FILESDIR}"/${PN}.pc.patch
	eapply "${FILESDIR}"/${P}-CVE-2021-42260.patch

	use debug && append-cppflags -DDEBUG
	use stl && eapply "${FILESDIR}"/${P}-defineSTL.patch

	sed -e "s:/lib:/$(get_libdir):g" -i tinyxml.pc || die # bug 738948
	if use stl; then
		sed -e "s/Cflags: -I\${includedir}/Cflags: -I\${includedir} -DTIXML_USE_STL=YES/g" -i tinyxml.pc || die
	fi

	if ! use static-libs; then
		sed -e "/^all:/s/\$(name).a //" -i Makefile || die
	fi

	tc-export AR CXX RANLIB

	[[ ${CHOST} == *-darwin* ]] && export LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	eapply_user
}

src_install() {
	dolib.so *$(get_libname)*

	insinto /usr/include
	doins *.h

	insinto /usr/share/pkgconfig
	doins tinyxml.pc

	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r docs/*
	fi
}
