# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream uses U22

# ELECTRON_APP_ELECTRON_PV is limited by nan
ELECTRON_APP_ELECTRON_PV="30.1.2" # Cr 124.0.6367.243, node 20.14.0.  Original

#ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="18.2.0"
NODE_GYP_PV="10.2.0" # Same as CI
NODE_ENV="development"
NODE_VERSION=18 # Upstream uses in CI 16-20 but 18 is used in release.  Limited by openai-node
NPM_AUDIT_FIX=0
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
)
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)
PYTHON_COMPAT=( "python3_11" ) # Upstream uses python 3.11, but node-gyp 10 requests py3.12.
YARN_ELECTRON_OFFLINE=1
YARN_EXE_LIST="
/usr/bin/theia
/opt/theia/chrome-sandbox
/opt/theia/electron
/opt/theia/libGLESv2.so
/opt/theia/libvk_swiftshader.so
/opt/theia/libEGL.so
/opt/theia/resources/app/plugins/EditorConfig.EditorConfig/extension/node_modules/semver/bin/semver
/opt/theia/resources/app/plugins/EditorConfig.EditorConfig/extension/node_modules/editorconfig/bin/editorconfig
/opt/theia/resources/app/plugins/vscode.git/extension/dist/askpass.sh
/opt/theia/resources/app/plugins/vscode.git/extension/dist/askpass-empty.sh
/opt/theia/resources/app/plugins/vscode.git/extension/dist/git-editor.sh
/opt/theia/resources/app/plugins/vscode.git/extension/dist/ssh-askpass.sh
/opt/theia/resources/app/plugins/vscode.git/extension/dist/git-editor-empty.sh
/opt/theia/resources/app/plugins/vscode.git/extension/dist/ssh-askpass-empty.sh
/opt/theia/libvulkan.so.1
/opt/theia/chrome_crashpad_handler
"
YARN_INSTALL_PATH="/opt/${PN}"
YARN_LOCKFILE_SOURCE="ebuild" # originally upstream
YARN_MULTI_LOCKFILE=1
YARN_OFFLINE=1
YARN_TEST_SCRIPT="test:theia"
declare -A THEIA_PLUGINS=(
["theia_plugin_EditorConfig_EditorConfig"]="EditorConfig.EditorConfig"
["theia_plugin_vscode_css"]="vscode.css"
["theia_plugin_vscode_go"]="vscode.go"
["theia_plugin_vscode_java"]="vscode.java"
["theia_plugin_vscode_markdown-language-features"]="vscode.markdown-language-features"
["theia_plugin_vscode_python"]="vscode.python"
["theia_plugin_vscode_simple-browser"]="vscode.simple-browser"
["theia_plugin_vscode_theme-solarized-light"]="vscode.theme-solarized-light"
["theia_plugin_dbaeumer_vscode-eslint"]="dbaeumer.vscode-eslint"
["theia_plugin_vscode_css-language-features"]="vscode.css-language-features"
["theia_plugin_vscode_groovy"]="vscode.groovy"
["theia_plugin_vscode_javascript"]="vscode.javascript"
["theia_plugin_vscode_markdown-math"]="vscode.markdown-math"
["theia_plugin_vscode_r"]="vscode.r"
["theia_plugin_vscode_sql"]="vscode.sql"
["theia_plugin_vscode_theme-tomorrow-night-blue"]="vscode.theme-tomorrow-night-blue"
["theia_plugin_eclipse-theia_builtin-extension-pack"]="eclipse-theia.builtin-extension-pack"
["theia_plugin_vscode_dart"]="vscode.dart"
["theia_plugin_vscode_grunt"]="vscode.grunt"
["theia_plugin_vscode_json"]="vscode.json"
["theia_plugin_vscode_media-preview"]="vscode.media-preview"
["theia_plugin_vscode_razor"]="vscode.razor"
["theia_plugin_vscode_swift"]="vscode.swift"
["theia_plugin_vscode_tunnel-forwarding"]="vscode.tunnel-forwarding"
["theia_plugin_ms-vscode_js-debug"]="ms-vscode.js-debug"
["theia_plugin_vscode_debug-auto-launch"]="vscode.debug-auto-launch"
["theia_plugin_vscode_gulp"]="vscode.gulp"
["theia_plugin_vscode_json-language-features"]="vscode.json-language-features"
["theia_plugin_vscode_merge-conflict"]="vscode.merge-conflict"
["theia_plugin_vscode_references-view"]="vscode.references-view"
["theia_plugin_vscode_theme-abyss"]="vscode.theme-abyss"
["theia_plugin_vscode_typescript"]="vscode.typescript"
["theia_plugin_vscode_bat"]="vscode.bat"
["theia_plugin_vscode_debug-server-ready"]="vscode.debug-server-ready"
["theia_plugin_vscode_handlebars"]="vscode.handlebars"
["theia_plugin_vscode_julia"]="vscode.julia"
["theia_plugin_vscode_npm"]="vscode.npm"
["theia_plugin_vscode_restructuredtext"]="vscode.restructuredtext"
["theia_plugin_vscode_theme-defaults"]="vscode.theme-defaults"
["theia_plugin_vscode_typescript-language-features"]="vscode.typescript-language-features"
["theia_plugin_vscode_builtin-notebook-renderers"]="vscode.builtin-notebook-renderers"
["theia_plugin_vscode_diff"]="vscode.diff"
["theia_plugin_vscode_hlsl"]="vscode.hlsl"
["theia_plugin_vscode_latex"]="vscode.latex"
["theia_plugin_vscode_objective-c"]="vscode.objective-c"
["theia_plugin_vscode_ruby"]="vscode.ruby"
["theia_plugin_vscode_theme-kimbie-dark"]="vscode.theme-kimbie-dark"
["theia_plugin_vscode_vb"]="vscode.vb"
["theia_plugin_vscode_clojure"]="vscode.clojure"
["theia_plugin_vscode_docker"]="vscode.docker"
["theia_plugin_vscode_html"]="vscode.html"
["theia_plugin_vscode_less"]="vscode.less"
["theia_plugin_vscode_perl"]="vscode.perl"
["theia_plugin_vscode_rust"]="vscode.rust"
["theia_plugin_vscode_theme-monokai"]="vscode.theme-monokai"
["theia_plugin_vscode_vscode-theme-seti"]="vscode.vscode-theme-seti"
["theia_plugin_vscode_coffeescript"]="vscode.coffeescript"
["theia_plugin_vscode_emmet"]="vscode.emmet"
["theia_plugin_vscode_html-language-features"]="vscode.html-language-features"
["theia_plugin_vscode_log"]="vscode.log"
["theia_plugin_vscode_php"]="vscode.php"
["theia_plugin_vscode_scss"]="vscode.scss"
["theia_plugin_vscode_theme-monokai-dimmed"]="vscode.theme-monokai-dimmed"
["theia_plugin_vscode_xml"]="vscode.xml"
["theia_plugin_vscode_configuration-editing"]="vscode.configuration-editing"
["theia_plugin_vscode_fsharp"]="vscode.fsharp"
["theia_plugin_vscode_ini"]="vscode.ini"
["theia_plugin_vscode_lua"]="vscode.lua"
["theia_plugin_vscode_php-language-features"]="vscode.php-language-features"
["theia_plugin_vscode_search-result"]="vscode.search-result"
["theia_plugin_vscode_theme-quietlight"]="vscode.theme-quietlight"
["theia_plugin_vscode_yaml"]="vscode.yaml"
["theia_plugin_vscode_cpp"]="vscode.cpp"
["theia_plugin_vscode_git"]="vscode.git"
["theia_plugin_vscode_ipynb"]="vscode.ipynb"
["theia_plugin_vscode_make"]="vscode.make"
["theia_plugin_vscode_powershell"]="vscode.powershell"
["theia_plugin_vscode_shaderlab"]="vscode.shaderlab"
["theia_plugin_vscode_theme-red"]="vscode.theme-red"
["theia_plugin_vscode_csharp"]="vscode.csharp"
["theia_plugin_vscode_git-base"]="vscode.git-base"
["theia_plugin_vscode_jake"]="vscode.jake"
["theia_plugin_vscode_markdown"]="vscode.markdown"
["theia_plugin_vscode_pug"]="vscode.pug"
["theia_plugin_vscode_shellscript"]="vscode.shellscript"
["theia_plugin_vscode_theme-solarized-dark"]="vscode.theme-solarized-dark"
)

