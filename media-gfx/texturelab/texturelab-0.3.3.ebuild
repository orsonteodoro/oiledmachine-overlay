# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ELECTRON_APP_ELECTRON_PV="13.6.9"
ELECTRON_APP_VUE_PV="2.6.11"
ELECTRON_APP_MODE="npm"
ELECTRON_APP_SKIP_EXIT_CODE_CHECK="1"
NODE_ENV="development"
NODE_VERSION="16" # 14
NPM_INSTALL_PATH="/opt/${PN}"
PYTHON_COMPAT=( python3_{8..10} )

inherit desktop electron-app lcnr python-r1 npm

DESCRIPTION="Free, Cross-Platform, GPU-Accelerated Procedural Texture Generator"
HOMEPAGE="
https://njbrown.itch.io/texturelab
https://github.com/njbrown/texturelab
"

ELECTRON_CHROMEDRIVER_LICENSES="
	(
		custom
		( HPND all-rights-reserved )
		( MIT all-rights-reserved )
		( public-domain BSD )
		BSD
		CPL-1.0
		FTL
		GPL-3.0
		icu-1.8.1
		IJG
		ISC
		LGPL-2.1
		LGPL-3.0
		libpng
		libstdc++
		MIT
		MPL-1.1
		MPL-2.0
		openssl
		trio
		unicode
		ZLIB
		|| ( LGPL-2.1 LGPL-2.1+ )
	)
	( IJG BSD ZLIB )
	( ISC all-rights-reserved no-advertising )
	( HPND all-rights-reserved )
	( MIT all-rights-reserved )
	( UoI-NCSA MIT )
	( || ( LGPL-2.1+ GPL-2+ ) LGPL-2.1+ BSD MIT )
	all-rights-reserved
	custom
	android
	Apache-2.0
	APSL-2
	AFL-2.0
	BitstreamVera
	BSD
	BSD-2
	BSD-4
	BSD-Protection
	curl
	FTL
	GPL-2
	GPL-2-with-classpath-exception
	icu-71.1
	GPL-3
	libpng
	IJG
	ISC
	LGPL-2.1
	LGPL-3.0+
	MIT
	MPL-1.1
	MPL-2.0
	Ms-PL
	openssl
	OFL-1.1
	Prior-BSD-License
	SunPro
	unRAR
	UoI-NCSA
	libwebm-PATENTS
	|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )
"


THIRD_PARTY_LICENSES="
	${ELECTRON_APP_LICENSES}
	${ELECTRON_CHROMEDRIVER_LICENSES}
	( Apache-2.0 all-rights-reserved )
	( custom MIT all-rights-reserved )
	( custom MIT ( MIT all-rights-reserved ) )
	( custom OFL )
	( MIT all-rights-reserved )
	( MIT CC0-1.0 )
	( MIT svgo )
	( ISC CC-BY-SA-4.0 )
	( WTFPL-2 MIT )
	( MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement CC-BY-4.0 W3C-Software-and-Document-Notice-and-License )
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC0-1.0
	custom
	ISC
	LGPL-3.0
	MagentaMgOpen
	MIT
	MPL-2.0
	Unlicense
	WTFPL-2
	|| ( BSD GPL-2 )
	|| ( ISC MIT )
	|| ( MIT GPL-3 )
