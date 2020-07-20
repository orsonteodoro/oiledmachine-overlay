# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Possibly development build, untagged

EAPI=7
DESCRIPTION="A clean and modern encrypted journal/diary app"
HOMEPAGE="https://epicjournal.xyz/"
LICENSE="CC-BY-NC-4.0"
KEYWORDS="~amd64"
SLOT="0"
RDEPEND="${RDEPEND}
	 dev-db/sqlcipher"
DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="3.1.13" # todo, update version
ELECTRON_APP_VUE_V="2.5.16"
inherit desktop electron-app eutils
MY_PN="Epic Journal"
EGIT_COMMIT="0cdc1091a1eaf7d8ccdd5893ac3d275a3b651c58"
SRC_URI=\
"https://github.com/alangrainger/epic-journal/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

LODASH_MERGE="^4.6.2"
TAR_V="^4.4.2"
HOEK_V="<5.0.0"
CLEAN_CSS_V="^4.1.11"
SQLITE3_V="^3.1.13"
JS_YAML_V="^3.13.1"

_fix_vulnerabilities() {
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX=0 per-package-wise."
	sed -i -e "s|\"clean-css\": \"3.4.x\"|\"clean-css\": \"${CLEAN_CSS_V}\"|g" \
		node_modules/vue-html-loader/node_modules/html-minifier/package.json || die
	rm -rf node_modules/vue-html-loader/node_modules/clean-css || die
	pushd node_modules/vue-html-loader || die
		npm install clean-css@"${CLEAN_CSS_V}" --no-save || die
	popd

	sed -i -e "s|\"lodash.merge\": \"^3.3.2\"|\"lodash.merge\": \"${LODASH_MERGE_V}\"|g" \
		node_modules/multispinner/package.json || die
	rm -rf node_modules/lodash.merge || die
	npm install lodash.merge@"${LODASH_MERGE_V}" --no-save || die
	rm package-lock.json
	npm i --package-lock-only

	# compatibility?
	rm -rf node_modules/hoek || die
	npm install hoek@"${HOEK_V}" || die
}

_fix_vulnerabilitiesB() {
	ewarn \
"Vulnerability resolution has not been updated.  Consider setting the\n\
environmental variable ELECTRON_APP_ALLOW_AUDIT_FIX=0 per-package-wise."
	npm i --package-lock-only
	npm install

	einfo "Performing recursive package-lock.json install"
	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		npm install
		popd
	done
	einfo "Recursive install done"

	einfo "Performing recursive package-lock.json audit fix"
	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		[ -e package-lock.json ] && rm package-lock.json
		einfo "Running \`npm i --package-lock-only\`"
		npm i --package-lock-only || die
		einfo "Running \`npm audit fix --force\`"
		npm audit fix --force --maxsockets=${ELECTRON_APP_MAXSOCKETS}
		popd
	done
	einfo "Audit fix done"

	pushd node_modules/unix-sqlcipher/node_modules/sqlite3
		npm install
	popd

	sed -i -e "s|\"tar\": \"^4\"|\"tar\": \"${TAR_V}\"|g" node_modules/unix-sqlcipher/node_modules/sqlite3/node_modules/node-pre-gyp/package.json || die

	rm -rf node_modules/tar || die
	rm -rf node_modules/sqlite3/node_modules/tar || die

	npm install tar@"${TAR_V}" || die

	rm -rf node_modules/hoek || die
	npm install hoek@"${HOEK_V}" || die

	einfo "curdir: $(pwd)"
	npm i --package-lock-only

	einfo "Running \`npm audit fix --force\` on top level."
	npm audit fix --force

	einfo "Performing recursive package-lock.json audit fix GA"
	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		npm audit fix --force
		popd
	done
	einfo "Audit fix done GA"

	sed -i -e "s|\"clean-css\": \"3.4.x\"|\"clean-css\": \"${CLEAN_CSS_V}\"|g" node_modules/html-minifier/package.json || die
	rm -rf node_modules/clean-css || die
	npm install clean-css@"${CLEAN_CSS_V}" --no-save || die

	sed -i -e "s|\"clean-css\": \"3.4.x\"|\"clean-css\": \"${CLEAN_CSS_V}\"|g" node_modules/vue-html-loader/node_modules/html-minifier/package.json || die
	rm -rf node_modules/vue-html-loader/node_modules/clean-css || die
	pushd node_modules/vue-html-loader || die
	npm install clean-css@"${CLEAN_CSS_V}" --no-save || die
	popd

	# fix top level: npm ERR! code ENOAUDIT
	rm package-lock.json || die
	npm i --package-lock-only || die

	electron-app_audit_fix_npm
}

electron-app_src_preprepareA() {
	ewarn "This ebuild may fail randomly.  Re-emerge it again."

	sed -i -e "s|\"win-sqlcipher\": \"^0.0.4\",|\"unix-sqlcipher\": \"^0.0.4\",|g" package.json || die
	sed -i -e "s|win-sqlcipher|unix-sqlcipher|g" src/main/datastore.js || die

	mkdir -p node_modules/unix-sqlcipher/node_modules || die
	pushd node_modules/unix-sqlcipher || die
		npm install sqlite3@"${SQLITE3_V}" || die
		mkdir -p node_modules/sqlite3/node_modules || die
		pushd node_modules/sqlite3 || die
			npm install
		popd
	popd
}

electron-app_src_postprepareB() {
	if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
	_fix_vulnerabilities
	fi
	sed -i -e "s|cssLoaderOptions += (cssLoaderOptions ? '\&' : '?') + 'minimize'||g" node_modules/vue-loader/lib/loader.js || die
}

electron-app_src_postprepare() {
	if [[ "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
	_fix_vulnerabilities
	fi
}

electron-app_src_prepare() {
	electron-app_fetch_deps
	# defer audit fix
}

electron-app_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:${PATH}"
	node .electron-vue/dev-runner.js || die
	node .electron-vue/build.js || die
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "build/icons/256x256.png" "${MY_PN}" \
		"Office" \
"/usr/$(get_libdir)/node/${PN}/${SLOT}/build/linux-unpacked/epic-journal"
}
