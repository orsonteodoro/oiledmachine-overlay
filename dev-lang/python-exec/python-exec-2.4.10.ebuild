# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#
# If you ctrl+c during `emerge -ve @system` with upstream's version of python-exec ebuild, it will break the entire toolchain for noobs.
# It is a availability vulnerability.
# People should not be touching _PYTHON_ALL_IMPLS or it should be removed.
#
# Fixes:
# ebuild: no python-exec wrapped executable found in /usr/lib/python-exec.
# To manually unbreak it, see https://forums.gentoo.org/viewtopic-t-1163258-start-0.html
#

PYTHON_COMPAT=( "python3_"{10..13} "pypy3" "pypy3_11" )

inherit python-any-r1

SRC_URI="https://github.com/projg2/python-exec/releases/download/v${PV}/${P}.tar.bz2"

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://github.com/projg2/python-exec/"
LICENSE="BSD-2"
SLOT="2"
KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
# Internal Python project hack.  Do not copy it.  Ever.
IUSE="${PYTHON_COMPAT[@]/#/python_targets_} +native-symlinks test"
RESTRICT="
	!test? ( test )
"

RDEPEND="
	!<=dev-lang/python-2.7.18-r3:2.7
	dev-lang/python-exec-conf
"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local pyimpls=() i EPYTHON
	local i
	for i in "${PYTHON_COMPAT[@]}"; do
		EPYTHON="${i/_/.}"
		pyimpls+=( "${EPYTHON}" )
	done

	einfo "pyimpls:  ${pyimpls[*]}"

	local myconf=(
		--with-fallback-path="${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin"
		--with-python-impls="${pyimpls[*]}"
	)

	econf "${myconf[@]}"
}

src_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	default
}

src_install() {
	default

	if use native-symlinks; then
		local programs=(
			"python"
			"python3"
		)
		local scripts=(
			"python-config"
			"python3-config"
			"2to3"
			"idle"
			"pydoc"
			"pyvenv"
		)

		local f
		for f in "${programs[@]}"; do
	# symlink the C wrapper for python to avoid shebang recursion
	# bug #568974
			dosym python-exec2c "/usr/bin/${f}"
		done
		for f in "${scripts[@]}"; do
	# those are python scripts (except for new python-configs)
	# so symlink them via the python wrapper
			dosym "../lib/python-exec/python-exec2" "/usr/bin/${f}"
		done
	fi
}
