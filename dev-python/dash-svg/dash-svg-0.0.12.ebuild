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
ebuild_revision_16
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

	# Pinned decode-uri-component required.

	local pkgs=(
	# Remove vendored copy
		"npm"

	# Remove EOL packages
		"request"
		"request-promise"
	)
	enpm uninstall "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"

#ewarn "QA:  Remove node_modules/source-map-resolve/node_modules/decode-uri-component in package-lock.json"

	NODE_CHEERIO_PV="1.2.0" # Force bump to try to remove vulnerable lodash.pick
	NODE_WEBPACK_SERVE_PV="4.0.0" # Force bump to try to remove vulnerable hoek
	NODE_HTTP_PROXY_MIDDLEWARE_PV="NODE_HTTP_PROXY_MIDDLEWARE_PV"
	patch_lockfile() {
		sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"cheerio\": \"^0.22.0\"|\"cheerio\": \"^${NODE_CHEERIO_PV}\"|g" "${S}/package-lock.json" || die # 0 -> 1 may be a breaking change
#		sed -i -e "s|\"decode-uri-component\": \"^0.2.0\"|\"decode-uri-component\": \"^${NODE_DECODE_URI_COMPONENT_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"flatted\": \"^2.0.0\"|\"flatted\": \"^${NODE_FLATTED_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"http-proxy-middleware\": \"^0.19.0\"|\"http-proxy-middleware\": \"^${NODE_HTTP_PROXY_MIDDLEWARE_2_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"http-proxy-middleware\": \"^1.0.3\"|\"http-proxy-middleware\": \"^${NODE_HTTP_PROXY_MIDDLEWARE_2_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"1.2.3\"|\"loader-utils\": \"^${NODE_LOADER_UTILS_1_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"^1.2.3\"|\"loader-utils\": \"^${NODE_LOADER_UTILS_1_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"^1.1.0\"|\"loader-utils\": \"^${NODE_LOADER_UTILS_1_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"nanoid\": \"^2.0.0\"|\"nanoid\": \"^${NODE_NANOID_3_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.5\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.6\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.14\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.32\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^8.5.23\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^8.5.28\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"serialize-javascript\": \"^4.0.0\"|\"serialize-javascript\": \"^${NODE_SERIALIZE_JAVASCRIPT_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"tmp\": \"^0.0.33\"|\"tmp\": \"^${NODE_TMP_PV}\"|g" "${S}/package-lock.json" || die
		sed -i -e "s|\"webpack-serve\": \"3.1.0\"|\"webpack-serve\": \"^${NODE_WEBPACK_SERVE_PV}\"|g" "${S}/package-lock.json" || die
	}

	patch_lockfile

	# Manual vulnerabilities fixes
	local pkgs=(
		"braces@^${NODE_BRACES_PV}"
		"cheerio@^${NODE_CHEERIO_PV}"
#		"decode-uri-component@^${NODE_DECODE_URI_COMPONENT_PV}"
		"flatted@^${NODE_FLATTED_PV}"
		"http-proxy-middleware@^${NODE_HTTP_PROXY_MIDDLEWARE_2_PV}"
		"loader-utils@^${NODE_LOADER_UTILS_1_PV}"
		"nanoid@^${NODE_NANOID_3_PV}"
		"postcss@^${NODE_POSTCSS_PV}"
		"serialize-javascript@^${NODE_SERIALIZE_JAVASCRIPT_PV}"
		"tmp@^${NODE_TMP_PV}"
		"webpack-serve@^${NODE_WEBPACK_SERVE_PV}"
	)
	enpm install "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	patch_lockfile

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
