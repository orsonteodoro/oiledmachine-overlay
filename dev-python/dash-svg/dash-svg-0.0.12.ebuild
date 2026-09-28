# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild uses AI to fix the EVP crypto issue.

# Missing:
# sci-visualization/dash[testing]

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="0.0.12" npm_updater_update_locks.sh

DISTUTILS_USE_PEP517="setuptools"
NODE_SLOT="24" # Upstream uses node 12.  14, 18, 24 works
NPM_AUDIT_FATAL=0
NPM_SLOT=3
NPM_TARBALL="${P}.tar.gz"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12
REACT_PV="16.14.0" # Supports up to node 14 used for testing.  node 14 uses npm 6.14.18 which is lockfile v1.
#REACT_PV="18.3.1" # Supports up to node 17

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

inherit distutils-r1 edo npm secure-version secure-version-node

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/stevej2608/dash-svg/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="SVG support library for Plotly/Dash"
HOMEPAGE="
https://github.com/stevej2608/dash-svg
https://pypi.org/project/dash-svg/
"
LICENSE="MIT" # https://github.com/stevej2608/dash-svg/blob/0.0.12/DESCRIPTION#L8
RESTRICT="mirror test" # Missing sci-visualization/dash[testing]
SLOT="0"
IUSE="
test
ebuild_revision_12
"
RDEPEND+="
	>=dev-python/twine-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/keyrings-alt-4.1.0[${PYTHON_USEDEP}]
	>=sci-visualization/dash-1.15.0[${PYTHON_USEDEP},dev(+)]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	>=net-libs/nodejs-${NODEJS_24_PV}:${NODE_SLOT}[webassembly(+)]
	sys-apps/npm:${NPM_SLOT}
	test? (
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

npm_unpack_post() {
	pushd "${S}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/dash-svg-0.0.12-use-fetch-api.patch"	# Untested patch
	popd >/dev/null 2>&1 || die
}

npm_update_lock_audit_post() {
	enpm audit fix "${NPM_AUDIT_FIX_ARGS[@]}"

	local pkgs=(
	# Remove vendored copy
		"npm"

	# Remove EOL packages
		"request"
		"request-promise"
	)
	enpm uninstall "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	# Manual vulnerabilities fixes
	local pkgs=(
		"braces@^${NODE_BRACES_PV}"
		"decode-uri-component@^${NODE_DECODE_URI_COMPONENT_PV}"
		"flatted@^${NODE_FLATTED_PV}"
		"http-proxy-middleware@^${NODE_HTTP_PROXY_MIDDLEWARE_2_PV}"
		"loader-utils@^${NODE_LOADER_UTILS_PV}"
		"nanoid@^${NODE_NANOID_3_PV}"
		"postcss@^${NODE_POSTCSS_PV}"
		"serialize-javascript@^${NODE_SERIALIZE_JAVASCRIPT_PV}"
		"tmp@^${NODE_TMP_PV}"
	)
	enpm install "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	enpm dedupe "${NPM_DEDUPE_ARGS[@]}"
}

src_unpack() {
	npm_src_unpack
}

src_compile() {
	export NODE_OPTIONS="--openssl-legacy-provider"
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.dev.js" | grep -q "dash_svg.dev.js" || die
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.min.js" | grep -q "dash_svg.min.js" || die
}

src_test() {
	pytest || die
}

src_install() {
	distutils-r1_src_install
}