inherit desktop edo electron-app python-single-r1 yarn xdg

KEYWORDS="~amd64"
SLOT="0/monthly"
if [[ "${SLOT}" =~ "community" ]] ; then
	SUFFIX="-community"
fi
# UPDATER_START_YARN_EXTERNAL_URIS
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
$(electron-app_gen_electron_uris)
${YARN_EXTERNAL_URIS}
https://github.com/eclipse-theia/theia/archive/refs/tags/v${PV}${SUFFIX}.tar.gz
	-> ${P}${SUFFIX}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}${SUFFIX}"

DESCRIPTION="Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript."
HOMEPAGE="
http://theia-ide.org/
https://github.com/eclipse-theia/theia
"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		Apache-2.0
		all-rights-reserved
		custom
	)
	(
		all-rights-reserved
		custom
		MIT
		no-advertising
	)
	(
		custom
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		custom
		(
			(
				LGPL-2.1
				LGPL-2.1+
			)
			|| (
				GPL-2.0
				MIT
			)
		)
		(
			AFL-2.0
			Apache-2.0
			BSD
			BSD-2
			CC-BY-3.0
			ISC
			MIT
			MPL-2.0
			public-domain
			Unlicense
			|| (
				Apache-2.0
				BSD-2
				MIT
			)
			|| (
				BSD
				MPL-2.0
			)
			|| (
				GPL-2
				MIT
			)
		)
		(
			Apache-2.0
			Artistic-2.0
			BSD
			BSD-2
			CC-BY-3.0
			CC-BY-4.0
			CC-BY-SA-2.5
			CC0-1.0
			GPL-2-with-autoconf-exception
			MPL-2.0
			|| (
				AFL-2.1
				BSD
			)
			|| (
				Apache-2.0
				MIT
			)
			|| (
				BSD
				MIT
			)
		)
		(
			Apache-2.0
			Artist
			Boost-1.0
			BSD
			BSD-2
			CC-BY-3.0
			CC0-1.0
			ISC
			MIT
			MPL-2.0
			OFL-1.1
			Unlicense
			ZLIB
			|| (
				AFL-2.0
				BSD
			)
			|| (
				GPL-3
				MIT
			)
			|| (
				Apache-2.0
				MIT
			)
		)
		(
			BSD
			BSD-2
		)
		(
			CC-BY-4.0
			MIT
		)
		(
			custom
			GPL-2.0+
			LGPL-2.1+
		)
		(
			BSD
			MIT
			public-domain
		)
		Apache-2.0
		EPL-1.0
		ISC
		LGPL-2.1+
		MIT
		W3C
		|| (
			EPL-2.0
			GPL-2.0-with-classpath-exception
		)
		|| (
			LGPL-2.1
			LGPL-2.1+
		)
	)
	(
		CC-BY-SA-4.0
		ISC
	)
	(
		all-rights-reserved
		MIT
	)
	(
		Apache-2.0
		MIT
	)
	(
		CC0-1.0
		MIT
	)
	0BSD
	Apache-2.0
	Artistic-2
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC0-1.0
	custom
	MIT
	ISC
	LGPL-2.1
	LGPL-3
	PSF-2.4
	Unlicense
	|| (
		AFL-2.1
		BSD
	)
	|| (
		Apache-2.0
		MPL-2.0
	)
