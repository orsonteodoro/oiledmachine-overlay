# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream uses U22

# typescript 5.3.3 = @types/node 20.8.9

AT_TYPES_NODE_PV="22.7.5"
# See https://releases.electronjs.org/releases.json

# The current strategy to bump to 32.
# 1. Keep original electron-rebuild.
# 2. Bump node-abi to 3.68.0 with sed edits to force references to it
# 3. Bump nan to 2.22.0
# 4. Keep NODE_VERSION=18
#
# Current errors:
# .electron-gyp/32.2.0/include/node/v8config.h:13:2: error: #error "C++20 or later required."
# nan.h:700:39: error: 'class v8::Isolate' has no member named 'IdleNotificationDeadline'
# nan.h:2560:8: error: 'class v8::ObjectTemplate' has no member named 'SetAccessor'

# ELECTRON_APP_ELECTRON_PV is limited by nan
#ELECTRON_APP_ELECTRON_PV="33.0.0-beta.10" # Cr 130.0.6723.31, node 20.18.0.
#ELECTRON_APP_ELECTRON_PV="32.2.0" # Cr 128.0.6613.178, node 20.18.0.  Temporary used for debugging current problem.
ELECTRON_APP_ELECTRON_PV="30.3.1" # Cr 124.0.6367.243, node 20.15.1.  Original

#ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY="1"
ELECTRON_APP_MODE="yarn"
ELECTRON_APP_REACT_PV="18.2.0"
NAN_PV="2.22.0" # 2.22.0 is needed for Electron 32 support
NODE_ABI_PV="3.68.0"
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
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/@aashutoshrathi/word-wrap/-/word-wrap-1.2.6.tgz -> yarnpkg-@aashutoshrathi-word-wrap-1.2.6.tgz
https://registry.yarnpkg.com/@ampproject/remapping/-/remapping-2.2.1.tgz -> yarnpkg-@ampproject-remapping-2.2.1.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz -> yarnpkg-@babel-code-frame-7.12.11.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.23.5.tgz -> yarnpkg-@babel-code-frame-7.23.5.tgz
https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.23.5.tgz -> yarnpkg-@babel-compat-data-7.23.5.tgz
https://registry.yarnpkg.com/@babel/core/-/core-7.23.9.tgz -> yarnpkg-@babel-core-7.23.9.tgz
https://registry.yarnpkg.com/@babel/generator/-/generator-7.23.6.tgz -> yarnpkg-@babel-generator-7.23.6.tgz
https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz -> yarnpkg-@babel-helper-annotate-as-pure-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.15.tgz -> yarnpkg-@babel-helper-builder-binary-assignment-operator-visitor-7.22.15.tgz
https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.23.6.tgz -> yarnpkg-@babel-helper-compilation-targets-7.23.6.tgz
https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.23.10.tgz -> yarnpkg-@babel-helper-create-class-features-plugin-7.23.10.tgz
https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.15.tgz -> yarnpkg-@babel-helper-create-regexp-features-plugin-7.22.15.tgz
https://registry.yarnpkg.com/@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.5.0.tgz -> yarnpkg-@babel-helper-define-polyfill-provider-0.5.0.tgz
https://registry.yarnpkg.com/@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.20.tgz -> yarnpkg-@babel-helper-environment-visitor-7.22.20.tgz
https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.23.0.tgz -> yarnpkg-@babel-helper-function-name-7.23.0.tgz
https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz -> yarnpkg-@babel-helper-hoist-variables-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.23.0.tgz -> yarnpkg-@babel-helper-member-expression-to-functions-7.23.0.tgz
https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.22.15.tgz -> yarnpkg-@babel-helper-module-imports-7.22.15.tgz
https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.23.3.tgz -> yarnpkg-@babel-helper-module-transforms-7.23.3.tgz
https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz -> yarnpkg-@babel-helper-optimise-call-expression-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz -> yarnpkg-@babel-helper-plugin-utils-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.20.tgz -> yarnpkg-@babel-helper-remap-async-to-generator-7.22.20.tgz
https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.22.20.tgz -> yarnpkg-@babel-helper-replace-supers-7.22.20.tgz
https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz -> yarnpkg-@babel-helper-simple-access-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz -> yarnpkg-@babel-helper-skip-transparent-expression-wrappers-7.22.5.tgz
https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz -> yarnpkg-@babel-helper-split-export-declaration-7.22.6.tgz
https://registry.yarnpkg.com/@babel/helper-string-parser/-/helper-string-parser-7.23.4.tgz -> yarnpkg-@babel-helper-string-parser-7.23.4.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.20.tgz -> yarnpkg-@babel-helper-validator-identifier-7.22.20.tgz
https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.23.5.tgz -> yarnpkg-@babel-helper-validator-option-7.23.5.tgz
https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.22.20.tgz -> yarnpkg-@babel-helper-wrap-function-7.22.20.tgz
https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.23.9.tgz -> yarnpkg-@babel-helpers-7.23.9.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.23.4.tgz -> yarnpkg-@babel-highlight-7.23.4.tgz
https://registry.yarnpkg.com/@babel/parser/-/parser-7.23.9.tgz -> yarnpkg-@babel-parser-7.23.9.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.23.3.tgz -> yarnpkg-@babel-plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.23.3.tgz -> yarnpkg-@babel-plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-bugfix-v8-static-class-fields-redefine-readonly/-/plugin-bugfix-v8-static-class-fields-redefine-readonly-7.23.7.tgz -> yarnpkg-@babel-plugin-bugfix-v8-static-class-fields-redefine-readonly-7.23.7.tgz
https://registry.yarnpkg.com/@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz -> yarnpkg-@babel-plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> yarnpkg-@babel-plugin-syntax-async-generators-7.8.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz -> yarnpkg-@babel-plugin-syntax-class-properties-7.12.13.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-class-static-block-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-dynamic-import-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-export-namespace-from-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.23.3.tgz -> yarnpkg-@babel-plugin-syntax-import-assertions-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.23.3.tgz -> yarnpkg-@babel-plugin-syntax-import-attributes-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-import-meta-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-json-strings-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> yarnpkg-@babel-plugin-syntax-numeric-separator-7.10.4.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-object-rest-spread-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> yarnpkg-@babel-plugin-syntax-optional-chaining-7.8.3.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-private-property-in-object-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz -> yarnpkg-@babel-plugin-syntax-top-level-await-7.14.5.tgz
https://registry.yarnpkg.com/@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz -> yarnpkg-@babel-plugin-syntax-unicode-sets-regex-7.18.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-arrow-functions-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.23.9.tgz -> yarnpkg-@babel-plugin-transform-async-generator-functions-7.23.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-async-to-generator-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-block-scoped-functions-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-block-scoping-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-class-properties-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-class-static-block-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.23.8.tgz -> yarnpkg-@babel-plugin-transform-classes-7.23.8.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-computed-properties-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-destructuring-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-dotall-regex-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-duplicate-keys-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-dynamic-import-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-exponentiation-operator-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-export-namespace-from-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.23.6.tgz -> yarnpkg-@babel-plugin-transform-for-of-7.23.6.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-function-name-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-json-strings-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-literals-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-logical-assignment-operators-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-member-expression-literals-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-modules-amd-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-modules-commonjs-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.23.9.tgz -> yarnpkg-@babel-plugin-transform-modules-systemjs-7.23.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-modules-umd-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz -> yarnpkg-@babel-plugin-transform-named-capturing-groups-regex-7.22.5.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-new-target-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-nullish-coalescing-operator-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-numeric-separator-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-object-rest-spread-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-object-super-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-optional-catch-binding-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-optional-chaining-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-parameters-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-private-methods-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.23.4.tgz -> yarnpkg-@babel-plugin-transform-private-property-in-object-7.23.4.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-property-literals-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-regenerator-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-reserved-words-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.23.9.tgz -> yarnpkg-@babel-plugin-transform-runtime-7.23.9.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-shorthand-properties-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-spread-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-sticky-regex-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-template-literals-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-typeof-symbol-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-unicode-escapes-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-unicode-property-regex-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-unicode-regex-7.23.3.tgz
https://registry.yarnpkg.com/@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.23.3.tgz -> yarnpkg-@babel-plugin-transform-unicode-sets-regex-7.23.3.tgz
https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.23.9.tgz -> yarnpkg-@babel-preset-env-7.23.9.tgz
https://registry.yarnpkg.com/@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz -> yarnpkg-@babel-preset-modules-0.1.6-no-external-plugins.tgz
https://registry.yarnpkg.com/@babel/regjsgen/-/regjsgen-0.8.0.tgz -> yarnpkg-@babel-regjsgen-0.8.0.tgz
https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.23.9.tgz -> yarnpkg-@babel-runtime-7.23.9.tgz
https://registry.yarnpkg.com/@babel/template/-/template-7.23.9.tgz -> yarnpkg-@babel-template-7.23.9.tgz
https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.23.9.tgz -> yarnpkg-@babel-traverse-7.23.9.tgz
https://registry.yarnpkg.com/@babel/types/-/types-7.23.9.tgz -> yarnpkg-@babel-types-7.23.9.tgz
https://registry.yarnpkg.com/@balena/dockerignore/-/dockerignore-1.0.2.tgz -> yarnpkg-@balena-dockerignore-1.0.2.tgz
https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> yarnpkg-@discoveryjs-json-ext-0.5.7.tgz
https://registry.yarnpkg.com/@electron/get/-/get-2.0.3.tgz -> yarnpkg-@electron-get-2.0.3.tgz
https://registry.yarnpkg.com/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> yarnpkg-@eslint-community-eslint-utils-4.4.0.tgz
https://registry.yarnpkg.com/@eslint-community/regexpp/-/regexpp-4.10.0.tgz -> yarnpkg-@eslint-community-regexpp-4.10.0.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.4.3.tgz -> yarnpkg-@eslint-eslintrc-0.4.3.tgz
https://registry.yarnpkg.com/@gar/promisify/-/promisify-1.1.3.tgz -> yarnpkg-@gar-promisify-1.1.3.tgz
https://registry.yarnpkg.com/@huggingface/inference/-/inference-2.8.1.tgz -> yarnpkg-@huggingface-inference-2.8.1.tgz
https://registry.yarnpkg.com/@huggingface/tasks/-/tasks-0.12.30.tgz -> yarnpkg-@huggingface-tasks-0.12.30.tgz
https://registry.yarnpkg.com/@humanwhocodes/config-array/-/config-array-0.5.0.tgz -> yarnpkg-@humanwhocodes-config-array-0.5.0.tgz
https://registry.yarnpkg.com/@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz -> yarnpkg-@humanwhocodes-object-schema-1.2.1.tgz
https://registry.yarnpkg.com/@hutson/parse-repository-url/-/parse-repository-url-3.0.2.tgz -> yarnpkg-@hutson-parse-repository-url-3.0.2.tgz
https://registry.yarnpkg.com/@inversifyjs/common/-/common-1.3.2.tgz -> yarnpkg-@inversifyjs-common-1.3.2.tgz
https://registry.yarnpkg.com/@inversifyjs/core/-/core-1.3.3.tgz -> yarnpkg-@inversifyjs-core-1.3.3.tgz
https://registry.yarnpkg.com/@inversifyjs/reflect-metadata-utils/-/reflect-metadata-utils-0.2.2.tgz -> yarnpkg-@inversifyjs-reflect-metadata-utils-0.2.2.tgz
https://registry.yarnpkg.com/@isaacs/cliui/-/cliui-8.0.2.tgz -> yarnpkg-@isaacs-cliui-8.0.2.tgz
https://registry.yarnpkg.com/@istanbuljs/load-nyc-config/-/load-nyc-config-1.1.0.tgz -> yarnpkg-@istanbuljs-load-nyc-config-1.1.0.tgz
https://registry.yarnpkg.com/@istanbuljs/schema/-/schema-0.1.3.tgz -> yarnpkg-@istanbuljs-schema-0.1.3.tgz
https://registry.yarnpkg.com/@jest/schemas/-/schemas-29.6.3.tgz -> yarnpkg-@jest-schemas-29.6.3.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.4.tgz -> yarnpkg-@jridgewell-gen-mapping-0.3.4.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> yarnpkg-@jridgewell-resolve-uri-3.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.1.2.tgz -> yarnpkg-@jridgewell-set-array-1.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/source-map/-/source-map-0.3.5.tgz -> yarnpkg-@jridgewell-source-map-0.3.5.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz -> yarnpkg-@jridgewell-sourcemap-codec-1.4.15.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.23.tgz -> yarnpkg-@jridgewell-trace-mapping-0.3.23.tgz
https://registry.yarnpkg.com/@lerna/child-process/-/child-process-7.4.2.tgz -> yarnpkg-@lerna-child-process-7.4.2.tgz
https://registry.yarnpkg.com/@lerna/create/-/create-7.4.2.tgz -> yarnpkg-@lerna-create-7.4.2.tgz
https://registry.yarnpkg.com/@malept/cross-spawn-promise/-/cross-spawn-promise-2.0.0.tgz -> yarnpkg-@malept-cross-spawn-promise-2.0.0.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-darwin-arm64/-/msgpackr-extract-darwin-arm64-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-darwin-arm64-3.0.2.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-darwin-x64/-/msgpackr-extract-darwin-x64-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-darwin-x64-3.0.2.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-linux-arm64/-/msgpackr-extract-linux-arm64-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-linux-arm64-3.0.2.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-linux-arm/-/msgpackr-extract-linux-arm-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-linux-arm-3.0.2.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-linux-x64/-/msgpackr-extract-linux-x64-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-linux-x64-3.0.2.tgz
https://registry.yarnpkg.com/@msgpackr-extract/msgpackr-extract-win32-x64/-/msgpackr-extract-win32-x64-3.0.2.tgz -> yarnpkg-@msgpackr-extract-msgpackr-extract-win32-x64-3.0.2.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> yarnpkg-@nodelib-fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> yarnpkg-@nodelib-fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> yarnpkg-@nodelib-fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-2.1.2.tgz -> yarnpkg-@npmcli-fs-2.1.2.tgz
https://registry.yarnpkg.com/@npmcli/fs/-/fs-3.1.0.tgz -> yarnpkg-@npmcli-fs-3.1.0.tgz
https://registry.yarnpkg.com/@npmcli/git/-/git-4.1.0.tgz -> yarnpkg-@npmcli-git-4.1.0.tgz
https://registry.yarnpkg.com/@npmcli/installed-package-contents/-/installed-package-contents-2.0.2.tgz -> yarnpkg-@npmcli-installed-package-contents-2.0.2.tgz
https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-2.0.1.tgz -> yarnpkg-@npmcli-move-file-2.0.1.tgz
https://registry.yarnpkg.com/@npmcli/node-gyp/-/node-gyp-3.0.0.tgz -> yarnpkg-@npmcli-node-gyp-3.0.0.tgz
https://registry.yarnpkg.com/@npmcli/promise-spawn/-/promise-spawn-6.0.2.tgz -> yarnpkg-@npmcli-promise-spawn-6.0.2.tgz
https://registry.yarnpkg.com/@npmcli/run-script/-/run-script-6.0.2.tgz -> yarnpkg-@npmcli-run-script-6.0.2.tgz
https://registry.yarnpkg.com/@nrwl/devkit/-/devkit-16.10.0.tgz -> yarnpkg-@nrwl-devkit-16.10.0.tgz
https://registry.yarnpkg.com/@nrwl/tao/-/tao-16.10.0.tgz -> yarnpkg-@nrwl-tao-16.10.0.tgz
https://registry.yarnpkg.com/@nx/devkit/-/devkit-16.10.0.tgz -> yarnpkg-@nx-devkit-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-darwin-arm64/-/nx-darwin-arm64-16.10.0.tgz -> yarnpkg-@nx-nx-darwin-arm64-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-darwin-x64/-/nx-darwin-x64-16.10.0.tgz -> yarnpkg-@nx-nx-darwin-x64-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-freebsd-x64/-/nx-freebsd-x64-16.10.0.tgz -> yarnpkg-@nx-nx-freebsd-x64-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-linux-arm-gnueabihf/-/nx-linux-arm-gnueabihf-16.10.0.tgz -> yarnpkg-@nx-nx-linux-arm-gnueabihf-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-linux-arm64-gnu/-/nx-linux-arm64-gnu-16.10.0.tgz -> yarnpkg-@nx-nx-linux-arm64-gnu-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-linux-arm64-musl/-/nx-linux-arm64-musl-16.10.0.tgz -> yarnpkg-@nx-nx-linux-arm64-musl-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-linux-x64-gnu/-/nx-linux-x64-gnu-16.10.0.tgz -> yarnpkg-@nx-nx-linux-x64-gnu-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-linux-x64-musl/-/nx-linux-x64-musl-16.10.0.tgz -> yarnpkg-@nx-nx-linux-x64-musl-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-win32-arm64-msvc/-/nx-win32-arm64-msvc-16.10.0.tgz -> yarnpkg-@nx-nx-win32-arm64-msvc-16.10.0.tgz
https://registry.yarnpkg.com/@nx/nx-win32-x64-msvc/-/nx-win32-x64-msvc-16.10.0.tgz -> yarnpkg-@nx-nx-win32-x64-msvc-16.10.0.tgz
https://registry.yarnpkg.com/@octokit/auth-token/-/auth-token-3.0.4.tgz -> yarnpkg-@octokit-auth-token-3.0.4.tgz
https://registry.yarnpkg.com/@octokit/core/-/core-4.2.4.tgz -> yarnpkg-@octokit-core-4.2.4.tgz
https://registry.yarnpkg.com/@octokit/endpoint/-/endpoint-7.0.6.tgz -> yarnpkg-@octokit-endpoint-7.0.6.tgz
https://registry.yarnpkg.com/@octokit/graphql/-/graphql-5.0.6.tgz -> yarnpkg-@octokit-graphql-5.0.6.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-18.1.1.tgz -> yarnpkg-@octokit-openapi-types-18.1.1.tgz
https://registry.yarnpkg.com/@octokit/plugin-enterprise-rest/-/plugin-enterprise-rest-6.0.1.tgz -> yarnpkg-@octokit-plugin-enterprise-rest-6.0.1.tgz
https://registry.yarnpkg.com/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-6.1.2.tgz -> yarnpkg-@octokit-plugin-paginate-rest-6.1.2.tgz
https://registry.yarnpkg.com/@octokit/plugin-request-log/-/plugin-request-log-1.0.4.tgz -> yarnpkg-@octokit-plugin-request-log-1.0.4.tgz
https://registry.yarnpkg.com/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-7.2.3.tgz -> yarnpkg-@octokit-plugin-rest-endpoint-methods-7.2.3.tgz
https://registry.yarnpkg.com/@octokit/request-error/-/request-error-3.0.3.tgz -> yarnpkg-@octokit-request-error-3.0.3.tgz
https://registry.yarnpkg.com/@octokit/request/-/request-6.2.8.tgz -> yarnpkg-@octokit-request-6.2.8.tgz
https://registry.yarnpkg.com/@octokit/rest/-/rest-19.0.11.tgz -> yarnpkg-@octokit-rest-19.0.11.tgz
https://registry.yarnpkg.com/@octokit/tsconfig/-/tsconfig-1.0.2.tgz -> yarnpkg-@octokit-tsconfig-1.0.2.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-10.0.0.tgz -> yarnpkg-@octokit-types-10.0.0.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-9.3.2.tgz -> yarnpkg-@octokit-types-9.3.2.tgz
https://registry.yarnpkg.com/@parcel/watcher-android-arm64/-/watcher-android-arm64-2.5.0.tgz -> yarnpkg-@parcel-watcher-android-arm64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-darwin-arm64/-/watcher-darwin-arm64-2.5.0.tgz -> yarnpkg-@parcel-watcher-darwin-arm64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-darwin-x64/-/watcher-darwin-x64-2.5.0.tgz -> yarnpkg-@parcel-watcher-darwin-x64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-freebsd-x64/-/watcher-freebsd-x64-2.5.0.tgz -> yarnpkg-@parcel-watcher-freebsd-x64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-arm-glibc/-/watcher-linux-arm-glibc-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-arm-glibc-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-arm-musl/-/watcher-linux-arm-musl-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-arm-musl-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-arm64-glibc/-/watcher-linux-arm64-glibc-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-arm64-glibc-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-arm64-musl/-/watcher-linux-arm64-musl-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-arm64-musl-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-x64-glibc/-/watcher-linux-x64-glibc-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-x64-glibc-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-linux-x64-musl/-/watcher-linux-x64-musl-2.5.0.tgz -> yarnpkg-@parcel-watcher-linux-x64-musl-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-win32-arm64/-/watcher-win32-arm64-2.5.0.tgz -> yarnpkg-@parcel-watcher-win32-arm64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-win32-ia32/-/watcher-win32-ia32-2.5.0.tgz -> yarnpkg-@parcel-watcher-win32-ia32-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher-win32-x64/-/watcher-win32-x64-2.5.0.tgz -> yarnpkg-@parcel-watcher-win32-x64-2.5.0.tgz
https://registry.yarnpkg.com/@parcel/watcher/-/watcher-2.0.4.tgz -> yarnpkg-@parcel-watcher-2.0.4.tgz
https://registry.yarnpkg.com/@parcel/watcher/-/watcher-2.5.0.tgz -> yarnpkg-@parcel-watcher-2.5.0.tgz
https://registry.yarnpkg.com/@phosphor/algorithm/-/algorithm-1.2.0.tgz -> yarnpkg-@phosphor-algorithm-1.2.0.tgz
https://registry.yarnpkg.com/@phosphor/collections/-/collections-1.2.0.tgz -> yarnpkg-@phosphor-collections-1.2.0.tgz
https://registry.yarnpkg.com/@phosphor/commands/-/commands-1.7.2.tgz -> yarnpkg-@phosphor-commands-1.7.2.tgz
https://registry.yarnpkg.com/@phosphor/coreutils/-/coreutils-1.3.1.tgz -> yarnpkg-@phosphor-coreutils-1.3.1.tgz
https://registry.yarnpkg.com/@phosphor/disposable/-/disposable-1.3.1.tgz -> yarnpkg-@phosphor-disposable-1.3.1.tgz
https://registry.yarnpkg.com/@phosphor/domutils/-/domutils-1.1.4.tgz -> yarnpkg-@phosphor-domutils-1.1.4.tgz
https://registry.yarnpkg.com/@phosphor/dragdrop/-/dragdrop-1.4.1.tgz -> yarnpkg-@phosphor-dragdrop-1.4.1.tgz
https://registry.yarnpkg.com/@phosphor/keyboard/-/keyboard-1.1.3.tgz -> yarnpkg-@phosphor-keyboard-1.1.3.tgz
https://registry.yarnpkg.com/@phosphor/messaging/-/messaging-1.3.0.tgz -> yarnpkg-@phosphor-messaging-1.3.0.tgz
https://registry.yarnpkg.com/@phosphor/properties/-/properties-1.1.3.tgz -> yarnpkg-@phosphor-properties-1.1.3.tgz
https://registry.yarnpkg.com/@phosphor/signaling/-/signaling-1.3.1.tgz -> yarnpkg-@phosphor-signaling-1.3.1.tgz
https://registry.yarnpkg.com/@phosphor/virtualdom/-/virtualdom-1.2.0.tgz -> yarnpkg-@phosphor-virtualdom-1.2.0.tgz
https://registry.yarnpkg.com/@phosphor/widgets/-/widgets-1.9.3.tgz -> yarnpkg-@phosphor-widgets-1.9.3.tgz
https://registry.yarnpkg.com/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> yarnpkg-@pkgjs-parseargs-0.11.0.tgz
https://registry.yarnpkg.com/@playwright/test/-/test-1.48.2.tgz -> yarnpkg-@playwright-test-1.48.2.tgz
https://registry.yarnpkg.com/@puppeteer/browsers/-/browsers-2.3.1.tgz -> yarnpkg-@puppeteer-browsers-2.3.1.tgz
https://registry.yarnpkg.com/@sigstore/bundle/-/bundle-1.1.0.tgz -> yarnpkg-@sigstore-bundle-1.1.0.tgz
https://registry.yarnpkg.com/@sigstore/protobuf-specs/-/protobuf-specs-0.2.1.tgz -> yarnpkg-@sigstore-protobuf-specs-0.2.1.tgz
https://registry.yarnpkg.com/@sigstore/sign/-/sign-1.0.0.tgz -> yarnpkg-@sigstore-sign-1.0.0.tgz
https://registry.yarnpkg.com/@sigstore/tuf/-/tuf-1.0.3.tgz -> yarnpkg-@sigstore-tuf-1.0.3.tgz
https://registry.yarnpkg.com/@sinclair/typebox/-/typebox-0.27.8.tgz -> yarnpkg-@sinclair-typebox-0.27.8.tgz
https://registry.yarnpkg.com/@sindresorhus/df/-/df-1.0.1.tgz -> yarnpkg-@sindresorhus-df-1.0.1.tgz
https://registry.yarnpkg.com/@sindresorhus/df/-/df-3.1.1.tgz -> yarnpkg-@sindresorhus-df-3.1.1.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-4.6.0.tgz -> yarnpkg-@sindresorhus-is-4.6.0.tgz
https://registry.yarnpkg.com/@sinonjs/commons/-/commons-1.8.6.tgz -> yarnpkg-@sinonjs-commons-1.8.6.tgz
https://registry.yarnpkg.com/@sinonjs/commons/-/commons-3.0.1.tgz -> yarnpkg-@sinonjs-commons-3.0.1.tgz
https://registry.yarnpkg.com/@sinonjs/fake-timers/-/fake-timers-11.2.2.tgz -> yarnpkg-@sinonjs-fake-timers-11.2.2.tgz
https://registry.yarnpkg.com/@sinonjs/fake-timers/-/fake-timers-8.1.0.tgz -> yarnpkg-@sinonjs-fake-timers-8.1.0.tgz
https://registry.yarnpkg.com/@sinonjs/samsam/-/samsam-6.1.3.tgz -> yarnpkg-@sinonjs-samsam-6.1.3.tgz
https://registry.yarnpkg.com/@sinonjs/text-encoding/-/text-encoding-0.7.2.tgz -> yarnpkg-@sinonjs-text-encoding-0.7.2.tgz
https://registry.yarnpkg.com/@socket.io/component-emitter/-/component-emitter-3.1.0.tgz -> yarnpkg-@socket.io-component-emitter-3.1.0.tgz
https://registry.yarnpkg.com/@stroncium/procfs/-/procfs-1.2.1.tgz -> yarnpkg-@stroncium-procfs-1.2.1.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> yarnpkg-@szmarczak-http-timer-4.0.6.tgz
https://registry.yarnpkg.com/@theia/monaco-editor-core/-/monaco-editor-core-1.83.101.tgz -> yarnpkg-@theia-monaco-editor-core-1.83.101.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-1.1.2.tgz -> yarnpkg-@tootallnate-once-1.1.2.tgz
https://registry.yarnpkg.com/@tootallnate/once/-/once-2.0.0.tgz -> yarnpkg-@tootallnate-once-2.0.0.tgz
https://registry.yarnpkg.com/@tootallnate/quickjs-emscripten/-/quickjs-emscripten-0.23.0.tgz -> yarnpkg-@tootallnate-quickjs-emscripten-0.23.0.tgz
https://registry.yarnpkg.com/@tufjs/canonical-json/-/canonical-json-1.0.0.tgz -> yarnpkg-@tufjs-canonical-json-1.0.0.tgz
https://registry.yarnpkg.com/@tufjs/models/-/models-1.0.4.tgz -> yarnpkg-@tufjs-models-1.0.4.tgz
https://registry.yarnpkg.com/@types/archiver/-/archiver-5.3.4.tgz -> yarnpkg-@types-archiver-5.3.4.tgz
https://registry.yarnpkg.com/@types/bent/-/bent-7.3.8.tgz -> yarnpkg-@types-bent-7.3.8.tgz
https://registry.yarnpkg.com/@types/body-parser/-/body-parser-1.19.5.tgz -> yarnpkg-@types-body-parser-1.19.5.tgz
https://registry.yarnpkg.com/@types/cacheable-request/-/cacheable-request-6.0.3.tgz -> yarnpkg-@types-cacheable-request-6.0.3.tgz
https://registry.yarnpkg.com/@types/chai-spies/-/chai-spies-1.0.3.tgz -> yarnpkg-@types-chai-spies-1.0.3.tgz
https://registry.yarnpkg.com/@types/chai-string/-/chai-string-1.4.5.tgz -> yarnpkg-@types-chai-string-1.4.5.tgz
https://registry.yarnpkg.com/@types/chai/-/chai-4.3.12.tgz -> yarnpkg-@types-chai-4.3.12.tgz
https://registry.yarnpkg.com/@types/chai/-/chai-4.3.0.tgz -> yarnpkg-@types-chai-4.3.0.tgz
https://registry.yarnpkg.com/@types/connect/-/connect-3.4.38.tgz -> yarnpkg-@types-connect-3.4.38.tgz
https://registry.yarnpkg.com/@types/cookie/-/cookie-0.3.3.tgz -> yarnpkg-@types-cookie-0.3.3.tgz
https://registry.yarnpkg.com/@types/cookie/-/cookie-0.4.1.tgz -> yarnpkg-@types-cookie-0.4.1.tgz
https://registry.yarnpkg.com/@types/cors/-/cors-2.8.17.tgz -> yarnpkg-@types-cors-2.8.17.tgz
https://registry.yarnpkg.com/@types/decompress/-/decompress-4.2.7.tgz -> yarnpkg-@types-decompress-4.2.7.tgz
https://registry.yarnpkg.com/@types/diff/-/diff-5.2.1.tgz -> yarnpkg-@types-diff-5.2.1.tgz
https://registry.yarnpkg.com/@types/docker-modem/-/docker-modem-3.0.6.tgz -> yarnpkg-@types-docker-modem-3.0.6.tgz
https://registry.yarnpkg.com/@types/dockerode/-/dockerode-3.3.23.tgz -> yarnpkg-@types-dockerode-3.3.23.tgz
https://registry.yarnpkg.com/@types/dompurify/-/dompurify-2.4.0.tgz -> yarnpkg-@types-dompurify-2.4.0.tgz
https://registry.yarnpkg.com/@types/escape-html/-/escape-html-0.0.20.tgz -> yarnpkg-@types-escape-html-0.0.20.tgz
https://registry.yarnpkg.com/@types/eslint-scope/-/eslint-scope-3.7.7.tgz -> yarnpkg-@types-eslint-scope-3.7.7.tgz
https://registry.yarnpkg.com/@types/eslint/-/eslint-8.56.3.tgz -> yarnpkg-@types-eslint-8.56.3.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.5.tgz -> yarnpkg-@types-estree-1.0.5.tgz
https://registry.yarnpkg.com/@types/express-http-proxy/-/express-http-proxy-1.6.6.tgz -> yarnpkg-@types-express-http-proxy-1.6.6.tgz
https://registry.yarnpkg.com/@types/express-serve-static-core/-/express-serve-static-core-4.17.43.tgz -> yarnpkg-@types-express-serve-static-core-4.17.43.tgz
https://registry.yarnpkg.com/@types/express/-/express-4.17.21.tgz -> yarnpkg-@types-express-4.17.21.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-4.0.15.tgz -> yarnpkg-@types-fs-extra-4.0.15.tgz
https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-9.0.13.tgz -> yarnpkg-@types-fs-extra-9.0.13.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-8.1.0.tgz -> yarnpkg-@types-glob-8.1.0.tgz
https://registry.yarnpkg.com/@types/highlight.js/-/highlight.js-10.1.0.tgz -> yarnpkg-@types-highlight.js-10.1.0.tgz
https://registry.yarnpkg.com/@types/http-cache-semantics/-/http-cache-semantics-4.0.4.tgz -> yarnpkg-@types-http-cache-semantics-4.0.4.tgz
https://registry.yarnpkg.com/@types/http-errors/-/http-errors-2.0.4.tgz -> yarnpkg-@types-http-errors-2.0.4.tgz
https://registry.yarnpkg.com/@types/js-yaml/-/js-yaml-4.0.9.tgz -> yarnpkg-@types-js-yaml-4.0.9.tgz
https://registry.yarnpkg.com/@types/jsdom/-/jsdom-21.1.7.tgz -> yarnpkg-@types-jsdom-21.1.7.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.15.tgz -> yarnpkg-@types-json-schema-7.0.15.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> yarnpkg-@types-json5-0.0.29.tgz
https://registry.yarnpkg.com/@types/keyv/-/keyv-3.1.4.tgz -> yarnpkg-@types-keyv-3.1.4.tgz
https://registry.yarnpkg.com/@types/linkify-it/-/linkify-it-3.0.5.tgz -> yarnpkg-@types-linkify-it-3.0.5.tgz
https://registry.yarnpkg.com/@types/lodash.clonedeep/-/lodash.clonedeep-4.5.9.tgz -> yarnpkg-@types-lodash.clonedeep-4.5.9.tgz
https://registry.yarnpkg.com/@types/lodash.debounce/-/lodash.debounce-4.0.3.tgz -> yarnpkg-@types-lodash.debounce-4.0.3.tgz
https://registry.yarnpkg.com/@types/lodash.throttle/-/lodash.throttle-4.1.9.tgz -> yarnpkg-@types-lodash.throttle-4.1.9.tgz
https://registry.yarnpkg.com/@types/lodash/-/lodash-4.14.202.tgz -> yarnpkg-@types-lodash-4.14.202.tgz
https://registry.yarnpkg.com/@types/long/-/long-4.0.2.tgz -> yarnpkg-@types-long-4.0.2.tgz
https://registry.yarnpkg.com/@types/luxon/-/luxon-2.4.0.tgz -> yarnpkg-@types-luxon-2.4.0.tgz
https://registry.yarnpkg.com/@types/markdown-it-anchor/-/markdown-it-anchor-4.0.4.tgz -> yarnpkg-@types-markdown-it-anchor-4.0.4.tgz
https://registry.yarnpkg.com/@types/markdown-it/-/markdown-it-13.0.7.tgz -> yarnpkg-@types-markdown-it-13.0.7.tgz
https://registry.yarnpkg.com/@types/markdown-it/-/markdown-it-12.2.3.tgz -> yarnpkg-@types-markdown-it-12.2.3.tgz
https://registry.yarnpkg.com/@types/mdurl/-/mdurl-1.0.5.tgz -> yarnpkg-@types-mdurl-1.0.5.tgz
https://registry.yarnpkg.com/@types/mime-types/-/mime-types-2.1.4.tgz -> yarnpkg-@types-mime-types-2.1.4.tgz
https://registry.yarnpkg.com/@types/mime/-/mime-3.0.4.tgz -> yarnpkg-@types-mime-3.0.4.tgz
https://registry.yarnpkg.com/@types/mime/-/mime-1.3.5.tgz -> yarnpkg-@types-mime-1.3.5.tgz
https://registry.yarnpkg.com/@types/mime/-/mime-2.0.3.tgz -> yarnpkg-@types-mime-2.0.3.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.5.tgz -> yarnpkg-@types-minimatch-3.0.5.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-5.1.2.tgz -> yarnpkg-@types-minimatch-5.1.2.tgz
https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.5.tgz -> yarnpkg-@types-minimist-1.2.5.tgz
https://registry.yarnpkg.com/@types/mocha/-/mocha-10.0.6.tgz -> yarnpkg-@types-mocha-10.0.6.tgz
https://registry.yarnpkg.com/@types/multer/-/multer-1.4.11.tgz -> yarnpkg-@types-multer-1.4.11.tgz
https://registry.yarnpkg.com/@types/mustache/-/mustache-4.2.5.tgz -> yarnpkg-@types-mustache-4.2.5.tgz
https://registry.yarnpkg.com/@types/node-abi/-/node-abi-3.0.3.tgz -> yarnpkg-@types-node-abi-3.0.3.tgz
https://registry.yarnpkg.com/@types/node-fetch/-/node-fetch-2.6.11.tgz -> yarnpkg-@types-node-fetch-2.6.11.tgz
https://registry.yarnpkg.com/@types/node/-/node-18.19.18.tgz -> yarnpkg-@types-node-18.19.18.tgz
https://registry.yarnpkg.com/@types/normalize-package-data/-/normalize-package-data-2.4.4.tgz -> yarnpkg-@types-normalize-package-data-2.4.4.tgz
https://registry.yarnpkg.com/@types/p-queue/-/p-queue-2.3.2.tgz -> yarnpkg-@types-p-queue-2.3.2.tgz
https://registry.yarnpkg.com/@types/prop-types/-/prop-types-15.7.11.tgz -> yarnpkg-@types-prop-types-15.7.11.tgz
https://registry.yarnpkg.com/@types/proxy-from-env/-/proxy-from-env-1.0.4.tgz -> yarnpkg-@types-proxy-from-env-1.0.4.tgz
https://registry.yarnpkg.com/@types/ps-tree/-/ps-tree-1.1.6.tgz -> yarnpkg-@types-ps-tree-1.1.6.tgz
https://registry.yarnpkg.com/@types/qs/-/qs-6.9.11.tgz -> yarnpkg-@types-qs-6.9.11.tgz
https://registry.yarnpkg.com/@types/range-parser/-/range-parser-1.2.7.tgz -> yarnpkg-@types-range-parser-1.2.7.tgz
https://registry.yarnpkg.com/@types/react-dom/-/react-dom-18.2.19.tgz -> yarnpkg-@types-react-dom-18.2.19.tgz
https://registry.yarnpkg.com/@types/react/-/react-18.2.59.tgz -> yarnpkg-@types-react-18.2.59.tgz
https://registry.yarnpkg.com/@types/readdir-glob/-/readdir-glob-1.1.5.tgz -> yarnpkg-@types-readdir-glob-1.1.5.tgz
https://registry.yarnpkg.com/@types/responselike/-/responselike-1.0.3.tgz -> yarnpkg-@types-responselike-1.0.3.tgz
https://registry.yarnpkg.com/@types/route-parser/-/route-parser-0.1.7.tgz -> yarnpkg-@types-route-parser-0.1.7.tgz
https://registry.yarnpkg.com/@types/safer-buffer/-/safer-buffer-2.1.3.tgz -> yarnpkg-@types-safer-buffer-2.1.3.tgz
https://registry.yarnpkg.com/@types/scheduler/-/scheduler-0.16.8.tgz -> yarnpkg-@types-scheduler-0.16.8.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.5.8.tgz -> yarnpkg-@types-semver-7.5.8.tgz
https://registry.yarnpkg.com/@types/send/-/send-0.17.4.tgz -> yarnpkg-@types-send-0.17.4.tgz
https://registry.yarnpkg.com/@types/serve-static/-/serve-static-1.15.5.tgz -> yarnpkg-@types-serve-static-1.15.5.tgz
https://registry.yarnpkg.com/@types/sinon/-/sinon-10.0.20.tgz -> yarnpkg-@types-sinon-10.0.20.tgz
https://registry.yarnpkg.com/@types/sinonjs__fake-timers/-/sinonjs__fake-timers-8.1.5.tgz -> yarnpkg-@types-sinonjs__fake-timers-8.1.5.tgz
https://registry.yarnpkg.com/@types/ssh2-sftp-client/-/ssh2-sftp-client-9.0.3.tgz -> yarnpkg-@types-ssh2-sftp-client-9.0.3.tgz
https://registry.yarnpkg.com/@types/ssh2/-/ssh2-1.11.19.tgz -> yarnpkg-@types-ssh2-1.11.19.tgz
https://registry.yarnpkg.com/@types/tar-fs/-/tar-fs-1.16.3.tgz -> yarnpkg-@types-tar-fs-1.16.3.tgz
https://registry.yarnpkg.com/@types/tar-stream/-/tar-stream-3.1.3.tgz -> yarnpkg-@types-tar-stream-3.1.3.tgz
https://registry.yarnpkg.com/@types/temp/-/temp-0.9.4.tgz -> yarnpkg-@types-temp-0.9.4.tgz
https://registry.yarnpkg.com/@types/tough-cookie/-/tough-cookie-4.0.5.tgz -> yarnpkg-@types-tough-cookie-4.0.5.tgz
https://registry.yarnpkg.com/@types/trusted-types/-/trusted-types-2.0.7.tgz -> yarnpkg-@types-trusted-types-2.0.7.tgz
https://registry.yarnpkg.com/@types/unzipper/-/unzipper-0.9.2.tgz -> yarnpkg-@types-unzipper-0.9.2.tgz
https://registry.yarnpkg.com/@types/uuid/-/uuid-9.0.8.tgz -> yarnpkg-@types-uuid-9.0.8.tgz
https://registry.yarnpkg.com/@types/vscode-notebook-renderer/-/vscode-notebook-renderer-1.72.3.tgz -> yarnpkg-@types-vscode-notebook-renderer-1.72.3.tgz
https://registry.yarnpkg.com/@types/vscode/-/vscode-1.86.0.tgz -> yarnpkg-@types-vscode-1.86.0.tgz
https://registry.yarnpkg.com/@types/which/-/which-1.3.2.tgz -> yarnpkg-@types-which-1.3.2.tgz
https://registry.yarnpkg.com/@types/write-json-file/-/write-json-file-2.2.1.tgz -> yarnpkg-@types-write-json-file-2.2.1.tgz
https://registry.yarnpkg.com/@types/ws/-/ws-8.5.10.tgz -> yarnpkg-@types-ws-8.5.10.tgz
https://registry.yarnpkg.com/@types/yargs-parser/-/yargs-parser-21.0.3.tgz -> yarnpkg-@types-yargs-parser-21.0.3.tgz
https://registry.yarnpkg.com/@types/yargs/-/yargs-15.0.19.tgz -> yarnpkg-@types-yargs-15.0.19.tgz
https://registry.yarnpkg.com/@types/yauzl/-/yauzl-2.10.3.tgz -> yarnpkg-@types-yauzl-2.10.3.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin-tslint/-/eslint-plugin-tslint-6.21.0.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-tslint-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-6.21.0.tgz -> yarnpkg-@typescript-eslint-eslint-plugin-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/experimental-utils/-/experimental-utils-3.10.1.tgz -> yarnpkg-@typescript-eslint-experimental-utils-3.10.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-6.21.0.tgz -> yarnpkg-@typescript-eslint-parser-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-6.21.0.tgz -> yarnpkg-@typescript-eslint-scope-manager-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/type-utils/-/type-utils-6.21.0.tgz -> yarnpkg-@typescript-eslint-type-utils-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-3.10.1.tgz -> yarnpkg-@typescript-eslint-types-3.10.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-6.21.0.tgz -> yarnpkg-@typescript-eslint-types-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-3.10.1.tgz -> yarnpkg-@typescript-eslint-typescript-estree-3.10.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-6.21.0.tgz -> yarnpkg-@typescript-eslint-typescript-estree-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/utils/-/utils-6.21.0.tgz -> yarnpkg-@typescript-eslint-utils-6.21.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-3.10.1.tgz -> yarnpkg-@typescript-eslint-visitor-keys-3.10.1.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-6.21.0.tgz -> yarnpkg-@typescript-eslint-visitor-keys-6.21.0.tgz
https://registry.yarnpkg.com/@virtuoso.dev/react-urx/-/react-urx-0.2.13.tgz -> yarnpkg-@virtuoso.dev-react-urx-0.2.13.tgz
https://registry.yarnpkg.com/@virtuoso.dev/urx/-/urx-0.2.13.tgz -> yarnpkg-@virtuoso.dev-urx-0.2.13.tgz
https://registry.yarnpkg.com/@vscode/codicons/-/codicons-0.0.35.tgz -> yarnpkg-@vscode-codicons-0.0.35.tgz
https://registry.yarnpkg.com/@vscode/debugprotocol/-/debugprotocol-1.64.0.tgz -> yarnpkg-@vscode-debugprotocol-1.64.0.tgz
https://registry.yarnpkg.com/@vscode/proxy-agent/-/proxy-agent-0.13.2.tgz -> yarnpkg-@vscode-proxy-agent-0.13.2.tgz
https://registry.yarnpkg.com/@vscode/ripgrep/-/ripgrep-1.15.9.tgz -> yarnpkg-@vscode-ripgrep-1.15.9.tgz
https://registry.yarnpkg.com/@vscode/vsce/-/vsce-2.24.0.tgz -> yarnpkg-@vscode-vsce-2.24.0.tgz
https://registry.yarnpkg.com/@vscode/windows-ca-certs/-/windows-ca-certs-0.3.1.tgz -> yarnpkg-@vscode-windows-ca-certs-0.3.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.11.6.tgz -> yarnpkg-@webassemblyjs-ast-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> yarnpkg-@webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> yarnpkg-@webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.11.6.tgz -> yarnpkg-@webassemblyjs-helper-buffer-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> yarnpkg-@webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> yarnpkg-@webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.11.6.tgz -> yarnpkg-@webassemblyjs-helper-wasm-section-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> yarnpkg-@webassemblyjs-ieee754-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> yarnpkg-@webassemblyjs-leb128-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> yarnpkg-@webassemblyjs-utf8-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.11.6.tgz -> yarnpkg-@webassemblyjs-wasm-edit-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.11.6.tgz -> yarnpkg-@webassemblyjs-wasm-gen-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.11.6.tgz -> yarnpkg-@webassemblyjs-wasm-opt-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.11.6.tgz -> yarnpkg-@webassemblyjs-wasm-parser-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.11.6.tgz -> yarnpkg-@webassemblyjs-wast-printer-1.11.6.tgz
https://registry.yarnpkg.com/@webpack-cli/configtest/-/configtest-1.2.0.tgz -> yarnpkg-@webpack-cli-configtest-1.2.0.tgz
https://registry.yarnpkg.com/@webpack-cli/info/-/info-1.5.0.tgz -> yarnpkg-@webpack-cli-info-1.5.0.tgz
https://registry.yarnpkg.com/@webpack-cli/serve/-/serve-1.7.0.tgz -> yarnpkg-@webpack-cli-serve-1.7.0.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> yarnpkg-@xtuc-ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> yarnpkg-@xtuc-long-4.2.2.tgz
https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> yarnpkg-@yarnpkg-lockfile-1.1.0.tgz
https://registry.yarnpkg.com/@yarnpkg/parsers/-/parsers-3.0.0-rc.46.tgz -> yarnpkg-@yarnpkg-parsers-3.0.0-rc.46.tgz
https://registry.yarnpkg.com/@zkochan/js-yaml/-/js-yaml-0.0.6.tgz -> yarnpkg-@zkochan-js-yaml-0.0.6.tgz
https://registry.yarnpkg.com/JSONStream/-/JSONStream-1.3.5.tgz -> yarnpkg-JSONStream-1.3.5.tgz
https://registry.yarnpkg.com/abab/-/abab-2.0.6.tgz -> yarnpkg-abab-2.0.6.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz -> yarnpkg-abbrev-1.1.1.tgz
https://registry.yarnpkg.com/abort-controller/-/abort-controller-3.0.0.tgz -> yarnpkg-abort-controller-3.0.0.tgz
https://registry.yarnpkg.com/accepts/-/accepts-1.3.8.tgz -> yarnpkg-accepts-1.3.8.tgz
https://registry.yarnpkg.com/acorn-import-assertions/-/acorn-import-assertions-1.9.0.tgz -> yarnpkg-acorn-import-assertions-1.9.0.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz -> yarnpkg-acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz -> yarnpkg-acorn-7.4.1.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.11.3.tgz -> yarnpkg-acorn-8.11.3.tgz
https://registry.yarnpkg.com/add-stream/-/add-stream-1.0.0.tgz -> yarnpkg-add-stream-1.0.0.tgz
https://registry.yarnpkg.com/advanced-mark.js/-/advanced-mark.js-2.6.0.tgz -> yarnpkg-advanced-mark.js-2.6.0.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-6.0.2.tgz -> yarnpkg-agent-base-6.0.2.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-7.1.0.tgz -> yarnpkg-agent-base-7.1.0.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-7.1.1.tgz -> yarnpkg-agent-base-7.1.1.tgz
https://registry.yarnpkg.com/agentkeepalive/-/agentkeepalive-4.5.0.tgz -> yarnpkg-agentkeepalive-4.5.0.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.1.0.tgz -> yarnpkg-aggregate-error-3.1.0.tgz
https://registry.yarnpkg.com/ajv-formats/-/ajv-formats-2.1.1.tgz -> yarnpkg-ajv-formats-2.1.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz -> yarnpkg-ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-5.1.0.tgz -> yarnpkg-ajv-keywords-5.1.0.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz -> yarnpkg-ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.12.0.tgz -> yarnpkg-ajv-8.12.0.tgz
https://registry.yarnpkg.com/allure-commandline/-/allure-commandline-2.27.0.tgz -> yarnpkg-allure-commandline-2.27.0.tgz
https://registry.yarnpkg.com/allure-js-commons/-/allure-js-commons-2.13.0.tgz -> yarnpkg-allure-js-commons-2.13.0.tgz
https://registry.yarnpkg.com/allure-playwright/-/allure-playwright-2.13.0.tgz -> yarnpkg-allure-playwright-2.13.0.tgz
https://registry.yarnpkg.com/anser/-/anser-2.1.1.tgz -> yarnpkg-anser-2.1.1.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz -> yarnpkg-ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.3.tgz -> yarnpkg-ansi-colors-4.1.3.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.2.tgz -> yarnpkg-ansi-escapes-4.3.2.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz -> yarnpkg-ansi-regex-2.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.1.tgz -> yarnpkg-ansi-regex-4.1.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz -> yarnpkg-ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-6.0.1.tgz -> yarnpkg-ansi-regex-6.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz -> yarnpkg-ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz -> yarnpkg-ansi-styles-4.3.0.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-5.2.0.tgz -> yarnpkg-ansi-styles-5.2.0.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-6.2.1.tgz -> yarnpkg-ansi-styles-6.2.1.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.3.tgz -> yarnpkg-anymatch-3.1.3.tgz
https://registry.yarnpkg.com/append-field/-/append-field-1.0.0.tgz -> yarnpkg-append-field-1.0.0.tgz
https://registry.yarnpkg.com/append-transform/-/append-transform-2.0.0.tgz -> yarnpkg-append-transform-2.0.0.tgz
https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz -> yarnpkg-aproba-1.2.0.tgz
https://registry.yarnpkg.com/aproba/-/aproba-2.0.0.tgz -> yarnpkg-aproba-2.0.0.tgz
https://registry.yarnpkg.com/archiver-utils/-/archiver-utils-2.1.0.tgz -> yarnpkg-archiver-utils-2.1.0.tgz
https://registry.yarnpkg.com/archiver-utils/-/archiver-utils-3.0.4.tgz -> yarnpkg-archiver-utils-3.0.4.tgz
https://registry.yarnpkg.com/archiver/-/archiver-5.3.2.tgz -> yarnpkg-archiver-5.3.2.tgz
https://registry.yarnpkg.com/archy/-/archy-1.0.0.tgz -> yarnpkg-archy-1.0.0.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-3.0.1.tgz -> yarnpkg-are-we-there-yet-3.0.1.tgz
https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.7.tgz -> yarnpkg-are-we-there-yet-1.1.7.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz -> yarnpkg-argparse-1.0.10.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz -> yarnpkg-argparse-2.0.1.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz -> yarnpkg-array-buffer-byte-length-1.0.1.tgz
https://registry.yarnpkg.com/array-differ/-/array-differ-3.0.0.tgz -> yarnpkg-array-differ-3.0.0.tgz
https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz -> yarnpkg-array-flatten-1.1.1.tgz
https://registry.yarnpkg.com/array-ify/-/array-ify-1.0.0.tgz -> yarnpkg-array-ify-1.0.0.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.7.tgz -> yarnpkg-array-includes-3.1.7.tgz
https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz -> yarnpkg-array-union-1.0.2.tgz
https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz -> yarnpkg-array-union-2.1.0.tgz
https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz -> yarnpkg-array-uniq-1.0.3.tgz
https://registry.yarnpkg.com/array.prototype.filter/-/array.prototype.filter-1.0.3.tgz -> yarnpkg-array.prototype.filter-1.0.3.tgz
https://registry.yarnpkg.com/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.4.tgz -> yarnpkg-array.prototype.findlastindex-1.2.4.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.2.tgz -> yarnpkg-array.prototype.flat-1.3.2.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.2.tgz -> yarnpkg-array.prototype.flatmap-1.3.2.tgz
https://registry.yarnpkg.com/array.prototype.tosorted/-/array.prototype.tosorted-1.1.3.tgz -> yarnpkg-array.prototype.tosorted-1.1.3.tgz
https://registry.yarnpkg.com/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz -> yarnpkg-arraybuffer.prototype.slice-1.0.3.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz -> yarnpkg-arrify-1.0.1.tgz
https://registry.yarnpkg.com/arrify/-/arrify-2.0.1.tgz -> yarnpkg-arrify-2.0.1.tgz
https://registry.yarnpkg.com/asn1/-/asn1-0.2.6.tgz -> yarnpkg-asn1-0.2.6.tgz
https://registry.yarnpkg.com/assertion-error/-/assertion-error-1.1.0.tgz -> yarnpkg-assertion-error-1.1.0.tgz
https://registry.yarnpkg.com/ast-types/-/ast-types-0.9.6.tgz -> yarnpkg-ast-types-0.9.6.tgz
https://registry.yarnpkg.com/ast-types/-/ast-types-0.13.4.tgz -> yarnpkg-ast-types-0.13.4.tgz
https://registry.yarnpkg.com/ast-types/-/ast-types-0.9.14.tgz -> yarnpkg-ast-types-0.9.14.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz -> yarnpkg-astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/async-mutex/-/async-mutex-0.3.2.tgz -> yarnpkg-async-mutex-0.3.2.tgz
https://registry.yarnpkg.com/async-mutex/-/async-mutex-0.4.1.tgz -> yarnpkg-async-mutex-0.4.1.tgz
https://registry.yarnpkg.com/async/-/async-2.6.4.tgz -> yarnpkg-async-2.6.4.tgz
https://registry.yarnpkg.com/async/-/async-3.2.5.tgz -> yarnpkg-async-3.2.5.tgz
https://registry.yarnpkg.com/asynciterator.prototype/-/asynciterator.prototype-1.0.0.tgz -> yarnpkg-asynciterator.prototype-1.0.0.tgz
https://registry.yarnpkg.com/asynckit/-/asynckit-0.4.0.tgz -> yarnpkg-asynckit-0.4.0.tgz
https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz -> yarnpkg-at-least-node-1.0.0.tgz
https://registry.yarnpkg.com/atomically/-/atomically-1.7.0.tgz -> yarnpkg-atomically-1.7.0.tgz
https://registry.yarnpkg.com/autosize/-/autosize-4.0.4.tgz -> yarnpkg-autosize-4.0.4.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz -> yarnpkg-available-typed-arrays-1.0.7.tgz
https://registry.yarnpkg.com/axios/-/axios-1.6.7.tgz -> yarnpkg-axios-1.6.7.tgz
https://registry.yarnpkg.com/azure-devops-node-api/-/azure-devops-node-api-11.2.0.tgz -> yarnpkg-azure-devops-node-api-11.2.0.tgz
https://registry.yarnpkg.com/b4a/-/b4a-1.6.7.tgz -> yarnpkg-b4a-1.6.7.tgz
https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.3.0.tgz -> yarnpkg-babel-loader-8.3.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.8.tgz -> yarnpkg-babel-plugin-polyfill-corejs2-0.4.8.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.9.0.tgz -> yarnpkg-babel-plugin-polyfill-corejs3-0.9.0.tgz
https://registry.yarnpkg.com/babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.5.tgz -> yarnpkg-babel-plugin-polyfill-regenerator-0.5.5.tgz
https://registry.yarnpkg.com/babel-polyfill/-/babel-polyfill-6.26.0.tgz -> yarnpkg-babel-polyfill-6.26.0.tgz
https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz -> yarnpkg-babel-runtime-6.26.0.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz -> yarnpkg-balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/bare-events/-/bare-events-2.5.0.tgz -> yarnpkg-bare-events-2.5.0.tgz
https://registry.yarnpkg.com/bare-fs/-/bare-fs-2.3.5.tgz -> yarnpkg-bare-fs-2.3.5.tgz
https://registry.yarnpkg.com/bare-os/-/bare-os-2.4.4.tgz -> yarnpkg-bare-os-2.4.4.tgz
https://registry.yarnpkg.com/bare-path/-/bare-path-2.1.3.tgz -> yarnpkg-bare-path-2.1.3.tgz
https://registry.yarnpkg.com/bare-stream/-/bare-stream-2.3.0.tgz -> yarnpkg-bare-stream-2.3.0.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz -> yarnpkg-base64-js-1.5.1.tgz
https://registry.yarnpkg.com/base64id/-/base64id-2.0.0.tgz -> yarnpkg-base64id-2.0.0.tgz
https://registry.yarnpkg.com/basic-auth/-/basic-auth-2.0.1.tgz -> yarnpkg-basic-auth-2.0.1.tgz
https://registry.yarnpkg.com/basic-ftp/-/basic-ftp-5.0.5.tgz -> yarnpkg-basic-ftp-5.0.5.tgz
https://registry.yarnpkg.com/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz -> yarnpkg-bcrypt-pbkdf-1.0.2.tgz
https://registry.yarnpkg.com/before-after-hook/-/before-after-hook-2.2.3.tgz -> yarnpkg-before-after-hook-2.2.3.tgz
https://registry.yarnpkg.com/bent/-/bent-7.3.12.tgz -> yarnpkg-bent-7.3.12.tgz
https://registry.yarnpkg.com/big-integer/-/big-integer-1.6.52.tgz -> yarnpkg-big-integer-1.6.52.tgz
https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz -> yarnpkg-big.js-5.2.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.2.0.tgz -> yarnpkg-binary-extensions-2.2.0.tgz
https://registry.yarnpkg.com/binary/-/binary-0.3.0.tgz -> yarnpkg-binary-0.3.0.tgz
https://registry.yarnpkg.com/bindings/-/bindings-1.5.0.tgz -> yarnpkg-bindings-1.5.0.tgz
https://registry.yarnpkg.com/bintrees/-/bintrees-1.0.2.tgz -> yarnpkg-bintrees-1.0.2.tgz
https://registry.yarnpkg.com/bl/-/bl-1.2.3.tgz -> yarnpkg-bl-1.2.3.tgz
https://registry.yarnpkg.com/bl/-/bl-4.1.0.tgz -> yarnpkg-bl-4.1.0.tgz
https://registry.yarnpkg.com/bluebird/-/bluebird-3.4.7.tgz -> yarnpkg-bluebird-3.4.7.tgz
https://registry.yarnpkg.com/body-parser/-/body-parser-1.20.3.tgz -> yarnpkg-body-parser-1.20.3.tgz
https://registry.yarnpkg.com/body-parser/-/body-parser-1.20.2.tgz -> yarnpkg-body-parser-1.20.2.tgz
https://registry.yarnpkg.com/boolbase/-/boolbase-1.0.0.tgz -> yarnpkg-boolbase-1.0.0.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz -> yarnpkg-boolean-3.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz -> yarnpkg-brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.1.tgz -> yarnpkg-brace-expansion-2.0.1.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz -> yarnpkg-braces-3.0.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.3.tgz -> yarnpkg-braces-3.0.3.tgz
https://registry.yarnpkg.com/browser-stdout/-/browser-stdout-1.3.1.tgz -> yarnpkg-browser-stdout-1.3.1.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.23.0.tgz -> yarnpkg-browserslist-4.23.0.tgz
https://registry.yarnpkg.com/buffer-alloc-unsafe/-/buffer-alloc-unsafe-1.1.0.tgz -> yarnpkg-buffer-alloc-unsafe-1.1.0.tgz
https://registry.yarnpkg.com/buffer-alloc/-/buffer-alloc-1.2.0.tgz -> yarnpkg-buffer-alloc-1.2.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz -> yarnpkg-buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-fill/-/buffer-fill-1.0.0.tgz -> yarnpkg-buffer-fill-1.0.0.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz -> yarnpkg-buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/buffer-indexof-polyfill/-/buffer-indexof-polyfill-1.0.2.tgz -> yarnpkg-buffer-indexof-polyfill-1.0.2.tgz
https://registry.yarnpkg.com/buffer/-/buffer-5.7.1.tgz -> yarnpkg-buffer-5.7.1.tgz
https://registry.yarnpkg.com/buffer/-/buffer-6.0.3.tgz -> yarnpkg-buffer-6.0.3.tgz
https://registry.yarnpkg.com/buffers/-/buffers-0.1.1.tgz -> yarnpkg-buffers-0.1.1.tgz
https://registry.yarnpkg.com/buildcheck/-/buildcheck-0.0.6.tgz -> yarnpkg-buildcheck-0.0.6.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-1.1.1.tgz -> yarnpkg-builtin-modules-1.1.1.tgz
https://registry.yarnpkg.com/builtins/-/builtins-1.0.3.tgz -> yarnpkg-builtins-1.0.3.tgz
https://registry.yarnpkg.com/builtins/-/builtins-5.0.1.tgz -> yarnpkg-builtins-5.0.1.tgz
https://registry.yarnpkg.com/busboy/-/busboy-1.6.0.tgz -> yarnpkg-busboy-1.6.0.tgz
https://registry.yarnpkg.com/byline/-/byline-5.0.0.tgz -> yarnpkg-byline-5.0.0.tgz
https://registry.yarnpkg.com/byte-size/-/byte-size-8.1.1.tgz -> yarnpkg-byte-size-8.1.1.tgz
https://registry.yarnpkg.com/bytes/-/bytes-3.1.2.tgz -> yarnpkg-bytes-3.1.2.tgz
https://registry.yarnpkg.com/bytesish/-/bytesish-0.4.4.tgz -> yarnpkg-bytesish-0.4.4.tgz
https://registry.yarnpkg.com/cacache/-/cacache-16.1.3.tgz -> yarnpkg-cacache-16.1.3.tgz
https://registry.yarnpkg.com/cacache/-/cacache-17.1.4.tgz -> yarnpkg-cacache-17.1.4.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz -> yarnpkg-cacheable-lookup-5.0.4.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-7.0.4.tgz -> yarnpkg-cacheable-request-7.0.4.tgz
https://registry.yarnpkg.com/caching-transform/-/caching-transform-4.0.0.tgz -> yarnpkg-caching-transform-4.0.0.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.7.tgz -> yarnpkg-call-bind-1.0.7.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz -> yarnpkg-callsites-3.1.0.tgz
https://registry.yarnpkg.com/camelcase-keys/-/camelcase-keys-6.2.2.tgz -> yarnpkg-camelcase-keys-6.2.2.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz -> yarnpkg-camelcase-5.3.1.tgz
https://registry.yarnpkg.com/camelcase/-/camelcase-6.3.0.tgz -> yarnpkg-camelcase-6.3.0.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001591.tgz -> yarnpkg-caniuse-lite-1.0.30001591.tgz
https://registry.yarnpkg.com/caseless/-/caseless-0.12.0.tgz -> yarnpkg-caseless-0.12.0.tgz
https://registry.yarnpkg.com/chai-spies/-/chai-spies-1.0.0.tgz -> yarnpkg-chai-spies-1.0.0.tgz
https://registry.yarnpkg.com/chai-string/-/chai-string-1.5.0.tgz -> yarnpkg-chai-string-1.5.0.tgz
https://registry.yarnpkg.com/chai/-/chai-4.3.10.tgz -> yarnpkg-chai-4.3.10.tgz
https://registry.yarnpkg.com/chai/-/chai-4.4.1.tgz -> yarnpkg-chai-4.4.1.tgz
https://registry.yarnpkg.com/chainsaw/-/chainsaw-0.1.0.tgz -> yarnpkg-chainsaw-0.1.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.0.0.tgz -> yarnpkg-chalk-4.0.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.0.tgz -> yarnpkg-chalk-4.1.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz -> yarnpkg-chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz -> yarnpkg-chalk-4.1.2.tgz
https://registry.yarnpkg.com/chardet/-/chardet-0.7.0.tgz -> yarnpkg-chardet-0.7.0.tgz
https://registry.yarnpkg.com/check-error/-/check-error-1.0.3.tgz -> yarnpkg-check-error-1.0.3.tgz
https://registry.yarnpkg.com/cheerio-select/-/cheerio-select-2.1.0.tgz -> yarnpkg-cheerio-select-2.1.0.tgz
https://registry.yarnpkg.com/cheerio/-/cheerio-1.0.0-rc.12.tgz -> yarnpkg-cheerio-1.0.0-rc.12.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.3.tgz -> yarnpkg-chokidar-3.5.3.tgz
https://registry.yarnpkg.com/chownr/-/chownr-1.1.4.tgz -> yarnpkg-chownr-1.1.4.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz -> yarnpkg-chownr-2.0.0.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.3.tgz -> yarnpkg-chrome-trace-event-1.0.3.tgz
https://registry.yarnpkg.com/chromium-bidi/-/chromium-bidi-0.6.4.tgz -> yarnpkg-chromium-bidi-0.6.4.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-3.9.0.tgz -> yarnpkg-ci-info-3.9.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz -> yarnpkg-clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-3.1.0.tgz -> yarnpkg-cli-cursor-3.1.0.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.6.1.tgz -> yarnpkg-cli-spinners-2.6.1.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.9.2.tgz -> yarnpkg-cli-spinners-2.9.2.tgz
https://registry.yarnpkg.com/cli-width/-/cli-width-3.0.0.tgz -> yarnpkg-cli-width-3.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-6.0.0.tgz -> yarnpkg-cliui-6.0.0.tgz
https://registry.yarnpkg.com/cliui/-/cliui-7.0.4.tgz -> yarnpkg-cliui-7.0.4.tgz
https://registry.yarnpkg.com/cliui/-/cliui-8.0.1.tgz -> yarnpkg-cliui-8.0.1.tgz
https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz -> yarnpkg-clone-deep-4.0.1.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.3.tgz -> yarnpkg-clone-response-1.0.3.tgz
https://registry.yarnpkg.com/clone/-/clone-1.0.4.tgz -> yarnpkg-clone-1.0.4.tgz
https://registry.yarnpkg.com/clone/-/clone-2.1.2.tgz -> yarnpkg-clone-2.1.2.tgz
https://registry.yarnpkg.com/cmd-shim/-/cmd-shim-6.0.1.tgz -> yarnpkg-cmd-shim-6.0.1.tgz
https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz -> yarnpkg-code-point-at-1.1.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz -> yarnpkg-color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz -> yarnpkg-color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz -> yarnpkg-color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz -> yarnpkg-color-name-1.1.4.tgz
https://registry.yarnpkg.com/color-support/-/color-support-1.1.3.tgz -> yarnpkg-color-support-1.1.3.tgz
https://registry.yarnpkg.com/colorette/-/colorette-1.4.0.tgz -> yarnpkg-colorette-1.4.0.tgz
https://registry.yarnpkg.com/columnify/-/columnify-1.6.0.tgz -> yarnpkg-columnify-1.6.0.tgz
https://registry.yarnpkg.com/combined-stream/-/combined-stream-1.0.8.tgz -> yarnpkg-combined-stream-1.0.8.tgz
https://registry.yarnpkg.com/commander/-/commander-2.6.0.tgz -> yarnpkg-commander-2.6.0.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz -> yarnpkg-commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-6.2.1.tgz -> yarnpkg-commander-6.2.1.tgz
https://registry.yarnpkg.com/commander/-/commander-7.2.0.tgz -> yarnpkg-commander-7.2.0.tgz
https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz -> yarnpkg-commondir-1.0.1.tgz
https://registry.yarnpkg.com/compare-func/-/compare-func-2.0.0.tgz -> yarnpkg-compare-func-2.0.0.tgz
https://registry.yarnpkg.com/compress-commons/-/compress-commons-4.1.2.tgz -> yarnpkg-compress-commons-4.1.2.tgz
https://registry.yarnpkg.com/compression-webpack-plugin/-/compression-webpack-plugin-9.2.0.tgz -> yarnpkg-compression-webpack-plugin-9.2.0.tgz
https://registry.yarnpkg.com/computed-style/-/computed-style-0.1.4.tgz -> yarnpkg-computed-style-0.1.4.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz -> yarnpkg-concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz -> yarnpkg-concat-stream-1.6.2.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-2.0.0.tgz -> yarnpkg-concat-stream-2.0.0.tgz
https://registry.yarnpkg.com/concurrently/-/concurrently-3.6.1.tgz -> yarnpkg-concurrently-3.6.1.tgz
https://registry.yarnpkg.com/conf/-/conf-10.2.0.tgz -> yarnpkg-conf-10.2.0.tgz
https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz -> yarnpkg-console-control-strings-1.1.0.tgz
https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.4.tgz -> yarnpkg-content-disposition-0.5.4.tgz
https://registry.yarnpkg.com/content-type/-/content-type-1.0.5.tgz -> yarnpkg-content-type-1.0.5.tgz
https://registry.yarnpkg.com/conventional-changelog-angular/-/conventional-changelog-angular-7.0.0.tgz -> yarnpkg-conventional-changelog-angular-7.0.0.tgz
https://registry.yarnpkg.com/conventional-changelog-core/-/conventional-changelog-core-5.0.1.tgz -> yarnpkg-conventional-changelog-core-5.0.1.tgz
https://registry.yarnpkg.com/conventional-changelog-preset-loader/-/conventional-changelog-preset-loader-3.0.0.tgz -> yarnpkg-conventional-changelog-preset-loader-3.0.0.tgz
https://registry.yarnpkg.com/conventional-changelog-writer/-/conventional-changelog-writer-6.0.1.tgz -> yarnpkg-conventional-changelog-writer-6.0.1.tgz
https://registry.yarnpkg.com/conventional-commits-filter/-/conventional-commits-filter-3.0.0.tgz -> yarnpkg-conventional-commits-filter-3.0.0.tgz
https://registry.yarnpkg.com/conventional-commits-parser/-/conventional-commits-parser-4.0.0.tgz -> yarnpkg-conventional-commits-parser-4.0.0.tgz
https://registry.yarnpkg.com/conventional-recommended-bump/-/conventional-recommended-bump-7.0.1.tgz -> yarnpkg-conventional-recommended-bump-7.0.1.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.9.0.tgz -> yarnpkg-convert-source-map-1.9.0.tgz
https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-2.0.0.tgz -> yarnpkg-convert-source-map-2.0.0.tgz
https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz -> yarnpkg-cookie-signature-1.0.6.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.6.0.tgz -> yarnpkg-cookie-0.6.0.tgz
https://registry.yarnpkg.com/cookie/-/cookie-0.4.2.tgz -> yarnpkg-cookie-0.4.2.tgz
https://registry.yarnpkg.com/copy-anything/-/copy-anything-2.0.6.tgz -> yarnpkg-copy-anything-2.0.6.tgz
https://registry.yarnpkg.com/copy-webpack-plugin/-/copy-webpack-plugin-8.1.1.tgz -> yarnpkg-copy-webpack-plugin-8.1.1.tgz
https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.36.0.tgz -> yarnpkg-core-js-compat-3.36.0.tgz
https://registry.yarnpkg.com/core-js/-/core-js-2.6.12.tgz -> yarnpkg-core-js-2.6.12.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.3.tgz -> yarnpkg-core-util-is-1.0.3.tgz
https://registry.yarnpkg.com/cors/-/cors-2.8.5.tgz -> yarnpkg-cors-2.8.5.tgz
https://registry.yarnpkg.com/corser/-/corser-2.0.1.tgz -> yarnpkg-corser-2.0.1.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-8.3.6.tgz -> yarnpkg-cosmiconfig-8.3.6.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-9.0.0.tgz -> yarnpkg-cosmiconfig-9.0.0.tgz
https://registry.yarnpkg.com/cpu-features/-/cpu-features-0.0.9.tgz -> yarnpkg-cpu-features-0.0.9.tgz
https://registry.yarnpkg.com/crc-32/-/crc-32-1.2.2.tgz -> yarnpkg-crc-32-1.2.2.tgz
https://registry.yarnpkg.com/crc32-stream/-/crc32-stream-4.0.3.tgz -> yarnpkg-crc32-stream-4.0.3.tgz
https://registry.yarnpkg.com/cross-env/-/cross-env-7.0.3.tgz -> yarnpkg-cross-env-7.0.3.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-4.0.2.tgz -> yarnpkg-cross-spawn-4.0.2.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz -> yarnpkg-cross-spawn-7.0.3.tgz
https://registry.yarnpkg.com/css-loader/-/css-loader-6.10.0.tgz -> yarnpkg-css-loader-6.10.0.tgz
https://registry.yarnpkg.com/css-select/-/css-select-5.1.0.tgz -> yarnpkg-css-select-5.1.0.tgz
https://registry.yarnpkg.com/css-what/-/css-what-6.1.0.tgz -> yarnpkg-css-what-6.1.0.tgz
https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz -> yarnpkg-cssesc-3.0.0.tgz
https://registry.yarnpkg.com/cssstyle/-/cssstyle-3.0.0.tgz -> yarnpkg-cssstyle-3.0.0.tgz
https://registry.yarnpkg.com/csstype/-/csstype-3.1.3.tgz -> yarnpkg-csstype-3.1.3.tgz
https://registry.yarnpkg.com/dargs/-/dargs-7.0.0.tgz -> yarnpkg-dargs-7.0.0.tgz
https://registry.yarnpkg.com/data-uri-to-buffer/-/data-uri-to-buffer-6.0.2.tgz -> yarnpkg-data-uri-to-buffer-6.0.2.tgz
https://registry.yarnpkg.com/data-urls/-/data-urls-4.0.0.tgz -> yarnpkg-data-urls-4.0.0.tgz
https://registry.yarnpkg.com/date-fns/-/date-fns-1.30.1.tgz -> yarnpkg-date-fns-1.30.1.tgz
https://registry.yarnpkg.com/dateformat/-/dateformat-3.0.3.tgz -> yarnpkg-dateformat-3.0.3.tgz
https://registry.yarnpkg.com/debounce-fn/-/debounce-fn-4.0.0.tgz -> yarnpkg-debounce-fn-4.0.0.tgz
https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz -> yarnpkg-debug-2.6.9.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.4.tgz -> yarnpkg-debug-4.3.4.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz -> yarnpkg-debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.7.tgz -> yarnpkg-debug-4.3.7.tgz
https://registry.yarnpkg.com/decamelize-keys/-/decamelize-keys-1.1.1.tgz -> yarnpkg-decamelize-keys-1.1.1.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz -> yarnpkg-decamelize-1.2.0.tgz
https://registry.yarnpkg.com/decamelize/-/decamelize-4.0.0.tgz -> yarnpkg-decamelize-4.0.0.tgz
https://registry.yarnpkg.com/decimal.js/-/decimal.js-10.4.3.tgz -> yarnpkg-decimal.js-10.4.3.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-4.2.1.tgz -> yarnpkg-decompress-response-4.2.1.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz -> yarnpkg-decompress-response-6.0.0.tgz
https://registry.yarnpkg.com/decompress-tar/-/decompress-tar-4.1.1.tgz -> yarnpkg-decompress-tar-4.1.1.tgz
https://registry.yarnpkg.com/decompress-tarbz2/-/decompress-tarbz2-4.1.1.tgz -> yarnpkg-decompress-tarbz2-4.1.1.tgz
https://registry.yarnpkg.com/decompress-targz/-/decompress-targz-4.1.1.tgz -> yarnpkg-decompress-targz-4.1.1.tgz
https://registry.yarnpkg.com/decompress-unzip/-/decompress-unzip-4.0.1.tgz -> yarnpkg-decompress-unzip-4.0.1.tgz
https://registry.yarnpkg.com/decompress/-/decompress-4.2.1.tgz -> yarnpkg-decompress-4.2.1.tgz
https://registry.yarnpkg.com/dedent/-/dedent-0.7.0.tgz -> yarnpkg-dedent-0.7.0.tgz
https://registry.yarnpkg.com/deep-eql/-/deep-eql-4.1.3.tgz -> yarnpkg-deep-eql-4.1.3.tgz
https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz -> yarnpkg-deep-extend-0.6.0.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.4.tgz -> yarnpkg-deep-is-0.1.4.tgz
https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.3.1.tgz -> yarnpkg-deepmerge-4.3.1.tgz
https://registry.yarnpkg.com/default-require-extensions/-/default-require-extensions-3.0.1.tgz -> yarnpkg-default-require-extensions-3.0.1.tgz
https://registry.yarnpkg.com/default-shell/-/default-shell-1.0.1.tgz -> yarnpkg-default-shell-1.0.1.tgz
https://registry.yarnpkg.com/defaults/-/defaults-1.0.4.tgz -> yarnpkg-defaults-1.0.4.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-2.0.1.tgz -> yarnpkg-defer-to-connect-2.0.1.tgz
https://registry.yarnpkg.com/define-data-property/-/define-data-property-1.1.4.tgz -> yarnpkg-define-data-property-1.1.4.tgz
https://registry.yarnpkg.com/define-lazy-prop/-/define-lazy-prop-2.0.0.tgz -> yarnpkg-define-lazy-prop-2.0.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.1.tgz -> yarnpkg-define-properties-1.2.1.tgz
https://registry.yarnpkg.com/degenerator/-/degenerator-5.0.1.tgz -> yarnpkg-degenerator-5.0.1.tgz
https://registry.yarnpkg.com/delayed-stream/-/delayed-stream-1.0.0.tgz -> yarnpkg-delayed-stream-1.0.0.tgz
https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz -> yarnpkg-delegates-1.0.0.tgz
https://registry.yarnpkg.com/depd/-/depd-2.0.0.tgz -> yarnpkg-depd-2.0.0.tgz
https://registry.yarnpkg.com/deprecation/-/deprecation-2.3.1.tgz -> yarnpkg-deprecation-2.3.1.tgz
https://registry.yarnpkg.com/destroy/-/destroy-1.2.0.tgz -> yarnpkg-destroy-1.2.0.tgz
https://registry.yarnpkg.com/detect-indent/-/detect-indent-5.0.0.tgz -> yarnpkg-detect-indent-5.0.0.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz -> yarnpkg-detect-libc-1.0.3.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-2.0.2.tgz -> yarnpkg-detect-libc-2.0.2.tgz
https://registry.yarnpkg.com/detect-libc/-/detect-libc-2.0.3.tgz -> yarnpkg-detect-libc-2.0.3.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz -> yarnpkg-detect-node-2.1.0.tgz
https://registry.yarnpkg.com/devtools-protocol/-/devtools-protocol-0.0.1312386.tgz -> yarnpkg-devtools-protocol-0.0.1312386.tgz
https://registry.yarnpkg.com/diff-sequences/-/diff-sequences-29.6.3.tgz -> yarnpkg-diff-sequences-29.6.3.tgz
https://registry.yarnpkg.com/diff/-/diff-5.0.0.tgz -> yarnpkg-diff-5.0.0.tgz
https://registry.yarnpkg.com/diff/-/diff-4.0.2.tgz -> yarnpkg-diff-4.0.2.tgz
https://registry.yarnpkg.com/diff/-/diff-5.2.0.tgz -> yarnpkg-diff-5.2.0.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-2.2.2.tgz -> yarnpkg-dir-glob-2.2.2.tgz
https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz -> yarnpkg-dir-glob-3.0.1.tgz
https://registry.yarnpkg.com/docker-modem/-/docker-modem-5.0.3.tgz -> yarnpkg-docker-modem-5.0.3.tgz
https://registry.yarnpkg.com/dockerode/-/dockerode-4.0.2.tgz -> yarnpkg-dockerode-4.0.2.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz -> yarnpkg-doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz -> yarnpkg-doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dom-serializer/-/dom-serializer-2.0.0.tgz -> yarnpkg-dom-serializer-2.0.0.tgz
https://registry.yarnpkg.com/domelementtype/-/domelementtype-2.3.0.tgz -> yarnpkg-domelementtype-2.3.0.tgz
https://registry.yarnpkg.com/domexception/-/domexception-4.0.0.tgz -> yarnpkg-domexception-4.0.0.tgz
https://registry.yarnpkg.com/domhandler/-/domhandler-5.0.3.tgz -> yarnpkg-domhandler-5.0.3.tgz
https://registry.yarnpkg.com/dompurify/-/dompurify-2.4.7.tgz -> yarnpkg-dompurify-2.4.7.tgz
https://registry.yarnpkg.com/domutils/-/domutils-3.1.0.tgz -> yarnpkg-domutils-3.1.0.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-5.3.0.tgz -> yarnpkg-dot-prop-5.3.0.tgz
https://registry.yarnpkg.com/dot-prop/-/dot-prop-6.0.1.tgz -> yarnpkg-dot-prop-6.0.1.tgz
https://registry.yarnpkg.com/dotenv-expand/-/dotenv-expand-10.0.0.tgz -> yarnpkg-dotenv-expand-10.0.0.tgz
https://registry.yarnpkg.com/dotenv/-/dotenv-16.3.2.tgz -> yarnpkg-dotenv-16.3.2.tgz
https://registry.yarnpkg.com/drivelist/-/drivelist-9.2.4.tgz -> yarnpkg-drivelist-9.2.4.tgz
https://registry.yarnpkg.com/dugite-extra/-/dugite-extra-0.1.17.tgz -> yarnpkg-dugite-extra-0.1.17.tgz
https://registry.yarnpkg.com/dugite-no-gpl/-/dugite-no-gpl-2.0.0.tgz -> yarnpkg-dugite-no-gpl-2.0.0.tgz
https://registry.yarnpkg.com/duplexer2/-/duplexer2-0.1.4.tgz -> yarnpkg-duplexer2-0.1.4.tgz
https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.2.tgz -> yarnpkg-duplexer-0.1.2.tgz
https://registry.yarnpkg.com/eastasianwidth/-/eastasianwidth-0.2.0.tgz -> yarnpkg-eastasianwidth-0.2.0.tgz
https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz -> yarnpkg-ee-first-1.1.1.tgz
https://registry.yarnpkg.com/ejs/-/ejs-3.1.9.tgz -> yarnpkg-ejs-3.1.9.tgz
https://registry.yarnpkg.com/electron-mocha/-/electron-mocha-12.3.0.tgz -> yarnpkg-electron-mocha-12.3.0.tgz
https://registry.yarnpkg.com/electron-rebuild/-/electron-rebuild-3.2.9.tgz -> yarnpkg-electron-rebuild-3.2.9.tgz
https://registry.yarnpkg.com/electron-store/-/electron-store-8.1.0.tgz -> yarnpkg-electron-store-8.1.0.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.4.682.tgz -> yarnpkg-electron-to-chromium-1.4.682.tgz
https://registry.yarnpkg.com/electron-window/-/electron-window-0.8.1.tgz -> yarnpkg-electron-window-0.8.1.tgz
https://registry.yarnpkg.com/electron/-/electron-30.1.2.tgz -> yarnpkg-electron-30.1.2.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz -> yarnpkg-emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-9.2.2.tgz -> yarnpkg-emoji-regex-9.2.2.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz -> yarnpkg-emojis-list-3.0.0.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz -> yarnpkg-encodeurl-1.0.2.tgz
https://registry.yarnpkg.com/encodeurl/-/encodeurl-2.0.0.tgz -> yarnpkg-encodeurl-2.0.0.tgz
https://registry.yarnpkg.com/encoding/-/encoding-0.1.13.tgz -> yarnpkg-encoding-0.1.13.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz -> yarnpkg-end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/engine.io-client/-/engine.io-client-6.5.3.tgz -> yarnpkg-engine.io-client-6.5.3.tgz
https://registry.yarnpkg.com/engine.io-parser/-/engine.io-parser-5.2.2.tgz -> yarnpkg-engine.io-parser-5.2.2.tgz
https://registry.yarnpkg.com/engine.io/-/engine.io-6.5.4.tgz -> yarnpkg-engine.io-6.5.4.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.15.0.tgz -> yarnpkg-enhanced-resolve-5.15.0.tgz
https://registry.yarnpkg.com/enquirer/-/enquirer-2.4.1.tgz -> yarnpkg-enquirer-2.4.1.tgz
https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz -> yarnpkg-enquirer-2.3.6.tgz
https://registry.yarnpkg.com/entities/-/entities-4.5.0.tgz -> yarnpkg-entities-4.5.0.tgz
https://registry.yarnpkg.com/entities/-/entities-2.1.0.tgz -> yarnpkg-entities-2.1.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz -> yarnpkg-env-paths-2.2.1.tgz
https://registry.yarnpkg.com/envinfo/-/envinfo-7.8.1.tgz -> yarnpkg-envinfo-7.8.1.tgz
https://registry.yarnpkg.com/envinfo/-/envinfo-7.11.1.tgz -> yarnpkg-envinfo-7.11.1.tgz
https://registry.yarnpkg.com/err-code/-/err-code-2.0.3.tgz -> yarnpkg-err-code-2.0.3.tgz
https://registry.yarnpkg.com/errno/-/errno-0.1.8.tgz -> yarnpkg-errno-0.1.8.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz -> yarnpkg-error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.22.4.tgz -> yarnpkg-es-abstract-1.22.4.tgz
https://registry.yarnpkg.com/es-array-method-boxes-properly/-/es-array-method-boxes-properly-1.0.0.tgz -> yarnpkg-es-array-method-boxes-properly-1.0.0.tgz
https://registry.yarnpkg.com/es-define-property/-/es-define-property-1.0.0.tgz -> yarnpkg-es-define-property-1.0.0.tgz
https://registry.yarnpkg.com/es-errors/-/es-errors-1.3.0.tgz -> yarnpkg-es-errors-1.3.0.tgz
https://registry.yarnpkg.com/es-iterator-helpers/-/es-iterator-helpers-1.0.17.tgz -> yarnpkg-es-iterator-helpers-1.0.17.tgz
https://registry.yarnpkg.com/es-module-lexer/-/es-module-lexer-1.4.1.tgz -> yarnpkg-es-module-lexer-1.4.1.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz -> yarnpkg-es-set-tostringtag-2.0.3.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz -> yarnpkg-es-shim-unscopables-1.0.2.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz -> yarnpkg-es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz -> yarnpkg-es6-error-4.1.1.tgz
https://registry.yarnpkg.com/es6-promise/-/es6-promise-4.2.8.tgz -> yarnpkg-es6-promise-4.2.8.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.1.2.tgz -> yarnpkg-escalade-3.1.2.tgz
https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz -> yarnpkg-escape-html-1.0.3.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz -> yarnpkg-escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz -> yarnpkg-escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escodegen/-/escodegen-2.1.0.tgz -> yarnpkg-escodegen-2.1.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz -> yarnpkg-eslint-import-resolver-node-0.3.9.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.8.1.tgz -> yarnpkg-eslint-module-utils-2.8.1.tgz
https://registry.yarnpkg.com/eslint-plugin-deprecation/-/eslint-plugin-deprecation-1.2.1.tgz -> yarnpkg-eslint-plugin-deprecation-1.2.1.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.29.1.tgz -> yarnpkg-eslint-plugin-import-2.29.1.tgz
https://registry.yarnpkg.com/eslint-plugin-no-null/-/eslint-plugin-no-null-1.0.2.tgz -> yarnpkg-eslint-plugin-no-null-1.0.2.tgz
https://registry.yarnpkg.com/eslint-plugin-no-unsanitized/-/eslint-plugin-no-unsanitized-4.0.2.tgz -> yarnpkg-eslint-plugin-no-unsanitized-4.0.2.tgz
https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.33.2.tgz -> yarnpkg-eslint-plugin-react-7.33.2.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz -> yarnpkg-eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz -> yarnpkg-eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz -> yarnpkg-eslint-visitor-keys-1.3.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz -> yarnpkg-eslint-visitor-keys-2.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz -> yarnpkg-eslint-visitor-keys-3.4.3.tgz
https://registry.yarnpkg.com/eslint/-/eslint-7.32.0.tgz -> yarnpkg-eslint-7.32.0.tgz
https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz -> yarnpkg-espree-7.3.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz -> yarnpkg-esprima-4.0.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-3.1.3.tgz -> yarnpkg-esprima-3.1.3.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz -> yarnpkg-esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz -> yarnpkg-esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz -> yarnpkg-estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz -> yarnpkg-estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz -> yarnpkg-esutils-2.0.3.tgz
https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz -> yarnpkg-etag-1.8.1.tgz
https://registry.yarnpkg.com/event-stream/-/event-stream-3.3.4.tgz -> yarnpkg-event-stream-3.3.4.tgz
https://registry.yarnpkg.com/event-target-shim/-/event-target-shim-5.0.1.tgz -> yarnpkg-event-target-shim-5.0.1.tgz
https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.7.tgz -> yarnpkg-eventemitter3-4.0.7.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz -> yarnpkg-events-3.3.0.tgz
https://registry.yarnpkg.com/execa/-/execa-5.0.0.tgz -> yarnpkg-execa-5.0.0.tgz
https://registry.yarnpkg.com/execa/-/execa-0.5.1.tgz -> yarnpkg-execa-0.5.1.tgz
https://registry.yarnpkg.com/execa/-/execa-2.1.0.tgz -> yarnpkg-execa-2.1.0.tgz
https://registry.yarnpkg.com/execa/-/execa-5.1.1.tgz -> yarnpkg-execa-5.1.1.tgz
https://registry.yarnpkg.com/expand-template/-/expand-template-2.0.3.tgz -> yarnpkg-expand-template-2.0.3.tgz
https://registry.yarnpkg.com/exponential-backoff/-/exponential-backoff-3.1.1.tgz -> yarnpkg-exponential-backoff-3.1.1.tgz
https://registry.yarnpkg.com/express-http-proxy/-/express-http-proxy-2.1.1.tgz -> yarnpkg-express-http-proxy-2.1.1.tgz
https://registry.yarnpkg.com/express/-/express-4.21.0.tgz -> yarnpkg-express-4.21.0.tgz
https://registry.yarnpkg.com/external-editor/-/external-editor-3.1.0.tgz -> yarnpkg-external-editor-3.1.0.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-2.0.1.tgz -> yarnpkg-extract-zip-2.0.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz -> yarnpkg-fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-fifo/-/fast-fifo-1.3.2.tgz -> yarnpkg-fast-fifo-1.3.2.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.3.2.tgz -> yarnpkg-fast-glob-3.3.2.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz -> yarnpkg-fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz -> yarnpkg-fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fast-plist/-/fast-plist-0.1.3.tgz -> yarnpkg-fast-plist-0.1.3.tgz
https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz -> yarnpkg-fastest-levenshtein-1.0.16.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.17.1.tgz -> yarnpkg-fastq-1.17.1.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz -> yarnpkg-fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/fflate/-/fflate-0.8.2.tgz -> yarnpkg-fflate-0.8.2.tgz
https://registry.yarnpkg.com/figures/-/figures-3.2.0.tgz -> yarnpkg-figures-3.2.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz -> yarnpkg-file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/file-icons-js/-/file-icons-js-1.0.3.tgz -> yarnpkg-file-icons-js-1.0.3.tgz
https://registry.yarnpkg.com/file-type/-/file-type-3.9.0.tgz -> yarnpkg-file-type-3.9.0.tgz
https://registry.yarnpkg.com/file-type/-/file-type-5.2.0.tgz -> yarnpkg-file-type-5.2.0.tgz
https://registry.yarnpkg.com/file-type/-/file-type-6.2.0.tgz -> yarnpkg-file-type-6.2.0.tgz
https://registry.yarnpkg.com/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz -> yarnpkg-file-uri-to-path-1.0.0.tgz
https://registry.yarnpkg.com/filelist/-/filelist-1.0.4.tgz -> yarnpkg-filelist-1.0.4.tgz
https://registry.yarnpkg.com/filename-reserved-regex/-/filename-reserved-regex-2.0.0.tgz -> yarnpkg-filename-reserved-regex-2.0.0.tgz
https://registry.yarnpkg.com/filenamify/-/filenamify-4.3.0.tgz -> yarnpkg-filenamify-4.3.0.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz -> yarnpkg-fill-range-7.0.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.1.1.tgz -> yarnpkg-fill-range-7.1.1.tgz
https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.3.1.tgz -> yarnpkg-finalhandler-1.3.1.tgz
https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.2.tgz -> yarnpkg-find-cache-dir-3.3.2.tgz
https://registry.yarnpkg.com/find-git-exec/-/find-git-exec-0.0.4.tgz -> yarnpkg-find-git-exec-0.0.4.tgz
https://registry.yarnpkg.com/find-git-repositories/-/find-git-repositories-0.1.3.tgz -> yarnpkg-find-git-repositories-0.1.3.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz -> yarnpkg-find-up-5.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz -> yarnpkg-find-up-2.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz -> yarnpkg-find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz -> yarnpkg-find-up-4.1.0.tgz
https://registry.yarnpkg.com/find-yarn-workspace-root/-/find-yarn-workspace-root-2.0.0.tgz -> yarnpkg-find-yarn-workspace-root-2.0.0.tgz
https://registry.yarnpkg.com/fix-path/-/fix-path-3.0.0.tgz -> yarnpkg-fix-path-3.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.2.0.tgz -> yarnpkg-flat-cache-3.2.0.tgz
https://registry.yarnpkg.com/flat/-/flat-5.0.2.tgz -> yarnpkg-flat-5.0.2.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.3.1.tgz -> yarnpkg-flatted-3.3.1.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.5.tgz -> yarnpkg-follow-redirects-1.15.5.tgz
https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.15.6.tgz -> yarnpkg-follow-redirects-1.15.6.tgz
https://registry.yarnpkg.com/font-awesome/-/font-awesome-4.7.0.tgz -> yarnpkg-font-awesome-4.7.0.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz -> yarnpkg-for-each-0.3.3.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-2.0.0.tgz -> yarnpkg-foreground-child-2.0.0.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-3.1.1.tgz -> yarnpkg-foreground-child-3.1.1.tgz
https://registry.yarnpkg.com/form-data-encoder/-/form-data-encoder-1.7.2.tgz -> yarnpkg-form-data-encoder-1.7.2.tgz
https://registry.yarnpkg.com/form-data/-/form-data-4.0.0.tgz -> yarnpkg-form-data-4.0.0.tgz
https://registry.yarnpkg.com/formdata-node/-/formdata-node-4.4.1.tgz -> yarnpkg-formdata-node-4.4.1.tgz
https://registry.yarnpkg.com/forwarded/-/forwarded-0.2.0.tgz -> yarnpkg-forwarded-0.2.0.tgz
https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz -> yarnpkg-fresh-0.5.2.tgz
https://registry.yarnpkg.com/from/-/from-0.1.7.tgz -> yarnpkg-from-0.1.7.tgz
https://registry.yarnpkg.com/fromentries/-/fromentries-1.3.2.tgz -> yarnpkg-fromentries-1.3.2.tgz
https://registry.yarnpkg.com/fs-constants/-/fs-constants-1.0.0.tgz -> yarnpkg-fs-constants-1.0.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz -> yarnpkg-fs-extra-10.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-11.2.0.tgz -> yarnpkg-fs-extra-11.2.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-4.0.3.tgz -> yarnpkg-fs-extra-4.0.3.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz -> yarnpkg-fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.1.0.tgz -> yarnpkg-fs-extra-9.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz -> yarnpkg-fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-3.0.3.tgz -> yarnpkg-fs-minipass-3.0.3.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz -> yarnpkg-fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz -> yarnpkg-fsevents-2.3.2.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.3.tgz -> yarnpkg-fsevents-2.3.3.tgz
https://registry.yarnpkg.com/fstream/-/fstream-1.0.12.tgz -> yarnpkg-fstream-1.0.12.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.2.tgz -> yarnpkg-function-bind-1.1.2.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.6.tgz -> yarnpkg-function.prototype.name-1.1.6.tgz
https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz -> yarnpkg-functional-red-black-tree-1.0.1.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz -> yarnpkg-functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/fuzzy/-/fuzzy-0.1.3.tgz -> yarnpkg-fuzzy-0.1.3.tgz
https://registry.yarnpkg.com/gauge/-/gauge-4.0.4.tgz -> yarnpkg-gauge-4.0.4.tgz
https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz -> yarnpkg-gauge-2.7.4.tgz
https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.2.tgz -> yarnpkg-gensync-1.0.0-beta.2.tgz
https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz -> yarnpkg-get-caller-file-2.0.5.tgz
https://registry.yarnpkg.com/get-func-name/-/get-func-name-2.0.2.tgz -> yarnpkg-get-func-name-2.0.2.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.4.tgz -> yarnpkg-get-intrinsic-1.2.4.tgz
https://registry.yarnpkg.com/get-package-type/-/get-package-type-0.1.0.tgz -> yarnpkg-get-package-type-0.1.0.tgz
https://registry.yarnpkg.com/get-pkg-repo/-/get-pkg-repo-4.2.1.tgz -> yarnpkg-get-pkg-repo-4.2.1.tgz
https://registry.yarnpkg.com/get-port/-/get-port-5.1.1.tgz -> yarnpkg-get-port-5.1.1.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.0.tgz -> yarnpkg-get-stream-6.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-2.3.1.tgz -> yarnpkg-get-stream-2.3.1.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz -> yarnpkg-get-stream-5.2.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-6.0.1.tgz -> yarnpkg-get-stream-6.0.1.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.2.tgz -> yarnpkg-get-symbol-description-1.0.2.tgz
https://registry.yarnpkg.com/get-uri/-/get-uri-6.0.3.tgz -> yarnpkg-get-uri-6.0.3.tgz
https://registry.yarnpkg.com/git-raw-commits/-/git-raw-commits-3.0.0.tgz -> yarnpkg-git-raw-commits-3.0.0.tgz
https://registry.yarnpkg.com/git-remote-origin-url/-/git-remote-origin-url-2.0.0.tgz -> yarnpkg-git-remote-origin-url-2.0.0.tgz
https://registry.yarnpkg.com/git-semver-tags/-/git-semver-tags-5.0.1.tgz -> yarnpkg-git-semver-tags-5.0.1.tgz
https://registry.yarnpkg.com/git-up/-/git-up-7.0.0.tgz -> yarnpkg-git-up-7.0.0.tgz
https://registry.yarnpkg.com/git-url-parse/-/git-url-parse-13.1.0.tgz -> yarnpkg-git-url-parse-13.1.0.tgz
https://registry.yarnpkg.com/gitconfiglocal/-/gitconfiglocal-1.0.0.tgz -> yarnpkg-gitconfiglocal-1.0.0.tgz
https://registry.yarnpkg.com/github-from-package/-/github-from-package-0.0.0.tgz -> yarnpkg-github-from-package-0.0.0.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz -> yarnpkg-glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz -> yarnpkg-glob-to-regexp-0.4.1.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.4.tgz -> yarnpkg-glob-7.1.4.tgz
https://registry.yarnpkg.com/glob/-/glob-8.1.0.tgz -> yarnpkg-glob-8.1.0.tgz
https://registry.yarnpkg.com/glob/-/glob-10.3.10.tgz -> yarnpkg-glob-10.3.10.tgz
https://registry.yarnpkg.com/glob/-/glob-10.4.5.tgz -> yarnpkg-glob-10.4.5.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz -> yarnpkg-glob-7.2.3.tgz
https://registry.yarnpkg.com/glob/-/glob-9.3.5.tgz -> yarnpkg-glob-9.3.5.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz -> yarnpkg-global-agent-3.0.0.tgz
https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz -> yarnpkg-globals-11.12.0.tgz
https://registry.yarnpkg.com/globals/-/globals-13.24.0.tgz -> yarnpkg-globals-13.24.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz -> yarnpkg-globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globby/-/globby-11.1.0.tgz -> yarnpkg-globby-11.1.0.tgz
https://registry.yarnpkg.com/globby/-/globby-7.1.1.tgz -> yarnpkg-globby-7.1.1.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz -> yarnpkg-gopd-1.0.1.tgz
https://registry.yarnpkg.com/got/-/got-11.8.6.tgz -> yarnpkg-got-11.8.6.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz -> yarnpkg-graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/graphemer/-/graphemer-1.4.0.tgz -> yarnpkg-graphemer-1.4.0.tgz
https://registry.yarnpkg.com/handlebars/-/handlebars-4.7.8.tgz -> yarnpkg-handlebars-4.7.8.tgz
https://registry.yarnpkg.com/hard-rejection/-/hard-rejection-2.1.0.tgz -> yarnpkg-hard-rejection-2.1.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz -> yarnpkg-has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-1.0.0.tgz -> yarnpkg-has-flag-1.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz -> yarnpkg-has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz -> yarnpkg-has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz -> yarnpkg-has-property-descriptors-1.0.2.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.3.tgz -> yarnpkg-has-proto-1.0.3.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz -> yarnpkg-has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.2.tgz -> yarnpkg-has-tostringtag-1.0.2.tgz
https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz -> yarnpkg-has-unicode-2.0.1.tgz
https://registry.yarnpkg.com/hasha/-/hasha-5.2.2.tgz -> yarnpkg-hasha-5.2.2.tgz
https://registry.yarnpkg.com/hasown/-/hasown-2.0.1.tgz -> yarnpkg-hasown-2.0.1.tgz
https://registry.yarnpkg.com/he/-/he-1.2.0.tgz -> yarnpkg-he-1.2.0.tgz
https://registry.yarnpkg.com/highlight.js/-/highlight.js-11.9.0.tgz -> yarnpkg-highlight.js-11.9.0.tgz
https://registry.yarnpkg.com/highlight.js/-/highlight.js-10.4.1.tgz -> yarnpkg-highlight.js-10.4.1.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.9.tgz -> yarnpkg-hosted-git-info-2.8.9.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-3.0.8.tgz -> yarnpkg-hosted-git-info-3.0.8.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-4.1.0.tgz -> yarnpkg-hosted-git-info-4.1.0.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-6.1.1.tgz -> yarnpkg-hosted-git-info-6.1.1.tgz
https://registry.yarnpkg.com/html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz -> yarnpkg-html-encoding-sniffer-3.0.0.tgz
https://registry.yarnpkg.com/html-escaper/-/html-escaper-2.0.2.tgz -> yarnpkg-html-escaper-2.0.2.tgz
https://registry.yarnpkg.com/htmlparser2/-/htmlparser2-8.0.2.tgz -> yarnpkg-htmlparser2-8.0.2.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz -> yarnpkg-http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-errors/-/http-errors-2.0.0.tgz -> yarnpkg-http-errors-2.0.0.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-4.0.1.tgz -> yarnpkg-http-proxy-agent-4.0.1.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-5.0.0.tgz -> yarnpkg-http-proxy-agent-5.0.0.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz -> yarnpkg-http-proxy-agent-7.0.2.tgz
https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.1.tgz -> yarnpkg-http-proxy-1.18.1.tgz
https://registry.yarnpkg.com/http-server/-/http-server-14.1.1.tgz -> yarnpkg-http-server-14.1.1.tgz
https://registry.yarnpkg.com/http-status-codes/-/http-status-codes-1.4.0.tgz -> yarnpkg-http-status-codes-1.4.0.tgz
https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-1.0.3.tgz -> yarnpkg-http2-wrapper-1.0.3.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz -> yarnpkg-https-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-7.0.4.tgz -> yarnpkg-https-proxy-agent-7.0.4.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz -> yarnpkg-https-proxy-agent-7.0.5.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-2.1.0.tgz -> yarnpkg-human-signals-2.1.0.tgz
https://registry.yarnpkg.com/humanize-ms/-/humanize-ms-1.2.1.tgz -> yarnpkg-humanize-ms-1.2.1.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz -> yarnpkg-iconv-lite-0.4.24.tgz
https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.6.3.tgz -> yarnpkg-iconv-lite-0.6.3.tgz
https://registry.yarnpkg.com/icss-utils/-/icss-utils-5.1.0.tgz -> yarnpkg-icss-utils-5.1.0.tgz
https://registry.yarnpkg.com/idb/-/idb-4.0.5.tgz -> yarnpkg-idb-4.0.5.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz -> yarnpkg-ieee754-1.2.1.tgz
https://registry.yarnpkg.com/if-env/-/if-env-1.0.4.tgz -> yarnpkg-if-env-1.0.4.tgz
https://registry.yarnpkg.com/ignore-loader/-/ignore-loader-0.1.2.tgz -> yarnpkg-ignore-loader-0.1.2.tgz
https://registry.yarnpkg.com/ignore-styles/-/ignore-styles-5.0.1.tgz -> yarnpkg-ignore-styles-5.0.1.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-5.0.1.tgz -> yarnpkg-ignore-walk-5.0.1.tgz
https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-6.0.4.tgz -> yarnpkg-ignore-walk-6.0.4.tgz
https://registry.yarnpkg.com/ignore/-/ignore-3.3.10.tgz -> yarnpkg-ignore-3.3.10.tgz
https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz -> yarnpkg-ignore-4.0.6.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.3.1.tgz -> yarnpkg-ignore-5.3.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-6.0.2.tgz -> yarnpkg-ignore-6.0.2.tgz
https://registry.yarnpkg.com/image-size/-/image-size-0.5.5.tgz -> yarnpkg-image-size-0.5.5.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz -> yarnpkg-import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-3.1.0.tgz -> yarnpkg-import-local-3.1.0.tgz
https://registry.yarnpkg.com/improved-yarn-audit/-/improved-yarn-audit-3.0.0.tgz -> yarnpkg-improved-yarn-audit-3.0.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz -> yarnpkg-imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz -> yarnpkg-indent-string-4.0.0.tgz
https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz -> yarnpkg-infer-owner-1.0.4.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz -> yarnpkg-inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz -> yarnpkg-inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-1.3.8.tgz -> yarnpkg-ini-1.3.8.tgz
https://registry.yarnpkg.com/init-package-json/-/init-package-json-5.0.0.tgz -> yarnpkg-init-package-json-5.0.0.tgz
https://registry.yarnpkg.com/inquirer/-/inquirer-8.2.6.tgz -> yarnpkg-inquirer-8.2.6.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.7.tgz -> yarnpkg-internal-slot-1.0.7.tgz
https://registry.yarnpkg.com/interpret/-/interpret-2.2.0.tgz -> yarnpkg-interpret-2.2.0.tgz
https://registry.yarnpkg.com/inversify/-/inversify-6.1.3.tgz -> yarnpkg-inversify-6.1.3.tgz
https://registry.yarnpkg.com/ip-address/-/ip-address-9.0.5.tgz -> yarnpkg-ip-address-9.0.5.tgz
https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.1.tgz -> yarnpkg-ipaddr.js-1.9.1.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.4.tgz -> yarnpkg-is-array-buffer-3.0.4.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz -> yarnpkg-is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-async-function/-/is-async-function-2.0.0.tgz -> yarnpkg-is-async-function-2.0.0.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz -> yarnpkg-is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz -> yarnpkg-is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz -> yarnpkg-is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz -> yarnpkg-is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-ci/-/is-ci-3.0.1.tgz -> yarnpkg-is-ci-3.0.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.13.1.tgz -> yarnpkg-is-core-module-2.13.1.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz -> yarnpkg-is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-docker/-/is-docker-2.2.1.tgz -> yarnpkg-is-docker-2.2.1.tgz
https://registry.yarnpkg.com/is-electron-renderer/-/is-electron-renderer-2.0.1.tgz -> yarnpkg-is-electron-renderer-2.0.1.tgz
https://registry.yarnpkg.com/is-electron/-/is-electron-2.2.2.tgz -> yarnpkg-is-electron-2.2.2.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz -> yarnpkg-is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-finalizationregistry/-/is-finalizationregistry-1.0.2.tgz -> yarnpkg-is-finalizationregistry-1.0.2.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz -> yarnpkg-is-fullwidth-code-point-1.0.0.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz -> yarnpkg-is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-generator-function/-/is-generator-function-1.0.10.tgz -> yarnpkg-is-generator-function-1.0.10.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz -> yarnpkg-is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-interactive/-/is-interactive-1.0.0.tgz -> yarnpkg-is-interactive-1.0.0.tgz
https://registry.yarnpkg.com/is-lambda/-/is-lambda-1.0.1.tgz -> yarnpkg-is-lambda-1.0.1.tgz
https://registry.yarnpkg.com/is-map/-/is-map-2.0.2.tgz -> yarnpkg-is-map-2.0.2.tgz
https://registry.yarnpkg.com/is-natural-number/-/is-natural-number-4.0.1.tgz -> yarnpkg-is-natural-number-4.0.1.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.3.tgz -> yarnpkg-is-negative-zero-2.0.3.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz -> yarnpkg-is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz -> yarnpkg-is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-2.0.0.tgz -> yarnpkg-is-obj-2.0.0.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz -> yarnpkg-is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-1.1.0.tgz -> yarnpkg-is-plain-obj-1.1.0.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-2.1.0.tgz -> yarnpkg-is-plain-obj-2.1.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz -> yarnpkg-is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz -> yarnpkg-is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz -> yarnpkg-is-potential-custom-element-name-1.0.1.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz -> yarnpkg-is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-set/-/is-set-2.0.2.tgz -> yarnpkg-is-set-2.0.2.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz -> yarnpkg-is-shared-array-buffer-1.0.3.tgz
https://registry.yarnpkg.com/is-ssh/-/is-ssh-1.4.0.tgz -> yarnpkg-is-ssh-1.4.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.0.tgz -> yarnpkg-is-stream-2.0.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz -> yarnpkg-is-stream-1.1.0.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.1.tgz -> yarnpkg-is-stream-2.0.1.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz -> yarnpkg-is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz -> yarnpkg-is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-text-path/-/is-text-path-1.0.1.tgz -> yarnpkg-is-text-path-1.0.1.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.13.tgz -> yarnpkg-is-typed-array-1.1.13.tgz
https://registry.yarnpkg.com/is-typedarray/-/is-typedarray-1.0.0.tgz -> yarnpkg-is-typedarray-1.0.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz -> yarnpkg-is-unicode-supported-0.1.0.tgz
https://registry.yarnpkg.com/is-weakmap/-/is-weakmap-2.0.1.tgz -> yarnpkg-is-weakmap-2.0.1.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz -> yarnpkg-is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-weakset/-/is-weakset-2.0.2.tgz -> yarnpkg-is-weakset-2.0.2.tgz
https://registry.yarnpkg.com/is-what/-/is-what-3.14.1.tgz -> yarnpkg-is-what-3.14.1.tgz
https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz -> yarnpkg-is-windows-1.0.2.tgz
https://registry.yarnpkg.com/is-wsl/-/is-wsl-2.2.0.tgz -> yarnpkg-is-wsl-2.2.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-2.0.5.tgz -> yarnpkg-isarray-2.0.5.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz -> yarnpkg-isarray-1.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz -> yarnpkg-isexe-2.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-3.1.1.tgz -> yarnpkg-isexe-3.1.1.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz -> yarnpkg-isobject-3.0.1.tgz
https://registry.yarnpkg.com/isomorphic.js/-/isomorphic.js-0.2.5.tgz -> yarnpkg-isomorphic.js-0.2.5.tgz
https://registry.yarnpkg.com/istanbul-lib-coverage/-/istanbul-lib-coverage-3.2.2.tgz -> yarnpkg-istanbul-lib-coverage-3.2.2.tgz
https://registry.yarnpkg.com/istanbul-lib-hook/-/istanbul-lib-hook-3.0.0.tgz -> yarnpkg-istanbul-lib-hook-3.0.0.tgz
https://registry.yarnpkg.com/istanbul-lib-instrument/-/istanbul-lib-instrument-4.0.3.tgz -> yarnpkg-istanbul-lib-instrument-4.0.3.tgz
https://registry.yarnpkg.com/istanbul-lib-processinfo/-/istanbul-lib-processinfo-2.0.3.tgz -> yarnpkg-istanbul-lib-processinfo-2.0.3.tgz
https://registry.yarnpkg.com/istanbul-lib-report/-/istanbul-lib-report-3.0.1.tgz -> yarnpkg-istanbul-lib-report-3.0.1.tgz
https://registry.yarnpkg.com/istanbul-lib-source-maps/-/istanbul-lib-source-maps-4.0.1.tgz -> yarnpkg-istanbul-lib-source-maps-4.0.1.tgz
https://registry.yarnpkg.com/istanbul-reports/-/istanbul-reports-3.1.7.tgz -> yarnpkg-istanbul-reports-3.1.7.tgz
https://registry.yarnpkg.com/iterator.prototype/-/iterator.prototype-1.1.2.tgz -> yarnpkg-iterator.prototype-1.1.2.tgz
https://registry.yarnpkg.com/jackspeak/-/jackspeak-2.3.6.tgz -> yarnpkg-jackspeak-2.3.6.tgz
https://registry.yarnpkg.com/jackspeak/-/jackspeak-3.4.3.tgz -> yarnpkg-jackspeak-3.4.3.tgz
https://registry.yarnpkg.com/jake/-/jake-10.8.7.tgz -> yarnpkg-jake-10.8.7.tgz
https://registry.yarnpkg.com/jest-diff/-/jest-diff-29.7.0.tgz -> yarnpkg-jest-diff-29.7.0.tgz
https://registry.yarnpkg.com/jest-get-type/-/jest-get-type-29.6.3.tgz -> yarnpkg-jest-get-type-29.6.3.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.5.1.tgz -> yarnpkg-jest-worker-27.5.1.tgz
https://registry.yarnpkg.com/js-levenshtein/-/js-levenshtein-1.1.6.tgz -> yarnpkg-js-levenshtein-1.1.6.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz -> yarnpkg-js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz -> yarnpkg-js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.14.1.tgz -> yarnpkg-js-yaml-3.14.1.tgz
https://registry.yarnpkg.com/jsbn/-/jsbn-1.1.0.tgz -> yarnpkg-jsbn-1.1.0.tgz
https://registry.yarnpkg.com/jschardet/-/jschardet-2.3.0.tgz -> yarnpkg-jschardet-2.3.0.tgz
https://registry.yarnpkg.com/jsdom/-/jsdom-22.1.0.tgz -> yarnpkg-jsdom-22.1.0.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.2.tgz -> yarnpkg-jsesc-2.5.2.tgz
https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz -> yarnpkg-jsesc-0.5.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.1.tgz -> yarnpkg-json-buffer-3.0.1.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz -> yarnpkg-json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz -> yarnpkg-json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.1.tgz -> yarnpkg-json-parse-even-better-errors-3.0.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz -> yarnpkg-json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz -> yarnpkg-json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-schema-typed/-/json-schema-typed-7.0.3.tgz -> yarnpkg-json-schema-typed-7.0.3.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz -> yarnpkg-json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json-stable-stringify/-/json-stable-stringify-1.1.1.tgz -> yarnpkg-json-stable-stringify-1.1.1.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz -> yarnpkg-json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz -> yarnpkg-json5-1.0.2.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz -> yarnpkg-json5-2.2.3.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.2.0.tgz -> yarnpkg-jsonc-parser-3.2.0.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-2.3.1.tgz -> yarnpkg-jsonc-parser-2.3.1.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.2.1.tgz -> yarnpkg-jsonc-parser-3.2.1.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz -> yarnpkg-jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.1.0.tgz -> yarnpkg-jsonfile-6.1.0.tgz
https://registry.yarnpkg.com/jsonify/-/jsonify-0.0.1.tgz -> yarnpkg-jsonify-0.0.1.tgz
https://registry.yarnpkg.com/jsonparse/-/jsonparse-1.3.1.tgz -> yarnpkg-jsonparse-1.3.1.tgz
https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.3.5.tgz -> yarnpkg-jsx-ast-utils-3.3.5.tgz
https://registry.yarnpkg.com/just-extend/-/just-extend-6.2.0.tgz -> yarnpkg-just-extend-6.2.0.tgz
https://registry.yarnpkg.com/just-performance/-/just-performance-4.3.0.tgz -> yarnpkg-just-performance-4.3.0.tgz
https://registry.yarnpkg.com/keytar/-/keytar-7.2.0.tgz -> yarnpkg-keytar-7.2.0.tgz
https://registry.yarnpkg.com/keytar/-/keytar-7.9.0.tgz -> yarnpkg-keytar-7.9.0.tgz
https://registry.yarnpkg.com/keyv/-/keyv-4.5.4.tgz -> yarnpkg-keyv-4.5.4.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz -> yarnpkg-kind-of-6.0.3.tgz
https://registry.yarnpkg.com/klaw-sync/-/klaw-sync-6.0.0.tgz -> yarnpkg-klaw-sync-6.0.0.tgz
https://registry.yarnpkg.com/lazystream/-/lazystream-1.0.1.tgz -> yarnpkg-lazystream-1.0.1.tgz
https://registry.yarnpkg.com/lerna/-/lerna-7.4.2.tgz -> yarnpkg-lerna-7.4.2.tgz
https://registry.yarnpkg.com/less/-/less-3.13.1.tgz -> yarnpkg-less-3.13.1.tgz
https://registry.yarnpkg.com/leven/-/leven-3.1.0.tgz -> yarnpkg-leven-3.1.0.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz -> yarnpkg-levn-0.4.1.tgz
https://registry.yarnpkg.com/lib0/-/lib0-0.2.94.tgz -> yarnpkg-lib0-0.2.94.tgz
https://registry.yarnpkg.com/lib0/-/lib0-0.2.93.tgz -> yarnpkg-lib0-0.2.93.tgz
https://registry.yarnpkg.com/libnpmaccess/-/libnpmaccess-7.0.2.tgz -> yarnpkg-libnpmaccess-7.0.2.tgz
https://registry.yarnpkg.com/libnpmpublish/-/libnpmpublish-7.3.0.tgz -> yarnpkg-libnpmpublish-7.3.0.tgz
https://registry.yarnpkg.com/limiter/-/limiter-2.1.0.tgz -> yarnpkg-limiter-2.1.0.tgz
https://registry.yarnpkg.com/line-height/-/line-height-0.3.1.tgz -> yarnpkg-line-height-0.3.1.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.2.4.tgz -> yarnpkg-lines-and-columns-1.2.4.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-2.0.4.tgz -> yarnpkg-lines-and-columns-2.0.4.tgz
https://registry.yarnpkg.com/linkify-it/-/linkify-it-3.0.3.tgz -> yarnpkg-linkify-it-3.0.3.tgz
https://registry.yarnpkg.com/listenercount/-/listenercount-1.0.1.tgz -> yarnpkg-listenercount-1.0.1.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-6.2.0.tgz -> yarnpkg-load-json-file-6.2.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-4.0.0.tgz -> yarnpkg-load-json-file-4.0.0.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.3.0.tgz -> yarnpkg-loader-runner-4.3.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.2.tgz -> yarnpkg-loader-utils-1.4.2.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.4.tgz -> yarnpkg-loader-utils-2.0.4.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz -> yarnpkg-locate-path-2.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz -> yarnpkg-locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz -> yarnpkg-locate-path-5.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz -> yarnpkg-locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz -> yarnpkg-lodash.clonedeep-4.5.0.tgz
https://registry.yarnpkg.com/lodash.debounce/-/lodash.debounce-4.0.8.tgz -> yarnpkg-lodash.debounce-4.0.8.tgz
https://registry.yarnpkg.com/lodash.defaults/-/lodash.defaults-4.2.0.tgz -> yarnpkg-lodash.defaults-4.2.0.tgz
https://registry.yarnpkg.com/lodash.difference/-/lodash.difference-4.5.0.tgz -> yarnpkg-lodash.difference-4.5.0.tgz
https://registry.yarnpkg.com/lodash.flatten/-/lodash.flatten-4.4.0.tgz -> yarnpkg-lodash.flatten-4.4.0.tgz
https://registry.yarnpkg.com/lodash.flattendeep/-/lodash.flattendeep-4.4.0.tgz -> yarnpkg-lodash.flattendeep-4.4.0.tgz
https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz -> yarnpkg-lodash.get-4.4.2.tgz
https://registry.yarnpkg.com/lodash.ismatch/-/lodash.ismatch-4.4.0.tgz -> yarnpkg-lodash.ismatch-4.4.0.tgz
https://registry.yarnpkg.com/lodash.isplainobject/-/lodash.isplainobject-4.0.6.tgz -> yarnpkg-lodash.isplainobject-4.0.6.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz -> yarnpkg-lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash.throttle/-/lodash.throttle-4.1.1.tgz -> yarnpkg-lodash.throttle-4.1.1.tgz
https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz -> yarnpkg-lodash.truncate-4.4.2.tgz
https://registry.yarnpkg.com/lodash.union/-/lodash.union-4.6.0.tgz -> yarnpkg-lodash.union-4.6.0.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz -> yarnpkg-lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.1.0.tgz -> yarnpkg-log-symbols-4.1.0.tgz
https://registry.yarnpkg.com/log-update/-/log-update-4.0.0.tgz -> yarnpkg-log-update-4.0.0.tgz
https://registry.yarnpkg.com/long/-/long-4.0.0.tgz -> yarnpkg-long-4.0.0.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz -> yarnpkg-loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/loupe/-/loupe-2.3.7.tgz -> yarnpkg-loupe-2.3.7.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz -> yarnpkg-lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-10.4.3.tgz -> yarnpkg-lru-cache-10.4.3.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-4.1.5.tgz -> yarnpkg-lru-cache-4.1.5.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz -> yarnpkg-lru-cache-5.1.1.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz -> yarnpkg-lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-7.18.3.tgz -> yarnpkg-lru-cache-7.18.3.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-10.2.0.tgz -> yarnpkg-lru-cache-10.2.0.tgz
https://registry.yarnpkg.com/lunr/-/lunr-2.3.9.tgz -> yarnpkg-lunr-2.3.9.tgz
https://registry.yarnpkg.com/luxon/-/luxon-2.5.2.tgz -> yarnpkg-luxon-2.5.2.tgz
https://registry.yarnpkg.com/lzma-native/-/lzma-native-8.0.6.tgz -> yarnpkg-lzma-native-8.0.6.tgz
https://registry.yarnpkg.com/macaddress/-/macaddress-0.5.3.tgz -> yarnpkg-macaddress-0.5.3.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-4.0.0.tgz -> yarnpkg-make-dir-4.0.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-1.3.0.tgz -> yarnpkg-make-dir-1.3.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-2.1.0.tgz -> yarnpkg-make-dir-2.1.0.tgz
https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz -> yarnpkg-make-dir-3.1.0.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-10.2.1.tgz -> yarnpkg-make-fetch-happen-10.2.1.tgz
https://registry.yarnpkg.com/make-fetch-happen/-/make-fetch-happen-11.1.1.tgz -> yarnpkg-make-fetch-happen-11.1.1.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-1.0.1.tgz -> yarnpkg-map-obj-1.0.1.tgz
https://registry.yarnpkg.com/map-obj/-/map-obj-4.3.0.tgz -> yarnpkg-map-obj-4.3.0.tgz
https://registry.yarnpkg.com/map-stream/-/map-stream-0.1.0.tgz -> yarnpkg-map-stream-0.1.0.tgz
https://registry.yarnpkg.com/markdown-it-anchor/-/markdown-it-anchor-5.0.2.tgz -> yarnpkg-markdown-it-anchor-5.0.2.tgz
https://registry.yarnpkg.com/markdown-it/-/markdown-it-12.3.2.tgz -> yarnpkg-markdown-it-12.3.2.tgz
https://registry.yarnpkg.com/marked/-/marked-4.3.0.tgz -> yarnpkg-marked-4.3.0.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz -> yarnpkg-matcher-3.0.0.tgz
https://registry.yarnpkg.com/mdurl/-/mdurl-1.0.1.tgz -> yarnpkg-mdurl-1.0.1.tgz
https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz -> yarnpkg-media-typer-0.3.0.tgz
https://registry.yarnpkg.com/meow/-/meow-8.1.2.tgz -> yarnpkg-meow-8.1.2.tgz
https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.3.tgz -> yarnpkg-merge-descriptors-1.0.3.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz -> yarnpkg-merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz -> yarnpkg-merge2-1.4.1.tgz
https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz -> yarnpkg-methods-1.1.2.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.5.tgz -> yarnpkg-micromatch-4.0.5.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.8.tgz -> yarnpkg-micromatch-4.0.8.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz -> yarnpkg-mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz -> yarnpkg-mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz -> yarnpkg-mime-1.6.0.tgz
https://registry.yarnpkg.com/mime/-/mime-2.6.0.tgz -> yarnpkg-mime-2.6.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz -> yarnpkg-mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-3.1.0.tgz -> yarnpkg-mimic-fn-3.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz -> yarnpkg-mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-2.1.0.tgz -> yarnpkg-mimic-response-2.1.0.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz -> yarnpkg-mimic-response-3.1.0.tgz
https://registry.yarnpkg.com/min-indent/-/min-indent-1.0.1.tgz -> yarnpkg-min-indent-1.0.1.tgz
https://registry.yarnpkg.com/mini-css-extract-plugin/-/mini-css-extract-plugin-2.8.0.tgz -> yarnpkg-mini-css-extract-plugin-2.8.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.5.tgz -> yarnpkg-minimatch-3.0.5.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.0.1.tgz -> yarnpkg-minimatch-5.0.1.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-9.0.3.tgz -> yarnpkg-minimatch-9.0.3.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz -> yarnpkg-minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-5.1.6.tgz -> yarnpkg-minimatch-5.1.6.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-8.0.4.tgz -> yarnpkg-minimatch-8.0.4.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-9.0.5.tgz -> yarnpkg-minimatch-9.0.5.tgz
https://registry.yarnpkg.com/minimist-options/-/minimist-options-4.1.0.tgz -> yarnpkg-minimist-options-4.1.0.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz -> yarnpkg-minimist-1.2.8.tgz
https://registry.yarnpkg.com/minipass-collect/-/minipass-collect-1.0.2.tgz -> yarnpkg-minipass-collect-1.0.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-2.1.2.tgz -> yarnpkg-minipass-fetch-2.1.2.tgz
https://registry.yarnpkg.com/minipass-fetch/-/minipass-fetch-3.0.4.tgz -> yarnpkg-minipass-fetch-3.0.4.tgz
https://registry.yarnpkg.com/minipass-flush/-/minipass-flush-1.0.5.tgz -> yarnpkg-minipass-flush-1.0.5.tgz
https://registry.yarnpkg.com/minipass-json-stream/-/minipass-json-stream-1.0.1.tgz -> yarnpkg-minipass-json-stream-1.0.1.tgz
https://registry.yarnpkg.com/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz -> yarnpkg-minipass-pipeline-1.2.4.tgz
https://registry.yarnpkg.com/minipass-sized/-/minipass-sized-1.0.3.tgz -> yarnpkg-minipass-sized-1.0.3.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.6.tgz -> yarnpkg-minipass-3.3.6.tgz
https://registry.yarnpkg.com/minipass/-/minipass-4.2.8.tgz -> yarnpkg-minipass-4.2.8.tgz
https://registry.yarnpkg.com/minipass/-/minipass-5.0.0.tgz -> yarnpkg-minipass-5.0.0.tgz
https://registry.yarnpkg.com/minipass/-/minipass-7.0.4.tgz -> yarnpkg-minipass-7.0.4.tgz
https://registry.yarnpkg.com/minipass/-/minipass-7.1.2.tgz -> yarnpkg-minipass-7.1.2.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz -> yarnpkg-minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mitt/-/mitt-3.0.1.tgz -> yarnpkg-mitt-3.0.1.tgz
https://registry.yarnpkg.com/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz -> yarnpkg-mkdirp-classic-0.5.3.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz -> yarnpkg-mkdirp-0.5.6.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz -> yarnpkg-mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/mocha/-/mocha-10.3.0.tgz -> yarnpkg-mocha-10.3.0.tgz
https://registry.yarnpkg.com/mocha/-/mocha-10.4.0.tgz -> yarnpkg-mocha-10.4.0.tgz
https://registry.yarnpkg.com/modify-values/-/modify-values-1.0.1.tgz -> yarnpkg-modify-values-1.0.1.tgz
https://registry.yarnpkg.com/mount-point/-/mount-point-3.0.0.tgz -> yarnpkg-mount-point-3.0.0.tgz
https://registry.yarnpkg.com/move-file/-/move-file-2.1.0.tgz -> yarnpkg-move-file-2.1.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz -> yarnpkg-ms-2.0.0.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.2.tgz -> yarnpkg-ms-2.1.2.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz -> yarnpkg-ms-2.1.3.tgz
https://registry.yarnpkg.com/msgpackr-extract/-/msgpackr-extract-3.0.2.tgz -> yarnpkg-msgpackr-extract-3.0.2.tgz
https://registry.yarnpkg.com/msgpackr/-/msgpackr-1.10.2.tgz -> yarnpkg-msgpackr-1.10.2.tgz
https://registry.yarnpkg.com/multer/-/multer-1.4.4-lts.1.tgz -> yarnpkg-multer-1.4.4-lts.1.tgz
https://registry.yarnpkg.com/multimatch/-/multimatch-5.0.0.tgz -> yarnpkg-multimatch-5.0.0.tgz
https://registry.yarnpkg.com/mustache/-/mustache-4.2.0.tgz -> yarnpkg-mustache-4.2.0.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-0.0.8.tgz -> yarnpkg-mute-stream-0.0.8.tgz
https://registry.yarnpkg.com/mute-stream/-/mute-stream-1.0.0.tgz -> yarnpkg-mute-stream-1.0.0.tgz
https://registry.yarnpkg.com/nan/-/nan-2.20.0.tgz -> yarnpkg-nan-2.20.0.tgz
https://registry.yarnpkg.com/nano/-/nano-10.1.3.tgz -> yarnpkg-nano-10.1.3.tgz
https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.7.tgz -> yarnpkg-nanoid-3.3.7.tgz
https://registry.yarnpkg.com/napi-build-utils/-/napi-build-utils-1.0.2.tgz -> yarnpkg-napi-build-utils-1.0.2.tgz
https://registry.yarnpkg.com/native-keymap/-/native-keymap-2.5.0.tgz -> yarnpkg-native-keymap-2.5.0.tgz
https://registry.yarnpkg.com/native-request/-/native-request-1.1.0.tgz -> yarnpkg-native-request-1.1.0.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz -> yarnpkg-natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.3.tgz -> yarnpkg-negotiator-0.6.3.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz -> yarnpkg-neo-async-2.6.2.tgz
https://registry.yarnpkg.com/netmask/-/netmask-2.0.2.tgz -> yarnpkg-netmask-2.0.2.tgz
https://registry.yarnpkg.com/nise/-/nise-5.1.9.tgz -> yarnpkg-nise-5.1.9.tgz
https://registry.yarnpkg.com/node-abi/-/node-abi-3.56.0.tgz -> yarnpkg-node-abi-3.56.0.tgz
https://registry.yarnpkg.com/node-abi/-/node-abi-2.30.1.tgz -> yarnpkg-node-abi-2.30.1.tgz
https://registry.yarnpkg.com/node-abort-controller/-/node-abort-controller-3.1.1.tgz -> yarnpkg-node-abort-controller-3.1.1.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-3.2.1.tgz -> yarnpkg-node-addon-api-3.2.1.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-4.3.0.tgz -> yarnpkg-node-addon-api-4.3.0.tgz
https://registry.yarnpkg.com/node-addon-api/-/node-addon-api-7.1.1.tgz -> yarnpkg-node-addon-api-7.1.1.tgz
https://registry.yarnpkg.com/node-api-version/-/node-api-version-0.1.4.tgz -> yarnpkg-node-api-version-0.1.4.tgz
https://registry.yarnpkg.com/node-domexception/-/node-domexception-1.0.0.tgz -> yarnpkg-node-domexception-1.0.0.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.7.tgz -> yarnpkg-node-fetch-2.6.7.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.7.0.tgz -> yarnpkg-node-fetch-2.7.0.tgz
https://registry.yarnpkg.com/node-gyp-build-optional-packages/-/node-gyp-build-optional-packages-5.0.7.tgz -> yarnpkg-node-gyp-build-optional-packages-5.0.7.tgz
https://registry.yarnpkg.com/node-gyp-build/-/node-gyp-build-4.8.0.tgz -> yarnpkg-node-gyp-build-4.8.0.tgz
https://registry.yarnpkg.com/node-gyp/-/node-gyp-9.4.1.tgz -> yarnpkg-node-gyp-9.4.1.tgz
https://registry.yarnpkg.com/node-loader/-/node-loader-2.0.0.tgz -> yarnpkg-node-loader-2.0.0.tgz
https://registry.yarnpkg.com/node-machine-id/-/node-machine-id-1.1.12.tgz -> yarnpkg-node-machine-id-1.1.12.tgz
https://registry.yarnpkg.com/node-preload/-/node-preload-0.2.1.tgz -> yarnpkg-node-preload-0.2.1.tgz
https://registry.yarnpkg.com/node-pty/-/node-pty-0.11.0-beta24.tgz -> yarnpkg-node-pty-0.11.0-beta24.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.14.tgz -> yarnpkg-node-releases-2.0.14.tgz
https://registry.yarnpkg.com/node-ssh/-/node-ssh-12.0.5.tgz -> yarnpkg-node-ssh-12.0.5.tgz
https://registry.yarnpkg.com/nodejs-file-downloader/-/nodejs-file-downloader-4.13.0.tgz -> yarnpkg-nodejs-file-downloader-4.13.0.tgz
https://registry.yarnpkg.com/noop-logger/-/noop-logger-0.1.1.tgz -> yarnpkg-noop-logger-0.1.1.tgz
https://registry.yarnpkg.com/nopt/-/nopt-6.0.0.tgz -> yarnpkg-nopt-6.0.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz -> yarnpkg-normalize-package-data-2.5.0.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-3.0.3.tgz -> yarnpkg-normalize-package-data-3.0.3.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-5.0.0.tgz -> yarnpkg-normalize-package-data-5.0.0.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz -> yarnpkg-normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz -> yarnpkg-normalize-url-6.1.0.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.1.2.tgz -> yarnpkg-npm-bundled-1.1.2.tgz
https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-3.0.0.tgz -> yarnpkg-npm-bundled-3.0.0.tgz
https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-6.3.0.tgz -> yarnpkg-npm-install-checks-6.3.0.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-1.0.1.tgz -> yarnpkg-npm-normalize-package-bin-1.0.1.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.1.tgz -> yarnpkg-npm-normalize-package-bin-3.0.1.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-8.1.1.tgz -> yarnpkg-npm-package-arg-8.1.1.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-10.1.0.tgz -> yarnpkg-npm-package-arg-10.1.0.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-5.1.1.tgz -> yarnpkg-npm-packlist-5.1.1.tgz
https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-7.0.4.tgz -> yarnpkg-npm-packlist-7.0.4.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-8.0.2.tgz -> yarnpkg-npm-pick-manifest-8.0.2.tgz
https://registry.yarnpkg.com/npm-registry-fetch/-/npm-registry-fetch-14.0.5.tgz -> yarnpkg-npm-registry-fetch-14.0.5.tgz
https://registry.yarnpkg.com/npm-run-all/-/npm-run-all-1.4.0.tgz -> yarnpkg-npm-run-all-1.4.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz -> yarnpkg-npm-run-path-2.0.2.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-3.1.0.tgz -> yarnpkg-npm-run-path-3.1.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz -> yarnpkg-npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz -> yarnpkg-npmlog-4.1.2.tgz
https://registry.yarnpkg.com/npmlog/-/npmlog-6.0.2.tgz -> yarnpkg-npmlog-6.0.2.tgz
https://registry.yarnpkg.com/nth-check/-/nth-check-2.1.1.tgz -> yarnpkg-nth-check-2.1.1.tgz
https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz -> yarnpkg-number-is-nan-1.0.1.tgz
https://registry.yarnpkg.com/nwsapi/-/nwsapi-2.2.12.tgz -> yarnpkg-nwsapi-2.2.12.tgz
https://registry.yarnpkg.com/nx/-/nx-16.10.0.tgz -> yarnpkg-nx-16.10.0.tgz
https://registry.yarnpkg.com/nyc/-/nyc-15.1.0.tgz -> yarnpkg-nyc-15.1.0.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz -> yarnpkg-object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.13.1.tgz -> yarnpkg-object-inspect-1.13.1.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz -> yarnpkg-object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.5.tgz -> yarnpkg-object.assign-4.1.5.tgz
https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.7.tgz -> yarnpkg-object.entries-1.1.7.tgz
https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.7.tgz -> yarnpkg-object.fromentries-2.0.7.tgz
https://registry.yarnpkg.com/object.groupby/-/object.groupby-1.0.2.tgz -> yarnpkg-object.groupby-1.0.2.tgz
https://registry.yarnpkg.com/object.hasown/-/object.hasown-1.1.3.tgz -> yarnpkg-object.hasown-1.1.3.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.7.tgz -> yarnpkg-object.values-1.1.7.tgz
https://registry.yarnpkg.com/octicons/-/octicons-7.4.0.tgz -> yarnpkg-octicons-7.4.0.tgz
https://registry.yarnpkg.com/ollama/-/ollama-0.5.8.tgz -> yarnpkg-ollama-0.5.8.tgz
https://registry.yarnpkg.com/on-finished/-/on-finished-2.4.1.tgz -> yarnpkg-on-finished-2.4.1.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz -> yarnpkg-once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.2.tgz -> yarnpkg-onetime-5.1.2.tgz
https://registry.yarnpkg.com/open-collaboration-protocol/-/open-collaboration-protocol-0.2.0.tgz -> yarnpkg-open-collaboration-protocol-0.2.0.tgz
https://registry.yarnpkg.com/open-collaboration-yjs/-/open-collaboration-yjs-0.2.0.tgz -> yarnpkg-open-collaboration-yjs-0.2.0.tgz
https://registry.yarnpkg.com/open/-/open-7.4.2.tgz -> yarnpkg-open-7.4.2.tgz
https://registry.yarnpkg.com/open/-/open-8.4.2.tgz -> yarnpkg-open-8.4.2.tgz
https://registry.yarnpkg.com/openai/-/openai-4.55.7.tgz -> yarnpkg-openai-4.55.7.tgz
https://registry.yarnpkg.com/opener/-/opener-1.5.2.tgz -> yarnpkg-opener-1.5.2.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.3.tgz -> yarnpkg-optionator-0.9.3.tgz
https://registry.yarnpkg.com/ora/-/ora-5.4.1.tgz -> yarnpkg-ora-5.4.1.tgz
https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz -> yarnpkg-os-homedir-1.0.2.tgz
https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz -> yarnpkg-os-tmpdir-1.0.2.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-2.1.1.tgz -> yarnpkg-p-cancelable-2.1.1.tgz
https://registry.yarnpkg.com/p-debounce/-/p-debounce-2.1.0.tgz -> yarnpkg-p-debounce-2.1.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz -> yarnpkg-p-finally-1.0.0.tgz
https://registry.yarnpkg.com/p-finally/-/p-finally-2.0.1.tgz -> yarnpkg-p-finally-2.0.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz -> yarnpkg-p-limit-1.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz -> yarnpkg-p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz -> yarnpkg-p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz -> yarnpkg-p-locate-2.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz -> yarnpkg-p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz -> yarnpkg-p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz -> yarnpkg-p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map-series/-/p-map-series-2.1.0.tgz -> yarnpkg-p-map-series-2.1.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz -> yarnpkg-p-map-4.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-3.0.0.tgz -> yarnpkg-p-map-3.0.0.tgz
https://registry.yarnpkg.com/p-pipe/-/p-pipe-3.1.0.tgz -> yarnpkg-p-pipe-3.1.0.tgz
https://registry.yarnpkg.com/p-queue/-/p-queue-6.6.2.tgz -> yarnpkg-p-queue-6.6.2.tgz
https://registry.yarnpkg.com/p-queue/-/p-queue-2.4.2.tgz -> yarnpkg-p-queue-2.4.2.tgz
https://registry.yarnpkg.com/p-reduce/-/p-reduce-2.1.0.tgz -> yarnpkg-p-reduce-2.1.0.tgz
https://registry.yarnpkg.com/p-timeout/-/p-timeout-3.2.0.tgz -> yarnpkg-p-timeout-3.2.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz -> yarnpkg-p-try-1.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz -> yarnpkg-p-try-2.2.0.tgz
https://registry.yarnpkg.com/p-waterfall/-/p-waterfall-2.1.1.tgz -> yarnpkg-p-waterfall-2.1.1.tgz
https://registry.yarnpkg.com/pac-proxy-agent/-/pac-proxy-agent-7.0.2.tgz -> yarnpkg-pac-proxy-agent-7.0.2.tgz
https://registry.yarnpkg.com/pac-resolver/-/pac-resolver-7.0.1.tgz -> yarnpkg-pac-resolver-7.0.1.tgz
https://registry.yarnpkg.com/package-hash/-/package-hash-4.0.0.tgz -> yarnpkg-package-hash-4.0.0.tgz
https://registry.yarnpkg.com/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz -> yarnpkg-package-json-from-dist-1.0.1.tgz
https://registry.yarnpkg.com/pacote/-/pacote-15.2.0.tgz -> yarnpkg-pacote-15.2.0.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz -> yarnpkg-parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz -> yarnpkg-parse-json-4.0.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.2.0.tgz -> yarnpkg-parse-json-5.2.0.tgz
https://registry.yarnpkg.com/parse-path/-/parse-path-7.0.0.tgz -> yarnpkg-parse-path-7.0.0.tgz
https://registry.yarnpkg.com/parse-semver/-/parse-semver-1.1.1.tgz -> yarnpkg-parse-semver-1.1.1.tgz
https://registry.yarnpkg.com/parse-url/-/parse-url-8.1.0.tgz -> yarnpkg-parse-url-8.1.0.tgz
https://registry.yarnpkg.com/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-7.0.0.tgz -> yarnpkg-parse5-htmlparser2-tree-adapter-7.0.0.tgz
https://registry.yarnpkg.com/parse5/-/parse5-7.1.2.tgz -> yarnpkg-parse5-7.1.2.tgz
https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz -> yarnpkg-parseurl-1.3.3.tgz
https://registry.yarnpkg.com/patch-package/-/patch-package-8.0.0.tgz -> yarnpkg-patch-package-8.0.0.tgz
https://registry.yarnpkg.com/path-browserify/-/path-browserify-1.0.1.tgz -> yarnpkg-path-browserify-1.0.1.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz -> yarnpkg-path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz -> yarnpkg-path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz -> yarnpkg-path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz -> yarnpkg-path-key-2.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz -> yarnpkg-path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz -> yarnpkg-path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-root-regex/-/path-root-regex-0.1.2.tgz -> yarnpkg-path-root-regex-0.1.2.tgz
https://registry.yarnpkg.com/path-root/-/path-root-0.1.1.tgz -> yarnpkg-path-root-0.1.1.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.10.1.tgz -> yarnpkg-path-scurry-1.10.1.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.11.1.tgz -> yarnpkg-path-scurry-1.11.1.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.10.tgz -> yarnpkg-path-to-regexp-0.1.10.tgz
https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-6.2.1.tgz -> yarnpkg-path-to-regexp-6.2.1.tgz
https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz -> yarnpkg-path-type-3.0.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz -> yarnpkg-path-type-4.0.0.tgz
https://registry.yarnpkg.com/pathval/-/pathval-1.1.1.tgz -> yarnpkg-pathval-1.1.1.tgz
https://registry.yarnpkg.com/pause-stream/-/pause-stream-0.0.11.tgz -> yarnpkg-pause-stream-0.0.11.tgz
https://registry.yarnpkg.com/pdfobject/-/pdfobject-2.3.0.tgz -> yarnpkg-pdfobject-2.3.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz -> yarnpkg-pend-1.2.0.tgz
https://registry.yarnpkg.com/perfect-scrollbar/-/perfect-scrollbar-1.5.5.tgz -> yarnpkg-perfect-scrollbar-1.5.5.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz -> yarnpkg-picocolors-1.0.0.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz -> yarnpkg-picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-5.0.0.tgz -> yarnpkg-pify-5.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz -> yarnpkg-pify-2.3.0.tgz
https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz -> yarnpkg-pify-3.0.0.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz -> yarnpkg-pify-4.0.1.tgz
https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz -> yarnpkg-pinkie-promise-2.0.1.tgz
https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz -> yarnpkg-pinkie-2.0.4.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz -> yarnpkg-pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/pkg-up/-/pkg-up-3.1.0.tgz -> yarnpkg-pkg-up-3.1.0.tgz
https://registry.yarnpkg.com/playwright-core/-/playwright-core-1.48.2.tgz -> yarnpkg-playwright-core-1.48.2.tgz
https://registry.yarnpkg.com/playwright/-/playwright-1.48.2.tgz -> yarnpkg-playwright-1.48.2.tgz
https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.32.tgz -> yarnpkg-portfinder-1.0.32.tgz
https://registry.yarnpkg.com/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz -> yarnpkg-possible-typed-array-names-1.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-3.0.0.tgz -> yarnpkg-postcss-modules-extract-imports-3.0.0.tgz
https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-4.0.4.tgz -> yarnpkg-postcss-modules-local-by-default-4.0.4.tgz
https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-3.1.1.tgz -> yarnpkg-postcss-modules-scope-3.1.1.tgz
https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-4.0.0.tgz -> yarnpkg-postcss-modules-values-4.0.0.tgz
https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.15.tgz -> yarnpkg-postcss-selector-parser-6.0.15.tgz
https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz -> yarnpkg-postcss-value-parser-4.2.0.tgz
https://registry.yarnpkg.com/postcss/-/postcss-8.4.35.tgz -> yarnpkg-postcss-8.4.35.tgz
https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-5.3.6.tgz -> yarnpkg-prebuild-install-5.3.6.tgz
https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-6.1.4.tgz -> yarnpkg-prebuild-install-6.1.4.tgz
https://registry.yarnpkg.com/prebuild-install/-/prebuild-install-7.1.1.tgz -> yarnpkg-prebuild-install-7.1.1.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz -> yarnpkg-prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/pretty-format/-/pretty-format-29.7.0.tgz -> yarnpkg-pretty-format-29.7.0.tgz
https://registry.yarnpkg.com/private/-/private-0.1.8.tgz -> yarnpkg-private-0.1.8.tgz
https://registry.yarnpkg.com/proc-log/-/proc-log-3.0.0.tgz -> yarnpkg-proc-log-3.0.0.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz -> yarnpkg-process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/process-on-spawn/-/process-on-spawn-1.0.0.tgz -> yarnpkg-process-on-spawn-1.0.0.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz -> yarnpkg-progress-2.0.3.tgz
https://registry.yarnpkg.com/prom-client/-/prom-client-10.2.3.tgz -> yarnpkg-prom-client-10.2.3.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz -> yarnpkg-promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise-retry/-/promise-retry-2.0.1.tgz -> yarnpkg-promise-retry-2.0.1.tgz
https://registry.yarnpkg.com/promzard/-/promzard-1.0.0.tgz -> yarnpkg-promzard-1.0.0.tgz
https://registry.yarnpkg.com/prop-types/-/prop-types-15.8.1.tgz -> yarnpkg-prop-types-15.8.1.tgz
https://registry.yarnpkg.com/properties/-/properties-1.2.1.tgz -> yarnpkg-properties-1.2.1.tgz
https://registry.yarnpkg.com/protocols/-/protocols-2.0.1.tgz -> yarnpkg-protocols-2.0.1.tgz
https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.7.tgz -> yarnpkg-proxy-addr-2.0.7.tgz
https://registry.yarnpkg.com/proxy-agent/-/proxy-agent-6.4.0.tgz -> yarnpkg-proxy-agent-6.4.0.tgz
https://registry.yarnpkg.com/proxy-from-env/-/proxy-from-env-1.1.0.tgz -> yarnpkg-proxy-from-env-1.1.0.tgz
https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz -> yarnpkg-prr-1.0.1.tgz
https://registry.yarnpkg.com/ps-tree/-/ps-tree-1.2.0.tgz -> yarnpkg-ps-tree-1.2.0.tgz
https://registry.yarnpkg.com/pseudomap/-/pseudomap-1.0.2.tgz -> yarnpkg-pseudomap-1.0.2.tgz
https://registry.yarnpkg.com/psl/-/psl-1.9.0.tgz -> yarnpkg-psl-1.9.0.tgz
https://registry.yarnpkg.com/pump/-/pump-1.0.3.tgz -> yarnpkg-pump-1.0.3.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz -> yarnpkg-pump-3.0.0.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.3.1.tgz -> yarnpkg-punycode-2.3.1.tgz
https://registry.yarnpkg.com/puppeteer-core/-/puppeteer-core-23.1.0.tgz -> yarnpkg-puppeteer-core-23.1.0.tgz
https://registry.yarnpkg.com/puppeteer-to-istanbul/-/puppeteer-to-istanbul-1.4.0.tgz -> yarnpkg-puppeteer-to-istanbul-1.4.0.tgz
https://registry.yarnpkg.com/puppeteer/-/puppeteer-23.1.0.tgz -> yarnpkg-puppeteer-23.1.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.0.tgz -> yarnpkg-qs-6.11.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.13.0.tgz -> yarnpkg-qs-6.13.0.tgz
https://registry.yarnpkg.com/qs/-/qs-6.11.2.tgz -> yarnpkg-qs-6.11.2.tgz
https://registry.yarnpkg.com/querystringify/-/querystringify-2.2.0.tgz -> yarnpkg-querystringify-2.2.0.tgz
https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz -> yarnpkg-queue-microtask-1.2.3.tgz
https://registry.yarnpkg.com/queue-tick/-/queue-tick-1.0.1.tgz -> yarnpkg-queue-tick-1.0.1.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-4.0.1.tgz -> yarnpkg-quick-lru-4.0.1.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz -> yarnpkg-quick-lru-5.1.1.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz -> yarnpkg-randombytes-2.1.0.tgz
https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz -> yarnpkg-range-parser-1.2.1.tgz
https://registry.yarnpkg.com/raw-body/-/raw-body-2.5.2.tgz -> yarnpkg-raw-body-2.5.2.tgz
https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz -> yarnpkg-rc-1.2.8.tgz
https://registry.yarnpkg.com/react-autosize-textarea/-/react-autosize-textarea-7.1.0.tgz -> yarnpkg-react-autosize-textarea-7.1.0.tgz
https://registry.yarnpkg.com/react-dom/-/react-dom-18.2.0.tgz -> yarnpkg-react-dom-18.2.0.tgz
https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz -> yarnpkg-react-is-16.13.1.tgz
https://registry.yarnpkg.com/react-is/-/react-is-18.2.0.tgz -> yarnpkg-react-is-18.2.0.tgz
https://registry.yarnpkg.com/react-perfect-scrollbar/-/react-perfect-scrollbar-1.5.8.tgz -> yarnpkg-react-perfect-scrollbar-1.5.8.tgz
https://registry.yarnpkg.com/react-tooltip/-/react-tooltip-4.5.1.tgz -> yarnpkg-react-tooltip-4.5.1.tgz
https://registry.yarnpkg.com/react-virtuoso/-/react-virtuoso-2.19.1.tgz -> yarnpkg-react-virtuoso-2.19.1.tgz
https://registry.yarnpkg.com/react/-/react-18.2.0.tgz -> yarnpkg-react-18.2.0.tgz
https://registry.yarnpkg.com/read-cmd-shim/-/read-cmd-shim-4.0.0.tgz -> yarnpkg-read-cmd-shim-4.0.0.tgz
https://registry.yarnpkg.com/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz -> yarnpkg-read-package-json-fast-3.0.2.tgz
https://registry.yarnpkg.com/read-package-json/-/read-package-json-6.0.4.tgz -> yarnpkg-read-package-json-6.0.4.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-3.0.0.tgz -> yarnpkg-read-pkg-up-3.0.0.tgz
https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-7.0.1.tgz -> yarnpkg-read-pkg-up-7.0.1.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-3.0.0.tgz -> yarnpkg-read-pkg-3.0.0.tgz
https://registry.yarnpkg.com/read-pkg/-/read-pkg-5.2.0.tgz -> yarnpkg-read-pkg-5.2.0.tgz
https://registry.yarnpkg.com/read/-/read-1.0.7.tgz -> yarnpkg-read-1.0.7.tgz
https://registry.yarnpkg.com/read/-/read-2.1.0.tgz -> yarnpkg-read-2.1.0.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.8.tgz -> yarnpkg-readable-stream-2.3.8.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.2.tgz -> yarnpkg-readable-stream-3.6.2.tgz
https://registry.yarnpkg.com/readdir-glob/-/readdir-glob-1.1.3.tgz -> yarnpkg-readdir-glob-1.1.3.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz -> yarnpkg-readdirp-3.6.0.tgz
https://registry.yarnpkg.com/recast/-/recast-0.11.23.tgz -> yarnpkg-recast-0.11.23.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.7.1.tgz -> yarnpkg-rechoir-0.7.1.tgz
https://registry.yarnpkg.com/redent/-/redent-3.0.0.tgz -> yarnpkg-redent-3.0.0.tgz
https://registry.yarnpkg.com/reflect-metadata/-/reflect-metadata-0.1.14.tgz -> yarnpkg-reflect-metadata-0.1.14.tgz
https://registry.yarnpkg.com/reflect.getprototypeof/-/reflect.getprototypeof-1.0.5.tgz -> yarnpkg-reflect.getprototypeof-1.0.5.tgz
https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.1.tgz -> yarnpkg-regenerate-unicode-properties-10.1.1.tgz
https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.2.tgz -> yarnpkg-regenerate-1.4.2.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.10.5.tgz -> yarnpkg-regenerator-runtime-0.10.5.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz -> yarnpkg-regenerator-runtime-0.11.1.tgz
https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.14.1.tgz -> yarnpkg-regenerator-runtime-0.14.1.tgz
https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.15.2.tgz -> yarnpkg-regenerator-transform-0.15.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz -> yarnpkg-regexp.prototype.flags-1.5.2.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.2.0.tgz -> yarnpkg-regexpp-3.2.0.tgz
https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-5.3.2.tgz -> yarnpkg-regexpu-core-5.3.2.tgz
https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.9.1.tgz -> yarnpkg-regjsparser-0.9.1.tgz
https://registry.yarnpkg.com/release-zalgo/-/release-zalgo-1.0.0.tgz -> yarnpkg-release-zalgo-1.0.0.tgz
https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz -> yarnpkg-require-directory-2.1.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz -> yarnpkg-require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz -> yarnpkg-require-main-filename-2.0.0.tgz
https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz -> yarnpkg-requires-port-1.0.0.tgz
https://registry.yarnpkg.com/resolve-alpn/-/resolve-alpn-1.2.1.tgz -> yarnpkg-resolve-alpn-1.2.1.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz -> yarnpkg-resolve-cwd-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz -> yarnpkg-resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz -> yarnpkg-resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-package-path/-/resolve-package-path-4.0.3.tgz -> yarnpkg-resolve-package-path-4.0.3.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.8.tgz -> yarnpkg-resolve-1.22.8.tgz
https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.5.tgz -> yarnpkg-resolve-2.0.0-next.5.tgz
https://registry.yarnpkg.com/responselike/-/responselike-2.0.1.tgz -> yarnpkg-responselike-2.0.1.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-3.1.0.tgz -> yarnpkg-restore-cursor-3.1.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz -> yarnpkg-retry-0.12.0.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz -> yarnpkg-reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz -> yarnpkg-rimraf-2.7.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz -> yarnpkg-rimraf-3.0.2.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-4.4.1.tgz -> yarnpkg-rimraf-4.4.1.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-5.0.10.tgz -> yarnpkg-rimraf-5.0.10.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.3.tgz -> yarnpkg-rimraf-2.6.3.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz -> yarnpkg-roarr-2.15.4.tgz
https://registry.yarnpkg.com/route-parser/-/route-parser-0.0.5.tgz -> yarnpkg-route-parser-0.0.5.tgz
https://registry.yarnpkg.com/rrweb-cssom/-/rrweb-cssom-0.6.0.tgz -> yarnpkg-rrweb-cssom-0.6.0.tgz
https://registry.yarnpkg.com/run-async/-/run-async-2.4.1.tgz -> yarnpkg-run-async-2.4.1.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz -> yarnpkg-run-parallel-1.2.0.tgz
https://registry.yarnpkg.com/rx/-/rx-2.3.24.tgz -> yarnpkg-rx-2.3.24.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-7.8.1.tgz -> yarnpkg-rxjs-7.8.1.tgz
https://registry.yarnpkg.com/safe-array-concat/-/safe-array-concat-1.1.0.tgz -> yarnpkg-safe-array-concat-1.1.0.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz -> yarnpkg-safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz -> yarnpkg-safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.3.tgz -> yarnpkg-safe-regex-test-1.0.3.tgz
https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz -> yarnpkg-safer-buffer-2.1.2.tgz
https://registry.yarnpkg.com/sanitize-filename/-/sanitize-filename-1.6.3.tgz -> yarnpkg-sanitize-filename-1.6.3.tgz
https://registry.yarnpkg.com/sax/-/sax-1.3.0.tgz -> yarnpkg-sax-1.3.0.tgz
https://registry.yarnpkg.com/saxes/-/saxes-6.0.0.tgz -> yarnpkg-saxes-6.0.0.tgz
https://registry.yarnpkg.com/sb-promise-queue/-/sb-promise-queue-2.1.0.tgz -> yarnpkg-sb-promise-queue-2.1.0.tgz
https://registry.yarnpkg.com/sb-scandir/-/sb-scandir-3.1.0.tgz -> yarnpkg-sb-scandir-3.1.0.tgz
https://registry.yarnpkg.com/scheduler/-/scheduler-0.23.0.tgz -> yarnpkg-scheduler-0.23.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.1.tgz -> yarnpkg-schema-utils-2.7.1.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.3.0.tgz -> yarnpkg-schema-utils-3.3.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-4.2.0.tgz -> yarnpkg-schema-utils-4.2.0.tgz
https://registry.yarnpkg.com/secure-compare/-/secure-compare-3.0.1.tgz -> yarnpkg-secure-compare-3.0.1.tgz
https://registry.yarnpkg.com/seek-bzip/-/seek-bzip-1.0.6.tgz -> yarnpkg-seek-bzip-1.0.6.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz -> yarnpkg-semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver/-/semver-5.7.2.tgz -> yarnpkg-semver-5.7.2.tgz
https://registry.yarnpkg.com/semver/-/semver-7.5.3.tgz -> yarnpkg-semver-7.5.3.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.1.tgz -> yarnpkg-semver-6.3.1.tgz
https://registry.yarnpkg.com/semver/-/semver-7.6.0.tgz -> yarnpkg-semver-7.6.0.tgz
https://registry.yarnpkg.com/semver/-/semver-7.6.2.tgz -> yarnpkg-semver-7.6.2.tgz
https://registry.yarnpkg.com/semver/-/semver-7.6.3.tgz -> yarnpkg-semver-7.6.3.tgz
https://registry.yarnpkg.com/send/-/send-0.19.0.tgz -> yarnpkg-send-0.19.0.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz -> yarnpkg-serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.0.tgz -> yarnpkg-serialize-javascript-6.0.0.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-5.0.1.tgz -> yarnpkg-serialize-javascript-5.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.2.tgz -> yarnpkg-serialize-javascript-6.0.2.tgz
https://registry.yarnpkg.com/serve-static/-/serve-static-1.16.2.tgz -> yarnpkg-serve-static-1.16.2.tgz
https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz -> yarnpkg-set-blocking-2.0.0.tgz
https://registry.yarnpkg.com/set-function-length/-/set-function-length-1.2.1.tgz -> yarnpkg-set-function-length-1.2.1.tgz
https://registry.yarnpkg.com/set-function-name/-/set-function-name-2.0.2.tgz -> yarnpkg-set-function-name-2.0.2.tgz
https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz -> yarnpkg-setimmediate-1.0.5.tgz
https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.2.0.tgz -> yarnpkg-setprototypeof-1.2.0.tgz
https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz -> yarnpkg-shallow-clone-3.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz -> yarnpkg-shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz -> yarnpkg-shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/shell-env/-/shell-env-0.3.0.tgz -> yarnpkg-shell-env-0.3.0.tgz
https://registry.yarnpkg.com/shell-escape/-/shell-escape-0.2.0.tgz -> yarnpkg-shell-escape-0.2.0.tgz
https://registry.yarnpkg.com/shell-path/-/shell-path-2.1.0.tgz -> yarnpkg-shell-path-2.1.0.tgz
https://registry.yarnpkg.com/shell-quote/-/shell-quote-1.8.1.tgz -> yarnpkg-shell-quote-1.8.1.tgz
https://registry.yarnpkg.com/shiki/-/shiki-0.10.1.tgz -> yarnpkg-shiki-0.10.1.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.5.tgz -> yarnpkg-side-channel-1.0.5.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.6.tgz -> yarnpkg-side-channel-1.0.6.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.7.tgz -> yarnpkg-signal-exit-3.0.7.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-4.1.0.tgz -> yarnpkg-signal-exit-4.1.0.tgz
https://registry.yarnpkg.com/sigstore/-/sigstore-1.9.0.tgz -> yarnpkg-sigstore-1.9.0.tgz
https://registry.yarnpkg.com/simple-concat/-/simple-concat-1.0.1.tgz -> yarnpkg-simple-concat-1.0.1.tgz
https://registry.yarnpkg.com/simple-get/-/simple-get-3.1.1.tgz -> yarnpkg-simple-get-3.1.1.tgz
https://registry.yarnpkg.com/simple-get/-/simple-get-4.0.1.tgz -> yarnpkg-simple-get-4.0.1.tgz
https://registry.yarnpkg.com/sinon/-/sinon-12.0.1.tgz -> yarnpkg-sinon-12.0.1.tgz
https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz -> yarnpkg-slash-3.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-1.0.0.tgz -> yarnpkg-slash-1.0.0.tgz
https://registry.yarnpkg.com/slash/-/slash-2.0.0.tgz -> yarnpkg-slash-2.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz -> yarnpkg-slice-ansi-4.0.0.tgz
https://registry.yarnpkg.com/smart-buffer/-/smart-buffer-4.2.0.tgz -> yarnpkg-smart-buffer-4.2.0.tgz
https://registry.yarnpkg.com/socket.io-adapter/-/socket.io-adapter-2.5.4.tgz -> yarnpkg-socket.io-adapter-2.5.4.tgz
https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-4.7.4.tgz -> yarnpkg-socket.io-client-4.7.4.tgz
https://registry.yarnpkg.com/socket.io-client/-/socket.io-client-4.7.5.tgz -> yarnpkg-socket.io-client-4.7.5.tgz
https://registry.yarnpkg.com/socket.io-parser/-/socket.io-parser-4.2.4.tgz -> yarnpkg-socket.io-parser-4.2.4.tgz
https://registry.yarnpkg.com/socket.io/-/socket.io-4.7.4.tgz -> yarnpkg-socket.io-4.7.4.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-5.0.1.tgz -> yarnpkg-socks-proxy-agent-5.0.1.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-7.0.0.tgz -> yarnpkg-socks-proxy-agent-7.0.0.tgz
https://registry.yarnpkg.com/socks-proxy-agent/-/socks-proxy-agent-8.0.4.tgz -> yarnpkg-socks-proxy-agent-8.0.4.tgz
https://registry.yarnpkg.com/socks/-/socks-2.8.1.tgz -> yarnpkg-socks-2.8.1.tgz
https://registry.yarnpkg.com/socks/-/socks-2.8.3.tgz -> yarnpkg-socks-2.8.3.tgz
https://registry.yarnpkg.com/sort-keys/-/sort-keys-2.0.0.tgz -> yarnpkg-sort-keys-2.0.0.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-0.6.2.tgz -> yarnpkg-source-map-js-0.6.2.tgz
https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz -> yarnpkg-source-map-js-1.0.2.tgz
https://registry.yarnpkg.com/source-map-loader/-/source-map-loader-2.0.2.tgz -> yarnpkg-source-map-loader-2.0.2.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz -> yarnpkg-source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz -> yarnpkg-source-map-0.6.1.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz -> yarnpkg-source-map-0.5.7.tgz
https://registry.yarnpkg.com/spawn-command/-/spawn-command-0.0.2-1.tgz -> yarnpkg-spawn-command-0.0.2-1.tgz
https://registry.yarnpkg.com/spawn-wrap/-/spawn-wrap-2.0.0.tgz -> yarnpkg-spawn-wrap-2.0.0.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz -> yarnpkg-spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.5.0.tgz -> yarnpkg-spdx-exceptions-2.5.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz -> yarnpkg-spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.17.tgz -> yarnpkg-spdx-license-ids-3.0.17.tgz
https://registry.yarnpkg.com/split-ca/-/split-ca-1.0.1.tgz -> yarnpkg-split-ca-1.0.1.tgz
https://registry.yarnpkg.com/split2/-/split2-3.2.2.tgz -> yarnpkg-split2-3.2.2.tgz
https://registry.yarnpkg.com/split/-/split-0.3.3.tgz -> yarnpkg-split-0.3.3.tgz
https://registry.yarnpkg.com/split/-/split-1.0.1.tgz -> yarnpkg-split-1.0.1.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.3.tgz -> yarnpkg-sprintf-js-1.1.3.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz -> yarnpkg-sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/ssh2-sftp-client/-/ssh2-sftp-client-9.1.0.tgz -> yarnpkg-ssh2-sftp-client-9.1.0.tgz
https://registry.yarnpkg.com/ssh2/-/ssh2-1.15.0.tgz -> yarnpkg-ssh2-1.15.0.tgz
https://registry.yarnpkg.com/ssri/-/ssri-10.0.5.tgz -> yarnpkg-ssri-10.0.5.tgz
https://registry.yarnpkg.com/ssri/-/ssri-9.0.1.tgz -> yarnpkg-ssri-9.0.1.tgz
https://registry.yarnpkg.com/stat-mode/-/stat-mode-1.0.0.tgz -> yarnpkg-stat-mode-1.0.0.tgz
https://registry.yarnpkg.com/statuses/-/statuses-2.0.1.tgz -> yarnpkg-statuses-2.0.1.tgz
https://registry.yarnpkg.com/stream-combiner/-/stream-combiner-0.0.4.tgz -> yarnpkg-stream-combiner-0.0.4.tgz
https://registry.yarnpkg.com/streamsearch/-/streamsearch-1.1.0.tgz -> yarnpkg-streamsearch-1.1.0.tgz
https://registry.yarnpkg.com/streamx/-/streamx-2.20.1.tgz -> yarnpkg-streamx-2.20.1.tgz
https://registry.yarnpkg.com/string-argv/-/string-argv-0.1.2.tgz -> yarnpkg-string-argv-0.1.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz -> yarnpkg-string-width-1.0.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz -> yarnpkg-string-width-4.2.3.tgz
https://registry.yarnpkg.com/string-width/-/string-width-5.1.2.tgz -> yarnpkg-string-width-5.1.2.tgz
https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.10.tgz -> yarnpkg-string.prototype.matchall-4.0.10.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.8.tgz -> yarnpkg-string.prototype.trim-1.2.8.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.7.tgz -> yarnpkg-string.prototype.trimend-1.0.7.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.7.tgz -> yarnpkg-string.prototype.trimstart-1.0.7.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz -> yarnpkg-string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz -> yarnpkg-string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz -> yarnpkg-strip-ansi-3.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz -> yarnpkg-strip-ansi-5.2.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz -> yarnpkg-strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-7.1.0.tgz -> yarnpkg-strip-ansi-7.1.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz -> yarnpkg-strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-4.0.0.tgz -> yarnpkg-strip-bom-4.0.0.tgz
https://registry.yarnpkg.com/strip-dirs/-/strip-dirs-2.1.0.tgz -> yarnpkg-strip-dirs-2.1.0.tgz
https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz -> yarnpkg-strip-eof-1.0.0.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz -> yarnpkg-strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-indent/-/strip-indent-3.0.0.tgz -> yarnpkg-strip-indent-3.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz -> yarnpkg-strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz -> yarnpkg-strip-json-comments-2.0.1.tgz
https://registry.yarnpkg.com/strip-outer/-/strip-outer-1.0.1.tgz -> yarnpkg-strip-outer-1.0.1.tgz
https://registry.yarnpkg.com/strong-log-transformer/-/strong-log-transformer-2.1.0.tgz -> yarnpkg-strong-log-transformer-2.1.0.tgz
https://registry.yarnpkg.com/style-loader/-/style-loader-2.0.0.tgz -> yarnpkg-style-loader-2.0.0.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz -> yarnpkg-sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz -> yarnpkg-supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-3.2.3.tgz -> yarnpkg-supports-color-3.2.3.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz -> yarnpkg-supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.2.0.tgz -> yarnpkg-supports-color-7.2.0.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz -> yarnpkg-supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/symbol-tree/-/symbol-tree-3.2.4.tgz -> yarnpkg-symbol-tree-3.2.4.tgz
https://registry.yarnpkg.com/table/-/table-6.8.1.tgz -> yarnpkg-table-6.8.1.tgz
https://registry.yarnpkg.com/tapable/-/tapable-2.2.1.tgz -> yarnpkg-tapable-2.2.1.tgz
https://registry.yarnpkg.com/tar-fs/-/tar-fs-1.16.3.tgz -> yarnpkg-tar-fs-1.16.3.tgz
https://registry.yarnpkg.com/tar-fs/-/tar-fs-2.1.1.tgz -> yarnpkg-tar-fs-2.1.1.tgz
https://registry.yarnpkg.com/tar-fs/-/tar-fs-3.0.6.tgz -> yarnpkg-tar-fs-3.0.6.tgz
https://registry.yarnpkg.com/tar-fs/-/tar-fs-2.0.1.tgz -> yarnpkg-tar-fs-2.0.1.tgz
https://registry.yarnpkg.com/tar-stream/-/tar-stream-1.6.2.tgz -> yarnpkg-tar-stream-1.6.2.tgz
https://registry.yarnpkg.com/tar-stream/-/tar-stream-2.2.0.tgz -> yarnpkg-tar-stream-2.2.0.tgz
https://registry.yarnpkg.com/tar-stream/-/tar-stream-3.1.7.tgz -> yarnpkg-tar-stream-3.1.7.tgz
https://registry.yarnpkg.com/tar/-/tar-6.1.11.tgz -> yarnpkg-tar-6.1.11.tgz
https://registry.yarnpkg.com/tar/-/tar-6.2.0.tgz -> yarnpkg-tar-6.2.0.tgz
https://registry.yarnpkg.com/tdigest/-/tdigest-0.1.2.tgz -> yarnpkg-tdigest-0.1.2.tgz
https://registry.yarnpkg.com/temp-dir/-/temp-dir-1.0.0.tgz -> yarnpkg-temp-dir-1.0.0.tgz
https://registry.yarnpkg.com/temp/-/temp-0.9.4.tgz -> yarnpkg-temp-0.9.4.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz -> yarnpkg-terser-webpack-plugin-5.3.10.tgz
https://registry.yarnpkg.com/terser/-/terser-5.28.1.tgz -> yarnpkg-terser-5.28.1.tgz
https://registry.yarnpkg.com/test-exclude/-/test-exclude-6.0.0.tgz -> yarnpkg-test-exclude-6.0.0.tgz
https://registry.yarnpkg.com/text-decoder/-/text-decoder-1.2.0.tgz -> yarnpkg-text-decoder-1.2.0.tgz
https://registry.yarnpkg.com/text-extensions/-/text-extensions-1.9.0.tgz -> yarnpkg-text-extensions-1.9.0.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz -> yarnpkg-text-table-0.2.0.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz -> yarnpkg-through2-2.0.5.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz -> yarnpkg-through-2.3.8.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.0.33.tgz -> yarnpkg-tmp-0.0.33.tgz
https://registry.yarnpkg.com/tmp/-/tmp-0.2.1.tgz -> yarnpkg-tmp-0.2.1.tgz
https://registry.yarnpkg.com/to-buffer/-/to-buffer-1.1.1.tgz -> yarnpkg-to-buffer-1.1.1.tgz
https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz -> yarnpkg-to-fast-properties-2.0.0.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz -> yarnpkg-to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.1.tgz -> yarnpkg-toidentifier-1.0.1.tgz
https://registry.yarnpkg.com/tough-cookie/-/tough-cookie-4.1.4.tgz -> yarnpkg-tough-cookie-4.1.4.tgz
https://registry.yarnpkg.com/tr46/-/tr46-4.1.1.tgz -> yarnpkg-tr46-4.1.1.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz -> yarnpkg-tr46-0.0.3.tgz
https://registry.yarnpkg.com/trash/-/trash-7.2.0.tgz -> yarnpkg-trash-7.2.0.tgz
https://registry.yarnpkg.com/traverse/-/traverse-0.3.9.tgz -> yarnpkg-traverse-0.3.9.tgz
https://registry.yarnpkg.com/tree-kill/-/tree-kill-1.2.2.tgz -> yarnpkg-tree-kill-1.2.2.tgz
https://registry.yarnpkg.com/trim-newlines/-/trim-newlines-3.0.1.tgz -> yarnpkg-trim-newlines-3.0.1.tgz
https://registry.yarnpkg.com/trim-repeated/-/trim-repeated-1.0.0.tgz -> yarnpkg-trim-repeated-1.0.0.tgz
https://registry.yarnpkg.com/truncate-utf8-bytes/-/truncate-utf8-bytes-1.0.2.tgz -> yarnpkg-truncate-utf8-bytes-1.0.2.tgz
https://registry.yarnpkg.com/ts-api-utils/-/ts-api-utils-1.3.0.tgz -> yarnpkg-ts-api-utils-1.3.0.tgz
https://registry.yarnpkg.com/ts-md5/-/ts-md5-1.3.1.tgz -> yarnpkg-ts-md5-1.3.1.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz -> yarnpkg-tsconfig-paths-3.15.0.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-4.2.0.tgz -> yarnpkg-tsconfig-paths-4.2.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.14.1.tgz -> yarnpkg-tslib-1.14.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.7.0.tgz -> yarnpkg-tslib-2.7.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.6.2.tgz -> yarnpkg-tslib-2.6.2.tgz
https://registry.yarnpkg.com/tslint/-/tslint-5.20.1.tgz -> yarnpkg-tslint-5.20.1.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-2.29.0.tgz -> yarnpkg-tsutils-2.29.0.tgz
https://registry.yarnpkg.com/tsutils/-/tsutils-3.21.0.tgz -> yarnpkg-tsutils-3.21.0.tgz
https://registry.yarnpkg.com/tuf-js/-/tuf-js-1.1.7.tgz -> yarnpkg-tuf-js-1.1.7.tgz
https://registry.yarnpkg.com/tunnel-agent/-/tunnel-agent-0.6.0.tgz -> yarnpkg-tunnel-agent-0.6.0.tgz
https://registry.yarnpkg.com/tunnel/-/tunnel-0.0.6.tgz -> yarnpkg-tunnel-0.0.6.tgz
https://registry.yarnpkg.com/tweetnacl/-/tweetnacl-0.14.5.tgz -> yarnpkg-tweetnacl-0.14.5.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz -> yarnpkg-type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-detect/-/type-detect-4.0.8.tgz -> yarnpkg-type-detect-4.0.8.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz -> yarnpkg-type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.18.1.tgz -> yarnpkg-type-fest-0.18.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz -> yarnpkg-type-fest-0.20.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.21.3.tgz -> yarnpkg-type-fest-0.21.3.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.4.1.tgz -> yarnpkg-type-fest-0.4.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.6.0.tgz -> yarnpkg-type-fest-0.6.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz -> yarnpkg-type-fest-0.8.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-2.19.0.tgz -> yarnpkg-type-fest-2.19.0.tgz
https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz -> yarnpkg-type-is-1.6.18.tgz
https://registry.yarnpkg.com/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz -> yarnpkg-typed-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz -> yarnpkg-typed-array-byte-length-1.0.1.tgz
https://registry.yarnpkg.com/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz -> yarnpkg-typed-array-byte-offset-1.0.2.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.5.tgz -> yarnpkg-typed-array-length-1.0.5.tgz
https://registry.yarnpkg.com/typed-query-selector/-/typed-query-selector-2.12.0.tgz -> yarnpkg-typed-query-selector-2.12.0.tgz
https://registry.yarnpkg.com/typed-rest-client/-/typed-rest-client-1.8.11.tgz -> yarnpkg-typed-rest-client-1.8.11.tgz
https://registry.yarnpkg.com/typedarray-to-buffer/-/typedarray-to-buffer-3.1.5.tgz -> yarnpkg-typedarray-to-buffer-3.1.5.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz -> yarnpkg-typedarray-0.0.6.tgz
https://registry.yarnpkg.com/typedoc-plugin-external-module-map/-/typedoc-plugin-external-module-map-1.3.2.tgz -> yarnpkg-typedoc-plugin-external-module-map-1.3.2.tgz
https://registry.yarnpkg.com/typedoc/-/typedoc-0.22.18.tgz -> yarnpkg-typedoc-0.22.18.tgz
https://registry.yarnpkg.com/typescript/-/typescript-5.3.3.tgz -> yarnpkg-typescript-5.3.3.tgz
https://registry.yarnpkg.com/typescript/-/typescript-5.4.5.tgz -> yarnpkg-typescript-5.4.5.tgz
https://registry.yarnpkg.com/uc.micro/-/uc.micro-1.0.6.tgz -> yarnpkg-uc.micro-1.0.6.tgz
https://registry.yarnpkg.com/uglify-js/-/uglify-js-3.17.4.tgz -> yarnpkg-uglify-js-3.17.4.tgz
https://registry.yarnpkg.com/umd-compat-loader/-/umd-compat-loader-2.1.2.tgz -> yarnpkg-umd-compat-loader-2.1.2.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz -> yarnpkg-unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unbzip2-stream/-/unbzip2-stream-1.4.3.tgz -> yarnpkg-unbzip2-stream-1.4.3.tgz
https://registry.yarnpkg.com/underscore/-/underscore-1.13.6.tgz -> yarnpkg-underscore-1.13.6.tgz
https://registry.yarnpkg.com/undici-types/-/undici-types-5.26.5.tgz -> yarnpkg-undici-types-5.26.5.tgz
https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz -> yarnpkg-unicode-canonical-property-names-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz -> yarnpkg-unicode-match-property-ecmascript-2.0.0.tgz
https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz -> yarnpkg-unicode-match-property-value-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz -> yarnpkg-unicode-property-aliases-ecmascript-2.1.0.tgz
https://registry.yarnpkg.com/union/-/union-0.5.0.tgz -> yarnpkg-union-0.5.0.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-2.0.1.tgz -> yarnpkg-unique-filename-2.0.1.tgz
https://registry.yarnpkg.com/unique-filename/-/unique-filename-3.0.0.tgz -> yarnpkg-unique-filename-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-3.0.0.tgz -> yarnpkg-unique-slug-3.0.0.tgz
https://registry.yarnpkg.com/unique-slug/-/unique-slug-4.0.0.tgz -> yarnpkg-unique-slug-4.0.0.tgz
https://registry.yarnpkg.com/universal-user-agent/-/universal-user-agent-6.0.1.tgz -> yarnpkg-universal-user-agent-6.0.1.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz -> yarnpkg-universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.2.0.tgz -> yarnpkg-universalify-0.2.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.1.tgz -> yarnpkg-universalify-2.0.1.tgz
https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz -> yarnpkg-unpipe-1.0.0.tgz
https://registry.yarnpkg.com/unzipper/-/unzipper-0.9.15.tgz -> yarnpkg-unzipper-0.9.15.tgz
https://registry.yarnpkg.com/upath/-/upath-2.0.1.tgz -> yarnpkg-upath-2.0.1.tgz
https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz -> yarnpkg-upath-1.2.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.0.13.tgz -> yarnpkg-update-browserslist-db-1.0.13.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz -> yarnpkg-uri-js-4.4.1.tgz
https://registry.yarnpkg.com/url-join/-/url-join-4.0.1.tgz -> yarnpkg-url-join-4.0.1.tgz
https://registry.yarnpkg.com/url-parse/-/url-parse-1.5.10.tgz -> yarnpkg-url-parse-1.5.10.tgz
https://registry.yarnpkg.com/urlpattern-polyfill/-/urlpattern-polyfill-10.0.0.tgz -> yarnpkg-urlpattern-polyfill-10.0.0.tgz
https://registry.yarnpkg.com/user-home/-/user-home-2.0.0.tgz -> yarnpkg-user-home-2.0.0.tgz
https://registry.yarnpkg.com/utf8-byte-length/-/utf8-byte-length-1.0.5.tgz -> yarnpkg-utf8-byte-length-1.0.5.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz -> yarnpkg-util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz -> yarnpkg-utils-merge-1.0.1.tgz
https://registry.yarnpkg.com/uuid/-/uuid-7.0.3.tgz -> yarnpkg-uuid-7.0.3.tgz
https://registry.yarnpkg.com/uuid/-/uuid-8.3.2.tgz -> yarnpkg-uuid-8.3.2.tgz
https://registry.yarnpkg.com/uuid/-/uuid-9.0.1.tgz -> yarnpkg-uuid-9.0.1.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.3.0.tgz -> yarnpkg-v8-compile-cache-2.3.0.tgz
https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.4.0.tgz -> yarnpkg-v8-compile-cache-2.4.0.tgz
https://registry.yarnpkg.com/v8-to-istanbul/-/v8-to-istanbul-1.2.1.tgz -> yarnpkg-v8-to-istanbul-1.2.1.tgz
https://registry.yarnpkg.com/valid-filename/-/valid-filename-2.0.1.tgz -> yarnpkg-valid-filename-2.0.1.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz -> yarnpkg-validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-5.0.0.tgz -> yarnpkg-validate-npm-package-name-5.0.0.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-3.0.0.tgz -> yarnpkg-validate-npm-package-name-3.0.0.tgz
https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz -> yarnpkg-vary-1.1.2.tgz
https://registry.yarnpkg.com/vhost/-/vhost-3.0.2.tgz -> yarnpkg-vhost-3.0.2.tgz
https://registry.yarnpkg.com/vscode-jsonrpc/-/vscode-jsonrpc-8.2.0.tgz -> yarnpkg-vscode-jsonrpc-8.2.0.tgz
https://registry.yarnpkg.com/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.5.tgz -> yarnpkg-vscode-languageserver-protocol-3.17.5.tgz
https://registry.yarnpkg.com/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.11.tgz -> yarnpkg-vscode-languageserver-textdocument-1.0.11.tgz
https://registry.yarnpkg.com/vscode-languageserver-types/-/vscode-languageserver-types-3.17.5.tgz -> yarnpkg-vscode-languageserver-types-3.17.5.tgz
https://registry.yarnpkg.com/vscode-oniguruma/-/vscode-oniguruma-1.6.1.tgz -> yarnpkg-vscode-oniguruma-1.6.1.tgz
https://registry.yarnpkg.com/vscode-oniguruma/-/vscode-oniguruma-1.7.0.tgz -> yarnpkg-vscode-oniguruma-1.7.0.tgz
https://registry.yarnpkg.com/vscode-textmate/-/vscode-textmate-5.2.0.tgz -> yarnpkg-vscode-textmate-5.2.0.tgz
https://registry.yarnpkg.com/vscode-textmate/-/vscode-textmate-9.0.0.tgz -> yarnpkg-vscode-textmate-9.0.0.tgz
https://registry.yarnpkg.com/vscode-uri/-/vscode-uri-2.1.2.tgz -> yarnpkg-vscode-uri-2.1.2.tgz
https://registry.yarnpkg.com/w3c-xmlserializer/-/w3c-xmlserializer-4.0.0.tgz -> yarnpkg-w3c-xmlserializer-4.0.0.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-2.4.0.tgz -> yarnpkg-watchpack-2.4.0.tgz
https://registry.yarnpkg.com/wcwidth/-/wcwidth-1.0.1.tgz -> yarnpkg-wcwidth-1.0.1.tgz
https://registry.yarnpkg.com/web-streams-polyfill/-/web-streams-polyfill-4.0.0-beta.3.tgz -> yarnpkg-web-streams-polyfill-4.0.0-beta.3.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz -> yarnpkg-webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-7.0.0.tgz -> yarnpkg-webidl-conversions-7.0.0.tgz
https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-4.7.0.tgz -> yarnpkg-webpack-cli-4.7.0.tgz
https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-5.10.0.tgz -> yarnpkg-webpack-merge-5.10.0.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-3.2.3.tgz -> yarnpkg-webpack-sources-3.2.3.tgz
https://registry.yarnpkg.com/webpack/-/webpack-5.90.3.tgz -> yarnpkg-webpack-5.90.3.tgz
https://registry.yarnpkg.com/whatwg-encoding/-/whatwg-encoding-2.0.0.tgz -> yarnpkg-whatwg-encoding-2.0.0.tgz
https://registry.yarnpkg.com/whatwg-fetch/-/whatwg-fetch-3.6.20.tgz -> yarnpkg-whatwg-fetch-3.6.20.tgz
https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz -> yarnpkg-whatwg-mimetype-3.0.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-12.0.1.tgz -> yarnpkg-whatwg-url-12.0.1.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz -> yarnpkg-whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz -> yarnpkg-which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-builtin-type/-/which-builtin-type-1.1.3.tgz -> yarnpkg-which-builtin-type-1.1.3.tgz
https://registry.yarnpkg.com/which-collection/-/which-collection-1.0.1.tgz -> yarnpkg-which-collection-1.0.1.tgz
https://registry.yarnpkg.com/which-module/-/which-module-2.0.1.tgz -> yarnpkg-which-module-2.0.1.tgz
https://registry.yarnpkg.com/which-pm-runs/-/which-pm-runs-1.1.0.tgz -> yarnpkg-which-pm-runs-1.1.0.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.14.tgz -> yarnpkg-which-typed-array-1.1.14.tgz
https://registry.yarnpkg.com/which/-/which-1.3.1.tgz -> yarnpkg-which-1.3.1.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz -> yarnpkg-which-2.0.2.tgz
https://registry.yarnpkg.com/which/-/which-3.0.1.tgz -> yarnpkg-which-3.0.1.tgz
https://registry.yarnpkg.com/which/-/which-4.0.0.tgz -> yarnpkg-which-4.0.0.tgz
https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.5.tgz -> yarnpkg-wide-align-1.1.5.tgz
https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.1.tgz -> yarnpkg-wildcard-2.0.1.tgz
https://registry.yarnpkg.com/wordwrap/-/wordwrap-1.0.0.tgz -> yarnpkg-wordwrap-1.0.0.tgz
https://registry.yarnpkg.com/worker-loader/-/worker-loader-3.0.8.tgz -> yarnpkg-worker-loader-3.0.8.tgz
https://registry.yarnpkg.com/workerpool/-/workerpool-6.2.1.tgz -> yarnpkg-workerpool-6.2.1.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz -> yarnpkg-wrap-ansi-6.2.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz -> yarnpkg-wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-8.1.0.tgz -> yarnpkg-wrap-ansi-8.1.0.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz -> yarnpkg-wrappy-1.0.2.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-5.0.1.tgz -> yarnpkg-write-file-atomic-5.0.1.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-2.4.3.tgz -> yarnpkg-write-file-atomic-2.4.3.tgz
https://registry.yarnpkg.com/write-file-atomic/-/write-file-atomic-3.0.3.tgz -> yarnpkg-write-file-atomic-3.0.3.tgz
https://registry.yarnpkg.com/write-json-file/-/write-json-file-2.3.0.tgz -> yarnpkg-write-json-file-2.3.0.tgz
https://registry.yarnpkg.com/write-json-file/-/write-json-file-3.2.0.tgz -> yarnpkg-write-json-file-3.2.0.tgz
https://registry.yarnpkg.com/write-pkg/-/write-pkg-4.0.0.tgz -> yarnpkg-write-pkg-4.0.0.tgz
https://registry.yarnpkg.com/ws/-/ws-8.18.0.tgz -> yarnpkg-ws-8.18.0.tgz
https://registry.yarnpkg.com/ws/-/ws-8.11.0.tgz -> yarnpkg-ws-8.11.0.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz -> yarnpkg-xdg-basedir-4.0.0.tgz
https://registry.yarnpkg.com/xdg-trashdir/-/xdg-trashdir-3.1.0.tgz -> yarnpkg-xdg-trashdir-3.1.0.tgz
https://registry.yarnpkg.com/xml-name-validator/-/xml-name-validator-4.0.0.tgz -> yarnpkg-xml-name-validator-4.0.0.tgz
https://registry.yarnpkg.com/xml2js/-/xml2js-0.5.0.tgz -> yarnpkg-xml2js-0.5.0.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-11.0.1.tgz -> yarnpkg-xmlbuilder-11.0.1.tgz
https://registry.yarnpkg.com/xmlchars/-/xmlchars-2.2.0.tgz -> yarnpkg-xmlchars-2.2.0.tgz
https://registry.yarnpkg.com/xmlhttprequest-ssl/-/xmlhttprequest-ssl-2.0.0.tgz -> yarnpkg-xmlhttprequest-ssl-2.0.0.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz -> yarnpkg-xtend-4.0.2.tgz
https://registry.yarnpkg.com/xterm-addon-fit/-/xterm-addon-fit-0.5.0.tgz -> yarnpkg-xterm-addon-fit-0.5.0.tgz
https://registry.yarnpkg.com/xterm-addon-fit/-/xterm-addon-fit-0.8.0.tgz -> yarnpkg-xterm-addon-fit-0.8.0.tgz
https://registry.yarnpkg.com/xterm-addon-search/-/xterm-addon-search-0.13.0.tgz -> yarnpkg-xterm-addon-search-0.13.0.tgz
https://registry.yarnpkg.com/xterm/-/xterm-4.19.0.tgz -> yarnpkg-xterm-4.19.0.tgz
https://registry.yarnpkg.com/xterm/-/xterm-5.3.0.tgz -> yarnpkg-xterm-5.3.0.tgz
https://registry.yarnpkg.com/y-protocols/-/y-protocols-1.0.6.tgz -> yarnpkg-y-protocols-1.0.6.tgz
https://registry.yarnpkg.com/y18n/-/y18n-4.0.3.tgz -> yarnpkg-y18n-4.0.3.tgz
https://registry.yarnpkg.com/y18n/-/y18n-5.0.8.tgz -> yarnpkg-y18n-5.0.8.tgz
https://registry.yarnpkg.com/yallist/-/yallist-2.1.2.tgz -> yarnpkg-yallist-2.1.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-3.1.1.tgz -> yarnpkg-yallist-3.1.1.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz -> yarnpkg-yallist-4.0.0.tgz
https://registry.yarnpkg.com/yaml/-/yaml-2.4.1.tgz -> yarnpkg-yaml-2.4.1.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.4.tgz -> yarnpkg-yargs-parser-20.2.4.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-21.1.1.tgz -> yarnpkg-yargs-parser-21.1.1.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-18.1.3.tgz -> yarnpkg-yargs-parser-18.1.3.tgz
https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-20.2.9.tgz -> yarnpkg-yargs-parser-20.2.9.tgz
https://registry.yarnpkg.com/yargs-unparser/-/yargs-unparser-2.0.0.tgz -> yarnpkg-yargs-unparser-2.0.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-16.2.0.tgz -> yarnpkg-yargs-16.2.0.tgz
https://registry.yarnpkg.com/yargs/-/yargs-15.4.1.tgz -> yarnpkg-yargs-15.4.1.tgz
https://registry.yarnpkg.com/yargs/-/yargs-17.7.2.tgz -> yarnpkg-yargs-17.7.2.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz -> yarnpkg-yauzl-2.10.0.tgz
https://registry.yarnpkg.com/yazl/-/yazl-2.5.1.tgz -> yarnpkg-yazl-2.5.1.tgz
https://registry.yarnpkg.com/yjs/-/yjs-13.6.15.tgz -> yarnpkg-yjs-13.6.15.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz -> yarnpkg-yocto-queue-0.1.0.tgz
https://registry.yarnpkg.com/zip-stream/-/zip-stream-4.1.1.tgz -> yarnpkg-zip-stream-4.1.1.tgz
https://registry.yarnpkg.com/zod-to-json-schema/-/zod-to-json-schema-3.23.2.tgz -> yarnpkg-zod-to-json-schema-3.23.2.tgz
https://registry.yarnpkg.com/zod/-/zod-3.23.8.tgz -> yarnpkg-zod-3.23.8.tgz
"
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
git ollama ebuild-revision-6
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
	#rm -f package-lock.json
	#rm -f yarn.lock

