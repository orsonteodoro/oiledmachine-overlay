# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="TypeScript"

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="7.0.2" npm_updater_update_locks.sh

# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_SLOT="24" # Same as major version of NPM_SECAUDIT_AT_TYPES_NODE_PV
NPM_AUDIT_FATAL=0
NPM_INSTALL_PATH="/opt/${PN}/${PV}"

NPM_SECAUDIT_AT_TYPES_NODE_PV="25.5.0"

NPM_EXE_LIST=(
	"${NPM_INSTALL_PATH}/bin/tsc"
	"${NPM_INSTALL_PATH}/bin/tsserver"
)

NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)

NPM_DEDUPE_ARGS=(
	"--prefer-offline"
)

NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

inherit secure-version secure-version-node npm

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="TypeScript is a statically typed superset of JavaScript that \
compiles to clean JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	CC-BY-4.0
	MIT
	Unicode-DFS-2016
	W3C-Community-Final-Specification-Agreement
	W3C-Software-and-Document-Notice-and-License-2015
"
# TODO:  Inspect downloaded dependencies
# (Apache-2.0 all-rights-reserved) - CopyrightNotice.txt
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
RESTRICT="mirror"
SLOT=$(ver_cut "1-2" "${PV}")"/${PV}"
IUSE+="
test ebuild_revision_13
"
RDEPEND+="
	>=net-libs/nodejs-${NODE_SLOT}:${NODE_SLOT}
	app-eselect/eselect-typescript
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_SLOT}[npm]
"

npm_update_lock_install_pre() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		enpm install "@types/node@${NPM_SECAUDIT_AT_TYPES_NODE_PV}" --prefer-offline
	fi
}

npm_update_lock_install_post() {
einfo "QA:  Remove node_modules/mocha/node_modules/serialize-javascript from ${S}/package-lock.json"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		patch_lockfiles() {
			sed -i -e "s|\"esbuild\": \"^0.27.4\"|\"esbuild\": \"^${NODE_ESBUILD_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"fast-xml-parser\": \"^5.5.9\"|\"fast-xml-parser\": \"^${NODE_FAST_XML_PARSER_5_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"serialize-javascript\": \"^6.0.2\"|\"serialize-javascript\": \"^${NODE_SERIALIZE_JAVASCRIPT_PV}\"|g" "package-lock.json" || die
		}

		patch_lockfiles

		local L=(
			"esbuild@^${NODE_ESBUILD_PV}"
			"fast-xml-parser@^${NODE_FAST_XML_PARSER_5_PV}"
			"serialize-javascript@^${NODE_SERIALIZE_JAVASCRIPT_PV}"
		)
		enpm install "${L[@]}" -D "${NPM_AUDIT_FIX_ARGS[@]}"

		patch_lockfiles

		enpm dedupe

		patch_lockfiles
	fi
}

src_install() {
	npm_src_install

	# Move wrappers
	mv "${ED}/usr/bin/tsc" \
		"${ED}/opt/${PN}/${PV}" || die
	mv "${ED}/usr/bin/tsserver" \
		"${ED}/opt/${PN}/${PV}" || die
einfo "Removing npm-packages-offline-cache"
        rm -rf "${ED}/opt/${PN}/npm-packages-offline-cache"
}

pkg_postinst() {
	if eselect typescript list | grep "${PV}" >/dev/null ; then
		eselect typescript set "${PV}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.3 (20230607)
# 87465 passing (17m)

# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.6 (20230709)
#  87478 passing (15m)
#
#Finished do-runtests-parallel in 15m 11.9s

# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.5.2 (20240620)
#12 errors
#Error in lint in 2m 45.1s
#  [▬▬▬▬▬▬▬▬▬▬] ✔ 94798 passing (24m)
#
#
#  94798 passing (24m)

