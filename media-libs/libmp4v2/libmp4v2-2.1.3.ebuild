# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/lib}"
PYTHON_COMPAT=( python3_{10..11} )
inherit autotools libtool multilib-minimal python-any-r1

DESCRIPTION="A C/C++ library to create, modify and read MP4 files"
HOMEPAGE="
https://mp4v2.org/
https://github.com/enzo1982/mp4v2
"
SRC_URI="
https://github.com/enzo1982/mp4v2/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

LICENSE="MPL-1.1"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="doc static-libs test utils"
REQUIRED_USE="
	test? (
		utils
	)
"

BDEPEND="
	sys-apps/sed
	doc? (
		app-doc/doxygen
		sys-apps/help2man
		sys-apps/texinfo
	)
	test? (
		dev-util/dejagnu
	)
	utils? (
		sys-apps/help2man
	)
"

DOCS=( README )

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-unsigned-int-cast.patch"
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/mp4v2/project.h
)

pkg_setup() {
	use doc && python_setup
}

src_prepare() {
	# Make it static to avoid Header checksum mismatch, aborting.
	eautoreconf
	sed -i -e "s|PROJECT_build=\"\`date\`\"|PROJECT_build=\"$(date)\"|" configure || die
	default
	elibtoolize
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--disable-gch \
		$(use_enable utils util) \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	emake
	multilib_is_native_abi && use doc && emake doc
}

multilib_src_test() {
	make check || die
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	if multilib_is_native_abi && use doc ; then
		HTML_DOCS+=(
			"${WORKDIR}/${MY_P}-${MULTIBUILD_VARIANT}/doc/api"
			"${WORKDIR}/${MY_P}-${MULTIBUILD_VARIANT}/doc/articles/html"
			"${WORKDIR}/${MY_P}-${MULTIBUILD_VARIANT}/doc/doxygen"
			"${WORKDIR}/${MY_P}-${MULTIBUILD_VARIANT}/doc/html"
			"${WORKDIR}/${MY_P}-${MULTIBUILD_VARIANT}/doc/site"
		)
		einstalldocs
		docinto texi
		dodoc -r doc/texi/*
		docinto txt
		dodoc doc/articles/txt/*
		if use utils ; then
			doman doc/man/man1/{mp4art,mp4chaps,mp4file,mp4subtitle,mp4tags,mp4track}.1
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multiabi, enable tests