"
LICENSE="
	GPL-3+
	${THIRD_PARTY_LICENSES}
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( Apache-2.0 all-rights-reserved ) - node_modules/typescript/CopyrightNotice.txt
# ( custom, MIT, all-rights-reserved ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( MIT all-rights-reserved ) - node_modules/spdy-transport/node_modules/readable-stream/LICENSE
# ( MIT all-rights-reserved ) - texturelab-0.3.3/node_modules/convert-source-map/LICENSE
# ( MIT all-rights-reserved ) - node_modules/xml2js/LICENSE
# ( MIT all-rights-reserved ) - node_modules/http-parser-js/LICENSE.md
# ( MIT all-rights-reserved ) - node_modules/@types/eslint-visitor-keys/LICENSE
# ( MIT CC0-1.0 ) - node_modules/lodash.throttle/LICENSE
# ( ISC CC-BY-SA-4.0 ) - node_modules/glob/LICENSE
# ( WTFPL-2 MIT ) - node_modules/path-is-inside/LICENSE.txt
# ( MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement CC-BY-4.0 W3C-Software-and-Document-Notice-and-License ) - node_modules/typescript/ThirdPartyNoticeText.txt
# 0BSD - node_modules/tslib/LICENSE.txt
# Apache-2.0 - node_modules/watch/LICENSE
# BSD
# BSD-2 - node_modules/@vue/cli-plugin-eslint/node_modules/eslint-scope/LICENSE
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# CC0-1.0 - node_modules/csso/node_modules/mdn-data/LICENSE
# custom - node_modules/node-notifier/vendor/terminal-notifier-LICENSE
# custom, MIT, ( MIT all-rights-reserved ) - node_modules/image-q/LICENSE
#   search "indirectly, is granted, free of charge, a full and unrestricted irrevocable"
# custom [Free Font License], OFL - node_modules/image-q/demo/html/lib/webix/fonts/font-license.txt
# GPL-3+ - LICENSE
# ISC - node_modules/sharp/node_modules/semver/LICENSE
# LGPL-3.0 - node_modules/node-notifier/vendor/snoreToast/LICENSE
# MagentaMgOpen - node_modules/three-orbitcontrols-ts/node_modules/three/examples/fonts/LICENSE
# MIT
# MIT, svgo - node_modules/svgo/LICENSE
# MPL-2.0 - node_modules/webpack-chain/LICENSE
# Unlicense - node_modules/tweetnacl/LICENSE
# WTFPL-2 - node_modules/svg2png/LICENSE.txt
# || ( BSD GPL-2 ) - node_modules/node-forge/LICENSE
# || ( ISC MIT ) - node_modules/abbrev/LICENSE
# || ( MIT GPL-3 ) - node_modules/jszip/LICENSE.markdown

# custom \
#   ( HPND all-rights-reserved ) \
#   ( ISC all-rights-reserved no-advertising ) \
#   ( custom MPL-2.0 BSD || ( LGPL-2.1 LGPL-2.1+ ) GPL-3.0 LGPL-3.0 FTL MIT \
#     Mark's-copyright SGI-Free-B BSD LGPL-2 CPL-1.0 LGPL-2.1 icu-1.8.1 \
#     unicode ( MIT all-rights-reserved ) IJG ISC trio ZLIB openssl PCRE8[BSD] \
#     libpng libstdc++ ( public-domain BSD ) ( HPND all-rights-reserved ) \
#     MPL-1.1 ) \
#   ( MIT all-rights-reserved ) \
#   ( UoI-NCSA MIT ) \
#   ( IJG BSD ZLIB ) \
#   ( || ( LGPL-2.1+ GPL-2+ ) LGPL-2.1+ BSD MIT ) \
#   all-rights-reserved \
#   custom \
#     search: "to anyone/anything when using this software" \
#     search: "license to install, copy and use the SDK solely as necessary for" \
#     search: "and this permission notice appear in all copies, and that the names of" \
#     search: "all paragraphs of this notice appear in all copies, and that the" \
#     search: "copyright notice and this permission notice appear in all copies, and that" \
#   android \
#   Apache-2.0 \
#   APSL-2 \
#   AFL-2.0 (Academic Free License) \
#   BitstreamVera \
#   BSD \
#   BSD-2 \
#   BSD-4 \
#   BSD-Protection \
#   CC∅ Public Domain Affirmation and Waiver 1.0 - https://www.creativecommons.org/licenses/zero-waive/1.0/us/legalcode \
#   curl \
#   FTL \
#   GPL-2 \
#   GPL-2-with-classpath-exception \
#   icu-71.1 \
#   GPL-3 \
#   libpng \
#   IJG \
#   ISC \
#   LGPL-2.1 \
#   LGPL-3.0+ \
#   MIT \
#   MPL-1.1 \
#   MPL-2.0 \
#   Ms-PL \
#   newlib-extras \
#   openssl \
#   OFL-1.1 \
#   Prior-BSD-License \
#   SunPro \
#   unRAR \
#   UoI-NCSA \
#   libwebm-PATENTS \
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   node_modules/electron-chromedriver/bin/LICENSES.chromium.html