if false ; then

	patch_edits() {
		sed -i -e "s|\"ajv\": \"^6.5.3\"|\"ajv\": \"^6.12.3\"|g" "packages/core/package.json" || die
		sed -i -e "s|\"ajv\": \"^6.5.3\"|\"ajv\": \"^6.12.3\"|g" "packages/toolbar/package.json" || die

		sed -i -e "/^axios@^1.0.0, axios@^1.6.2:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|axios \"^1.0.0\"|axios \"^1.7.4\"|g" "yarn.lock" || die
		sed -i -e "s|axios \"^1.6.2\"|axios \"^1.7.4\"|g" "yarn.lock" || die

		sed -i -e "s|\"body-parser\": \"^1.17.2\"|\"body-parser\": \"^1.20.3\"|g" "packages/core/package.json" || die
		sed -i -e "s|\"body-parser\": \"^1.18.3\"|\"body-parser\": \"^1.20.3\"|g" "packages/filesystem/package.json" || die

		sed -i -e "/^braces@^3.0.2, braces@~3.0.2:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|braces \"^3.0.2\"|braces \"^3.0.3\"|g" "yarn.lock" || die
		sed -i -e "s|braces \"~3.0.2\"|braces \"^3.0.3\"|g" "yarn.lock" || die

		sed -i -e "/^cookie@~0.4.1:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|cookie \"~0.4.1\"|cookie \"^0.7.0\"|g" "yarn.lock" || die
		sed -i -e "s|\"cookie\": \"^0.4.0\"|\"cookie\": \"^0.7.0\"|g" "packages/core/package.json" || die

		sed -i -e "s|\"dompurify\": \"^2.2.9\"|\"dompurify\": \"^2.5.4\"|g" "packages/core/package.json" || die

		sed -i -e "/^ejs@^3.1.7:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|ejs \"^3.1.7\"|ejs \"^3.1.10\"|g" "yarn.lock" || die

	# Replace vulernable Cr 124 with recent Cr 130 to mitigate.
#		sed -i -e "s|\"electron\": \"^30.1.2\"|\"electron\": \"${ELECTRON_APP_ELECTRON_PV}\"|g" "packages/electron/package.json" || die
#		sed -i -e "s|\"electron\": \"^30.1.2\"|\"electron\": \"${ELECTRON_APP_ELECTRON_PV}\"|g" "examples/electron/package.json" || die

		sed -i -e "/^follow-redirects@^1.0.0, follow-redirects@^1.15.4:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|follow-redirects \"^1.0.0\"|follow-redirects \"^1.15.6\"|g" "yarn.lock" || die
		sed -i -e "s|follow-redirects \"^1.15.4\"|follow-redirects \"^1.15.6\"|g" "yarn.lock" || die

	# Not listed in lockfile but mentioned by GH security scan.
	# semver 5.x added by
	#	@theia/core -> keytar [EOL] -> prebuild-install -> node-abi				# keytar pruning requires modding
	#	@theia/core -> drivelist -> prebuild-install -> node-abi				# drivelist prning requires modding
	#	@theia/application-manager -> less -> make-dir						# vulnerable
	#	@theia/monorepo -> @typescript-eslint/eslint-plugin-tslint -> tslint			# pruned
	#	@theia/monorepo -> @vscode/vsce -> parse-semver						# can be pruned

		sed -i -e "/^micromatch@^4.0.2, micromatch@^4.0.4:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|micromatch \"^4.0.2\"|micromatch \"^4.0.8\"|g" "yarn.lock" || die
		sed -i -e "s|micromatch \"^4.0.4\"|micromatch \"^4.0.8\"|g" "yarn.lock" || die

#		sed -i -e "s|\"[*][*]/nan\": \"2.20.0\"|\"**/nan\": \"${NAN_PV}\"|g" "package.json" || die
#		sed -i -e "s|\"[*][*]/@types/node\": \"18\"|\"[*][*]/@types/node\": \"${NODE_VERSION}\"|g" "package.json" || die

#		sed -i -e "/^node-abi@[*], node-abi@^3.0.0, node-abi@^3.3.0:/,/^$/d" "yarn.lock" || die
#		sed -i -e "/^node-abi@^2.21.0, node-abi@^2.7.0:/,/^$/d" "yarn.lock" || die
#		sed -i -e "s|^node-abi@^${NODE_ABI_PV}:|node-abi@*, node-abi@^2.21.0, node-abi@^2.7.0, node-abi@^3.0.0, node-abi@^3.3.0, node-abi@^${NODE_ABI_PV}:|" "yarn.lock" || die

#		sed -i -e "s|node-abi \"^2.7.0\"|node-abi \"^${NODE_ABI_PV}\"|g" "yarn.lock" || die
#		sed -i -e "s|node-abi \"^2.21.0\"|node-abi \"^${NODE_ABI_PV}\"|g" "yarn.lock" || die
#		sed -i -e "s|node-abi \"^3.3.0\"|node-abi \"^${NODE_ABI_PV}\"|g" "yarn.lock" || die

		sed -i -e "/^path-to-regexp@0.1.10:/,/^$/d" "yarn.lock" || die
		sed -i -e "/^path-to-regexp@^6.2.1:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|path-to-regexp \"0.1.10\"|path-to-regexp \"^6.3.0\"|g" "yarn.lock" || die
		sed -i -e "s|path-to-regexp \"^6.2.1\"|path-to-regexp \"^6.3.0\"|g" "yarn.lock" || die

		sed -i -e "/^tar@6.1.11:/,/^$/d" "yarn.lock" || die
		sed -i -e "/^tar@^6.0.5, tar@^6.1.11, tar@^6.1.2:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|tar \"6.1.11\"|tar \"^6.2.1\"|g" "yarn.lock" || die
		sed -i -e "s|tar \"^6.0.5\"|tar \"^6.2.1\"|g" "yarn.lock" || die
		sed -i -e "s|tar \"^6.1.11\"|tar \"^6.2.1\"|g" "yarn.lock" || die
		sed -i -e "s|tar \"^6.1.2\"|tar \"^6.2.1\"|g" "yarn.lock" || die

		sed -i -e "s|\"webpack\": \"^5.76.0\"|\"webpack\": \"^5.94.0\"|g" "dev-packages/application-manager/package.json" || die
		sed -i -e "s|\"webpack\": \"^5.76.0\"|\"webpack\": \"^5.94.0\"|g" "dev-packages/native-webpack-plugin/package.json" || die

		sed -i -e "/^ws@8.11.0, ws@~8.11.0:/,/^$/d" "yarn.lock" || die
		sed -i -e "s|ws \"8.11.0\"|ws \"^8.17.1\"|g" "yarn.lock" || die
		sed -i -e "s|ws \"~8.11.0\"|ws \"^8.17.1\"|g" "yarn.lock" || die
		sed -i -e "s|\"ws\": \"^8.17.1\"|\"ws\": \"^8.17.1\"|g" "packages/core/package.json" || die
	}

	local pkgs

