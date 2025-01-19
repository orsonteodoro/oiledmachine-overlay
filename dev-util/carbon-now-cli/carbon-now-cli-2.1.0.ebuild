# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_TYPES_NODE_PV="18.16.3"
declare -A DL_REVISIONS=(
# See lockfile for playwright version
# See https://github.com/microsoft/playwright/blob/v1.49.1/packages/playwright-core/browsers.json
# See https://github.com/microsoft/playwright/blob/v1.49.1/packages/playwright-core/src/server/registry/index.ts#L231
	["chromium-linux-glibc-amd64"]="1148"
	["chromium-headless-shell-linux-glibc-amd64"]="1148"
	["chromium-tip-of-tree-linux-glibc-amd64"]="1148"
	["ffmpeg-linux-glibc-amd64"]="1010"
	["firefox-linux-glibc-amd64-ubuntu-24_04"]="1466"
	["firefox-beta-linux-glibc-amd64-ubuntu-24_04"]="1466"
	["webkit-linux-glibc-amd64-ubuntu-24_04"]="2104"
)
EPLAYRIGHT_ALLOW_BROWSERS=(
# https://github.com/mixn/carbon-now-cli/blob/v2.1.0/src/views/default.view.ts#L23
	"chromium"			# EOL
#	"chromium-tip-of-tree"
	"firefox"			# EOL
#	"firefox-beta"			# EOL
	"webkit"
)
MY_PN="${PN//-cli/}"
NODE_ENV="development"
NODE_VERSION=${AT_TYPES_NODE_PV%%.*} # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}"

inherit desktop npm playwright

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium" ]] ; then
	SRC_URI+="
		amd64? (
			kernel_linux? (
				elibc_glibc? (
https://playwright.azureedge.net/builds/ffmpeg/${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}/ffmpeg-linux.zip
	-> ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}-amd64.zip
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	SRC_URI+="
		chromium? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium/${DL_REVISIONS[chromium-linux-glibc-amd64]}/chromium-linux.zip
	-> chromium-linux-${DL_REVISIONS[chromium-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-headless-shell"( |$) ]] ; then
	SRC_URI+="
		chromium-headless-shell? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium/${DL_REVISIONS[chromium-headless-shell-linux-glibc-amd64]}/chromium-headless-shell-linux.zip
	-> chromium-headless-shell-linux-${DL_REVISIONS[chromium-headless-shell-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	SRC_URI+="
		chromium-tip-of-tree? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium-tip-of-tree/${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-amd64]}/chromium-tip-of-tree-linux.zip
	-> chromium-tip-of-tree-linux-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-amd64]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	SRC_URI+="
		firefox? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-24_04]}/firefox-ubuntu-24.04.zip
	-> firefox-ubuntu-24.04-${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-24_04]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	SRC_URI+="
		firefox-beta? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-24_04]}/firefox-beta-ubuntu-24.04.zip
	-> firefox-beta-ubuntu-24.04-${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-24_04]}-amd64.zip
					)
				)
			)
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	SRC_URI+="
		webkit? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/webkit/${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-24_04]}/webkit-ubuntu-24.04.zip
	-> webkit-ubuntu-24.04-${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-24_04]}-amd64.zip
					)
				)
			)
		)
	"
fi


DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
# There are more licenses.
THIRD_PARTY_LICENSES=""
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium? (
			BSD
			chromium-131.0.6778.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-tip-of-tree? (
			BSD
			chromium-132.0.6834.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-headless-shell"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-headless-shell? (
			BSD
			chromium-131.0.6778.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox? (
			BSD
			FF-132.0-THIRD-PARTY-LICENSES
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox-beta? (
			BSD
			FF-132.0-THIRD-PARTY-LICENSES
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		webkit? (
			BSD
		)
	"
fi
LICENSE="
	${THIRD_PARTY_LICENSES}
	MIT
"
SLOT="0"
IUSE+="+chromium clipboard ebuild_revision_6"
REQUIRED_USE+="
	|| (
		${PLAYWRIGHT_BROWSERS[@]}
	)
"
NODEJS_PV="18"
RDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	sys-kernel/mitigate-id
	clipboard? (
		x11-misc/xclip
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=net-libs/nodejs-${NODEJS_PV}:${NODE_VERSION}
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"

enpx() {
einfo "Running:  npx ${@}"
	npx "${@}" || die
}

npm_update_lock_install_pre() {
	# This is to prevent the sudden ***untrustworthy*** sudo prompt.
	sed -i -e "s|npx playwright|true npx playwright|g" package.json || die
}

npm_update_lock_audit_post() {
einfo "Applying mitigation"
	patch_edits() {
		sed -i -e "s|\"phin\": \"^2.9.1\"|\"phin\": \"^3.7.1\"|g" "package-lock.json" || die
		sed -i -e "s|\"phin\": \"^2.9.3\"|\"phin\": \"^3.7.1\"|g" "package-lock.json" || die
	}
	patch_edits

	# ID = Information Disclosure
	enpm install "phin@^3.7.1" -P --prefer-offline		# ID		# GHSA-x565-32qp-m3vf

	patch_edits

	enpm dedupe

	patch_edits
}

_unpack_playwright() {
	local u="${1}"
	local rel_path="${2}"
	local tarball_name="${3}"
	has "${u}" ${IUSE} || return
	use "${u}" || return
	mkdir -p "${S}/${rel_path}" || die
	pushd "${S}/${rel_path}" >/dev/null 2>&1 || die
		touch "INSTALLATION_COMPLETE" || die
		touch "DEPENDENCIES_VALIDATED" || die
		unpack "${tarball_name}"
	popd >/dev/null 2>&1 || die
}

npm_unpack_install_post() {
	# See
	# https://github.com/microsoft/playwright/blob/v1.49.1/packages/playwright-core/src/server/registry/index.ts#L232
	# https://github.com/microsoft/playwright/blob/v1.49.1/docs/src/browsers.md
	# https://github.com/microsoft/playwright/blob/v1.49.1/packages/playwright-core/src/server/registry/nativeDeps.ts
	# https://github.com/microsoft/playwright/blob/v1.49.1/packages/playwright-core/browsers.json

	local L=()
	local choice
	local x
	for x in ${PLAYWRIGHT_BROWSERS[@]} ; do
		if has ${x} ${IUSE} && use "${x}" ; then
			L+=( "${x}" )
			break
		fi
	done

	# https://github.com/microsoft/playwright/blob/v1.49.1/docs/src/browsers.md#hermetic-install
	export PLAYWRIGHT_BROWSERS_PATH=0
	cd "${S}" || die
	# The sandbox doesn't want us to download even though it is permitted.
	export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
	export PLAYWRIGHT_SKIP_BROWSER_GC=1
	local d_base="node_modules/playwright-core/.local-browsers"

	_unpack_playwright "chromium" "${d_base}/chromium-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}" "chromium-linux-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}-${ABI}.zip"
	_unpack_playwright "chromium" "${d_base}/chromium_headless_shell-${DL_REVISIONS[chromium-headless-shell-linux-glibc-${ABI}]}" "chromium-headless-shell-linux-${DL_REVISIONS[chromium-headless-shell-linux-glibc-${ABI}]}-${ABI}.zip"
	_unpack_playwright "chromium" "${d_base}/ffmpeg-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}" "ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-${ABI}]}-${ABI}.zip"

	_unpack_playwright "chromium-tip-of-tree" "chromium_tip_of_tree-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}" "chromium-tip-of-tree-linux-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}-${ABI}.zip"
	_unpack_playwright "chromium-tip-of-tree" "${d_base}/ffmpeg-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}" "ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-${ABI}]}-${ABI}.zip"

	_unpack_playwright "firefox" "${d_base}/firefox-${DL_REVISIONS[firefox-linux-glibc-${ABI}-ubuntu-24_04]}" "firefox-ubuntu-24.04-${DL_REVISIONS[firefox-linux-glibc-${ABI}-ubuntu-24_04]}-${ABI}.zip"

	_unpack_playwright "firefox-beta" "${d_base}/firefox_beta-${DL_REVISIONS[firefox-linux-glibc-${ABI}-ubuntu-24_04]}" "firefox-beta-ubuntu-24.04-${DL_REVISIONS[firefox-beta-linux-glibc-${ABI}-ubuntu-24_04]}-${ABI}.zip"

	_unpack_playwright "webkit" "${d_base}/webkit_ubuntu24.04_x64_special-${DL_REVISIONS[webkit-linux-glibc-${ABI}-ubuntu-24_04]}" "webkit-ubuntu-24.04-${DL_REVISIONS[webkit-linux-glibc-${ABI}-ubuntu-24_04]}-${ABI}.zip"

	cd "${S}" || die
	for x in ${L[@]} ; do
		enpx playwright install ${choice}
	done
}

pkg_setup() {
	npm_pkg_setup
}

src_compile() {
	npm_hydrate
	enpm run build
}

src_install() {
	local NPM_EXE_LIST=(
		$(find . -executable -type f \
			| sort \
			| uniq \
			| grep -v "\.ts$" \
			| grep -v "\.png$" \
			| grep -v "\.fnt$" \
			| grep -v "\.md" \
			| grep -i -v "LICENSE" \
			| sed -e "s|^./||g" \
			| sed -e "/\.husky/d")
	)
	insinto "${NPM_INSTALL_PATH}"
	doins -r *

	local path
	for path in ${NPM_EXE_LIST[@]} ; do
		fperms 0755 "${path}"
	done

	cp "${FILESDIR}/${MY_PN}" "${T}" || die
	sed -i -e "s|__NODE_VERSION__|${NODE_VERSION}|g" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_SKIP_BROWSER_GC=1" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1" \
		"${T}/${MY_PN}" \
		|| die
	sed -i -e "1aexport PLAYWRIGHT_BROWSERS_PATH=0" \
		"${T}/${MY_PN}" \
		|| die
	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	local path
	for path in ${NPM_EXE_LIST[@]} ; do
		fperms 0755 "${NPM_INSTALL_PATH}/${path}"
	done
ewarn "This package contains EOL browsers, you should uninstall it after use."
	fperms 0755 "${NPM_INSTALL_PATH}/dist/cli.js"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.0.0 (20230604)
