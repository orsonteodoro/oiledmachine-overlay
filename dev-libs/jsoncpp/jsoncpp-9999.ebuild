# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=11
PYTHON_COMPAT=( "python3_"{10..14} )

inherit cflags-hardened libcxx-slot libstdcxx-slot meson-multilib python-any-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="edc01ab10f52135ec80e3589b6b4e0a9c65b27fd"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/open-source-parsers/jsoncpp.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	if [[ ${PV} != *_rc* ]]; then
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
	fi
	SRC_URI="
https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz
	-> ${P/_/-}.tar.gz
	"
fi

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp/"

LICENSE="
	|| (
		public-domain
		MIT
	)
"
SOVER="27"
SLOT="0/${SOVER}"
IUSE+="
doc test
ebuild_revision_9
"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
	)
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
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
	local actual_sover=$(grep -r -e "PROJECT_SOVERSION" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump the SOVER in the ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		# Follow Debian, Ubuntu, Arch convention for headers location
		# bug #452234
		--includedir "include/jsoncpp"
		-Dtests=$(usex test true false)
	)
	meson_src_configure
}

src_compile() {
	meson-multilib_src_compile

	if use doc ; then
		echo "${PV}" > version || die
		"${EPYTHON}" doxybuild.py --doxygen="${EPREFIX}/usr/bin/doxygen" || die
		HTML_DOCS=( dist/doxygen/jsoncpp*/. )
	fi
}

multilib_src_test() {
	# increase test timeout due to failures on slower hardware
	meson_src_test -t 2
}

multilib_src_install() {
	meson_install
	# https://bugs.gentoo.org/941642
	rm -r "${ED}/usr/$(get_libdir)/cmake" || die
}
