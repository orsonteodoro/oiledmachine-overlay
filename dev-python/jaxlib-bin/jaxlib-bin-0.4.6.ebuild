# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="jaxlib"

DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="XLA library for JAX"
HOMEPAGE="
http://jax.readthedocs.io/
https://github.com/google/jax
https://github.com/google/jax/tree/main/jaxlib
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"
SLOT="0/$(ver_cut 1-2 ${PV})"
# For cpuflags, see https://github.com/google/jax/blob/jaxlib-v0.4.6/.bazelrc#L54
# They use non-portable -march=native for x86_64.
IUSE+=" cpu_flags_x86_avx"
REQUIRED_USE="
	amd64? (
		cpu_flags_x86_avx
	)
"
RDEPEND+="
	!dev-python/jaxlib
	>=dev-python/jaxlib-${PV}[${PYTHON_USEDEP}]
"
DEPEND+="
	${DEPEND}
"
BDEPEND+="
"
gen_uris() {
	local i
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${i}" "${PYTHON_COMPAT[@]}"; then
			local python_pv=""
			python_pv="${i/python}"
			python_pv="${python_pv/_/}"
			echo "
				kernel_linux? (
					elibc_glibc? (
						python_targets_${i/./_}? (
							amd64? (
								cpu_flags_x86_avx? (
https://files.pythonhosted.org/packages/cp${python_pv}/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-manylinux2014_x86_64.whl
								)
							)
						)
					)
				)
				kernel_Darwin? (
					elibc_Darwin? (
						python_targets_${i/./_}? (
							arm64-macos? (
https://files.pythonhosted.org/packages/cp${python_pv}/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-macosx_10_14_x86_64.whl
							)
							x64-macos? (
https://files.pythonhosted.org/packages/cp${python_pv}/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-macosx_11_0_arm64.whl
							)
						)
					)
				)
			"
		fi
	done
}
SRC_URI="
	$(gen_uris)
"
RESTRICT="mirror"
S="${WORKDIR}"

python_compile() {
	local i
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${i}" "${PYTHON_COMPAT[@]}"; then
			local python_pv=""
			python_pv="${i/python}"
			python_pv="${python_pv/_/}"
			if use kernel_linux ; then
				if use elibc_glibc ; then
					if use python_targets_${i/./_} ; then
						if use amd64 ; then
							distutils_wheel_install "${BUILD_DIR}/install" \
								"${DISTDIR}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-manylinux2014_x86_64.whl"
						fi
					fi
				fi
			fi
			if use kernel_Darwin ; then
				if use elibc_Darwin ; then
					if use python_targets_${i/./_} ; then
						if use arm64-macos ; then
							distutils_wheel_install "${BUILD_DIR}/install" \
								"${DISTDIR}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-macosx_10_14_x86_64.whl"
						fi
						if use x64-macos ; then
							distutils_wheel_install "${BUILD_DIR}/install" \
								"${DISTDIR}/${MY_PN}-${PV}-cp${python_pv}-cp${python_pv}-macosx_11_0_arm64.whl"
						fi
					fi
				fi
			fi
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
