# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

TS_VER="3.2"

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]
	>=sys-apps/yarn-1.13.0
	net-misc/curl[curl_ssl_gnutls]"


ELECTRON_APP_MODE="yarn"

inherit eutils desktop electron-app

PV="${PV//_/-}"
DESCRIPTION="TIL writing tool for programmer"
HOMEPAGE="https://github.com/seokju-na/geeks-diary"
SRC_URI="https://github.com/seokju-na/geeks-diary/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="SECURITY_HAZARD"
REQUIRED_USE="SECURITY_HAZARD"

S="${WORKDIR}/${PN}-${PV}"
RESTRICT="userpriv"

pkg_setup() {
	if use SECURITY_HAZARD ; then
		ewarn "You are building ${PN} without audit fix and checks."
	fi

	electron-app_pkg_setup
	if [ ! -L /usr/lib/libcurl-gnutls.so.4 ] ; then
		# Required by nodegit in src_prepare
		# See https://github.com/adaptlearning/adapt-cli/issues/84
		eerror "You must \`ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl-gnutls.so.4\`"
		die
	fi
}

src_prepare() {
	#rm package-lock.json

	patch -p1 -i "${FILESDIR}"/geeks-diary-1.0.0_beta2-vcs-item_ts-rest-parameter-trailing-comma-fix.patch || die

	if ! use SECURITY_HAZARD ; then
		rm yarn.lock || die

		ANGULAR_VER="^7.2.7"
		ANGULAR_CLI_VER="^7.3.3"
		TS_VER="<3.2.0"
		NGRX_VER="^7.3.0"
		FLEX_LAYOUT_VER="7.0.0-beta.23"

		# https://www.npmjs.com/package/@types/jasmine/v/2.8.9
		TYPES_JASMINE_VER="2.8.9" # = TS 2.7
		REMARKABLE_VER="1.7.1"
		TYPES_REMARKABLE_VER="1.7.0"
		BUILD_ANGULAR_VER="<0.14.0"

		sed -i -e "s|\"typescript\": \"2.7.2\",|\"typescript\": \"${TS_VER}\",|g" package.json || die
		#sed -i -e "s|\"@angular/animations\": \"^6.1.0\",||g" package.json || die # already in angular 7.x
		sed -i -e "s|\"@angular/animations\": \"^6.1.0\",|\"@angular/animations\": \"${ANGULAR_VER}\",|g" package.json || die # already in angular 7.x
		sed -i -e "s|\"@angular/cdk\": \"^6.3.2\",|\"@angular/cdk\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/cli\": \"6.0.7\",|\"@angular/cli\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/common\": \"^6.1.0\",|\"@angular/common\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/compiler\": \"^6.1.0\",|\"@angular/compiler\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/compiler-cli\": \"^6.1.0\",|\"@angular/compiler-cli\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/core\": \"^6.1.0\",|\"@angular/core\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/forms\": \"^6.1.0\",|\"@angular/forms\": \"${ANGULAR_VER}\",|g" package.json|| die
		sed -i -e "s|\"@angular/language-service\": \"^6.1.0\",|\"@angular/language-service\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/platform-browser\": \"^6.1.0\",|\"@angular/platform-browser\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/platform-browser-dynamic\": \"^6.1.0\",|\"@angular/platform-browser-dynamic\": \"${ANGULAR_VER}\",|g" package.json || die
		sed -i -e "s|\"@angular/router\": \"^6.1.0\",|\"@angular/router\": \"${ANGULAR_VER}\",|g" package.json || die

		sed -i -e "s|\"@angular-devkit/build-angular\": \"0.6.7\",|\"@angular-devkit/build-angular\": \"${BUILD_ANGULAR_VER}\",|g" package.json || die # in @angular/cli

		sed -i -e "s|\"@angular/flex-layout\": \"6.0.0-beta.16\",|\"@angular/flex-layout\": \"${FLEX_LAYOUT_VER}\",|g" package.json || die

		sed -i -e "s|\"@ngrx/effects\": \"^6.0.1\",|\"@ngrx/effects\": \"${NGRX_VER}\",|g" package.json || die
		sed -i -e "s|\"@ngrx/store\": \"^6.0.1\",|\"@ngrx/store\": \"${NGRX_VER}\",|g" package.json || die
		sed -i -e "s|\"@ngrx/store-devtools\": \"^6.0.1\",|\"@ngrx/store-devtools\": \"${NGRX_VER}\",|g" package.json || die

		sed -i -e "s|\"@types/jasmine\": \"^2.8.8\",|\"@types/jasmine\": \"${TYPES_JASMINE_VER}\",|g" package.json || die

		sed -i -e "s|\"remarkable\": \"^1.7.1\",|\"remarkable\": \"${REMARKABLE_VER}\",|g" package.json || die
		sed -i -e "s|\"@types/remarkable\": \"^1.7.0\",|\"@types/remarkable\": \"${TYPES_REMARKABLE_VER}\",|g" package.json || die

		# ---

		# missing node modules
		npm install path || die
		npm install stream || die
		npm install os || die

		electron-app_src_prepare

		patch -p1 -i "${FILESDIR}/geeks-diary-angular-devkit-browser-config-fix.patch" || die

		# Re-install it again because the audit fix breaks it.
		# TypeScript >=3.1.1 and <3.3.0 only
		npm uninstall typescript
		npm install typescript@"${TS_VER}"

		grep -r -e "node: false," node_modules/@angular-devkit/build-angular/src/angular-cli-files/models/webpack-configs/browser.js && die "browser.js is not patched."
	else
if false; then
		TS_VER="<2.9.0"
		NGRX_VER="6.0.1"

		# https://www.npmjs.com/package/@types/jasmine/v/2.8.9
		TYPES_JASMINE_VER="2.8.9" # = TS 2.7
		JASMINE_WD2_VER="2.0.3"
		REMARKABLE_VER="1.7.1"
		TYPES_REMARKABLE_VER="1.7.0"
		REMARKABLE_META_VER="1.0.1"

		sed -i -e "s|\"typescript\": \"2.7.2\",|\"typescript\": \"${TS_VER}\",|g" package.json || die
		sed -i -e "s|\"@types/jasmine\": \"^2.8.8\",|\"@types/jasmine\": \"${TYPES_JASMINE_VER}\",|g" package.json || die
		sed -i -e "s|\"@types/jasminewd2\": \"^2.0.3\",|\"@types/jasminewd2\": \"${JASMINE_WD2_VER}\",|g" package.json || die

		sed -i -e "s|\"@types/remarkable\": \"^1.7.0\",|\"@types/remarkable\": \"${TYPES_REMARKABLE_VER}\",|g" package.json || die
		sed -i -e "s|\"remarkable\": \"^1.7.1\",|\"remarkable\": \"${REMARKABLE_VER}\",|g" package.json || die
		sed -i -e "s|\"remarkable-meta\": \"^1.0.1\",|\"remarkable-meta\": \"${REMARKABLE_META_VER}\",|g" package.json || die

		# ---

		eapply_user

		npm install --maxsockets=5 || die
fi
		echo "" > .yarnrc
		electron-app_src_prepare
	fi

}

src_install() {
	electron-desktop-app-install "*" "src/assets/logos/512x512.png" "${MY_PN}" "Development" "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/dist/main.js"
}
