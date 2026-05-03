# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="17.0.1" npm_updater_update_locks.sh

CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO"
NODE_SLOT="22"
NPM_AUDIT_FATAL=0
NPM_INSTALL_PATH="/opt/${PN}"
NPM_TARBALL="prantlf-${P}.tar.gz"
NPM_TEST_SCRIPT="test"
RUST_MAX_VER="1.80.0" # Inclusive
RUST_MIN_VER="1.80.0" # llvm-18.1, required by @swc/core
RUST_PV="${RUST_MIN_VER}"

NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)
NPM_DEDUPE_ARGS=(
	"--legacy-peer-deps"
	"--prefer-offline"
)

# Partially generated from:  find ${NPM_INSTALL_PATH} -path "*/.bin/*" -o -path "*/.bin"
NPM_EXE_LIST=(
	"${NPM_INSTALL_PATH}/lib/cli.js"

	"${NPM_INSTALL_PATH}/node_modules/@semantic-release/github/node_modules/.bin"
	"${NPM_INSTALL_PATH}/node_modules/@semantic-release/github/node_modules/.bin/mime"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/cross-spawn/node_modules/.bin"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/cross-spawn/node_modules/.bin/node-which"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/semver"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/pacote"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/mkdirp"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/arborist"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/glob"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/installed-package-contents"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/cssesc"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-gyp"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/nopt"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/qrcode-terminal"
	"${NPM_INSTALL_PATH}/node_modules/npm/node_modules/.bin/node-which"
	"${NPM_INSTALL_PATH}/node_modules/.bin"
	"${NPM_INSTALL_PATH}/node_modules/.bin/teru"
	"${NPM_INSTALL_PATH}/node_modules/.bin/http-server"
	"${NPM_INSTALL_PATH}/node_modules/.bin/rimraf"
	"${NPM_INSTALL_PATH}/node_modules/.bin/npx"
	"${NPM_INSTALL_PATH}/node_modules/.bin/tsc"
	"${NPM_INSTALL_PATH}/node_modules/.bin/semver"
	"${NPM_INSTALL_PATH}/node_modules/.bin/semantic-release"
	"${NPM_INSTALL_PATH}/node_modules/.bin/marked"
	"${NPM_INSTALL_PATH}/node_modules/.bin/denolint"
	"${NPM_INSTALL_PATH}/node_modules/.bin/mkdirp"
	"${NPM_INSTALL_PATH}/node_modules/.bin/mv-j"
	"${NPM_INSTALL_PATH}/node_modules/.bin/conventional-commits-parser"
	"${NPM_INSTALL_PATH}/node_modules/.bin/rc"
	"${NPM_INSTALL_PATH}/node_modules/.bin/highlight"
	"${NPM_INSTALL_PATH}/node_modules/.bin/he"
	"${NPM_INSTALL_PATH}/node_modules/.bin/tsserver"
	"${NPM_INSTALL_PATH}/node_modules/.bin/rollup"
	"${NPM_INSTALL_PATH}/node_modules/.bin/resolve"
	"${NPM_INSTALL_PATH}/node_modules/.bin/mime"
	"${NPM_INSTALL_PATH}/node_modules/.bin/npm"
	"${NPM_INSTALL_PATH}/node_modules/.bin/js-yaml"
	"${NPM_INSTALL_PATH}/node_modules/.bin/handlebars"
	"${NPM_INSTALL_PATH}/node_modules/.bin/teru-cjs"
	"${NPM_INSTALL_PATH}/node_modules/.bin/uglifyjs"
	"${NPM_INSTALL_PATH}/node_modules/.bin/opener"
	"${NPM_INSTALL_PATH}/node_modules/.bin/conventional-changelog-writer"
	"${NPM_INSTALL_PATH}/node_modules/.bin/c8"
	"${NPM_INSTALL_PATH}/node_modules/.bin/cat-j"
	"${NPM_INSTALL_PATH}/node_modules/.bin/tehanu"
	"${NPM_INSTALL_PATH}/node_modules/.bin/node-which"
	"${NPM_INSTALL_PATH}/node_modules/.bin/teru-esm"
	"${NPM_INSTALL_PATH}/node_modules/.bin/esbuild"
)

inherit npm rust

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/prantlf/jsonlint/archive/refs/tags/v${PV}.tar.gz
	-> prantlf-${P}.tar.gz
"

DESCRIPTION="JSON/CJSON/JSON5 parser, syntax & schema validator and pretty-printer with a command-line client, written in pure JavaScript."
HOMEPAGE="
http://prantlf.github.io/jsonlint/
https://github.com/prantlf/jsonlint
"
LICENSE="MIT"
RESTRICT="mirror test" # Missing dev dependencies
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test ebuild_revision_15"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
	>=net-libs/nodejs-${NODE_SLOT}:${NODE_SLOT}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_SLOT}
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"

pkg_setup() {
	npm_pkg_setup
	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	fi
}

npm_update_lock_audit_post() {
einfo "Applying mitigation"
	patch_edits() {
		sed -i -e "s|\"esbuild\": \"0.23.0\"|\"esbuild\": \"^0.25.0\"|g" "package-lock.json" || die
		sed -i -e "s|\"rollup\": \"4.20.0\"|\"rollup\": \"^4.22.4\"|g" "package-lock.json" || die
		sed -i -e "s|\"ajv\": \"8.17.1\"|\"ajv\": \"^8.18.0\"|g" "package-lock.json" || die
		sed -i -e "s|\"ajv\": \"^8.5.0\"|\"ajv\": \"^8.18.0\"|g" "package-lock.json" || die
		sed -i -e "s|\"ajv\": \"^8.0.0\"|\"ajv\": \"^8.18.0\"|g" "package-lock.json" || die
		sed -i -e "s|\"ajv\": \"^8.8.2\"|\"ajv\": \"^8.18.0\"|g" "package-lock.json" || die
	}
	patch_edits
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# ZC = Zero-click vulnerability
	# VS = Vulnerable System [aka direct attack or immediate affected system]
	# SS = Subsequent System [aka multiple system(s) beyond the direct attack]
	local L
	L=(
		"esbuild@0.25.0"	# GHSA-67mh-4wv8-2f99; ID; Moderate
		"rollup@^4.22.4"	# CVE-2024-47068; ZC, VS(DoS, DT, ID); High
	)
	enpm install "${L[@]}" -D "${NPM_INSTALL_ARGS[@]}"

	L=(
		"ajv@^8.18.0"		# CVE-2025-69873; ZC, DoS; Moderate
	)
	enpm install "${L[@]}" -P "${NPM_INSTALL_ARGS[@]}"

	patch_edits
}