einfo "Add/update toolchain"
	pkgs=(
		"node-gyp"
	)
	eyarn remove ${pkgs[@]} -W

	pkgs=(
		"node-gyp@^${NODE_GYP_PV}"
#		"node-abi@^${NODE_ABI_PV}"								# A dependency of electron-rebuild.  The abi field in abi_registry.json must be >= the major version of Electron.
		"ts-clean"										# For download:plugins
	)
	eyarn add ${pkgs[@]} -D -W

	patch_edits

# Need to check if tslint package is *backdoored* or introduces a vulnerability
einfo "Pruning vulnerable packages"

	pkgs=(
		"keytar"										# Adds semver 5.x, EOL
	)
#	eyarn workspace "@theia/core" remove ${pkgs[@]}

	pkgs=(
		# See https://en.wikipedia.org/wiki/Palantir_Technologies#WikiLeaks_proposals_(2010)
		"tslint"										# Adds semver 5.x
		"@typescript-eslint/eslint-plugin-tslint"						# Adds tslint

#		"@vscode/vsce"										# Adds semver 5.x
	)
	eyarn remove ${pkgs[@]} -W

	# This should be pruned
	pkgs=(
		"@theia/ffmpeg"
	)
#	eyarn workspace "@theia/application-manager" remove ${pkgs[@]} -W
#	eyarn workspace "@theia/cli" remove ${pkgs[@]} -W

