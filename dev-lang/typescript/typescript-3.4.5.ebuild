# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 app-eselect/eselect-typescript"

DEPEND="${RDEPEND}
	media-libs/vips
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit versionator npm-utils

MY_PN="TypeScript"

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
SRC_URI="https://github.com/Microsoft/TypeScript/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

UNDERSCORE_STRING_VER="3.3.5"
DEBUG_VER="<3.0.0"
BRACES_VER="^2.3.2"
JS_YAML_VER="^3.13.0"

_fix_vulnerbilities() {
	npm i --package-lock || die

	#einfo "Performing recursive package-lock.json install"
	#L=$(find . -name "package-lock.json")
	#for l in $L; do
	#	pushd $(dirname $l) || die
	#	npm install
	#	popd
	#done
	#einfo "Recursive install done"

	# fix vulnerbilities top level
	npm audit fix --force || die

	# fix vulnerbility mocha
	pushd node_modules/mocha || die
	npm i --package-lock || die
	npm audit fix --force || die
	npm uninstall js-yaml
	npm install js-yaml@"^3.13.0" --save-prod || die
	rm package-lock.json || die
	popd

	sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/upath/package.json || die
	#sed -i -e "s|\"underscore.string\": \"^3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/wd/package.json || die
	sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/upath/package.json || die
	sed -i -e "s|\"underscore.string\": \"~2.4.0\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/remarkable/node_modules/argparse/package.json || die
	sed -i -e "s|\"underscore.string\": \"2.4.0\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/remarkable/package.json || die
	rm -rf node_modules/mocha/node_modules/underscore.string || die
	pushd node_modules/mocha || die
	npm install "underscore.string"@"${UNDERSCORE_STRING_VER}" --save-dev || die
	popd

	sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/micromatch/package.json || die

	#sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/lint-staged/node_modules/micromatch/package.json || die
	sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/micromatch/package.json || die
	#sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/readdirp/node_modules/micromatch/package.json || die
	#sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/anymatch/node_modules/micromatch/package.json || die
	#sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/fast-glob/node_modules/micromatch/package.json || die
	sed -i -e "s|\"braces\": \"^2.0.3\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/arr-map/package.json || die
	#rm -rf node_modules/braces || die
	#rm -rf node_modules/mocha/node_modules/browser-sync/node_modules/braces || die
	#rm -rf node_modules/mocha/node_modules/braces || die
	#rm -rf node_modules/mocha/node_modules/micromatch/node_modules/braces || die
	#pushd node_modules/mocha/node_modules/micromatch || die
	#npm install "braces"@"${BRACES_VER}" --save-prod || die
	#popd
	#pushd node_modules/mocha || die
	#npm install "braces"@"${BRACES_VER}" || die
	#popd
	#npm install "braces"@"${BRACES_VER}" || die

	sed -i -e "s|\"debug\": \"~2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/gm-papandreou/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/snapdragon/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/needle/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/resp-modifier/package.json || die
	sed -i -e "s|\"debug\": \"^2.3.3\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/expand-brackets/package.json || die
	sed -i -e "s|\"debug\": \"^2.6.8\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/eslint-module-utils/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/fsevents/node_modules/needle/package.json || die
	sed -i -e "s|\"debug\": \"2.6.9\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/finalhandler/package.json || die
	sed -i -e "s|\"debug\": \"^2.3.3\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/expand-brackets/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/snapdragon/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/fsevents/node_modules/needle/package.json || die
	rm -rf node_modules/mocha/node_modules/gm-papandreou/node_modules/debug || die
	rm -rf node_modules/fsevents/node_modules/debug || die
	rm -rf node_modules/mocha/node_modules/debug || die
	rm -rf node_modules/debug || die
	pushd node_modules/mocha || die
	npm install "debug"@"${DEBUG_VER}" --save-prod || die
	popd
	pushd node_modules/fsevents || die
	npm install "debug"@"${DEBUG_VER}" || die
	popd
	pushd node_modules/mocha/node_modules/gm-papandreou || die
	npm install "debug"@"${DEBUG_VER}" --save-prod || die
	popd
	npm install "debug"@"${DEBUG_VER}" || die

	sed -i -e "s|\"js-yaml\": \"3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.7.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/tslint/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/jsdom/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.9.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/nps/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/svgo/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.11.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/gray-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.8.1\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/markdown-toc/node_modules/gray-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.11.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/coveralls/package.json || die
	sed -i -e "s|\"js-yaml\": \"~3.12.1\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/markdownlint/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.10.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/section-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/eslint/package.json || die
	rm -rf node_modules/js-yaml || die
	rm -rf node_modules/mocha/node_modules/js-yaml || die
	pushd node_modules/mocha || die
	npm install "js-yaml"@"${JS_YAML_VER}" --save-prod || die
	popd
	npm install "js-yaml"@"${JS_YAML_VER}" || die

	rm -rf node_modules/fsevents || die
	rm -rf node_modules/mocha/node_modules/fsevents || die

	# We need 4.X for gulp-help.  The audit fix updates it to 4.X and breaks it.
	npm uninstall gulp
	npm install gulp@"<5.0.0" --save-dev || die
}

npm-secaudit_src_postprepare() {
	_fix_vulnerbilities

	npm_audit_package_lock_update node_modules/mocha/node_modules/gm-papandreou
	npm_audit_package_lock_update node_modules/mocha/node_modules/browser-sync
	npm_audit_package_lock_update node_modules/mocha/node_modules/babel-runtime
	npm_audit_package_lock_update node_modules/mocha/node_modules/babel-types
	npm_audit_package_lock_update node_modules/mocha
}

npm-secaudit_src_postcompile() {
	npm uninstall gulp -D
}

src_install() {
	npm-secaudit_install "*"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	eselect typescript list | grep ${SLOT} >/dev/null
	if [[ "$?" == "0" ]] ; then
		eselect typescript set ${SLOT}
	fi
}