KEYWORDS="~amd64"
SLOT="0"
IUSE+=" system-vips r1"
REQUIRED_USE="
!wayland X
"
# wayland error:  /usr/bin/texturelab: line 13: 2993280 Trace/breakpoint trap
SHARP_DEPENDS="
	>=net-libs/nodejs-14.15:${NODE_VERSION}
	system-vips? (
		>=media-libs/vips-8.13.3[png,jpeg,tiff]
	)
" # For vips version see https://github.com/lovell/sharp/blob/main/package.json#L158
RDEPEND+="
	${SHARP_DEPENDS}
"
RDEPEND+="
	${DEPEND}
"
NODE_GYP_BDEPENDS="
	${PYTHON_DEPS}
	sys-devel/gcc
	sys-devel/make
"
BDEPEND+="
	${NODE_GYP_BDEPENDS}
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
TEXTURELABDATA_COMMIT="eed449f3f9abe8f17ae354ab4cb9932272c7811b"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/media-gfx/texturelab-0.3.3/work/texturelab-0.3.3/npm.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
"
# UPDATER_END_NPM_EXTERNAL_URIS
PHANTOMJS_PV="2.1.1"
SENTRY_CLI_PV="1.75.0"
SHARP_PV=""
VIPS_PV="8.11.3"
SRC_URI="
$(electron-app_gen_electron_uris)
${NPM_EXTERNAL_URIS}
https://github.com/njbrown/texturelab/archive/v${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
https://github.com/njbrown/texturelabdata/archive/${TEXTURELABDATA_COMMIT}.tar.gz
	-> ${PN}data-${TEXTURELABDATA_COMMIT:0:7}.tar.gz
https://github.com/Medium/phantomjs/releases/download/v${PHANTOMJS_PV}/phantomjs-${PHANTOMJS_PV}-linux-x86_64.tar.bz2
https://downloads.sentry-cdn.com/sentry-cli/${SENTRY_CLI_PV}/sentry-cli-Linux-x86_64 -> sentry-cli-Linux-x86_64.${SENTRY_CLI_PV}
https://github.com/lovell/sharp-libvips/releases/download/v${VIPS_PV}/libvips-${VIPS_PV}-linux-x64.tar.br
"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
MY_PN="TextureLab"

__npm_run() {
	local cmd=( "${@}" )
einfo "Running:\t${cmd[@]}"
	"${cmd[@]}" || die
	if [[ "${ELECTRON_APP_SKIP_EXIT_CODE_CHECK}" == "1" ]] ; then
		:;
	elif grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi
}

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download micropackages and obtain version releases"
eerror "information."
eerror
		die
	fi
}

pkg_setup() {
	if use system-vips ; then
		if has_version "media-libs/vips[-graphicsmagick,-imagemagick]" ; then
eerror
eerror "media-libs/vips requires imagemagick or graphicsmagick USE flag"
eerror
			die
		fi
	fi

	# Online is still required for Electron based packages.
	check_network_sandbox

	npm_pkg_setup
}

cp_sentry_cli() {
	local dest
	local arch
	local plat
	local suffix
	# See https://github.com/getsentry/sentry-cli/releases/tag/1.17.0
	if use kernel_linux ; then
		plat="Linux"
	elif use kernel_Darwin ; then
		plat="Darwin"
	elif use kernel_Winnt ; then
		plat="Windows"
		suffix=".exe"
	fi
	if use amd64 || use x64-macos ; then
		arch="x86_64"
	elif use x86 || use x86-winnt ; then
		arch="i686"
	fi
	export SENTRYCLI_USE_LOCAL=1
	dest="${WORKDIR}/bin"
	mkdir -p "${dest}"
	export PATH="${dest}:${PATH}"
	cat \
		"${DISTDIR}/sentry-cli-${plat}-${arch}.${SENTRY_CLI_PV}" \
		> \
		"${dest}/sentry-cli" \
		|| die
	chmod +x "${dest}/sentry-cli"
}

cp_phantomjs() {
	local dest
	dest="${T}/phantomjs"
	# https://github.com/Medium/phantomjs/releases/tag/v2.1.1
	local plat
	local zip_format
	if use kernel_linux ; then
		plat="linux"
	elif use kernel_Darwin ; then
		plat="macosx"
	elif use kernel_Winnt ; then
		plat="windows"
	fi
	if use kernel_linux && use amd64 ; then
		arch="-x86_64"
	elif use kernel_linux && use x86 ; then
		arch="-i686"
	fi
	if use kernel_Winnt ; then
		zip_format="zip"
	else
		zip_format="tar.bz2"
	fi
	mkdir -p "${dest}" || die
	cp -a \
		"${DISTDIR}/phantomjs-${PHANTOMJS_PV}-${plat}${arch}.${zip_format}" \
		"${dest}" \
		|| die
}

