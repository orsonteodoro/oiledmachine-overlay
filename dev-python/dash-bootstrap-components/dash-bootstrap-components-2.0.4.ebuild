# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile:
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="2.0.4" npm_updater_update_locks.sh

DISTUTILS_USE_PEP517="hatchling"
NPM_AUDIT_FATAL=0
NPM_TARBALL="${P}.tar.gz"
NODE_SLOT="22" # Upstream uses node 22
PYTHON_COMPAT=( "python3_"{10..13} ) # Lists up to 3.13

NPM_INSTALL_ARGS=(
	"--prefer-offline"
	"--legacy-peer-deps"
)

NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
	"--legacy-peer-deps"
)

NPM_DEDUPE_ARGS=(
	"--prefer-offline"
	"--legacy-peer-deps"
)

inherit distutils-r1 secure-version-node npm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/facultyai/dash-bootstrap-components/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bootstrap components for Plotly Dash"
HOMEPAGE="
https://dash-bootstrap-components.opensource.faculty.ai/
https://github.com/facultyai/dash-bootstrap-components
https://pypi.org/project/dash-bootstrap-components/
"
LICENSE="Apache-2.0"
RESTRICT="mirror test" # Did not test
SLOT="0"
IUSE="
dev pandas
ebuild_revision_7
"
REQUIRED_USE="
	pandas? (
		|| (
			python_targets_python3_13
		)
	)
"
RDEPEND+="
	>=sci-visualization/dash-3.0.4[${PYTHON_USEDEP},dev(+)]
	pandas? (
		>=dev-python/pandas-2.2.3[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_SLOT}[webassembly(+)]
	dev? (
		>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
		>=dev-python/semver-3.0.2[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.8.5
		>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
	)
"
DOCS=( "README.md" )

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

npm_dedupe_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		patch_lockfile() {
			sed -i -e "s|||g" "package-lock.json" || die
		}
		#patch_lockfile

		local pkgs
		pkgs=(
		)
		#enpm install "${pkgs[@]}" -P --prefer-offline "${NPM_INSTALL_ARGS[@]}"

		pkgs=(
			"@babel/core@^7.29.6"
			"@babel/plugin-transform-modules-systemjs@^7.29.4"
			"baseline-browser-mapping@^2.11.0"
			"brace-expansion@^${NODE_BRACE_EXPANSION_1_PV}"
			"browserslist@^${NODE_BROWSERSLISTS_PV}"
			"fast-uri@^${NODE_FAST_URI_3_PV}"
			"http-proxy-middleware@^2.0.10"
			"js-yaml@${NODE_JS_YAML_3_PV}"
			"nanoid@^${NODE_NANOID_3_PV}"
			"launch-editor@^${NODE_LAUNCH_EDITOR_PV}"
			"postcss@^${NODE_POSTCSS_PV}"
			"postcss-selector-parser@^7.1.3"
			"qs@^${NODE_QS_PV}"
			"shell-quote@^${NODE_SHELL_QUOTE_PV}"
			"uuid@^${NODE_UUID_11_PV}"
			"webpack-dev-server@^5.2.6"
			"websocket-driver@0.7.5"
			"ws@^${NODE_WS_8_PV}"
		)
		enpm install "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"
		#patch_lockfile

		enpm dedupe "${NPM_DEDUPE_ARGS[@]}"
	fi
}

src_unpack() {
	npm_src_unpack
}

python_compile() {
	distutils-r1_python_compile
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages" >/dev/null 2>&1 || die
		local L=(
			"pyproject.toml"
			"NOTICE.txt"
			"dash_bootstrap_components-${PV}.dist-info"
			"LICENSE"
			"README.md"
			"examples"
		)
		mv "${L[@]}" "${PN//-/_}" || die
	popd >/dev/null 2>&1 || die
}

src_compile() {
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	grep -q -e "WARNING warning: no files found matching" "${T}/build.log" && die "Detected error"
	grep -q -e "ModuleNotFoundError: No module named" "${T}/build.log" && die "Detected error"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	dodoc "NOTICE.txt"
}