"
LICENSE="
	${ELECTRON_APP_LICENSES}
	${THIRD_PARTY_LICENSES}
	electron-33.0.0-beta.9-chromium.html
	EPL-2.0
	GPL-2-with-classpath-exception
"

# For ELECTRON_APP_LICENSES, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass#L67

# ( Apache-2.0 all-rights-reserved ) - node_modules/rx/license.txt
# ( custom Apache-2.0 all-rights-reserved ) - node_modules/typescript/CopyrightNotice.txt
# ( custom MIT all-rights-reserved no-advertising ) - node_modules/ecc-jsbn/lib/LICENSE-jsbn
# ( \
#   custom \
#   MIT \
#   Unicode-DFS-2016 \
#   W3C-Software-and-Document-Notice-and-License \
#   W3C-Community-Final-Specification-Agreement \
# ) - node_modules/typescript/ThirdPartyNoticeText.txt
# ( \
#   custom \
#   ( \
#     ( LGPL-2.1 LGPL-2.1+ ) \
#     || ( MIT GPL-2.0 ) \
#   ) \
#   ( \
#     AFL-2.0 \
#     Apache-2.0 \
#     BSD \
#     BSD-2 \
#     BSD-2 \
#     CC-BY-3.0 \
#     ISC \
#     MIT \
#     MPL-2.0 \
#     public-domain \
#     Unlicense \
#     X11 [see distro MIT license file] \
#     || ( BSD-2 MIT Apache-2.0 ) \
#     || ( BSD MPL-2.0 ) \
#     || ( MIT GPL-2 ) \
#   ) \
#   ( \
#     Apache-2.0 \
#     Artistic-2.0 \
#     BSD \
#     BSD-2 \
#     CC-BY-3.0 \
#     CC-BY-4.0 \
#     CC-BY-SA-2.5 \
#     CC0-1.0 \
#     GPL-2-with-autoconf-exception \
#     MPL-2.0 \
#     || ( AFL-2.1 BSD ) \
#     || ( MIT Apache-2.0 ) \
#     || ( BSD MIT ) \
#   ) \
#   ( \
#     Boost-1.0 \
#     Unlicense \
#     Apache-2.0 \
#     Artist \
#     BSD \
#     BSD-2 \
#     CC-BY-3.0 \
#     CC0-1.0 \
#     ISC \
#     MIT \
#     MPL-2.0 \
#     OFL-1.1 \
#     ZLIB \
#     || ( AFL-2.0 BSD ) \
#     || ( MIT GPL-3 ) \
#     || ( MIT Apache-2.0 ) \
#   ) \
#   ( \
#     BSD \
#     BSD-2 \
#   ) \
#   ( \
#     CC-BY-4.0 \
#     MIT \
#   ) \
#   ( \
#     custom \
#     GPL-2.0+ \
#     LGPL-2.1+ \
#   ) \
#   ( \
#     BSD \
#     MIT \
#     public-domain \
#   ) \
#   Apache-2.0 \
#   MIT \
#   EPL-1.0 \
#   ISC \
#   LGPL-2.1+ \
#   W3C \
#   || ( EPL-2.0 GPL-2.0-with-classpath-exception ) \
#   || ( LGPL-2.1 LGPL-2.1+ ) \
# ) - NOTICE.md
# ( ISC CC-BY-SA-4.0 ) - node_modules/glob/LICENSE
# ( MIT all-rights-reserved ) - node_modules/minizlib/LICENSE
# ( MIT all-rights-reserved ) - node_modules/@vscode/debugprotocol/License.txt
# ( MIT Apache-2.0 ) - node_modules/pause-stream/LICENSE
# ( MIT CC0-1.0 ) - node_modules/lodash.throttle/LICENSE
# 0BSD - node_modules/tslib/CopyrightNotice.txt
# Apache-2.0 - node_modules/ts-clean/node_modules/typescript/LICENSE.txt
# Apache-2.0 - node_modules/playwright-core/LICENSE
# Artistic-2 - node_modules/yarn-lifecycle/LICENSE
# BSD - node_modules/entities/LICENSE
# BSD-2 - node_modules/eslint-scope/node_modules/estraverse/LICENSE.BSD
# CC-BY-3.0 - node_modules/atob/LICENSE.DOCS
# CC-BY-4.0 - node_modules/caniuse-lite/LICENSE
# CC0-1.0 - node_modules/@stroncium/procfs/LICENSE
# custom - node_modules/vscode-languageserver-textdocument/thirdpartynotices.txt
# MIT - node_modules/simple-get/LICENSE
# ISC - node_modules/at-least-node/LICENSE
# LGPL-2.1 - node_modules/jschardet/LICENSE
# LGPL-3 - node_modules/eslint-plugin-deprecation/LICENSE
# PSF-2.4 - node_modules/markdown-it/node_modules/argparse/LICENSE
# Unlicense - node_modules/markdown-it-anchor/UNLICENSE
# || ( BSD AFL-2.1 ) - node_modules/json-schema/LICENSE
# || ( Apache-2.0 MPL-2.0 ) - node_modules/dompurify/LICENSE

