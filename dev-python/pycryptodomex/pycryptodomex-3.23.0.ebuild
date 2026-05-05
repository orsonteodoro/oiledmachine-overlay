# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Both pycryptodomex and pycryptodome are the same but only by one file with .separate_namespace in pycryptodomex.
# The ebuild offered for those that don't want to patch.

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 ) # Upstream supports up to 3.13, but 3.14 is allowed for gnome-extra/secrets
PYTHON_REQ_USE="threads(+)"
S="${WORKDIR}/pycryptodome-${PV}x"

inherit cflags-hardened distutils-r1

DESCRIPTION="A self-contained cryptographic library for Python (Cryptodome namespace)"
HOMEPAGE="
	https://www.pycryptodome.org/
	https://github.com/Legrandin/pycryptodome/tree/pycryptodomex
	https://pypi.org/project/pycryptodomex/
"
SRC_URI="
	https://github.com/Legrandin/pycryptodome/archive/refs/tags/v${PV}x.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2 Unlicense"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

DEPEND="
	dev-libs/gmp:=
	>=dev-libs/libtomcrypt-1.18.2-r1:=
"
BDEPEND="
	$(python_gen_cond_dep 'dev-python/cffi[${PYTHON_USEDEP}]' 'python*')
"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

PATCHES=(
	"${FILESDIR}/pycryptodome-3.10.1-system-libtomcrypt.patch"
)

python_prepare_all() {
	# make sure we're unbundling it correctly
	rm -r src/libtom || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cflags-hardened_append
}

python_test() {
	local -x PYTHONPATH=${S}/test_vectors:${PYTHONPATH}
	"${EPYTHON}" - <<-EOF || die
		import sys
		from Crypto import SelfTest
		SelfTest.run(verbosity=2, stream=sys.stdout)
	EOF

	# TODO: run cmake tests from src/test?
}
