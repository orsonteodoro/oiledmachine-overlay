# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="55d6998a48eeedc92c3789ba96bea55e3f6cd15f"
NODE_SLOT="20"
NPM_TARBALL="${P}-${EGIT_COMMIT:0:7}.tar.gz"

NPM_EXE_LIST=(
	"/opt/loz/dist/index.js"
	"/opt/loz/node_modules/rimraf/bin.js"
	"/opt/loz/node_modules/typescript/bin/tsc"
	"/opt/loz/node_modules/typescript/bin/tsserver"
	"/opt/loz/node_modules/eslint/bin/eslint.js"
	"/opt/loz/node_modules/@cspotcode/source-map-support/register.d.ts"
	"/opt/loz/node_modules/@cspotcode/source-map-support/source-map-support.d.ts"
	"/opt/loz/node_modules/@cspotcode/source-map-support/register-hook-require.d.ts"
	"/opt/loz/node_modules/ts-node/dist/bin.js"
	"/opt/loz/node_modules/ts-node/dist/bin-esm.js"
	"/opt/loz/node_modules/ts-node/dist/bin-transpile.js"
	"/opt/loz/node_modules/ts-node/dist/bin-cwd.js"
	"/opt/loz/node_modules/ts-node/dist/bin-script-deprecated.js"
	"/opt/loz/node_modules/ts-node/dist/bin-script.js"
	"/opt/loz/node_modules/acorn/bin/acorn"
	"/opt/loz/node_modules/semver/bin/semver.js"
	"/opt/loz/node_modules/prettier/bin/prettier.cjs"
	"/opt/loz/node_modules/openai/bin/cli"
	"/opt/loz/node_modules/which/bin/node-which"
	"/opt/loz/node_modules/he/bin/he"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.js"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.js"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.js.map"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.min.d.ts"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.js.map"
	"/opt/loz/node_modules/uri-js/dist/es5/uri.all.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/index.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/util.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/uri.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/uri.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/index.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/util.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/http.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/https.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/ws.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/wss.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/urn-uuid.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/schemes/mailto.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/index.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/uri.js"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-iri.js.map"
	"/opt/loz/node_modules/uri-js/dist/esnext/util.d.ts"
	"/opt/loz/node_modules/uri-js/dist/esnext/regexps-uri.js.map"
	"/opt/loz/node_modules/js-yaml/bin/js-yaml.js"
	"/opt/loz/node_modules/flat/cli.js"
	"/opt/loz/node_modules/wrap-ansi/index.js"
	"/opt/loz/node_modules/mock-stdin/test/stdin.spec.js"
	"/opt/loz/node_modules/mock-stdin/lib/index.d.ts"
	"/opt/loz/node_modules/mock-stdin/lib/mock/stdin.js"
	"/opt/loz/node_modules/mock-stdin/lib/index.js"
	"/opt/loz/node_modules/mock-stdin/tools/travis.sh"
	"/opt/loz/node_modules/mock-stdin/.travis.yml"
	"/opt/loz/node_modules/mocha/lib/cli/cli.js"
	"/opt/loz/node_modules/mocha/bin/_mocha"
	"/opt/loz/node_modules/mocha/bin/mocha.js"
	"/opt/loz/install.sh"
	"/opt/loz/scripts/prepare-commit-msg"
	"/opt/loz/tools/git_scripts/pre-commit"
	"/opt/loz/bump_version.sh"
)

inherit git-r3 npm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
SRC_URI="
https://github.com/joone/loz/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Loz is a command-line tool that enables your preferred LLM to execute system commands and utilize Unix pipes, integrating AI capabilities with other Unix tools."
LICENSE="
	(
		Apache-2.0
		BSD
		BSD-2
		ISC
		MIT
	)
	(
		CC-BY-4.0
		custom
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		CC-BY-SA-4.0
		ISC
	)
	(
		CC0-1.0
		MIT
	)
	Apache-2.0
	BSD
	BSD-2
	ISC
	MIT
	PSF-2.2
"
# Apache-2.0 - ./node_modules/eslint-visitor-keys/LICENSE
# Apache-2.0 BSD BSD-2 ISC MIT - ./node_modules/prettier/LICENSE
# BSD-2 - ./node_modules/eslint-scope/LICENSE
# BSD - ./node_modules/ts-node/node_modules/diff/LICENSE
# CC-BY-SA-4.0 ISC - ./node_modules/rimraf/node_modules/glob/LICENSE
# CC0-1.0 MIT - ./node_modules/lodash.merge/LICENSE
# ISC - ./node_modules/rimraf/node_modules/minimatch/LICENSE
# MIT - ./node_modules/dir-glob/license
# PSF-2.2 - ./node_modules/argparse/LICENSE
# CC-BY-4.0 custom MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement W3C-Software-and-Document-Notice-and-License - ./node_modules/typescript/ThirdPartyNoticeText.txt
HOMEPAGE="https://github.com/joone/loz"
SLOT="0"
IUSE="codellama llama2 ollama"
REQUIRED_USE="
	ollama? (
		|| (
			codellama
			llama2
		)
	)
"
RDEPEND="
	ollama? (
		codellama? (
			app-misc/ollama[ollama_llms_codellama]
		)
		llama2? (
			app-misc/ollama[ollama_llms_llama2]
		)
	)
"
RESTRICT="mirror"
DOCS=( "README.md" )

npm_update_lock_audit_post() {
	# Fix breaking changes
	enpm add "@types/node@20.11.28" -D
}

src_unpack() {
	npm_src_unpack
}

configure_ollama_support() {
	local name
# Sort by security benchmark score.
	if use llama2 ; then
		name="llama2"
	elif use codellama ; then
		name="codellama"
	else
		name="llama2"
	fi
	sed \
		-i \
		-e "s|DEFAULT_OLLAMA_MODEL = \"llama2\"|DEFAULT_OLLAMA_MODEL = \"${name}\"|g" \
		"src/config/index.ts" \
		|| die
}

src_prepare() {
	default
	if use ollama ; then
		configure_ollama_support
	fi
}

pkg_postinst() {
	if use ollama ; then
		if use codellama ; then
einfo "You still need to download the model, run \`ollama run codellama\` to install."
		fi
		if use llama2 ; then
einfo "You still need to download the model, run \`ollama run llama2\` to install."
		fi
einfo
einfo "You can change the values of ollama.model and model in"
einfo "\"~/.loz/config.json\" to either llama2 or codellama."
einfo
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  TESTING (0.3.1_p20240322, 20241201)
# ls | loz "all rows uppercase" (with yi-coder:1.5b) - failed (produces junk on the top of output and bottom)
# ls | loz "all rows uppercase" (with llama3.2:1b-text-q5_1) - failed (the model variant is poor quality)