RESTRICT="mirror"
IUSE+="
${!THEIA_PLUGINS[@]}
git ollama ebuild_revision_6
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	>=app-crypt/libsecret-0.20.5
	>=x11-libs/libX11-1.7.5
	>=x11-libs/libxkbfile-1.1.0
	git? (
		>=dev-vcs/git-2.34.1
	)
	ollama? (
		app-misc/ollama
	)
"
DEPEND+="
	${RDEPEND}
"
# pointer-compression may be needed to avoid:
# FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/make-4.3
	>=net-libs/nodejs-14.18.0:${NODE_VERSION}[pointer-compression]
	>=sys-apps/yarn-1.22.22:1
	>=sys-devel/gcc-11.2.0
	virtual/pkgconfig
"
PATCHES=(
)

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
	einfo "This is the monthly release."
	python_setup
	check_network_sandbox
	yarn_pkg_setup
}

get_plugins() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	cd "${S}" || die

	local tries=0
	while (( ${tries} < ${YARN_TRIES} )) ; do
		eyarn download:plugins
		if ! grep -q -E -r -e "Errors downloading some plugins" "${T}/build.log" ; then
			break
		fi
		if grep -q -E -r -e "Errors downloading some plugins" "${T}/build.log" ; then
			tries=$((${tries} + 1))
			sed -i -e "/Errors downloading some plugins/d" "${T}/build.log"
		fi
	done
}

