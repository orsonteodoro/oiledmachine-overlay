# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_SLOTS=( "20" "22" )

# Generated from
#PV="1.9.14"
#find /var/tmp/portage/dev-util/synp-${PV}/work/synp-${PV} \( -path "*/.bin/*" -o -path "*/cli/*" \) \
#	| sed -e "s|/var/tmp/portage/dev-util/synp-${PV}/work/synp-${PV}|/opt/synp|g" \
#	| sort

NPM_EXE_LIST=(
	"/opt/synp/cli/run.js"
	"/opt/synp/cli/synp.js"
	"/opt/synp/cli/validate-args.js"
	"/opt/synp/cli/validate-path.js"
	"/opt/synp/cli/write-output.js"
	"/opt/synp/node_modules/.bin/acorn"
	"/opt/synp/node_modules/.bin/eslint"
	"/opt/synp/node_modules/.bin/esparse"
	"/opt/synp/node_modules/.bin/esvalidate"
	"/opt/synp/node_modules/.bin/ignored"
	"/opt/synp/node_modules/.bin/js-yaml"
	"/opt/synp/node_modules/.bin/jsesc"
	"/opt/synp/node_modules/.bin/json5"
	"/opt/synp/node_modules/.bin/loose-envify"
	"/opt/synp/node_modules/.bin/nmtree"
	"/opt/synp/node_modules/.bin/nyc"
	"/opt/synp/node_modules/.bin/parser"
	"/opt/synp/node_modules/.bin/resolve"
	"/opt/synp/node_modules/.bin/rimraf"
	"/opt/synp/node_modules/.bin/semver"
	"/opt/synp/node_modules/.bin/standard"
	"/opt/synp/node_modules/.bin/tape"
	"/opt/synp/node_modules/.bin/uuid"
	"/opt/synp/node_modules/.bin/which"
	"/opt/synp/node_modules/@babel/core/node_modules/.bin/semver"
	"/opt/synp/node_modules/eslint-plugin-node/node_modules/.bin/semver"
	"/opt/synp/node_modules/eslint-plugin-react/node_modules/.bin/resolve"
	"/opt/synp/node_modules/eslint/node_modules/.bin/node-which"
	"/opt/synp/node_modules/foreground-child/node_modules/.bin/node-which"
	"/opt/synp/node_modules/istanbul-lib-instrument/node_modules/.bin/semver"
	"/opt/synp/node_modules/istanbul-lib-processinfo/node_modules/.bin/node-which"
	"/opt/synp/node_modules/make-dir/node_modules/.bin/semver"
	"/opt/synp/node_modules/normalize-package-data/node_modules/.bin/semver"
	"/opt/synp/node_modules/spawn-wrap/node_modules/.bin/node-which"
	"/opt/synp/node_modules/tape/node_modules/.bin/resolve"
	"/opt/synp/node_modules/tsconfig-paths/node_modules/.bin/json5"
	"/opt/synp/test/fixtures/bundled-deps-npm/node_modules/.bin/newrelic-naming-rules"
	"/opt/synp/test/fixtures/bundled-deps-npm/node_modules/newrelic/node_modules/.bin/semver"
	"/opt/synp/test/fixtures/bundled-deps-yarn/node_modules/.bin/newrelic-naming-rules"
	"/opt/synp/test/fixtures/bundled-deps-yarn/node_modules/.bin/semver"
	"/opt/synp/test/fixtures/bundled-deps-yarn/node_modules/newrelic/node_modules/.bin/semver"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/acorn"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/ansi-html"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/babylon"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/browserslist"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/build-storybook"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/cssesc"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/csso"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/errno"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/esparse"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/esvalidate"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/js-yaml"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/jsesc"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/json5"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/loose-envify"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/miller-rabin"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/mime"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/mkdirp"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/react-docgen"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/regjsparser"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/semver"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/sha.js"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/shjs"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/sshpk-conv"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/sshpk-sign"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/sshpk-verify"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/start-storybook"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/storybook-server"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/svgo"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/uglifyjs"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/uuid"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/webpack"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/.bin/which"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/acorn-dynamic-import/node_modules/.bin/acorn"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/caniuse-api/node_modules/.bin/browserslist"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/cssnano/node_modules/.bin/browserslist"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/js-yaml/node_modules/.bin/esparse"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/js-yaml/node_modules/.bin/esvalidate"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/postcss-merge-rules/node_modules/.bin/browserslist"
	"/opt/synp/test/fixtures/deps-with-scopes/node_modules/regjsparser/node_modules/.bin/jsesc"
	"/opt/synp/test/fixtures/multiple-level-deps/node_modules/send/node_modules/.bin/mime"
)

inherit npm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/imsnif/synp.git"
	FALLBACK_COMMIT="53e664e93348e17ea576cf0c49c36b229855721b" # Apr 29, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/imsnif/synp/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Convert yarn.lock to package-lock.json and vice versa"
HOMEPAGE="
	https://github.com/imsnif/synp
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_1
"
gen_node_depends() {
	local s
	for s in ${NODE_SLOTS[@]} ; do
		echo "
			net-libs/nodejs:${s}
		"
	done
}
RDEPEND+="
	|| (
		$(gen_node_depends)
	)
	net-libs/nodejs:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	|| (
		$(gen_node_depends)
	)
"
DOCS=( "README.md" )

pkg_setup() {
	local x=""
	for x in "${NODE_SLOTS[@]}" ; do
		if [[ -e "/usr/lib/node/${x}/bin/node" ]] ; then
			export NODE_SLOT="${x}"
			break
		fi
	done
	npm_pkg_setup
}

src_unpack() {
	export COREPACK_ENABLE_DOWNLOAD_PROMPT=1
	npm_src_unpack
}

src_compile() {
	:
}

src_install() {
	npm_src_install
	docinto "licenses"
	dodoc "LICENSE.md"
	dosym \
		"/opt/${PN}/cli/synp.js" \
		"/usr/bin/synp"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