einfo "Updating dependencies"
	# ID = Information Disclosure
	# DoS = Denial of Service
	# DT = Data Tampering

	pkgs=(
		# @theia/core:
		"dompurify@^2.5.4"				# CVE-2024-45801 # DoS, DT, ID
		"express@^4.20.0"				# CVE-2024-43796 # DT, ID
								# CVE-2024-29041 # DT, ID
		"body-parser@^1.20.3"				# CVE-2024-45590 # DoS
		"cookie@^0.7.0"					# CVE-2024-47764 # DT
		"ajv@^6.12.3"					# CVE-2020-15366 # DoS, DT, ID
		"ws@^8.17.1"					# CVE-2024-37890 # DoS			@theia/core -> socket.io -> engine.io -> ws
		"semver@^5.7.2"					# CVE-2022-25883 # DoS

		# @theia/core -> express:
		"path-to-regexp@^6.3.0"				# CVE-2024-45296 # DoS
		"serve-static@^1.16.0"				# CVE-2024-43800 # DT, ID
		"send@^0.19.0"					# CVE-2024-43799 # DT, ID
	)
	eyarn workspace "@theia/core" upgrade ${pkgs[@]}

	pkgs=(
		"body-parser@^1.20.3"
	)
	eyarn workspace "@theia/filesystem" upgrade ${pkgs[@]}

	pkgs=(
		"ajv@^6.12.3"
	)
	eyarn workspace "@theia/toolbar" upgrade ${pkgs[@]}

	pkgs=(
		"electron-rebuild"                              # EOL
	)