_WANTS_PLUGIN_CACHED=-1
user_wants_plugin() {
	(( ${_WANTS_PLUGIN_CACHED} != -1 )) && return ${_WANTS_PLUGIN_CACHED}
	local x
	for x in ${!THEIA_PLUGINS[@]} ; do
		if use "${x}" ; then
			_WANTS_PLUGIN_CACHED=0
			break
		fi
	done
	(( ${_WANTS_PLUGIN_CACHED} != 0 )) && _WANTS_PLUGIN_CACHED=1
	return ${_WANTS_PLUGIN_CACHED}
}

gen_plugin_array() {
	L=(
		# Paste subfolders of plugins folder
	)
	local raw_name
	for raw_name in ${L[@]} ; do
		local name="${raw_name/./_}"
		echo "[\"theia_plugin_${name}\"]=\"${raw_name}\""
	done
}

yarn_unpack_install_pre() {
	[[ "${YARN_UPDATE_LOCK}" == "1" ]] && return
einfo "Called yarn_unpack_install_pre()"
einfo "Adding dependencies"
	local pkgs
	pkgs=(
		"node-gyp@^${NODE_GYP_PV}"
	)
	eyarn add ${pkgs[@]} -D -W
}

yarn_unpack_post() {
	:
}

yarn_src_unpack_update_ebuild_custom() {
einfo "Updating lockfile from _yarn_src_unpack_update_ebuild_custom()"
	if [[ "${PV}" =~ "9999" ]] ; then
                        :
	elif [[ -n "${YARN_TARBALL}" ]] ; then
		unpack "${YARN_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi

	if declare -f yarn_unpack_post >/dev/null 2>&1 ; then
		yarn_unpack_post
	fi

	export PATH="${S}/node_modules/.bin:${PATH}"
	export PATH="${HOME}/.config/yarn/global/node_modules/.bin:${PATH}" # For npx
	export PATH="${HOME}/.cache/node/corepack/v1/npm/9.8.0/bin:${PATH}" # For npx
	edo npx --version
	cd "${S}" || die

einfo "Generating yarn.lock"
	eyarn install

	# yarn.lock
	mkdir -p "${WORKDIR}/lockfile-image"
	cp -a \
		"${S}/yarn.lock" \
		"${WORKDIR}/lockfile-image" \
		|| die

	local L=(
sample-plugins/sample-namespace/plugin-a/package.json
sample-plugins/sample-namespace/plugin-b/package.json
sample-plugins/sample-namespace/plugin-gotd/package.json
dev-packages/private-eslint-plugin/package.json
dev-packages/native-webpack-plugin/package.json
dev-packages/private-ext-scripts/package.json
dev-packages/ffmpeg/package.json
dev-packages/localization-manager/package.json
dev-packages/request/package.json
dev-packages/application-package/package.json
dev-packages/ovsx-client/package.json
dev-packages/private-re-exports/package.json
dev-packages/application-manager/package.json
dev-packages/cli/package.json
packages/file-search/package.json
packages/secondary-window/package.json
packages/callhierarchy/package.json
packages/monaco/package.json
packages/navigator/package.json
packages/ai-openai/package.json
packages/dev-container/package.json
packages/electron/package.json
packages/ai-terminal/package.json
packages/userstorage/package.json
packages/editor-preview/package.json
packages/ai-core/package.json
packages/test/package.json
packages/git/package.json
packages/preferences/package.json
packages/getting-started/package.json
packages/ai-ollama/package.json
packages/core/package.json
packages/search-in-workspace/package.json
packages/vsx-registry/package.json
packages/metrics/package.json
packages/ai-chat-ui/package.json
packages/plugin-dev/package.json
packages/scm/package.json
packages/ai-history/package.json
packages/outline-view/package.json
packages/property-view/package.json
packages/timeline/package.json
packages/mini-browser/package.json
packages/memory-inspector/package.json
packages/plugin-ext-vscode/package.json
packages/scm-extra/package.json
packages/task/package.json
packages/debug/package.json
packages/ai-chat/package.json
packages/keymaps/package.json
packages/preview/package.json
packages/output/package.json
packages/editor/package.json
packages/plugin-ext-headless/package.json
packages/workspace/package.json
packages/collaboration/package.json
packages/toolbar/package.json
packages/remote/package.json
packages/variable-resolver/package.json
packages/filesystem/package.json
packages/process/package.json
packages/messages/package.json
packages/terminal/package.json
packages/plugin-ext/package.json
packages/notebook/package.json
packages/markers/package.json
packages/console/package.json
packages/plugin-metrics/package.json
packages/plugin/package.json
packages/external-terminal/package.json
packages/ai-workspace-agent/package.json
packages/bulk-edit/package.json
packages/ai-code-completion/package.json
packages/typehierarchy/package.json
package.json
examples/electron/package.json
examples/playwright/package.json
examples/browser/package.json
examples/api-samples/package.json
examples/api-tests/package.json
examples/browser-only/package.json
examples/api-provider-sample/package.json
	)

	local x
	for x in ${L[@]} ; do
		local path=$(dirname "${x}")
		mkdir -p "${WORKDIR}/lockfile-image/${path}"
		cp -a \
			"${x}" \
			"${WORKDIR}/lockfile-image/${path}" \
			|| die
	done
}

