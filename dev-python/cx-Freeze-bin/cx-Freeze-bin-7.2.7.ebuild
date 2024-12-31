# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We use the prebuilt because it needs binary cx_Freeze/bases binaries

MY_PN="cx_Freeze"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}/${P}"
SRC_URI="
	amd64? (
		python_targets_python3_10? (
https://files.pythonhosted.org/packages/36/d3/dc10cba6905160a4da44c197eca1d41b1d8c59fb0ae732d9690af88bcf79/cx_Freeze-7.2.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/96/9f/ac656645d9c399b68811b5ef8e7f6bdabc324685b5c6b72ae5a9b937582d/cx_Freeze-7.2.7-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/1b/06/db74d3ab4a851cdd45254b3afdb305e454a6420f9d043159e80c0e3a6f9a/cx_Freeze-7.2.7-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
		python_targets_python3_13? (
https://files.pythonhosted.org/packages/a5/59/b5927b79d7d599630cfe0772fbb98ab64e33d2cff6eb186b13ef102d3035/cx_Freeze-7.2.7-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
	)
	arm64? (
		python_targets_python3_10? (
https://files.pythonhosted.org/packages/bc/71/7598e7769dc1ec834e470798314786195a0c5de920d8145d86f62e6cf403/cx_Freeze-7.2.7-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/aa/09/aeca5e86a75b25b1a2455b7e0fa3166eae7ead07d795c0061c1bcedc5eb0/cx_Freeze-7.2.7-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/77/79/043d442716ec36f9a0d1e9ebc6fdc6b966da2c5131d7e481dbe3e6c45df8/cx_Freeze-7.2.7-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
		python_targets_python3_13? (
https://files.pythonhosted.org/packages/61/70/57f2c34bf8cdb103377d08ae9db88fca69b8dd0ac336de2697fa68f1c38f/cx_Freeze-7.2.7-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
	)
	ppc64? (
		python_targets_python3_10? (
https://files.pythonhosted.org/packages/10/ef/3f66480bac7e4d29c521e854cc54685a64770140e639b25aca5779ed5876/cx_Freeze-7.2.7-cp310-cp310-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/a3/f4/a060909a2ea8f7425c5379ac9be74a192cc0847f612cd1c92649c1deeb86/cx_Freeze-7.2.7-cp311-cp311-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/2c/32/3db0938fac59d082694c1aab3087354828a838d0853d0909116716a6bd3d/cx_Freeze-7.2.7-cp312-cp312-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
		python_targets_python3_13? (
https://files.pythonhosted.org/packages/0c/a5/0cec1917c50bbd4a99318c0bdd99d5cd339eabeca2865398d721c6adfc87/cx_Freeze-7.2.7-cp313-cp313-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
	)
"

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="
	https://github.com/marcelotduarte/cx_Freeze
	https://pypi.org/project/cx-Freeze
"
LICENSE="
	custom
"
# custom - See https://github.com/marcelotduarte/cx_Freeze/blob/7.2.7/LICENSE.md
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev doc multiprocess pandas test
ebuild_revision_4
"
RDEPEND+="
	>=dev-python/filelock-3.12.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-24[${PYTHON_USEDEP}]
	>=dev-python/setuptools-65.6.3[${PYTHON_USEDEP}]
	dev-util/patchelf
	multiprocess? (
		dev-python/multiprocess[${PYTHON_USEDEP}]
	)
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' python3_10)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(python_gen_any_dep '
			>=dev-vcs/pre-commit-3.5.0[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/build-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/cibuildwheel-2.22.0[${PYTHON_USEDEP}]
		>=dev-util/bump-my-version-0.26.1[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/furo-2024.8.6[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-new-tab-link-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tabs-3.4.5[${PYTHON_USEDEP}]
	)
	test? (
		pandas? (
			dev-python/pandas[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7.6.1[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-datafiles-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP},psutil(+)]
	)
"
DOCS=( )

_install_wheel() {
	local wheel_path="${1}"
	local bn=$(basename "${wheel_path}")

	local epython=""
	if [[ "${bn}" =~ "cp310" ]] ; then
		epython="python3.10"
	elif [[ "${bn}" =~ "cp311" ]] ; then
		epython="python3.11"
	elif [[ "${bn}" =~ "cp312" ]] ; then
		epython="python3.12"
	elif [[ "${bn}" =~ "cp313" ]] ; then
		epython="python3.13"
	else
		die "Python implementation for ${bn} is not supported"
	fi

einfo "Installing wheel ${bn} for ${epython}"

	local d="${WORKDIR}/${PN}-${PV}-${epython/./_}/install"
	distutils_wheel_install "${d}" \
		"${wheel_path}"

	# Unbreak die check
	mkdir -p "${d}/usr/bin"
	touch "${d}/usr/bin/"{"${epython}","python3","python","pyvenv.cfg"}

	mkdir -p "${d}/usr/lib/python-exec/${epython}" || die

	cp -aT \
		"${d}/usr/bin" \
		"${d}/usr/lib/python-exec/${epython}" \
		|| die

	rm "${d}/usr/lib/python-exec/${epython}/"{"${epython}","python3","python","pyvenv.cfg"}
}

pkg_setup() {
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		mkdir -p "${S}" || die
	fi
}

src_compile() {
	declare -A arches=(
		["amd64"]="x86_64"
		["arm64"]="aarch64"
		["ppc64"]="ppc64le"
	)
	install_impl() {
		local id="${EPYTHON/python}"
		id="cp${id/./}"
		local manylinux_version="2_17"
		_install_wheel "${DISTDIR}/${MY_PN}-${PV}-${id}-${id}-manylinux_${manylinux_version}_${arches[${ARCH}]}.manylinux2014_x86_64.whl"

	# Prevent:
	# TypeError: 'NoneType' object is not iterable
		sed -i \
			-e "54d;55d;56d" \
			"${S}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages/cx_Freeze/hooks/numpy.py" \
			|| die

	# Fix:
	# error: cannot find file/directory named /usr/lib/python3.11/site-packages/cv2/config-3.py
		local ver="${EPYTHON/python}"
		sed -i \
			-e "s|config-3.py|config-${ver}.py|g" \
			"${S}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages/cx_Freeze/hooks/cv2.py" \
			|| die
	}
	python_foreach_impl install_impl
}

src_install() {
	declare -A arches=(
		["amd64"]="x86_64"
		["arm64"]="aarch64"
		["ppc64"]="ppc64le"
	)
	if use python_targets_python3_10 ; then
ewarn "Python 3.10 fails ldd test for console-cpython-310-${arches}-linux-gnu.  Try >= 3.11 instead if runtime failure."
	fi
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
