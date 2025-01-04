# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -A DL_REVISIONS=(
	["chromium-linux-glibc-amd64"]="1064"
	["chromium-with-symbols-linux-glibc-amd64"]="1064"
	["chromium-tip-of-tree-linux-glibc-amd64"]="1111"
	["ffmpeg-linux-glibc-amd64"]="1009"
	["firefox-linux-glibc-amd64-ubuntu-20_04"]="1408"
	["firefox-beta-linux-glibc-amd64-ubuntu-20_04"]="1410"
	["webkit-linux-glibc-amd64-ubuntu-20_04"]="1848"
)
EPLAYRIGHT_ALLOW_BROWSERS=(
	"chromium"
	"firefox"
	"webkit"
)
MY_PN="${PN//-cli/}"
NODE_ENV="development"
NODE_VERSION=18 # Using nodejs muxer variable name.
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
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-with-symbols"( |$) ]] ; then
	SRC_URI+="
		chromium-with-symbols? (
			amd64? (
				kernel_linux? (
					elibc_glibc? (
https://playwright.azureedge.net/builds/chromium/${DL_REVISIONS[chromium-with-symbols-linux-glibc-amd64]}/chromium-with-symbols-linux.zip
	-> chromium-with-symbols-linux-${DL_REVISIONS[chromium-with-symbols-linux-glibc-amd64]}-amd64.zip
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
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-20_04]}/firefox-ubuntu-20.04.zip
	-> firefox-ubuntu-20.04-${DL_REVISIONS[firefox-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
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
https://playwright.azureedge.net/builds/firefox/${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-20_04]}/firefox-beta-ubuntu-20.04.zip
	-> firefox-beta-ubuntu-20.04-${DL_REVISIONS[firefox-beta-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
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
https://playwright.azureedge.net/builds/webkit/${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-20_04]}/webkit-ubuntu-20.04.zip
	-> webkit-ubuntu-20.04-${DL_REVISIONS[webkit-linux-glibc-amd64-ubuntu-20_04]}-amd64.zip
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
			chromium-114.0.5735.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-tip-of-tree? (
			BSD
			chromium-115.0.5750.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-with-symbols"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		chromium-with-symbols? (
			BSD
			chromium-114.0.5735.x
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox? (
			BSD
			FF-113.0-THIRD-PARTY-LICENSES
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	THIRD_PARTY_LICENSES+="
		firefox-beta? (
			BSD
			FF-114.0-THIRD-PARTY-LICENSES
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
IUSE+="clipboard ebuild_revision_4"
REQUIRED_USE+="
	^^ (
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

check_network_sandbox() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download a web browser."
eerror
		die
	fi
}

enpx() {
einfo "Running:  npx ${@}"
	npx "${@}" || die
}

get_ffmpeg_tarball_name() {
	echo "ffmpeg-linux-${DL_REVISIONS[ffmpeg-linux-glibc-${ABI}]}-${ABI}.zip"
}

get_browser_tarball_name() {
	if has chromium ${IUSE} && use chromium ; then
		echo "chromium-linux-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has chromium-with-symbols ${IUSE} && use chromium-with-symbols ; then
		echo "chromium-with-symbols-linux-${DL_REVISIONS[chromium-with-symbols-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has chromium-tip-of-tree-linux ${IUSE} && use chromium-tip-of-tree-linux ; then
		echo "chromium-tip-of-tree-linux-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has firefox ${IUSE} && use firefox ; then
		echo "firefox-ubuntu-20.04-${DL_REVISIONS[firefox-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has firefox-beta ${IUSE} && use firefox-beta ; then
		echo "firefox-beta-ubuntu-20.04-${DL_REVISIONS[firefox-beta-linux-glibc-${ABI}]}-${ABI}.zip"
	elif has webkit ${IUSE} && use webkit ; then
		echo "webkit-ubuntu-20.04-${DL_REVISIONS[webkit-linux-glibc-${ABI}]}-${ABI}.zip"
	else
eerror
eerror "Browser not supported or not selected"
eerror
		die
	fi
}

get_browser_folder_name() {
	if has chromium ${IUSE} && use chromium ; then
		echo "chromium-${DL_REVISIONS[chromium-linux-glibc-${ABI}]}"
	elif has chromium-with-symbols ${IUSE} && use chromium-with-symbols ; then
		echo "chromium_with_symbols-${DL_REVISIONS[chromium-with-symbols-linux-glibc-${ABI}]}"
	elif has chromium-tip-of-tree-linux ${IUSE} && use chromium-tip-of-tree-linux ; then
		echo "chromium_tip_of_tree-${DL_REVISIONS[chromium-tip-of-tree-linux-glibc-${ABI}]}"
	elif has firefox ${IUSE} && use firefox ; then
		echo "firefox-${DL_REVISIONS[firefox-linux-glibc-${ABI}]}"
	elif has firefox-beta ${IUSE} && use firefox-beta ; then
		echo "firefox_beta-${DL_REVISIONS[firefox-beta-linux-glibc-${ABI}]}"
	elif has webkit ${IUSE} && use webkit ; then
		echo "webkit-${DL_REVISIONS[webkit-linux-glibc-${ABI}]}"
	else
eerror
eerror "Browser not supported or not selected"
eerror
		die
	fi
}

npm_update_lock_install_pre() {
	# This is to prevent the sudden ***untrustworthy*** sudo prompt.
	sed -i -e "s|npx playwright|true npx playwright|g" package.json || die
}

npm_update_lock_audit_post() {
einfo "Applying mitigation"
	patch_edits() {
		sed -i -e "s|\"phin\": \"^2.9.1\"|\"phin\": \"^3.7.1\"|g" "package-lock.json" || die
	}
	patch_edits

	# ID = Information Disclosure
	enpm install "phin@^3.7.1" -P		# ID		# GHSA-x565-32qp-m3vf

	patch_edits

	enpm dedupe

	patch_edits
}

npm_unpack_install_post() {
	# See
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/src/server/registry/index.ts#L232
	# https://github.com/microsoft/playwright/blob/v1.34.3/docs/src/browsers.md
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/src/server/registry/nativeDeps.ts
	# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/browsers.json

	local choice
	local x
	for x in ${PLAYWRIGHT_BROWSERS[@]} ; do
		if has ${x} ${IUSE} && use "${x}" ; then
			choice="${x}"
			break
		fi
	done

	if [[ -z "${choice}" ]] ; then
eerror "You must choose a web browser."
		die
	fi
einfo "choice: ${choice}"

	if use chromium ; then
		mkdir -p "node_modules/playwright-core/.local-browsers"
	fi

	# https://github.com/microsoft/playwright/blob/v1.34.3/docs/src/browsers.md#hermetic-install
	export PLAYWRIGHT_BROWSERS_PATH=0
	cd "${S}" || die
	# The sandbox doesn't want us to download even though it is permitted.
	export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
	export PLAYWRIGHT_SKIP_BROWSER_GC=1
	local d="node_modules/playwright-core/.local-browsers/$(get_browser_folder_name)"
	mkdir -p "${d}" || die
	touch "${d}/INSTALLATION_COMPLETE" || die

	cd "${S}/${d}" || die
	unpack $(get_browser_tarball_name)
	if use chromium \
		|| use chromium-with-symbols \
		|| use chromium-tip-of-tree ; then
		local d="node_modules/playwright-core/.local-browsers/ffmpeg-${DL_REVISIONS[ffmpeg-linux-glibc-amd64]}"
		mkdir -p "${d}" || die
		cd "${d}" || die
		touch "INSTALLATION_COMPLETE" || die
		unpack $(get_ffmpeg_tarball_name)
	fi
	cd "${S}" || die
	if [[ ! -e "node_modules/playwright-core/.local-browsers" ]] ; then
eerror
eerror "Missing node_modules/playwright-core/.local-browsers"
eerror
		die
	fi
	enpx playwright install ${choice}
}

pkg_setup() {
	check_network_sandbox
	npm_pkg_setup
}

src_compile() {
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
ewarn
ewarn "This package should be re-installed every week since it uses an old browser."
ewarn
	fperms 0755 "${NPM_INSTALL_PATH}/dist/cli.js"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.0.0 (20230604)
