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
SRC_URI_GLIBC="
	amd64? (
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/94/d1/c073a99d2633a1c231921d5a9ba9f1f94485da7a75d0139101f4e157c1c5/cx_freeze-8.3.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/e8/b5/21dfa6fd4580bed578e22f4be2f42d585d1e064f1b58fc2321477030414e/cx_freeze-8.3.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
		python_targets_python3_13? (
https://files.pythonhosted.org/packages/da/da/a97fbb2ee9fb958aca527a9a018a98e8127f0b43c4fb09323d2cdbc4ec94/cx_freeze-8.3.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
		)
	)
	arm64? (
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/77/ba/004331711db1913bc27a844d6cb89b48b0dabea0fadc0adf57dd2e090b80/cx_freeze-8.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/de/97/ddd0daa6de5da6d142a77095d66c8466442f0f8721c6eaa52b63bdbbb29a/cx_freeze-8.3.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
		python_targets_python3_13? (
https://files.pythonhosted.org/packages/45/df/ba05eba858fa33bfcdde589d4b22333ff1444f42ff66e88ad98133105126/cx_freeze-8.3.0-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
		)
	)
	ppc64? (
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/6c/5f/9d66343f42c5fdfaa0e4afb3def357b54159a034f0990adbf27ba5c08620/cx_freeze-8.3.0-cp311-cp311-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/b5/0b/b4cf3e7dffd1a4fa6aa80b26af6b21d0b6dafff56495003639eebdc9a9ba/cx_freeze-8.3.0-cp312-cp312-manylinux_2_17_ppc64le.manylinux2014_ppc64le.whl
		)
	)
"
SRC_URI_MUSL="
	amd64? (
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/bb/a9/96281c51edde509e73fe16cd3cd997cb4982ec907818a4b9a25289838baf/cx_freeze-8.3.0-cp311-cp311-musllinux_1_2_x86_64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/98/8c/4da11732f32ed51f2b734caa3fe87559734f68f508ce54b56196ae1c4410/cx_freeze-8.3.0-cp312-cp312-musllinux_1_2_x86_64.whl
		)
	)
	arm64? (
		python_targets_python3_11? (
https://files.pythonhosted.org/packages/57/2d/ef8ca36b173444a47ffc94086f3fb03c0ca2f4465f7db14a8c82d06e3ed7/cx_freeze-8.3.0-cp311-cp311-musllinux_1_2_aarch64.whl
		)
		python_targets_python3_12? (
https://files.pythonhosted.org/packages/9b/08/76270e82bff702edd584e252239c1ab92e1807cf5ca2efafd0c69a948775/cx_freeze-8.3.0-cp312-cp312-musllinux_1_2_aarch64.whl
		)
	)
"
SRC_URI="
	elibc_glibc? (
		${SRC_URI_GLIBC}
	)
	elibc_musl? (
		${SRC_URI_MUSL}
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
REQUIRED_USE="
	elibc_glibc? (
		ppc64? (
			!python_targets_python3_13
		)
	)
	elibc_musl? (
		amd64? (
			!python_targets_python3_13
		)
		arm64? (
			!python_targets_python3_13
		)
		ppc64? (
			!python_targets_python3_11
			!python_targets_python3_12
			!python_targets_python3_13
		)
	)
"
RDEPEND+="
	>=dev-python/filelock-3.12.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-24[${PYTHON_USEDEP}]
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
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
			>=dev-vcs/pre-commit-4.2.0[${PYTHON_SINGLE_USEDEP}]
		')
		>=dev-python/build-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/cibuildwheel-2.23.3[${PYTHON_USEDEP}]
		>=dev-util/bump-my-version-1.1.2[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/furo-2024.8.6[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-8.2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-new-tab-link-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tabs-3.4.7[${PYTHON_USEDEP}]
	)
	test? (
		pandas? (
			dev-python/pandas[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7.8.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-6.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.14.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.6.1[${PYTHON_USEDEP}]
	)
"
DOCS=( )

_install_wheel() {
	local wheel_path="${1}"
	local bn=$(basename "${wheel_path}")

	local epython=""
	if [[ "${bn}" =~ "cp311" ]] ; then
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