#	eyarn workspace "@theia/application-manager" remove ${pkgs[@]}

	pkgs=(
	# Force 3.6.2 to prefer node-gyp over @electron/node-gyp
		"@electron/rebuild@3.6.2"			# For Electron beta.  Breaks rebuild.
	)
#	eyarn workspace "@theia/application-manager" add ${pkgs[@]}

	pkgs=(
		"axios@^1.7.4"					# CVE-2024-39338 # ID			# @theia/application-package -> nano
		"follow-redirects@^1.15.6"			# CVE-2024-28849 # ID                   # nano -> axios -> follow-redirects
	)
	eyarn workspace "@theia/application-package" upgrade ${pkgs[@]}

	pkgs=(
		# @theia/application-manager
		"webpack@^5.94.0"				# CVE-2024-43788 # DoS, DT, ID		# @theia/application-manager
		"follow-redirects@^1.15.6"			# CVE-2024-28849 # ID			# @theia/application-manager -> http-server
		"braces@^3.0.3"					# CVE-2024-4068  # DoS			# @theia/application-manager -> copy-webpack-plugin -> fast-glob -> micromatch
		"micromatch@^4.0.8"				# CVE-2024-4067  # DoS
		"semver@^5.7.2"					# CVE-2022-25883 # DoS
	)
	eyarn workspace "@theia/application-manager" upgrade ${pkgs[@]}

	pkgs=(
		"webpack@^5.94.0"				# CVE-2024-43788 # DoS, DT, ID		# @theia/native-webpack-plugin
	)
	eyarn workspace "@theia/native-webpack-plugin" upgrade ${pkgs[@]}

	pkgs=(
		"follow-redirects@^1.15.6"			# CVE-2024-28849 # ID                   # @theia/cli -> http-server
		"braces@^3.0.3"					# CVE-2024-4068  # DoS			# @theia/cli -> chokidar -> mocha
	)
	eyarn workspace "@theia/cli" upgrade ${pkgs[@]}

	pkgs=(
#		"electron@${ELECTRON_APP_ELECTRON_PV}"							# Pinned for license file consistency
		"got@^11.8.5"					# CVE-2022-33987 # DT			# @theia/example-electron -> electron -> @electron/get
	)
	eyarn workspace "@theia/example-electron" upgrade ${pkgs[@]} #-D

	pkgs=(
#		"electron@${ELECTRON_APP_ELECTRON_PV}"							# Pinned for license file consistency
	)
