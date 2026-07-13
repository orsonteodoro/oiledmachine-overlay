# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BOR BU CE DF DOS HO IO NPD OOBR OOBW SO TA UM"

PYTHON_COMPAT=( python3_{10..14} )

inherit cflags-hardened cmake flag-o-matic multilib-minimal python-any-r1 secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="068ff080b369adfac81509f9b57b2afabaf82dc5"
	EGIT_BRANCH="mbedtls-3.6"
	EGIT_REPO_URI="https://github.com/Mbed-TLS/mbedtls.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	SRC_URI="https://github.com/Mbed-TLS/mbedtls/releases/download/${P}/${P}.tar.bz2"
fi

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="https://www.trustedfirmware.org/projects/mbed-tls/"

LICENSE="|| ( Apache-2.0 GPL-2+ )"
MBEDCRYPTO_SOVER="16"
MBEDTLS_SOVER="21"
MBEDX509_SOVER="7"
SLOT_MAJOR="${PV%%.*}"
SLOT="${SLOT_MAJOR}/${MBEDCRYPTO_SOVER}.${MBEDTLS_SOVER}.${MBEDX509_SOVER}" # ffmpeg subslot naming: SONAME tuple of {libmbedcrypto.so,libmbedtls.so,libmbedx509.so}
IUSE+=" cpu_flags_x86_sse2 doc programs static-libs test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	programs? (
		!net-libs/mbedtls:0[programs]
		!net-libs/mbedtls:4[programs]
	)
"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	test? ( >=dev-lang/perl-${PERL_PV} )
"

PATCHES=(
	"${FILESDIR}/mbedtls-3.6.7-allow-install-headers-to-different-location.patch"
	"${FILESDIR}/mbedtls-3.6.7-add-version-suffix-for-all-installable-targets.patch"
	"${FILESDIR}/mbedtls-3.6.2-add-version-suffix-for-pkg-config-files.patch"
	"${FILESDIR}/mbedtls-3.6.2-exclude-static-3dparty.patch"
	"${FILESDIR}/mbedtls-3.6.7-slotted-version.patch"
)

enable_mbedtls_option() {
	local myopt="$@"
	# check that config.h syntax is the same at version bump
	sed -i \
		-e "s://#define ${myopt}:#define ${myopt}:" \
		include/mbedtls/mbedtls_config.h || die
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover
	local expected_sover

	actual_sover=$(grep -r -e "mbedcrypto_target.*SOVER" "${S}/library/CMakeLists.txt" | grep -o -E -e "SOVERSION [0-9]+" | cut -f 2 -d " ")
	expected_sover="${MBEDCRYPTO_SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update MBEDCRYPTO_SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi

	actual_sover=$(grep -r -e "mbedtls_target.*SOVER" "${S}/library/CMakeLists.txt" | grep -o -E -e "SOVERSION [0-9]+" | cut -f 2 -d " ")
	expected_sover="${MBEDTLS_SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update MBEDTLS_SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi

	actual_sover=$(grep -r -e "mbedx509_target.*SOVER" "${S}/library/CMakeLists.txt" | grep -o -E -e "SOVERSION [0-9]+" | cut -f 2 -d " ")
	expected_sover="${MBEDX509_SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update MBEDX509_SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	use cpu_flags_x86_sse2 && enable_mbedtls_option MBEDTLS_HAVE_SSE2
	use threads && enable_mbedtls_option MBEDTLS_THREADING_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_PTHREAD

	# Changes minimum CMake version.
	sed -i -e "s:VERSION 3.5.1:VERSION 3.10:g" CMakeLists.txt || die

	cmake_src_prepare
}

multilib_src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DENABLE_PROGRAMS=$(multilib_native_usex programs)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_SLOTTED_VERSION=ON
		-DINSTALL_MBEDTLS_HEADERS=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/mbedtls${SLOT_MAJOR}"
		-DLINK_WITH_PTHREAD=$(usex threads)
		-DMBEDTLS_FATAL_WARNINGS=OFF # Don't use -Werror, #744946
		-DUSE_SHARED_MBEDTLS_LIBRARY=ON
		-DUSE_STATIC_MBEDTLS_LIBRARY=$(usex static-libs)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	use doc && multilib_is_native_abi && emake -C "${S}" apidoc
}

multilib_src_test() {
	# Disable parallel run, bug #718390
	# https://github.com/Mbed-TLS/mbedtls/issues/4980
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}/library" \
		cmake_src_test -j1
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( apidoc )

	einstalldocs

	if use programs ; then
		# avoid file collisions with sys-apps/coreutils
		local p e
		for p in "${ED}"/usr/bin/* ; do
			if [[ -x "${p}" && ! -d "${p}" ]] ; then
				mv "${p}" "${ED}"/usr/bin/mbedtls_${p##*/} || die
			fi
		done
		for e in aes hash pkey ssl test ; do
			docinto "${e}"
			dodoc programs/"${e}"/*.c
			dodoc programs/"${e}"/*.txt
		done
	fi
}
