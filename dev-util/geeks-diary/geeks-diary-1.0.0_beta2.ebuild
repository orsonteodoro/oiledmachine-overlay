# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]
	>=sys-apps/yarn-1.13.0
	net-misc/curl[curl_ssl_gnutls]"


#ELECTRON_APP_INSTALL_AUDIT="0"

inherit eutils desktop electron-app

PV="${PV//_/-}"
DESCRIPTION="TIL writing tool for programmer"
HOMEPAGE="https://github.com/seokju-na/geeks-diary"
SRC_URI="https://github.com/seokju-na/geeks-diary/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	electron-app_pkg_setup
	if [ ! -L /usr/lib/libcurl-gnutls.so.4 ] ; then
		# Required by nodegit in src_prepare
		# See https://github.com/adaptlearning/adapt-cli/issues/84
		eerror "You must \`ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl-gnutls.so.4\`"
		die
	fi
}

src_prepare() {
	patch -p1 -i "${FILESDIR}"/geeks-diary-1.0.0_beta2-vcs-item_ts-rest-parameter-trailing-comma-fix.patch || die

	# Kept in sync with yarn.lock which CI uses.
	# NPM is not tested which should be.  NPM building is broken for npm install but untested for npm ci.

	ANGULAR_VER="^7.2.0"
	ANGULAR_CLI_VER="^7.2.0"
	ANGULAR_CDK_VER="^7.2.0"
	TS_VER="<3.3.0" # 3.3 required by @angular/compiler-cli
	FLEX_LAYOUT_VER="^7.0.0-beta.23"

	# https://www.npmjs.com/package/@types/jasmine/v/2.8.9
	TYPES_JASMINE_VER="3.3.9" # = TS 3.2
	# https://www.npmjs.com/package/@types/jasminewd2
	TYPES_JASMINEWD2_VER="2.0.6" #= TS 3.2

	TYPES_REMARKABLE_VER="<1.7.1" # hard
	REMARKABLE_VER="^1.7.1"
	BUILD_ANGULAR_VER="^0.6.7" #testing

	WEBPACK_CLI_VER="^3.1.2"
	WEBPACK_VER="^4.20.2"
	NGTOOLS_WEBPACK_VER="^7.2.0" # update to 6.2?

	NGTOOLS_VER="^7.2.0"

	sed -i -e "s|\"typescript\": \"2.7.2\",|\"typescript\": \"${TS_VER}\",|g" package.json || die
	#sed -i -e "s|\"@angular/animations\": \"^6.1.0\",||g" package.json || die # already in angular 7.x
	sed -i -e "s|\"@angular/animations\": \"^6.1.0\",|\"@angular/animations\": \"${ANGULAR_VER}\",|g" package.json || die # already in angular 7.x
	sed -i -e "s|\"@angular/cdk\": \"^6.3.2\",|\"@angular/cdk\": \"${ANGULAR_CDK_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/common\": \"^6.1.0\",|\"@angular/common\": \"${ANGULAR_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/compiler\": \"^6.1.0\",|\"@angular/compiler\": \"${ANGULAR_VER}\",|g" package.json || die

	# must match
	sed -i -e "s|\"@angular/compiler-cli\": \"^6.1.0\",|\"@angular/compiler-cli\": \"${ANGULAR_CLI_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/cli\": \"6.0.7\",|\"@angular/cli\": \"${ANGULAR_CLI_VER}\",|g" package.json || die

	sed -i -e "s|\"@angular/core\": \"^6.1.0\",|\"@angular/core\": \"${ANGULAR_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/forms\": \"^6.1.0\",|\"@angular/forms\": \"${ANGULAR_VER}\",|g" package.json|| die
	sed -i -e "s|\"@angular/language-service\": \"^6.1.0\",|\"@angular/language-service\": \"${ANGULAR_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/platform-browser\": \"^6.1.0\",|\"@angular/platform-browser\": \"${ANGULAR_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/platform-browser-dynamic\": \"^6.1.0\",|\"@angular/platform-browser-dynamic\": \"${ANGULAR_VER}\",|g" package.json || die
	sed -i -e "s|\"@angular/router\": \"^6.1.0\",|\"@angular/router\": \"${ANGULAR_VER}\",|g" package.json || die

	sed -i -e "s|\"@angular-devkit/build-angular\": \"0.6.7\",|\"@angular-devkit/build-angular\": \"${BUILD_ANGULAR_VER}\",|g" package.json || die # in @angular/cli

	sed -i -e "s|\"@angular/flex-layout\": \"6.0.0-beta.16\",|\"@angular/flex-layout\": \"${FLEX_LAYOUT_VER}\",|g" package.json || die

	sed -i -e "s|\"@types/jasmine\": \"^2.8.8\",|\"@types/jasmine\": \"${TYPES_JASMINE_VER}\",|g" package.json || die
	sed -i -e "s|\"@types/jasminewd2\": \"^2.0.3\",|\"@types/jasminewd2\": \"${TYPES_JASMINEWD2_VER}\",|g" package.json || die

	# hard dep
	sed -i -e "s|\"remarkable\": \"^1.7.1\",|\"remarkable\": \"${REMARKABLE_VER}\",|g" package.json || die
	sed -i -e "s|\"@types/remarkable\": \"^1.7.0\",|\"@types/remarkable\": \"${TYPES_REMARKABLE_VER}\",|g" package.json || die

	#sed -i -e "s|\"os\": \"^0.1.1\",|\"os\": \"0.1.1\",|g" package.json || die
	#sed -i -e "s|\"path\": \"^0.12.7\",|\"path\": \"0.12.7\",|g" package.json || die

	sed -i -e "s|\"webpack-cli\": \"^3.0.8\"|\"webpack-cli\": \"${WEBPACK_CLI_VER}\"|g" package.json || die
	sed -i -e "s|\"webpack\": \"^4.14.0\",|\"webpack\": \"${WEBPACK_VER}\",|g" package.json || die

	sed -i -e "s|\"@ngrx/effects\": \"^6.0.1\",|\"@ngrx/effects\": \"${NGTOOLS_VER}\",|g" package.json || die
	sed -i -e "s|\"@ngrx/store\": \"^6.0.1\",|\"@ngrx/store\": \"${NGTOOLS_VER}\",|g" package.json || die
	sed -i -e "s|\"@ngrx/store-devtools\": \"^6.0.1\",|\"@ngrx/store-devtools\": \"${NGTOOLS_VER}\",|g" package.json || die

	# ---

	npm install os --save || die
	npm install stream --save || die
	npm install path --save || die

	electron-app_src_prepare

	npm uninstall @ngtools/webpack || die
	npm install @ngtools/webpack@"${NGTOOLS_WEBPACK_VER}" || die

	# Re-installs because the audit fix breaks it.
	# TypeScript >=3.1.1 and <3.3.0 only
	npm uninstall typescript || die
	npm install typescript@"${TS_VER}" --save || die

	npm uninstall @angular/compiler-cli || die
	npm install @angular/compiler-cli@"${ANGULAR_CLI_VER}" --save || die

	npm uninstall @angular/cli || die
	npm install @angular/cli@"${ANGULAR_CLI_VER}" --save || die

	npm uninstall @angular-devkit/build-angular || die
	npm install @angular-devkit/build-angular@"${BUILD_ANGULAR_VER}" --save || die

	pushd node_modules/@angular-devkit/build-angular
	npm uninstall @ngtools/webpack
	npm install @ngtools/webpack@"${NGTOOLS_WEBPACK_VER}" --save || die
	popd
	npm uninstall @ngtools/webpack
	npm install @ngtools/webpack@"${NGTOOLS_WEBPACK_VER}" --save || die
	npm dedupe

	# fix vulnerability
	pushd node_modules/remarkable
	npm install argparse@"^1.0.10" --save || die
	popd

	patch -F 100 -p1 -i "${FILESDIR}/geeks-diary-angular-devkit-browser-config-fix-0.8.9.patch" || die
}

src_compile() {
	export PATH="${S}/node_modules/.bin:$PATH"

	# test here again. it seems bugged
	grep -r -e "electron-renderer" "${S}/node_modules/@angular-devkit/build-angular/src/angular-cli-files/models/webpack-configs/browser.js" || die "failed to patch"

	electron-app_src_compile
}

src_install() {
	electron-desktop-app-install "*" "src/assets/logos/512x512.png" "${MY_PN}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/dist/main.js"
}