src_unpack() {
einfo "YARN_UPDATE_LOCK=${YARN_UPDATE_LOCK}"
	yarn_src_unpack
	export PATH="${HOME}/.config/yarn/global/node_modules/.bin:${PATH}" # For npx
	export PATH="${HOME}/.cache/node/corepack/v1/npm/9.8.0/bin:${PATH}" # For npx
	edo npx --version
	if [[ -z "${YARN_UPDATE_LOCK}" ]] ; then
		user_wants_plugin && get_plugins
	fi
	local path="${S}/node_modules/electron/dist"
	mkdir -p "${S}/node_modules/electron/dist" || die
	pushd "${path}" || die
		unpack "electron-v${ELECTRON_APP_ELECTRON_PV}-$(electron-app_get_electron_platarch).zip"
	popd
	[[ "${path}/version" ]] || die "Missing file"
}

src_prepare() {
	default

	# Remove Sample Menu
	sed \
		-i \
		-e "\|@theia/api-samples|d" \
		"examples/browser/package.json" \
		"examples/browser-only/package.json" \
		"examples/electron/package.json" \
		|| die

	sed -i \
		-e "s|Theia Electron Example|Theia IDE|g" \
		"examples/electron/package.json" \
		|| die

}

src_compile() {
	yarn_hydrate
	eyarn run compile
	eyarn run browser build
	eyarn run electron build
	eyarn run browser-only build

	# Fix for issue #10246
	eyarn browser rebuild
	eyarn electron rebuild

	grep -q \
		-e "Error: ENOENT: no such file or directory, open '${S}/node_modules/electron/dist/version'" \
		"${T}/build.log" \
		&& die "Build failure"
	grep -q \
		-e "Rebuild Failed" \
		"${T}/build.log" \
		&& die "Build failure"
}