cp_assets() {
	local dest
	dest="${S}/public/assets"
	cd "${WORKDIR}" || die
	unpack "${PN}data-${TEXTURELABDATA_COMMIT:0:7}.tar.gz"
	rm -rf "${dest}" || die
	mkdir -p "${dest}" || die
	cp -aT \
		"${WORKDIR}/${PN}data-${TEXTURELABDATA_COMMIT}" \
		"${dest}" \
		|| die
}

cp_sharp_deps() {
	local dest
	dest="${T}/sharp-deps"
#	export sharp_libvips_local_prebuilds="${T}/sharp-deps"
	mkdir -p "${dest}" || die
#	cat \
#		"${DISTDIR}/libvips-${VIPS_PV}-linux-x64.tar.br" \
#		> \
#		"${dest}/libvips-${VIPS_PV}-linux-x64.tar.br" \
#		|| die

	export sharp_local_prebuilds="${T}/sharp-deps"
	mkdir -p "${dest}" || die
	cat \
		"${DISTDIR}/libvips-${VIPS_PV}-linux-x64.tar.br" \
		> \
		"${dest}/libvips-${VIPS_PV}-linux-x64.tar.br" \
		|| die
}

add_deps() {
	cd "${S}" || die
	export SHARP_IGNORE_GLOBAL_LIBVIPS=1
	if use system-vips ; then
		export SHARP_IGNORE_GLOBAL_LIBVIPS=0
		#__npm_run npm add "node-gyp@9.3.1"
	fi
}

__npm_run() {
	local cmd=( "${@}" )
	local tries

	tries=0
	while (( ${tries} < 5 )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\t${cmd[@]}"
		"${cmd[@]}" || die
		if ! grep -q -r -e "ERR_SOCKET_TIMEOUT" "${HOME}/.npm/_logs" ; then
			break
		fi
		rm -rf "${HOME}/.npm/_logs"
		tries=$((${tries} + 1))
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

src_unpack() {
eerror "This ebuild is currently under maintenance."
die
        if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
                unpack ${P}.tar.gz
                cd "${S}" || die
                rm package-lock.json
		rm yarn.lock

		__npm_run npm i --legacy-peer-deps
		__npm_run npm audit fix

	# Fix the following upgrade breakage manually by downgrading:

	# Change to ^2.6.10 afterwards.
		npm upgrade "vue@2.6.x" || die

	# change to ^2.6.10 afterwards.
		npm upgrade "vue-template-compiler@2.6.x" || die

	# Change to ^3.0.3 afterwards.
		npm upgrade "vue-router@3.3.x" || die

	# Change to ^0.6.2 afterwards.
		npm upgrade "vue-toast-notification@0.6.2" || die

		__npm_run npm audit fix --legacy-peer-deps || die

		die
        else
		#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		mkdir -p "${S}" || die
		cp -a "${FILESDIR}/${PV}/package.json" "${S}" || die
		cp_sharp_deps
		cp_phantomjs
		cp_sentry_cli
		npm_src_unpack
		cp_assets
		add_deps
        fi
}

src_prepare() {
	default
	cd "${S}" || die
	if use system-vips ; then
		eapply "${FILESDIR}/texturelab-0.3.3-node-gyp-openssl_fips.patch"
		export ELECTRON_APP_SKIP_EXIT_CODE_CHECK=0
	fi
}

src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	NODE_VERSION="16"
	electron-app_cp_electron
	__npm_run npm electron:build --publish=never
}

src_install() {
	insinto "${NPM_INSTALL_PATH}"
	doins -r "dist_electron/linux-unpacked/"*
	fperms 0755 "${NPM_INSTALL_PATH}/texturelab"
	electron-app_gen_wrapper \
		"${PN}" \
		"${NPM_INSTALL_PATH}/${PN}"
	newicon "src/assets/logo.png" "${PN}.png"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Graphics;2DGraphics"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
