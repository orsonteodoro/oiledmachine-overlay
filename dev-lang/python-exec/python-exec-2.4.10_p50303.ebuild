# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=15
MY_P="${PN}-$(ver_cut 1-3 ${PV})"
PYTHON_COMPAT=( "python3_"{9..11} "pypy3" )
ROCM_SLOT="5.3"
ROCM_VERSION="5.3.3"

inherit python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://github.com/projg2/python-exec/releases/download/v${PV}/${MY_P}.tar.bz2"

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://github.com/projg2/python-exec/"
LICENSE="BSD-2"
RESTRICT="
	!test? (
		test
	)
"
SLOT="rocm-${ROCM_SLOT}/${ROCM_VERSION}"
IUSE="
${_PYTHON_ALL_IMPLS[@]/#/python_targets_} +native-symlinks test
ebuild_revision_1
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
	rocm_pkg_setup
}

src_prepare() {
	default
	rocm_src_prepare
}

src_configure() {
	local pyimpls=() i EPYTHON
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if use "python_targets_${i}"; then
			_python_export "${i}" "EPYTHON"
			pyimpls+=(
				"${EPYTHON}"
			)
		fi
	done

	local myconf=(
		--prefix="${EPREFIX}${EROCM_PATH}"
		--with-fallback-path="${EPREFIX}${EROCM_PATH}/bin:${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin"
		--with-python-impls="${pyimpls[*]}"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	if use native-symlinks; then
		local programs=( python python3 )
		local scripts=( python-config python3-config 2to3 idle pydoc pyvenv )

		local f
		for f in "${programs[@]}"; do
			# symlink the C wrapper for python to avoid shebang recursion
			# bug #568974
			dosym python-exec2c "${EROCM_PATH}/bin/${f}"
		done
		for f in "${scripts[@]}"; do
			# those are python scripts (except for new python-configs)
			# so symlink them via the python wrapper
			dosym ../lib/python-exec/python-exec2 "${EROCM_PATH}/bin/${f}"
		done
	fi
	rocm_mv_docs
}
