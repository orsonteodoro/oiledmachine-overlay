# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( "python3_"{8..11} )
EXPECTED_BUILD_FINGERPRINT="\
34d5dd4c2f2fcd708ca826714e1a4bc0fc331ae48d20883c47d0a2fca62fb413\
20f00fd42c2232881b8532530fa8ccfdabed6e30107a082ee5c9f300155c1f68"

inherit check-compiler-switch cmake flag-o-matic git-r3 python-any-r1 sandbox-changes

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/clayne/selfrando.git"
	FALLBACK_COMMIT="fe47bc08cf420edfdad44a967b601f29ebfed4d9"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	KEYWORDS="~arm64 ~amd64"
	SRC_URI="
	"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="Function order shuffling to defend against ROP and other types of code reuse"
HOMEPAGE="https://github.com/immunant/selfrando"
LICENSE="
	AGPL-1
	AGPL-3+
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	custom
	ISC
	SunPro
"
# AGPL-1 - LICENSE
# AGPL-3+ - src/RandoLib/posix/util/rand_linux.cpp
# Apache-2.0 BSD BSD-2 BSD-4 custom ISC SunPro  - src/RandoLib/posix/bionic/NOTICE
#   custom keywords: "You may redistribute unmodified or modified versions of this source"
#   custom keywords: "To the extent it has a right to do so,"
RESTRICT="mirror"
SLOT="0"
IUSE+=" doc test"
CDEPEND="
	>=sys-libs/zlib-1.2.11
	sys-devel/gcc[cxx(+)]
	virtual/libc
"
DEPEND+="
	${CDEPEND}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_any_dep '
		dev-python/future[${PYTHON_USEDEP}]
	')
	${CDEPEND}
	>=dev-libs/elfutils-0.176[static-libs]
	>=dev-build/cmake-3.3
	>=dev-util/pkgconf-0.29.1[pkg-config(+)]
	>=dev-vcs/git-2.25.1
	>=sys-devel/m4-1.4.18
	>=dev-build/make-4.2.1
	>=virtual/libelf-3
"
PATCHES=(
	"${FILESDIR}/${PN}-fe47bc0-scons-print.patch"
	"${FILESDIR}/${PN}-fe47bc0-test-machine-path.patch"
	"${FILESDIR}/${PN}-fe47bc0-https-test.patch"
#	"${FILESDIR}/${PN}-fe47bc0-nginx-apply-ngx_user-fix.patch"
	"${FILESDIR}/${PN}-fe47bc0-nginx-1.27.1.patch"
	"${FILESDIR}/${PN}-fe47bc0-nginx-fPIC.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
}

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
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

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
	if use test ; then
	# TODO:  verify that this can be removed.
		sandbox-changes_no_network_sandbox "To be able to use USE=test"
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
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	[[ "${ARCH}" == "amd64" ]] && export SR_ARCH="x86_64"
	[[ "${ARCH}" == "arm" ]] && die "64-bit only supported"
	[[ "${ARCH}" == "arm64" ]] && export SR_ARCH="arm64"
	[[ "${ARCH}" == "x86" ]] && die "64-bit only supported"
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

src_test() {
	[[ "${ARCH}" == "amd64" ]] && export SR_ARCH="x86_64"
	[[ "${ARCH}" == "arm64" ]] && export SR_ARCH="arm64"

	append-cppflags -Wno-error=array-parameter

	sh "scripts/build_libelf.sh" "${PWD}/libelf" || die
	export DEBUG_LEVEL=0
	scons -Q arch="x86_64" LIBELF_PATH="${PWD}/libelf/libelf-prefix" FORCE_INPLACE=1 DEBUG_LEVEL=env || die
	if [[ "${TESTS_THTTPD:-1}" == "1" ]] ; then
		tests/posix/thttpd.sh || die
	fi
	if [[ "${TESTS_LUA:-1}" == "1" ]] ; then
		tests/posix/lua.sh || die
	fi
	if [[ "${TESTS_NGINX:-1}" == "1" ]] ; then
	append-cppflags -fPIC
		tests/posix/nginx.sh || die
	fi
}

src_install() {
	[[ "${ARCH}" == "amd64" ]] && export SR_ARCH="x86_64"
	[[ "${ARCH}" == "arm64" ]] && export SR_ARCH="arm64"
	cmake_src_install

	docinto "licenses"
	dodoc "LICENSE"
	docinto "."
	if use doc ; then
		dodoc -r "docs"
		dodoc "selfrando-vs-aslr.png"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
