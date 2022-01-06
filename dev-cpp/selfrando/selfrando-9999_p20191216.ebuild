# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake multilib-minimal python-any-r1

DESCRIPTION="Function order shuffling to defend against ROP and other types of code reuse"
HOMEPAGE="https://github.com/immunant/selfrando"
LICENSE="AGPL-3+ BSD"
#KEYWORDS="~arm ~arm64 ~amd64 ~x86" # Live ebuilds (or snapshots) do not get KEYWORDS
SLOT="0"
IUSE+=" doc +gold"
CDEPEND=" >=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	  sys-devel/gcc[cxx(+)]
	  virtual/libc
	  gold? ( sys-devel/binutils[gold,plugins] )"
DEPEND+=" ${CDEPEND}"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	>=dev-libs/elfutils-0.176[static-libs,${MULTILIB_USEDEP}]
	>=dev-util/cmake-3.3
	>=dev-util/pkgconf-0.29.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-vcs/git-2.25.1
	>=sys-devel/m4-1.4.18
	>=sys-devel/make-4.2.1
	>=virtual/libelf-3
"
EGIT_COMMIT="fe47bc08cf420edfdad44a967b601f29ebfed4d9"
SRC_URI="
https://github.com/immunant/selfrando/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup()
{
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	configure_abi() {
		[[ "${ABI}" == "amd64" ]] && export SR_ARCH="x86_64"
		[[ "${ABI}" == "arm" ]] && export SR_ARCH="arm"
		[[ "${ABI}" == "arm64" ]] && export SR_ARCH="arm64"
		[[ "${ABI}" == "x86" ]] && export SR_ARCH="x86"
		local mycmakeargs=(
			-DSR_DEBUG_LEVEL=env
			-DCMAKE_BUILD_TYPE=Release
			-DSR_BUILD_LIBELF=0
			-DSR_ARCH=${SR_ARCH}
			-DSR_LOG=console
			-DSR_FORCE_INPLACE=1 -G "Unix Makefiles"
			-DCMAKE_INSTALL_PREFIX:PATH=/usr/lib/${PN}
		)
		cmake_src_configure
	}
	multilib_foreach_abi configure_abi

}

src_install() {
	install_abi() {
		[[ "${ABI}" == "amd64" ]] && export SR_ARCH="x86_64"
		[[ "${ABI}" == "arm" ]] && export SR_ARCH="arm"
		[[ "${ABI}" == "arm64" ]] && export SR_ARCH="arm64"
		[[ "${ABI}" == "x86" ]] && export SR_ARCH="x86"
		cmake_src_install
	}
	multilib_foreach_abi install_abi
	if ! use gold ; then
		find "${ED}" -name "ld.gold" -delete
	fi
	docinto licenses
	dodoc LICENSE "${FILESDIR}/LICENSE.BSD"
	docinto .
	if use doc ; then
		dodoc -r docs
		dodoc selfrando-vs-aslr.png
	fi
}