#	eyarn workspace "@theia/electron" upgrade ${pkgs[@]} #-P

	pkgs=(
		"nan@${NAN_PV}"
	)
	#eyarn add ${pkgs[@]} -W # -D

	pkgs=(
		# @theia/monorepo
		# TODO: bump parent packages
		"http-cache-semantics@^4.1.1"			# CVE-2022-25881 # DoS			# @theia/monorepo -> node-gyp -> make-fetch-happen
		"hosted-git-info@^2.8.9"			# CVE-2021-23362 # DoS			# @theia/monorepo -> @vscode/vsce
		"tough-cookie@^4.1.3"				# CVE-2023-26136 # DoS, DT		# @theia/monorepo -> jsdom
		"semver@^5.7.2"					# CVE-2022-25883 # DoS
		"axios@^1.7.4"					# CVE-2024-39338 # ID			# @theia/monorepo -> lerna -> @lerna/create -> nx
		"chownr@^1.1.0"					# CVE-2017-18869 # DT			# @theia/monorepo -> lerna
		"yargs-parser@^13.1.2"				# CVE-2020-7608  # DoS, DT, ID		# @theia/monorepo -> lerna
		"ssri@^6.0.2"					# CVE-2021-27290 # DoS			# @theia/monorepo -> lerna
		"ejs@^3.1.10"					# CVE-2024-33883 # DoS			# @theia/monorepo -> lerna -> @lerna/create -> @nx/devkit
		"tar@^6.2.1"					# CVE-2021-37713 # DT, ID		# @theia/monorepo -> lerna
								# CVE-2021-32804 # DT, ID
								# CVE-2024-28863 # DoS
		"path-to-regexp@^6.3.0"				# CVE-2024-45296 # DoS			# @theia/monorepo -> sinon -> nise
		"ws@^8.17.1"					# CVE-2024-37890 # DoS			# @theia/monorepo -> jsdom
		"follow-redirects@^1.15.6"			# CVE-2024-28849 # ID                   # @theia/monorepo -> lerna -> @lerna/create -> nx -> axios -> follow-redirects

		"@types/node@${NODE_VERSION}"
	)
	eyarn upgrade ${pkgs[@]} #-D -W

	patch_edits

	eyarn dedupe

	# Running `yarn dedupe` will undo patch_edits.
	patch_edits
fi

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
einfo "The default models listed for Ollama support are llama3 and gemma2."
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.37.1 (20230525)
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.50.1 (20240620)
# OILEDMACHINE-OVERLAY-TEST:  PASSED  (interactive) 1.56.0 (20241201)
# launch-test:  passed