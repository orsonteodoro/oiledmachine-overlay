# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 20.04

# TODO package
# interpreters-pep-734

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_rc/rc}"

CFLAGS_HARDENED_CF_PROTECTION=0									# Untested or unverified
CFLAGS_HARDENED_FHARDENED=0									# Untested or unverified
CFLAGS_HARDENED_USE_CASES="system-set"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} "pypy3" )
PYTHON_REQ_USE="threads(+)"
SITEFILE="50cython-gentoo.el"
SLOT_MAJOR=$(ver_cut 1-2 "${PV}")

inherit distutils-r1 toolchain-funcs elisp-common

# Based on CI
KEYWORDS="
~amd64 ~amd64-linux ~amd64-macos ~arm64 ~arm64-macos
"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/cython/cython/archive/${MY_PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="A Python to C compiler"
HOMEPAGE="
	https://cython.org/
	https://github.com/cython/cython/
	https://pypi.org/project/Cython/
"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${SLOT_MAJOR}/${PV}"
IUSE="emacs test ebuild_revision_5"
RDEPEND="
	!dev-python/cython:3
	app-eselect/eselect-cython
	emacs? (
		>=app-editors/emacs-23.1:*
	)
"
DEPEND="
	${RDEPEND}
"
# <dev-python/setuptools-60[${PYTHON_USEDEP}] relaxed for python3_11
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	' python3_{10..11})
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	' python3_12)
	doc? (
		>=dev-python/jinja2-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-issues-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tabs-3.4.4[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.3[${PYTHON_USEDEP}]
		>=dev-python/jupyter-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/alabaster-0.7.16[${PYTHON_USEDEP}]
		>=dev-python/anyio-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-bindings-21.2.0[${PYTHON_USEDEP}]
		>=dev-python/arrow-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/asttokens-2.4.1[${PYTHON_USEDEP}]
		>=dev-python/async-lru-2.0.4[${PYTHON_USEDEP}]
		>=dev-python/attrs-23.2.0[${PYTHON_USEDEP}]
		>=dev-python/babel-2.14.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.12.2[${PYTHON_USEDEP}]
		>=dev-python/bleach-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/certifi-2023.11.17[${PYTHON_USEDEP}]
		>=dev-python/cffi-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/comm-0.2.1[${PYTHON_USEDEP}]
		>=dev-python/debugpy-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/decorator-5.1.1[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/executing-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/fastjsonschema-2.19.1[${PYTHON_USEDEP}]
		>=dev-python/fqdn-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/idna-3.6[${PYTHON_USEDEP}]
		>=dev-python/imagesize-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-7.0.1[${PYTHON_USEDEP}]
		>=dev-python/ipykernel-6.28.0[${PYTHON_USEDEP}]
		>=dev-python/ipython-8.18.1[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-8.1.1[${PYTHON_USEDEP}]
		>=dev-python/isoduration-20.11.0[${PYTHON_USEDEP}]
		>=dev-python/jedi-0.19.1[${PYTHON_USEDEP}]
		>=dev-python/json5-0.9.14[${PYTHON_USEDEP}]
		>=dev-python/jsonpointer-2.4[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-4.20.0[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-specifications-2023.12.1[${PYTHON_USEDEP}]
		>=dev-python/jupyter-console-6.6.3[${PYTHON_USEDEP}]
		>=dev-python/jupyter-events-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/jupyter-lsp-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/jupyter_client-8.6.0[${PYTHON_USEDEP}]
		>=dev-python/jupyter_core-5.7.1[${PYTHON_USEDEP}]
		>=dev-python/jupyter_server-2.12.4[${PYTHON_USEDEP}]
		>=dev-python/jupyter_server_terminals-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/jupyterlab-4.0.10[${PYTHON_USEDEP}]
		>=dev-python/jupyterlab-widgets-3.0.9[${PYTHON_USEDEP}]
		>=dev-python/jupyterlab_pygments-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/jupyterlab_server-2.25.2[${PYTHON_USEDEP}]
		>=dev-python/MarkupSafe-2.1.3[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-inline-0.1.6[${PYTHON_USEDEP}]
		>=dev-python/mistune-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/nbclient-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/nbconvert-7.14.1[${PYTHON_USEDEP}]
		>=dev-python/nbformat-5.9.2[${PYTHON_USEDEP}]
		>=dev-python/nest-asyncio-1.5.8[${PYTHON_USEDEP}]
		>=dev-python/notebook-7.0.6[${PYTHON_USEDEP}]
		>=dev-python/notebook_shim-0.2.3[${PYTHON_USEDEP}]
		>=dev-python/overrides-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
		>=dev-python/pandocfilters-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/parso-0.8.3[${PYTHON_USEDEP}]
		>=dev-python/pexpect-4.9.0[${PYTHON_USEDEP}]
		>=dev-python/platformdirs-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/prometheus-client-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.43[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9.7[${PYTHON_USEDEP}]
		>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pure-eval-0.2.2[${PYTHON_USEDEP}]
		>=dev-python/pycparser-2.21[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.17.2[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
		>=dev-python/python-json-logger-2.0.7[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-25.1.2[${PYTHON_USEDEP}]
		>=dev-python/qtconsole-5.5.1[${PYTHON_USEDEP}]
		>=dev-python/QtPy-2.4.1[${PYTHON_USEDEP}]
		>=dev-python/referencing-0.32.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=dev-python/rfc3339-validator-0.1.4[${PYTHON_USEDEP}]
		>=dev-python/rfc3986-validator-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/rpds-py-0.17.1[${PYTHON_USEDEP}]
		>=dev-python/send2trash-1.8.2[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/sniffio-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/snowballstemmer-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/soupsieve-2.5[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-applehelp-1.0.8[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-devhelp-1.0.6[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-htmlhelp-2.0.5[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-qthelp-1.0.7[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-serializinghtml-1.1.10[${PYTHON_USEDEP}]
		>=dev-python/stack-data-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/terminado-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/tinycss2-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.4[${PYTHON_USEDEP}]
		>=dev-python/traitlets-5.14.1[${PYTHON_USEDEP}]
		>=dev-python/types-python-dateutil-2.8.19.20240106[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.9.0[${PYTHON_USEDEP}]
		>=dev-python/uri-template-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/wcwidth-0.2.13[${PYTHON_USEDEP}]
		>=dev-python/webcolors-1.13[${PYTHON_USEDEP}]
		>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/widgetsnbextension-4.0.9[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.17.0[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_any_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/pycodestyle[${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/pycodestyle[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
		' python3_12)
		$(python_gen_cond_dep '
			dev-python/interpreters-pep734[${PYTHON_USEDEP}]
		' python3_12)
		$(python_gen_cond_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/line-profiler[${PYTHON_USEDEP}]
			dev-python/pycodestyle[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		' python3_{10..11})
		doc? (
			$(python_gen_cond_dep '
				dev-python/ipython[${PYTHON_USEDEP}]
			' python3_{10..11})
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.29.22-spawn-multiprocessing.patch"
#	"${FILESDIR}/${PN}-0.29.23-test_exceptions-py310.patch"
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

distutils_enable_sphinx \
	"docs" \
	"dev-python/jinja2" \
	"dev-python/sphinx-issues" \
	"dev-python/sphinx-tabs"

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_compile_all() {
	use emacs && elisp-compile "Tools/cython-mode.el"
}

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}" ; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	# Needed to avoid confusing cache tests
	unset CYTHON_FORCE_REGEN

	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" "runtests.py" \
		-vv \
		-j "$(makeopts_jobs)" \
		--work-dir "${BUILD_DIR}/tests" \
		--no-examples \
		--no-code-style \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=(
		"CHANGES.rst"
		"README.rst"
		"ToDo.txt"
		"USAGE.txt"
	)
	distutils-r1_python_install_all

	if use emacs; then
		elisp-install "${PN}" "Tools/cython-mode."*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	_slotify() {
		einfo "Slotifying ${PN}"
		mv "${ED}$(python_get_sitedir)/Cython"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}$(python_get_sitedir)/pyximport"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}$(python_get_sitedir)/cython.py"{"",".${SLOT_MAJOR}"} || die
		find "${ED}" -regex '^.*\(__pycache__\|\.py[co]\)$' -delete || die
		rm -rf "${ED}/usr/bin/cygdb" || die
		rm -rf "${ED}/usr/bin/cython" || die
		rm -rf "${ED}/usr/bin/cythonize" || die

		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cygdb"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cython"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cythonize"{"",".${SLOT_MAJOR}"} || die
	}

	python_foreach_impl _slotify
}

pkg_postinst() {
	use emacs && elisp-site-regen
	eselect cython set "${SLOT_MAJOR}"
einfo "Use \`eselect cython\` to switch between Cython slots."
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot
# OILEDMACHINE-OVERLAY-META-REVDEP:  RapidFuzz, JaroWinkler
