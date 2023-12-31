# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake git-r3 multilib-minimal python-any-r1

DESCRIPTION="Function order shuffling to defend against ROP and other types of code reuse"
HOMEPAGE="https://github.com/immunant/selfrando"
LICENSE="AGPL-3+ BSD"
#KEYWORDS="~arm ~arm64 ~amd64 ~x86" # Live ebuilds (or snapshots) do not get KEYWORDS
SLOT="0"
IUSE+=" doc +gold"
CDEPEND="
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	sys-devel/gcc[cxx(+)]
	virtual/libc
	gold? (
		sys-devel/binutils[gold,plugins]
	)
"
DEPEND+="
	${CDEPEND}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${CDEPEND}
	>=dev-libs/elfutils-0.176[static-libs,${MULTILIB_USEDEP}]
	>=dev-util/cmake-3.3
	>=dev-util/pkgconf-0.29.1[${MULTILIB_USEDEP},pkg-config(+)]
	>=dev-vcs/git-2.25.1
	>=sys-devel/m4-1.4.18
	>=sys-devel/make-4.2.1
	>=virtual/libelf-3
	dev-python/future
"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="mirror"
EXPECTED_BUILD_FINGERPRINT="\
34d5dd4c2f2fcd708ca826714e1a4bc0fc331ae48d20883c47d0a2fca62fb413\
20f00fd42c2232881b8532530fa8ccfdabed6e30107a082ee5c9f300155c1f68"

src_unpack() {
	export EGIT_BRANCH="master"
	export EGIT_REPO_URI="https://github.com/runsafesecurity/selfrando.git"
	git-r3_fetch
	git-r3_checkout
	actual_build_fingerprint=$(cat \
		$(find . -name "*.cmake" -o -name "CMakeLists.txt" | sort) \
			| sha512sum \
			| cut -f 1 -d " ")
	if [[ "${actual_build_fingerprint}" != "${EXPECTED_BUILD_FINGERPRINT}" ]] ; then
eerror
eerror "New build changes"
eerror
eerror "Expected build files fingerprint:  ${actual_build_fingerprint}"
eerror "Actual build files fingerprint:  ${EXPECTED_BUILD_FINGERPRINT}"
eerror
eerror "QA:  Review the IUSE, *DEPENDs for changes"
eerror
		die
	fi
}

src_prepare() {
	local x
	for x in $(find . -name "*.py") ; do
		if ! grep -q "python3" "${x}" ; then
			futurize -0 -v -w "${x}" || die
		else
einfo "${x} is already python3"
		fi
		if grep -q "python2.7" "${x}" ; then
einfo "${x} python2.7 -> python"
			sed -i -e "s|python2.7|python|g" "${x}" || die
		fi
	done
	cmake_src_prepare
}

src_configure() {
	configure_abi() {
		[[ "${ABI}" == "amd64" ]] && export SR_ARCH="x86_64"
		[[ "${ABI}" == "arm" ]] && export SR_ARCH="arm"
		[[ "${ABI}" == "arm64" ]] && export SR_ARCH="arm64"
		[[ "${ABI}" == "x86" ]] && export SR_ARCH="x86"
		local mycmakeargs=(
			-DCMAKE_BUILD_TYPE=Release
			-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}/usr/lib/${PN}"
			-DSR_ARCH=${SR_ARCH}
			-DSR_BUILD_LIBELF=0
			-DSR_DEBUG_LEVEL=env
			-DSR_FORCE_INPLACE=1
			-DSR_LOG=console
			-G "Unix Makefiles"
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
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