_install() {
	# Reconstruct AppImage
	insinto "/opt/${PN}"
	doins -r "node_modules/electron/dist/"*
	insinto "/opt/${PN}/resources/app"
	doins -r "examples/electron/"*
	doins -r "examples/electron/."*
	if user_wants_plugin ; then
		insinto "/opt/${PN}/resources/app"
		doins -r "plugins"
	fi
	cat "${FILESDIR}/${PN}-v2" > "${T}/${PN}" || die

	local path
	for path in ${YARN_EXE_LIST} ; do
		if [[ -e "${ED}/${path}" ]] ; then
			fperms 0755 "${path}"
		fi
	done
	fperms 4711 "/opt/${PN}/chrome-sandbox"
}

_install_plugins() {
	local x
	for x in ${!THEIA_PLUGINS[@]} ; do
		local raw_name
		raw_name="${THEIA_PLUGINS[${x}]}"
		if use "${x}" ; then
			if [[ -e "${ED}/opt/${PN}/resources/app/plugins/${raw_name}" ]] ; then
einfo "Keeping ${raw_name}"
			else
ewarn "QA:  Missing ${raw_name}"
			fi
		else
			if [[ -e "${ED}/opt/${PN}/resources/app/plugins/${raw_name}" ]] ; then
einfo "Removing ${raw_name}"
				rm -rf "${ED}/opt/${PN}/resources/app/plugins/${raw_name}" || die
			else
ewarn "QA:  Missing ${raw_name}"
			fi
		fi
	done
}

src_install() {
	_install
	newicon "logo/theia.svg" "${PN}.svg"
	make_desktop_entry \
		"/usr/bin/${PN}" \
		"${PN^}" \
		"${PN}.svg" \
		"Development"
	sed -i \
		-e "s|\${NODE_VERSION}|${NODE_VERSION}|g" \
		-e "s|\${NODE_ENV}|${NODE_ENV}|g" \
		-e "s|\${INSTALL_PATH}|${YARN_INSTALL_PATH}|g" \
		"${T}/${PN}" \
		|| die
	exeinto "/usr/bin"
	doexe "${T}/${PN}"

	if user_wants_plugin ; then
		_install_plugins
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	if use ollama ; then
einfo
einfo "The default models listed for Ollama support are llama3 and gemma2."
einfo
einfo "To set up the models per agent, see https://theia-ide.org/docs/user_ai/#ollama"
einfo "To access the chat, View > Chat Experimental"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.37.1 (20230525)
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.50.1 (20240620)
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.56.0 (20241201)
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.57.1 (20241222)
# launch-test:  passed
# ai-assistant (ollama with yi-coder:1.5b with Universal agent):  passed
# Run hello world for python:  fail
# Run hello world for c:  fail
