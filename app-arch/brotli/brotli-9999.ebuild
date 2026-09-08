# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO IU"
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )
SO_CURRENT=3
SO_AGE=2

inherit cflags-hardened cmake-multilib distutils-r1 flag-o-matic

if [[ ${PV} == *9999* ]] ; then
	FALLBACK_COMMIT="4508218e7fef90fa4273286f7a415065946f2c43"
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
	SRC_URI="
		https://github.com/google/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
fi

DESCRIPTION="Generic-purpose lossless compression algorithm"
HOMEPAGE="https://github.com/google/brotli/"

LICENSE="MIT python? ( Apache-2.0 )"
SOVER=$(( ${SO_CURRENT} - ${SO_AGE} )) # The distro formula is wrong.
SLOT="0/${SOVER}"
IUSE+="
python test
ebuild_revision_1
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
	)
"

DOCS=( README.md CONTRIBUTING.md )

src_unpack() {
	if [[ ${PV} == *9999* ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local c=$(grep -E -e "BROTLI_ABI_CURRENT" "${S}/c/common/version.h" | head -n 1 | sed -E -e "s|[ ]+| |g" | cut -f 3 -d " ")
	local a=$(grep -E -e "BROTLI_ABI_AGE" "${S}/c/common/version.h" | head -n 1 | sed -E -e "s|[ ]+| |g" | cut -f 3 -d " ")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SO_CURRENT, SO_AGE"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

src_configure() {
	cflags-hardened_append
	append-lfs-flags

	cmake-multilib_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake-multilib_src_compile
	use python && distutils-r1_src_compile
}

python_test() {
	eunittest -s python -p "*_test.py"
}

src_test() {
	cmake-multilib_src_test
	use python && distutils-r1_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	use python && distutils-r1_src_install

	doman docs/brotli.1

	local page
	for page in constants decode encode types ; do
		newman docs/${page}.h.3 ${PN}_${page}.h.3
	done

	dosym -r /usr/bin/brotli /usr/bin/brcat
	dosym -r /usr/bin/brotli /usr/bin/unbrotli
	dosym -r /usr/share/man/man1/brotli.1 /usr/share/man/man1/brcat.1
	dosym -r /usr/share/man/man1/brotli.1 /usr/share/man/man1/unbrotli.1
}
