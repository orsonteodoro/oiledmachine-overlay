# Copyright 2025-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  Test e-mail login.

# Downgraded till build error fixed:
#> Build error occurred
#Error: Turbopack build failed with 1 errors:
#
#./src/app/spa/[variants]/[[...path]]/route.ts:98:61
#Module not found: Can't resolve './spaHtmlTemplates'
#   96 |   }
#   97 |
#>  98 |   const { desktopHtmlTemplate, mobileHtmlTemplate } = await import('./spaHtmlTemplates');
#      |                                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   99 |
#  100 |   return isMobile ? mobileHtmlTemplate : desktopHtmlTemplate;
#  101 | }
#
#https://nextjs.org/docs/messages/module-not-found
#
#    at <unknown> (./src/app/spa/[variants]/[[...path]]/route.ts:98:61)
#    at <unknown> (https://nextjs.org/docs/messages/module-not-found)

# Version bump history for configuration update reviews:
# 1.74.0 -> 1.96.13
# 1.96.13 -> 1.96.14
# 1.96.14 -> 1.111.4
# 1.111.4 -> 1.133.4
# 1.133.4 -> 1.137.0
# 1.137.0 -> 1.142.8
# 1.142.8 -> 1.146.0
# 1.146.0 -> 2.1.34
# 2.1.34 -> 2.1.36
# 2.1.36 - 2.1.43
# 2.1.43 -> 2.1.44
# 2.1.44 -> 2.1.46
# 2.1.46 -> 2.1.47

# Ebuild using React 19

#
# China distro users, fork ebuild and regenerate the npm lockfile.
#
# Contents of /etc/portage/env/lobehub.conf:
#
#   USE_CN_MIRROR=true
#
# Contents of /etc/portage/package.env:
#
#   www-apps/LobeHub lobehub.conf
#
# Generate the lockfile as follows:
#
#   OILEDMACHINE_OVERLAY_DIR="/usr/local/oiledmachine-overlay"
#   PATH="${OILEDMACHINE_OVERLAY_DIR}/scripts:${PATH}"
#   cd "${OILEDMACHINE_OVERLAY_DIR}/www-apps/LobeHub"
#   PNPM_UPDATER_VERSIONS="2.1.47" pnpm_updater_update_locks.sh
#

# U22, U24, D12
# U24 - node 20 (release - live, debug - live)
# U22 - node 18 (check - live)

# TODO:
# USE sandbox

# @serwist/next needs pnpm workspaces

MY_PN="${PN}"		# LobeHub
MY_PN2="${PN,,}"	# lobehub

# See also https://github.com/vercel/next.js/blob/v15.1.6/.github/workflows/build_and_test.yml#L328
_ELECTRON_DEP_ROUTE="secure"
NODE_SHARP_USE="exif lcms webp"
NODE_SLOT="24" # See .nvmrc or Dockerfile
NPM_SLOT="3"
PNPM_AUDIT_FIX=0
PNPM_DEDUPE=0 # Still debugging
PNPM_SLOT="9"
POSTGRESQL_PORT="5432"
POSTGRESQL_SLOT="17"
RUST_MAX_VER="1.88.0" # Inclusive
RUST_MIN_VER="1.88.0" # LLVM 20.  Dependency graph:  next -> @swc/core -> rust \
# https://github.com/swc-project/swc/blob/v1.15.21/rust-toolchain		# 2025-05-06 nightly
# https://github.com/rust-lang/rust/commits/main/src/version
# Find the version bump with commit <= 2025-05-06
RUST_PV="${RUST_MIN_VER}"

NEXTJS_PV="16.1.7"
SHARP_PV="0.34.5"
VIPS_PV="8.18.0"

if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
	# Ebuild maintainer's choice
	ELECTRON_APP_ELECTRON_PV="41.0.3" # Cr 146.0.7680.80, node 24.14.0
else
#https://github.com/lobehub/lobehub/blob/v2.1.44/apps/desktop/package.json#L70
	# Upstream's choice
	ELECTRON_APP_ELECTRON_PV="41.0.2" # Cr 146.0.7680.72, node 24.14.0
fi


CPU_FLAGS_X86=(
	"cpu_flags_x86_sse4_2"
)

NODE_SHARP_PATCHES=(
	"${FILESDIR}/sharp-0.34.5-debug.patch"
	"${FILESDIR}/sharp-0.34.5-format-fixes.patch"
	"${FILESDIR}/sharp-0.34.5-static-libs.patch"
)

# Use pnpm for pnpm_updater_update_locks.sh
inherit dhms desktop edo electron-app node-sharp npm pnpm rust xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lobehub/lobehub.git"
	FALLBACK_COMMIT="ef0e4a674322a1faa1f7fd2ff70011a2b6a9bb6c" # Feb 21, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${MY_PN2}-${PV}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN2}-${PV}"
	SRC_URI="
	electron? (
		$(electron-app_gen_electron_uris)
	)
https://github.com/lobehub/lobehub/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An AI Agent framework supporting AI chat, function call plugins, open/closed LLM models, RAG, TTS, vision"
HOMEPAGE="
	https://lobehub.com/
	https://github.com/lobehub/lobehub
"
LICENSE="
	(
		Apache-2.0
		LobeHub-Community-License-20250921
		LobeHub-Privacy-Policy
		LobeHub-Terms-of-Service
	)
	(
		${ELECTRON_APP_LICENSES}
		(
			CC0-1.0
			MIT
		)
		(
			BSD-2
			CC0-1.0
			ISC
			MIT
		)
		(
			all-rights-reserved
			MIT
		)
		(
			CC-BY-SA-4.0
			ISC
		)
		AGPL-3
		Apache-2.0
		Artistic-2
		BlueOak-1.0.0
		BSD-2
		CC-BY-4.0
		custom
		ISC
		icu-64.2
		MIT
		BSD
		CC0-1.0
		custom
		MIT-0
		MPL-2.0
		OFL-1.1
		Princeton
		PSF-2.2
		Unlicense
		WTFPL-2
		|| (
			AFL-2.1
			BSD
		)
		|| (
			Apache-2.0
			MPL-2.0
		)
		|| (
			BSD
			GPL-2
		)
		|| (
			GPL-3
			MIT
		)
	)
"
if [[ "${_ELECTRON_DEP_ROUTE}" == "secure" ]] ; then
        LICENSE+="
                electron-41.0.3-chromium.html
        "
else
	LICENSE+="
                electron-41.0.2-chromium.html
        "
fi
# Third party licenses:
# ( CC0-1.0 MIT ) - ./lobehub-2.1.44/node_modules/.pnpm/lodash.escape@4.0.1/node_modules/lodash.escape/LICENSE
# all-rights-reserved MIT - ./lobehub-2.1.44/node_modules/.pnpm/vscode-languageserver-protocol@3.17.5/node_modules/vscode-languageserver-protocol/License.txt
# all-rights-reserved MIT - ./lobehub-2.1.44/node_modules/.pnpm/tsyringe@4.10.0/node_modules/tsyringe/LICENSE
# AGPL-3 - ./lobehub-2.1.44/node_modules/.pnpm/dirty-json@0.9.2/node_modules/dirty-json/LICENSE
# Apache-2.0 - ./lobehub-2.1.44/node_modules/.pnpm/aria-query@5.3.2/node_modules/aria-query/LICENSE
# Artistic-2 - ./lobehub-2.1.44/node_modules/.pnpm/textextensions@6.11.0/node_modules/textextensions/LICENSE.md
# BlueOak-1.0.0 - ./lobehub-2.1.44/node_modules/.pnpm/@isaacs+cliui@9.0.0/node_modules/@isaacs/cliui/LICENSE.md
# BlueOak-1.0.0 - ./lobehub-2.1.44/node_modules/.pnpm/yallist@5.0.0/node_modules/yallist/LICENSE.md
# BSD - ./lobehub-2.1.44/node_modules/.pnpm/@protobufjs+pool@1.1.0/node_modules/@protobufjs/pool/LICENSE
# BSD-2 - ./lobehub-2.1.44/node_modules/.pnpm/esutils@2.0.3/node_modules/esutils/LICENSE.BSD
# BSD-2 CC0-1.0 ISC MIT - ./lobehub-2.1.44/node_modules/.pnpm/vite@7.3.1_@types+node@24.12.0_jiti@2.6.1_terser@5.46.1_tsx@4.21.0_yaml@2.8.3/node_modules/vite/LICENSE.md
# CC-BY-4.0 - ./lobehub-2.1.44/node_modules/.pnpm/caniuse-lite@1.0.30001780/node_modules/caniuse-lite/LICENSE
# CC-BY-SA-4.0 ISC - ./lobehub-2.1.44/node_modules/.pnpm/npm@9.9.4/node_modules/npm/node_modules/node-gyp/node_modules/glob/LICENSE
# CC0-1.0 - ./lobehub-2.1.44/node_modules/.pnpm/type-fest@5.5.0/node_modules/type-fest/license-cc0
# custom (Sustainable Use License) - ./lobehub-2.1.44/node_modules/.pnpm/@codesandbox+nodebox@0.1.8/node_modules/@codesandbox/nodebox/LICENSE
# custom (https://code.claude.com/docs/en/legal-and-compliance) - ./lobehub-2.1.44/node_modules/.pnpm/@anthropic-ai+claude-agent-sdk@0.2.81_zod@4.3.6/node_modules/@anthropic-ai/claude-agent-sdk/LICENSE.md
# custom - ./lobehub-2.1.44/node_modules/.pnpm/npm@9.9.4/node_modules/npm/node_modules/jsbn/LICENSE
# ISC - ./lobehub-2.1.44/node_modules/.pnpm/internmap@2.0.3/node_modules/internmap/LICENSE
# icu-64.2 - ./lobehub-2.1.44/node_modules/.pnpm/tree-sitter@0.21.1/node_modules/tree-sitter/vendor/tree-sitter/lib/src/unicode/LICENSE
# LobeHub-Community-License-20250921 - See https://github.com/lobehub/lobehub/blob/main/LICENSE
# MIT - ./lobehub-2.1.44/node_modules/.pnpm/matcher@3.0.0/node_modules/matcher/license
# MIT-0 - ./lobehub-2.1.44/node_modules/.pnpm/@csstools+selector-specificity@5.0.0_postcss-selector-parser@7.1.1/node_modules/@csstools/selector-specificity/LICENSE.md
# MPL-2.0 - ./lobehub-2.1.44/node_modules/.pnpm/@vercel+analytics@1.6.1_next@16.1.7_@babel+core@7.29.0_@opentelemetry+api@1.9.0_@playwr_479db63f3807ed5fe2ed8b4d0278027d/node_modules/@vercel/analytics/LICENSE
# OFL-1.1 - ./lobehub-2.1.44/node_modules/.pnpm/polished@4.3.1/node_modules/polished/docs/assets/fonts/LICENSE.txt
# Princeton - ./lobehub-2.1.44/node_modules/.pnpm/wordnet-db@3.1.14/node_modules/wordnet-db/LICENSE
# PSF-2.2 (similar to PSF-2.4) - ./lobehub-2.1.44/node_modules/.pnpm/argparse@2.0.1/node_modules/argparse/LICENSE
# Unlicense - ./lobehub-2.1.44/node_modules/.pnpm/robust-predicates@3.0.2/node_modules/robust-predicates/LICENSE
# WTFPL-2 - MIT - ./lobehub-2.1.44/node_modules/.pnpm/opener@1.5.2/node_modules/opener/LICENSE.txt
# || ( Apache-2.0 MPL-2.0 ) - ./lobehub-2.1.44/node_modules/.pnpm/dompurify@3.3.3/node_modules/dompurify/LICENSE
# || ( AFL-2.1 BSD ) - ./lobehub-2.1.44/node_modules/.pnpm/json-schema@0.4.0/node_modules/json-schema/LICENSE
# || ( BSD GPL-2 ) - ./lobehub-2.1.44/node_modules/.pnpm/node-forge@1.3.3/node_modules/node-forge/LICENSE
# || ( GPL-3 MIT ) - ./lobehub-2.1.44/node_modules/.pnpm/jszip@3.10.1/node_modules/jszip/LICENSE.markdown
# The distro's Apache-2.0 license file does not contain all rights reserved.
# The distro's MIT license file does not contain all rights reserved.
# The PSF-2.2 license differs from the PSF-2.4 license.
RESTRICT="binchecks mirror strip test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_X86[@]}
ceph -electron +embeddings +file-management indexeddb minio +openrc +pwa +postgres +rag redis +s3 systemd
ebuild_revision_95
"
REQUIRED_USE="
	postgres
	pwa
	embeddings? (
		postgres
	)
	file-management? (
		postgres
	)
	rag? (
		postgres
		^^ (
			ceph
			minio
			s3
		)
	)
	^^ (
		indexeddb
		postgres
	)
	^^ (
		electron
		pwa
	)
	|| (
		openrc
		systemd
	)
"
# xdg-open is from x11-misc/xdg-utils
RDEPEND+="
	${VIPS_RDEPEND}
	acct-group/lobehub
	acct-user/lobehub
	>=app-misc/ca-certificates-20240203
	>=net-misc/proxychains-3.1
	>=sys-devel/gcc-12.2.0
	net-libs/nodejs:${NODE_SLOT}[corepack,npm]
	net-libs/nodejs:=
	x11-misc/xdg-utils
	embeddings? (
		dev-db/pgvector[postgres_targets_postgres${POSTGRESQL_SLOT}]
	)
	openrc? (
		sys-apps/openrc[bash]
		sys-process/procps[kill]
	)
	postgres? (
		dev-db/postgresql:${POSTGRESQL_SLOT}[server]
		dev-db/postgresql:=
		dev-db/pg_search[postgres_targets_postgres${POSTGRESQL_SLOT}]
	)
	rag? (
		dev-db/pgvector[postgres_targets_postgres${POSTGRESQL_SLOT}]
	)
	redis? (
		dev-db/redis
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=sys-apps/pnpm-10.20.0:${PNPM_SLOT}
	>=sys-apps/npm-10.8.2:${NPM_SLOT}
	net-libs/nodejs:${NODE_SLOT}[corepack,npm]
	net-libs/nodejs:=
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
	|| (
		dev-lang/rust:=
		dev-lang/rust-bin:=
	)
"
PDEPEND+="
	ceph? (
		sys-cluster/ceph[radosgw]
	)
	minio? (
		app-misc/minio-docker
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

setup_cn_mirror_env() {
	if [[ "${USE_CN_MIRROR:-false}" == "true" ]] ; then
		export SENTRYCLI_CDNURL="https://npmmirror.com/mirrors/sentry-cli"
		npm config set registry "https://registry.npmmirror.com/"
		echo 'canvas_binary_host_mirror=https://npmmirror.com/mirrors/canvas' >> ".npmrc" || die
	fi
}

setup_build_env() {
	export DOCKER="true"

	export RUST_BACKTRACE="full"

	# Fix:
#<--- Last few GCs --->
#
#[1358:0x56512381a000]   779656 ms: Mark-Compact 3463.9 (4143.6) -> 3463.6 (4139.6) MB, pooled: 18 MB, 3813.95 / 0.00 ms  (average mu = 0.085, current mu = 0.009) allocation failure; GC in old space requested
#[1358:0x56512381a000]   783649 ms: Mark-Compact 3484.5 (4141.6) -> 3470.1 (4139.6) MB, pooled: 18 MB, 3859.23 / 0.00 ms  (average mu = 0.060, current mu = 0.033) allocation failure; scavenge might not succeed
#
#
#<--- JS stacktrace --->
#
#FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
#----- Native stack trace -----
#
# 1: 0x565121987504 node::DumpNativeBacktrace(_IO_FILE*) [/usr/bin/node22]
# 2: 0x565121a39d3d node::OOMErrorHandler(char const*, v8::OOMDetails const&) [/usr/bin/node22]
# 3: 0x565121cd60e4 v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, v8::OOMDetails const&) [/usr/bin/node22]
# 4: 0x565121cd634d v8::internal::V8::FatalProcessOutOfMemory(v8::internal::Isolate*, char const*, v8::OOMDetails const&) [/usr/bin/node22]
# 5: 0x565121e954c5  [/usr/bin/node22]
# 6: 0x565121e954f4 v8::internal::Heap::ReportIneffectiveMarkCompactIfNeeded() [/usr/bin/node22]
# 7: 0x565121ea9c0e  [/usr/bin/node22]
# 8: 0x565121eabb8d  [/usr/bin/node22]
# 9: 0x5651226cd425  [/usr/bin/node22]
	export NODE_OPTIONS=" --max-old-space-size=8192" # 6144 and 8192 works but 6144 may trigger OOM killer.
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"

	# The build variables below can be set in /etc/portage/env/lobehub.conf
	# Then referenced in /etc/portage/package.env with a `www-apps/LobeHub lobehub.conf` line.

	export NEXT_PUBLIC_BASE_PATH="${NEXT_PUBLIC_BASE_PATH}"

	# Sentry (debug, session replay, performance monitoring)
	export NEXT_PUBLIC_SENTRY_DSN="${NEXT_PUBLIC_SENTRY_DSN}"
	export SENTRY_ORG=""
	export SENTRY_PROJECT=""

	# Posthog (analytics)
	export NEXT_PUBLIC_ANALYTICS_POSTHOG="${NEXT_PUBLIC_ANALYTICS_POSTHOG}"
	export NEXT_PUBLIC_POSTHOG_HOST="${NEXT_PUBLIC_POSTHOG_HOST}"
	export NEXT_PUBLIC_POSTHOG_KEY="${NEXT_PUBLIC_POSTHOG_KEY}" # API key

	# Umami (analytics)
	export NEXT_PUBLIC_ANALYTICS_UMAMI="${NEXT_PUBLIC_ANALYTICS_UMAMI}"
	export NEXT_PUBLIC_UMAMI_SCRIPT_URL="${NEXT_PUBLIC_UMAMI_SCRIPT_URL}"
	export NEXT_PUBLIC_UMAMI_WEBSITE_ID="${NEXT_PUBLIC_UMAMI_WEBSITE_ID}"

einfo "Inspecting per-package environment variables."
einfo
einfo "To set up per-package environment variables see"
einfo "https://wiki.gentoo.org/wiki//etc/portage/package.env"
einfo
}

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

check_virtual_mem() {
	local total_mem=$(free -t \
		| grep "Total:" \
		| sed -r -e "s|[[:space:]]+| |g" \
		| cut -f 2 -d " ")
	local total_mem_gib=$(python -c "import math;print(round(${total_mem}/1024/1024))")
	if (( ${total_mem_gib} < 8 )) ; then
ewarn
ewarn "Please add more swap."
ewarn
ewarn "Current total memory:  ${total_mem_gib} GiB"
ewarn "Minimum total memory:  8 GiB"
ewarn "Tested total memory:  30 GiB"
ewarn
	fi
}

pkg_setup() {
ewarn
ewarn "${CATEGORY}/${PN} build warning."
ewarn
ewarn "The browser OOM manager may inadvertantly prevent access to"
ewarn "browser tabs or the kernel may OOM kill the web browser"
ewarn "after high memory pressure during build time which may"
ewarn "result in data loss."
ewarn
ewarn "Save work immediately."
ewarn
ewarn "For 8 GiB or less, close all web browsers or large running programs to"
ewarn "reduce build time failures."
ewarn
#	sleep 15
	dhms_start
	# If a "next" package is found in package.json, this should be added.
	# Otherwise, the license variable should be updated with additional
	# legal text.
	export NEXT_TELEMETRY_DISABLED=1

	# Prevent redownloads because they unusually bump more than once a day.
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${PN}"
	export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${PN}"

	addwrite "${EDISTDIR}"
	npm_pkg_setup
	pnpm_pkg_setup
	check_virtual_mem

	node-sharp_pkg_setup

	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	else
eerror "Rust ${RUST_PV} required for @swc/core"
		die
	fi
	if use electron ; then
		electron-app_pkg_setup
	fi
}

pnpm_unpack_post() {
	gen_git_tag "${S}" "v${PV}"

	local pnpm_pv=$(pnpm --version)
	# better-auth is bumped to 1.5.6 to avoid runtime authentication issues.
	# All versions directly below are pinned versions using same version as
	# better-auth's lockfile to avoid build and runtime issues.
	sed -i \
		-e "s|\"@types/react\": \"19.2.13\"|\"@types/react\": \"19.2.14\"|g" \
		-e "s|\"@types/react-dom\": \"^19.2.3\"|\"@types/react-dom\": \"19.2.3\"|g" \
		-e "s|\"better-auth\": \"1.4.6\"|\"better-auth\": \"1.5.6\"|g" \
		-e "s|\"better-call\": \"1.1.8\"|\"better-call\": \"1.3.2\"|g" \
		-e "s|\"drizzle-kit\": \"^0.31.8\"|\"drizzle-kit\": \"0.30.6\"|g" \
		-e "s|\"drizzle-orm\": \"^0.45.1\"|\"drizzle-orm\": \"0.45.1\"|g" \
		-e "s|\"fast-xml-parser\": \"5.4.2\"|\"fast-xml-parser\": \"5.5.7\"|g" \
		-e "s|\"pg\": \"^8.17.2\"|\"pg\": \"8.19.0\"|g" \
		"package.json" \
		|| die

	sed -i \
		-e "s|npm@11.1.0|npm@${pnpm_pv}|g" \
		"package.json" \
		|| die

	setup_cn_mirror_env

	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i \
			-e "s|bun run|npm run|g" \
			"${S}/package.json" \
			|| die
		grep -e "ERR_PNPM_FETCH_404" "${T}/build.log" && die "Detected error.  Check pnpm add"
	fi

# The prebuilt vips could be causing the segfault.  The sharp package need to
# reference the system's vips package not the prebuilt one.
	eapply "${FILESDIR}/${MY_PN2}-2.1.34-hardcoded-paths.patch"
	eapply "${FILESDIR}/lobe-chat-1.65.0-sharp-declaration.patch"
	eapply "${FILESDIR}/${PN}-2.1.33-use-e965-xlsx.patch"

	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
	# Fixes to unmet peer or missing references
		pkgs=(
			"@next/bundle-analyzer@^${NEXTJS_PV}"

	# Pin better-auth and dependencies
			"drizzle-kit@0.30.6"
			"@types/react@19.2.14"
			"@types/react-dom@19.2.3"
		)
		epnpm add -D ${pkgs[@]}
		pkgs=(
			"next@${NEXTJS_PV}"								# CVE-2025-29927; ZC, DoS, DT, ID; Critical
													# CVE-2026-29057; ZC, DT, ID; Moderate
													# CVE-2026-27979; ZC, DoS; Moderate
													# CVE-2026-27980; ZC, DoS; Moderate
													# CVE-2026-27978; VS(DT); Moderate
													# CVE-2026-27977; DT, ID; Low
			"svix@1.84.1"

	# Pin better-auth and dependencies
			"drizzle-orm@0.45.1"
			"better-auth@1.5.6"
			"fast-xml-parser@5.5.7"
			"pg@8.19.0"

	# Reverse depends or transitive dependencies of better-auth
			"@better-auth/passkey@1.5.6"							# Same version as better-auth
			"@better-auth/expo@1.5.6"							# Same version as better-ath

	# pg alternative
#			"postgres@3.4.8"
		)
		epnpm add ${pkgs[@]} ${NPM_INSTALL_ARGS[@]}
	fi
}

pnpm_install_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		:
	else
		local pkgs=(
			"sharp@${SHARP_PV}"
		)
		epnpm add ${pkgs[@]} ${NPM_INSTALL_ARGS[@]}
	fi
}

pnpm_audit_post() {
	local pkgs
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		pnpm_patch_lockfile() {
			sed -i -e "s|\"vitest\": ^3.2.4|\"vitest\": 3.2.4|g" "pnpm-lock.yaml" || die
			sed -i -e "s|\"vitest\": \"^3.2.4\"|\"vitest\": \"3.2.4\"|g" "package.json" || die
		}
		pnpm_patch_lockfile
		pkgs=(
			"vitest@3.2.4"
		)
		epnpm add -D ${pkgs[@]} ${NPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical
		pnpm_patch_lockfile
	fi
}

pnpm_dedupe_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
ewarn "QA:  Manually remove lodash@4.17.21 from ${S}/pnpm-lock.yaml" # Skip
ewarn "QA:  Manually remove yaml@2.3.3 from ${S}/pnpm-lock.yaml" # Skip
ewarn "QA:  Manually change yaml: 2.3.3 to yaml: 2.8.3 from ${S}/pnpm-lock.yaml" # Skip
#ewarn "QA:  Manually remove nodemailer@7.0.13 from ${S}/pnpm-lock.yaml" # Skip
#ewarn "QA:  Manually change nodemailer: version: 7.0.13 to version: 8.0.4 specifier: ^7.0.12 to specifier: ^8.0.4 from ${S}/pnpm-lock.yaml" # Skip
#ewarn "QA:  Manually remove serialize-javascript@7.0.3 from ${S}/pnpm-lock.yaml" # Skip
ewarn "QA:  Manually remove path-to-regexp@8.2.0 from ${S}/pnpm-lock.yaml" # Skip
ewarn "QA:  Manually change path-to-regexp: 8.2.0 to path-to-regexp: 8.4.0 from ${S}/pnpm-lock.yaml" # Skip
#ewarn "QA:  Manually remove @xmldom/xmldom@0.8.11 from ${S}/pnpm-lock.yaml" # Skip
#ewarn "QA:  Manually remove @xmldom/xmldom@0.9.8 from ${S}/pnpm-lock.yaml" # Skip
ewarn "QA:  Manually remove ai@4.3.19 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @tootallnate/once@2.0.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove serialize-javascript@6.0.2 from ${S}/pnpm-lock.yaml" # Skip

#ewarn "QA:  Manually remove undici@6.21.3 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change undici: 6.21.3 to undici: 7.24.5 from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove file-type@16.5.4 from ${S}/pnpm-lock.yaml"	# CVE-2026-31808; ZC, DoS; Moderate
ewarn "QA:  Manually change file-type: 16.5.4 to file-type: 21.3.4 from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove bn.js@4.12.3 from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove ajv@6.14.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove ajv@8.12.0 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove ajv-formats@2.1.1 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change ajv-formats: 2.1.1(ajv@8.12.0) to ajv-formats: 3.0.1(ajv@8.18.0) from ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove @apidevtools/json-schema-ref-parser@11.1.0 from ${S}/pnpm-lock.yaml"

# Skip section
ewarn "QA:  Manually remove minimatch@3.1.5 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove minimatch@5.1.9 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove minimatch@9.0.3 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove minimatch@9.0.9 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change from minimatch@x.y.z to minimatch@10.2.5 from ${S}/pnpm-lock.yaml"

# ignore section because of pnpm override
# 5.4.2 -> 5.5.7
#ewarn "QA:  Manually remove fast-xml-parser@4.5.3 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser@4.5.4 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser@5.2.5 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser@5.3.6 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser@5.3.8 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser@5.4.1 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change fast-xml-parser: 4.x, 5.x, or earlier to fast-xml-parser: 5.5.7 depends in ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser: 5.4.1 in ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove fast-xml-parser: 5.5.5 or earlier in ${S}/pnpm-lock.yaml"

ewarn "QA:  Manually remove jsondiffpatch@0.6.0 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove @apidevtools/json-schema-ref-parser@11.1.0 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change @apidevtools/json-schema-ref-parser@11.1.0 to @apidevtools/json-schema-ref-parser@11.2.0 in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove esbuild@0.18.20 and arch implementations from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove esbuild@0.19.12 and arch implementations from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove esbuild@0.25.12 and arch implementations from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change (esbuild@0.19.12) to (esbuild@0.27.5) and arch implementations from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove esbuild@0.21.4 and arch implementations from ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually remove esbuild@0.21.5 and arch implementations from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove <esbuild-0.27.5 from ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually change esbuild: 0.21.4 references to esbuild: 0.25.0"
##ewarn "QA:  Manually change esbuild: 0.21.5 references to esbuild: 0.25.0"
##ewarn "QA:  Manually change esbuild: 0.18.20 references to esbuild: 0.25.0"
#ewarn "QA:  Manually remove @babel/core@7.23.6 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove @babel/runtime@7.23.6 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/core@4.2.4 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/auth-token@3.0.4 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/endpoint@7.0.6 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/graphql@5.0.6 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/request@6.2.8 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/request-error@3.0.3 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/rest@19.0.13 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/tsconfig@1.0.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/types@9.3.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-paginate-rest@6.1.2 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-request-log@1.0.4 from ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove @octokit/plugin-rest-endpoint-methods@7.2.3 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove js-yaml@4.1.0 from ${S}/pnpm-lock.yaml"

#ewarn "QA:  Manually change '@babel/core': 7.23.6 references to '@babel/core': 7.28.5 for ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change '@babel/runtime': 7.28.2 references to '@babel/runtime': 7.28.4 for ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change '@octokit/rest': 19.0.13 references to '@octokit/rest': 20.1.2 for ${S}/pnpm-lock.yaml"

##ewarn "QA:  Manually change '@octokit/auth-token': 3.0.4 to '@octokit/auth-token': 4.0.0 in ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually change '@octokit/graphql': 5.0.6 to '@octokit/graphql': 7.1.1 in ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually change '@octokit/request': 6.2.8 to '@octokit/request': 8.4.1 in ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually change '@octokit/request-error': 3.0.3 to '@octokit/request-error': 5.1.1 in ${S}/pnpm-lock.yaml"
##ewarn "QA:  Manually change '@octokit/types': 9.3.2 to '@octokit/types': 13.10.0 in ${S}/pnpm-lock.yaml"

#ewarn "QA:  Manually change @octokit/rest@20.1.2(encoding@0.1.13) references to @octokit/rest@20.1.2 in ${S}/pnpm-lock.yaml"

#ewarn "QA:  Manually remove regenerator-runtime@0.14.1 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually remove tmp@0.0.33 from ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually change tmp: 0.0.33 references to tmp: 0.2.4 in ${S}/pnpm-lock.yaml"
#ewarn "QA:  Manually dedupe @babel/helper-module-transforms in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually add ai@5.0.52(zod@3.25.76) for @upstash/workflow depends in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually remove electron@34.5.8 in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change electron specifier to ^41.0.0 and version to 41.0.3 for packages/electron-client-ipc depends in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change esbuild-register@3.6.0(esbuild@0.27.5) to esbuild-register@3.6.0 in ${S}/pnpm-lock.yaml"
ewarn "QA:  Manually change esbuild-register: 3.6.0(esbuild@0.27.5) to esbuild-register: 3.6.0 in in ${S}/pnpm-lock.yaml"

		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# EBR = Extended Blast Radius
		# ZC = Zero Click Attack (AV:N, PR:N, UI:N)
		# CE = Code Execution

		pnpm_patch_lockfile() {
			sed -i -e "s|'@apidevtools/json-schema-ref-parser': 11.1.0|'@apidevtools/json-schema-ref-parser': 11.2.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.25.12|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.18.20|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.19.12|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.21.4|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.21.5|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.23.1|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.24.2|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: '>=0.12 <1'|esbuild: 0.27.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|snowflake-sdk: 2.0.3|snowflake-sdk: 2.0.4|g" "pnpm-lock.yaml" || die

			sed -i -e "s|'@babel/runtime': 7.23.6|'@babel/runtime': 7.28.2|g" "pnpm-lock.yaml" || die

	# xlsx-republish or @e965/xlsx can be used as a drop in replacement of xlsx
			sed -i -e "s|\"xlsx\": \"^0.18.5\"|\"@e965/xlsx\": \"^0.20.3\"|g" "packages/file-loaders/package.json" || die

			sed -i -e "s|tmp: 0.0.33|tmp: 0.2.4|g" "pnpm-lock.yaml" || die

#			sed -i -e "s|minimatch: 9.0.9|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 9.0.6|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 9.0.3|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 5.1.9|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 5.1.7|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 3.1.5|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die
#			sed -i -e "s|minimatch: 3.1.3|minimatch: 10.2.5|g" "pnpm-lock.yaml" || die

			sed -i -e "s|bn.js: 4.12.3|bn.js: 5.2.3|g" "pnpm-lock.yaml" || die

			sed -i -e "s|jsondiffpatch: 0.6.0|jsondiffpatch: 0.7.2|g" "pnpm-lock.yaml" || die

			sed -i -e "s|ajv: 8.12.0|ajv: 8.18.0|g" "pnpm-lock.yaml" || die			# CVE-2025-69873; ZC, DoS; Moderate
			sed -i -e "s|ajv: 6.14.0|ajv: 8.18.0|g" "pnpm-lock.yaml" || die			# CVE-2025-69873; ZC, DoS; Moderate

			sed -i -e "s|js-yaml: 4.1.0|js-yaml: 4.1.1|g" "pnpm-lock.yaml" || die

			sed -i -e "s|ai: 4.3.19(react@19.2.4)(zod@3.25.76)|ai: 5.0.52|g" "pnpm-lock.yaml" || die
			sed -i -e "s|'@octokit/rest': 19.0.13(encoding@0.1.13)|'@octokit/rest': 20.1.2|g" "pnpm-lock.yaml" || die
			sed -i -e "s|tar: 7.5.9|tar: 7.5.11|g" "pnpm-lock.yaml" || die
			sed -i -e "s|hono: 4.12.3|hono: 4.12.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|'@hono/node-server': 1.19.9(hono@4.12.3)|'@hono/node-server': 1.19.10|g" "pnpm-lock.yaml" || die
			sed -i -e "s|'@tootallnate/once': 2.0.0|'@tootallnate/once': 3.0.1|g" "pnpm-lock.yaml" || die

#			sed -i -e "s|serialize-javascript: 6.0.2|serialize-javascript: 7.0.5|g" "pnpm-lock.yaml" || die
			sed -i -e "s|undici: 6.21.3|undici: 7.24.5|g" "pnpm-lock.yaml" || die

			sed -i -e "s|fast-xml-parser: 5.4.1|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 5.4.2|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 5.2.5|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 5.3.6|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 4.5.4|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 4.5.3|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|fast-xml-parser: 4.5.3|fast-xml-parser: 5.5.7|g" "pnpm-lock.yaml" || die
			sed -i -e "s|\"fast-xml-parser\": \"5.4.2\"|\"fast-xml-parser\": \"5.5.7\"|g" "package.json" || die

#			sed -i -e "s|handlebars: ^4.7.8|handlebars: 4.7.9|g" "package.json" || die
#			sed -i -e "s|handlebars: 4.7.8|handlebars: 4.7.9|g" "package.json" || die
#			sed -i -e "s|'@xmldom/xmldom': 0.8.11|'@xmldom/xmldom': 0.9.9|g" "package.json" || die
#			sed -i -e "s|path-to-regexp: 8.2.0|path-to-regexp: 8.4.0|g" "package.json" || die
#			sed -i -e "s|happy-dom: 20.8.8|happy-dom: 20.8.9|g" "package.json" || die 
#			sed -i -e "s|yaml: 2.3.3|yaml: 2.8.3|g" "package.json" || die
#			sed -i -e "s|lodash: 4.17.21|lodash: 4.17.23|g" "package.json" || die
		}

		pnpm_patch_lockfile

		local pkgs
		pkgs=(
			"@apidevtools/json-schema-ref-parser@11.2.0"					# CVE-2024-29651; DoS, DT, ID; High
		)
		epnpm add ${pkgs[@]}

		pkgs=(
			"esbuild@0.27.5"								# GHSA-67mh-4wv8-2f99; DI; Moderate

			"@e965/xlsx"									# CVE-2024-22363; DoS; High
													# CVE-2023-30533; DoS, DT, ID; High

			"jsondiffpatch@0.7.2"								# CVE-2025-9910; VS(DT, ID); Moderate
			"ai@5.0.52"									# CVE-2025-48985; DT; Low
#			"@langchain/community@1.1.18"							# CVE-2026-27795; ID; Moderate
													# CVE-2026-26019; ID; Moderate
													# CVE-2026-25528; ID; Moderate for langsmith dep of @langchain/community and langchain
			"electron@${ELECTRON_APP_ELECTRON_PV}"						# CVE-2025-55305; DoS, DT, ID; Moderate
#			"minimatch@10.2.5"								# CVE-2026-26996: ZC, DoS; High
													# CVE-2026-27903; ZC, DoS; High
													# CVE-2026-27904; ZC, DoS; High
			"undici@7.24.5"									# CVE-2026-2229; ZC, DoS, High
													# CVE-2026-1526; ZC, DoS, High
													# CVE-2026-1525; ZC, DT, ID; Moderate
													# CVE-2026-22036; ZC, DoS; Moderate
													# CVE-2026-1527; DT, ID; Moderate
													# CVE-2026-1528; ZC, DoS; High
			"fast-xml-parser@5.5.7"								# CVE-2026-25896; ZC, EBR, DT, ID; Critical
													# CVE-2026-26278; ZC, DoS; High
													# CVE-2026-27942; ZC, VS(DoS); Low		# >= 5.3.8 or >= 4.5.4
													# CVE-2026-33036; ZC, DoS; High
													# CVE-2026-33349; ZC, DoS; Moderate
#			"handlebars@4.7.9"								# CVE-2026-33937; ZC, DoS, DT, ID; Critical
													# CVE-2026-33941; DoS, DT, ID; High
													# CVE-2026-33940; ZC, DoS, DT, ID; High
													# CVE-2026-33938; DoS, DT, ID; High
													# CVE-2026-33939; ZC, DoS; High
													# GHSA-7rx3-28cr-v5wh; ZC, DT, ID; Moderate
													# CVE-2026-33916; DoS, DT; Moderate
													# GHSA-442j-39wm-28r2; ZC, ID; Low
#			"@xmldom/xmldom@0.9.9"								# CVE-2026-34601; ZC, DT; High
#			"path-to-regexp@8.4.0"								# CVE-2026-4923; ZC, DoS; High
#			"nodemailer@8.0.4"								# GHSA-c7w3-x93f-qmm8; VS(DT)
#			"lodash@4.17.23"								# CVE-2025-13465; ZC, VS(DoS, DT), SS(DoS, DT, ID); Moderate
#			"yaml@2.8.3"									# CVE-2026-33532; DoS; Moderate
#			"@langchain/community@1.1.18"
		)
		epnpm add ${pkgs[@]} ${NPM_INSTALL_ARGS[@]}

		pkgs=(
			"snowflake-sdk@2.0.4"								# CVE-2025-24791; DT, ID; Medium
													# CVE-2025-46328; DoS, DT, ID; High
			"tmp@0.2.4"									# CVE-2025-54798; DT; Low

			"@octokit/rest@20.1.2"								# Bump to remove octokit 4.x vulnerabilities
#			"minimatch@10.2.5"								# CVE-2026-26996: ZC, DoS; High
													# CVE-2026-27903; ZC, DoS; High
													# CVE-2026-27904; ZC, DoS; High
			"bn.js@5.2.3"									# CVE-2026-2739: DoS; Moderate
			"js-yaml@4.1.1"									# CVE-2025-64718: ZC, DT; Moderate
			"tar@7.5.11"									# GHSA-qffp-2rhf-9h96; VS(DT, ID), SS(DT, ID)
													# CVE-2026-31802; ZC, VS(DT), SS(DT), High
			"@hono/node-server@1.19.10"							# CVE-2026-29087; ZC, ID; High
			"hono@4.12.7"									# CVE-2026-29045; ZC, ID; High
													# CVE-2026-29085; DT, ID; Moderate
													# CVE-2026-29086; DT, ID; Moderate
													# GHSA-v8w9-8mx6-g223; ZC, DT, ID; Moderate
			"@tootallnate/once@3.0.1"							# CVE-2026-3449; DoS; Low
#			"serialize-javascript@7.0.5"							# GHSA-5c6j-r48x-rmvq; CE, DoS, DT, ID; High
													# CVE-2026-34043; DoS; Moderate
#			"happy-dom@20.8.9"								# CVE-2026-34226; ID; High
		)
		epnpm add -D ${pkgs[@]}

		NODE_ADDON_API_INSTALL_ARGS=( "-P" )
		NODE_GYP_INSTALL_ARGS=( "-D" )
		epnpm add -D "@types/sharp" ${NPM_INSTALL_ARGS[@]}
		node-sharp_pnpm_lockfile_add_sharp
		pnpm_patch_lockfile
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		pnpm_hydrate
		_npm_setup_offline_cache
		_pnpm_setup_offline_cache
		pnpm_src_unpack
		rm -rf "${S}/node_modules/sharp/src/build"
#ewarn "QA: Dedupe and remove sharp@0.33.5.  Change reference of sharp@0.33.5 to sharp@0.30.7"

		local configuration="Debug"
		local nconfiguration="Release"
		if [[ "${NODE_SHARP_DEBUG}" != "1" ]] ; then
			configuration="Release"
			nconfiguration="Debug"
		fi
		local sharp_platform=$(node-sharp_get_platform)

		if [[ "${PNPM_UPDATE_LOCK}" != "1" ]] ; then
		        einfo "Rebuilding sharp in ${S}"
		        pushd "${S}" >/dev/null 2>&1 || die
				node-sharp_pnpm_rebuild_sharp
				# Copy sharp binary to expected location
				mkdir -p "node_modules/sharp/build/${configuration}" || die "Failed to create node_modules/sharp/build/${configuration}"
				cp \
					"node_modules/sharp/src/build/${configuration}/sharp-${sharp_platform}.node" \
					"node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" \
					|| die "Failed to copy sharp-${sharp_platform}.node"
				ls -l "node_modules/sharp/build/${configuration}/sharp-${sharp_platform}.node" || die "sharp-${sharp_platform}.node not found"

		# Remove prebuilts
				rm -rf "node_modules/.pnpm/@img+sharp-"*"@"* || true

				node-sharp_verify_dedupe
			popd >/dev/null 2>&1 || die
		fi

#		epnpm add "svix@1.45.1" ${NPM_INSTALL_ARGS[@]}
	fi
}

src_prepare() {
	default
}

is_postgres_ready() {
	if [[ -z "${KEY_VAULTS_SECRET}" || -z "${DATABASE_URL}" ]] ; then
		[[ -z "${KEY_VAULTS_SECRET}" ]] && eerror "KEY_VAULTS_SECRET is missing."
		[[ -z "${DATABASE_URL}" ]] && eerror "DATABASE_URL is missing."
eerror
eerror "The KEY_VAULTS_SECRET environment variable needs to be set for postgres"
eerror "support."
eerror
eerror "The DATABASE_URL needs to be set for PostgreSQL support."
eerror "Place them into per-package package.env."
eerror
eerror "The value of KEY_VAULTS_SECRET must be generated from"
eerror "\`openssl rand -base64 32\`"
eerror
eerror "The value of DATABASE_URL must must have a strong password and"
eerror "match the port for dev-db/postgres:17"
eerror
eerror "Contents of /etc/portage/env/lobehub.conf:"
eerror "export DATABASE_URL=\"postgres://<lobehub_user>:<lobehub_password>@localhost:5432/lobehub\""
eerror "export KEY_VAULTS_SECRET=\"<key>\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror "${CATEGORY}/${PN} lobehub.conf"
eerror
		die
	fi
	if ! pg_isready -h "localhost" -p ${POSTGRESQL_PORT} ; then
eerror "The postgres-${POSTGRESQL_SLOT} daemon needs to run to continue."
		die
	fi
}

src_configure() {
	npm_hydrate
	pnpm_hydrate

	setup_build_env

	# Checks to see if toolchain is working or meets requirements
	edo npm --version
	edo pnpm --version
	edo tsc --version

ewarn "Do not store KEY_VAULTS_SECRET in /etc/portage/make.conf file for ${PN}."
ewarn "Do not store NEXT_PUBLIC_POSTHOG_KEY in /etc/portage/make.conf file for ${PN}."

	if use postgres ; then
		is_postgres_ready
	fi
}

src_compile() {
	if [[ -e "${S}/.next" ]] ; then
ewarn "Removing ${S}/.next"
		rm -rf "${S}/.next"
	fi

	npm_hydrate
	pnpm_hydrate

	setup_build_env

	# Force rebuild to prevent illegal instruction
	#edo npm rebuild "sharp"

	if ver_test "${NEXTJS_PV%%.*}" "-lt" "15" ; then
	# tsc will ignore tsconfig.json, so it must be explicit.
einfo "Building next.config.js"
		tsc \
			next.config.ts \
			--allowJs \
			--esModuleInterop "true" \
			--jsx "preserve" \
			--lib "dom,dom.iterable,esnext,webworker" \
			--module "esnext" \
			--moduleResolution "bundler" \
			--noCheck \
			--outDir "." \
			--skipDefaultLibCheck \
			--target "esnext" \
			--typeRoots "./node_modules/@types" \
			--types "react,react-dom" \
			|| die
		mv "next.config."{"js","mjs"} || die
#einfo "End build of next.config.js"
		#grep -q -E -e "Found [0-9]+ error." "${T}/build.log" && die "Detected error"
		#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"
	fi

	if ! use postgres ; then
		sed -i -e "s|MIGRATION_DB=1|true MIGRATION_DB=1|g" "package.json" || die
	fi

	if use pwa ; then
		edo npm run "build"
		grep -q -e "Next.js build worker exited with code" "${T}/build.log" && die "Detected error"
		grep -q -e "Failed to load next.config.js" "${T}/build.log" && die "Detected error"
		edo npm run "build-sitemap"
	else
		edo npm run "desktop:build:all"
		edo npm run "build:main"
	fi

	# Equivalent to `pnpm run postbuild`
	edo npm run "build-sitemap"

	if use postgres ; then
		is_postgres_ready

		cat /dev/null > "${S}/.env" || die
		echo "KEY_VAULTS_SECRET=\"${KEY_VAULTS_SECRET}\"" >> "${S}/.env" || die
		if [[ "${DATABASE_URL}" =~ "sslmode" ]] ; then
			echo "DATABASE_URL=\"${DATABASE_URL}\"" >> "${S}/.env" || die
		else
			echo "DATABASE_URL=\"${DATABASE_URL}?sslmode=disable\"" >> "${S}/.env" || die
		fi
		echo "DATABASE_DRIVER=\"node\"" >> "${S}/.env" || die

		edo npm run "db:generate"
		edo npm run "db:migrate"
	fi

	grep -q -e "Build failed because of webpack errors" "${T}/build.log" && die "Detected error"
	grep -q -e "Failed to compile" "${T}/build.log" && die "Detected error"
	#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"

	if ! [[ -e "${S}/.next/standalone/server.js" ]] ; then
eerror "Build failure.  Missing ${S}/.next/standalone/server.js"
		die
	fi

	# Change hardcoded paths
	sed -i -e "s|${S}|/opt/${MY_PN2}|g" $(grep -l -r -e "${S}" "${S}/.next") || die

	if use electron ;then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		export ELECTRON_CUSTOM_DIR="v${ELECTRON_APP_ELECTRON_PV}"

		electron-app_cp_electron

		pushd "apps/desktop" || die
			edo electron-builder \
				--config "electron-builder.mjs" \
				$(electron-app_get_electron_platarch_args) \
				-l "dir"
		popd || die
	fi

	# Remove the plaintext keys from the package manager's environment.bz2.
	# API keys are considered sensitive data.
	AUTH_SECRET=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)			# Session key
	KEY_VAULTS_SECRET=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)		# DB key
	NEXT_PUBLIC_POSTHOG_KEY=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)	# Analytics/telemetry key
	DATABASE_URL=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)			# DB key
	unset AUTH_SECRET
	unset KEY_VAULTS_SECRET
	unset NEXT_PUBLIC_POSTHOG_KEY
	unset DATABASE_URL
	shred "${S}/.env"
}

_install_pwa_webapp() {
	local _PREFIX="/opt/${MY_PN2}"

	# Include hidden files/dirs with *
	shopt -s dotglob

	insinto "${_PREFIX}"
	doins -r "${S}/.next/standalone/"* # Contains node_modules, .next, server.js

	insinto "${_PREFIX}/.next/static"
	doins -r "${S}/.next/static/"*

	insinto "${_PREFIX}/public/spa"
	doins -r "${S}/public/spa/"*

	if use postgres ; then
		insinto "${_PREFIX}/packages/database/migrations"
		doins -r "${S}/packages/database/migrations/"*

		insinto "${_PREFIX}"
		doins "${S}/scripts/migrateServerDB/docker.cjs"
		doins "${S}/scripts/migrateServerDB/errorHint.js"
	fi

	# Copy database dependencies and drivers
	insinto "${_PREFIX}/node_modules/.pnpm"
	doins -r "${S}/node_modules/.pnpm/"*
	insinto "${_PREFIX}/node_modules/pg"
	doins -r "${S}/node_modules/pg/"*
	insinto "${_PREFIX}/node_modules/drizzle-orm"
	doins -r "${S}/node_modules/drizzle-orm/"*

	sed -i \
		-e "s|@NODE_SLOT@|${NODE_SLOT}|g" \
		"${S}/scripts/serverLauncher/startServer.js" \
		|| die
	insinto "${_PREFIX}"
	doins "${S}/scripts/serverLauncher/startServer.js"

	insinto "${_PREFIX}/scripts/_shared"
	doins -r "${S}/scripts/_shared/"*

	fowners -R "${MY_PN2}:${MY_PN2}" "${_PREFIX}"

	# Exclude hidden files/dirs with *
	shopt -u dotglob
}

_install_electron() {
eerror "TODO: _install_electron"
	die
}

has_s3_support() {
	if use ceph || use minio || use s3 ; then
		echo "1"
	else
		echo "0"
	fi
}

get_s3_provider() {
	if use ceph ; then
		echo "ceph"
	elif use minio ; then
		echo "minio"
	elif use s3 ; then
		echo "s3"
	fi
}

gen_pwa_config() {
	local database_type=""
	if use postgres ; then
		database_type="postgres"
	else
		database_type="next"
	fi
	local enable_s3_support=$(has_s3_support)
	local redis_url=$(usex redis "redis://localhost:6379" "")
	local s3_provider=$(get_s3_provider)
	local ui_mode=$(usex electron "electron" "pwa")

	cat \
		"${FILESDIR}/${MY_PN2}.conf" \
			> \
		"${T}/${MY_PN2}.conf" \
		|| die
	sed -i \
		-e "s|@DATABASE_TYPE@|${database_type}|g" \
		-e "s|@ENABLE_S3_SUPPORT@|${enable_s3_support}|g" \
		-e "s|@HOSTNAME@|${lobehub_hostname}|g" \
		-e "s|@NODE_SLOT@|${NODE_SLOT}|g" \
		-e "s|@PORT@|${lobehub_port}|g" \
		-e "s|@REDIS_URL@|${redisurl}|g" \
		-e "s|@UI_MODE@|${ui_mode}|g" \
		-e "s|@S3_PROVIDER@|${s3_provider}|g" \
		"${T}/${MY_PN2}.conf" \
		|| die

	insinto "/etc/conf.d"
	newins "${T}/${MY_PN2}.conf" "${MY_PN2}"

	# Secure keys/tokens
	fperms 0640 "/etc/conf.d/${MY_PN2}"
}

gen_start_server_wrapper() {
	cat \
		"${FILESDIR}/${MY_PN2}-start-server" \
		> \
		"${T}/${MY_PN2}-start-server" \
		|| die
	sed -i \
		-e "s|@NODE_SLOT@|${NODE_SLOT}|g" \
		"${T}/${MY_PN2}-start-server" \
		|| die

	exeinto "/usr/bin"
	doexe "${T}/${MY_PN2}-start-server"
	fperms 0755 "/usr/bin/${MY_PN2}-start-server"
}

_install_pwa() {
	_install_pwa_webapp
	gen_pwa_config
	gen_start_server_wrapper

	if use openrc ; then
		cat "${FILESDIR}/${MY_PN2}.openrc" > "${T}/${MY_PN2}" || die
		sed -i -e "s|@POSTGRESQL_SLOT@|${POSTGRESQL_SLOT}|g" "${T}/${MY_PN2}" || die
		doinitd "${T}/${MY_PN2}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		cat "${FILESDIR}/${MY_PN2}.systemd" > "${T}/${MY_PN2}.service" || die
		sed -i -e "s|@POSTGRESQL_SLOT@|${POSTGRESQL_SLOT}|g" "${T}/${MY_PN2}.service" || die
		doins "${T}/${MY_PN2}.service"
	fi

	# Include hidden files/dirs with *
	shopt -s dotglob

	# Bypass normal merge to speed up merge using OS tricks
	# Essentially portage does a k*O(n) problem with copy, scanelf, md5,
	# etc. versus a simple pointer change with the code below.
	mv "${ED}/opt/${MY_PN2}/"* "/opt/${MY_PN2}"
	keepdir "/opt/${MY_PN2}"
ewarn "An install speed up trick is used."
ewarn "You may need to emerge again if missing /opt/lobehub/startServer.js"

	# Exclude hidden files/dirs with *
	shopt -u dotglob

	exeinto "/usr/bin"
	cat \
		"${FILESDIR}/${MY_PN2}" \
		> \
		"${T}/${MY_PN2}" \
		|| die

	local lobehub_uri=${LOBEHUB_URI:-"http://${lobehub_hostname}:${lobehub_port}"}
einfo "LOBEHUB_URI:  ${lobehub_uri}"
	sed -i \
		-e "s|@LOBEHUB_URI@|${lobehub_uri}|g" \
		"${T}/${MY_PN2}" \
		|| die
	doexe "${T}/${MY_PN2}"

	make_desktop_entry \
		"${MY_PN2}" \
		"${PN}" \
		"${PN}.png" \
		"Education;ArtificialIntelligence"

	keepdir "/var/cache/${MY_PN2}"
	keepdir "/opt/${MY_PN2}/.next"
	dosym "/var/cache/${MY_PN2}" "/opt/${MY_PN2}/.next/cache"
	fowners "${MY_PN2}:${MY_PN2}" "/var/cache/${MY_PN2}"

	fowners "${MY_PN2}:${MY_PN2}" "/etc/conf.d/${MY_PN2}"
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"

	newicon \
		"${S}/public/icons/icon-512x512.png" \
		"${PN}.png"

	# Include hidden files/dir for *
	shopt -s dotglob

	addwrite "/opt/${MY_PN2}"
	rm -rf "/opt/${MY_PN2}/"*

	# Exclude hidden files/dir for *
	shopt -u dotglob

	local lobehub_hostname=${LOBEHUB_HOSTNAME:-"localhost"}
	local lobehub_port=${LOBEHUB_PORT:-3210}

einfo "LOBEHUB_HOSTNAME:  ${lobehub_hostname} (user-definable, per-package environment variable)"
einfo "LOBEHUB_PORT:  ${lobehub_port} (user-definable, per-package environment variable)"

	if use pwa ; then
		_install_pwa
	else
		_install_electron
	fi

	dhms_end
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "The documentation for /etc/conf.d/lobehub can be found at"
einfo
einfo "https://lobehub.com/docs/self-hosting/advanced/auth"
einfo "https://lobehub.com/docs/self-hosting/environment-variables/model-provider"
einfo "https://lobehub.com/docs/self-hosting/advanced/s3"
einfo
ewarn
ewarn "The auth system has switched to Better Auth requiring variable name changes."
ewarn "See the link below details:"
ewarn
ewarn "https://lobehub.com/docs/self-hosting/migration/v2/auth/nextauth-to-betterauth"
ewarn
ewarn
ewarn "The ${PN} package uses dev-db/postgresql:${POSTGRESQL_SLOT}."
ewarn "Make sure the PostgreSQL server is loaded and configured."
ewarn
ewarn "The use of localhost or 127.0.0.1 identifiers are mutually exclusive for OAuth."
ewarn "Use the same identifier throughout the /etc/conf.d/lobehub and the remote OAuth settings."
ewarn
	if use minio ; then
ewarn "You must manually update S3_SECRET_ACCESS_KEY in /etc/conf.d/lobehub with the new login details."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/opt/${MY_PN2}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  FAIL 1.62.0 (20250222).  Build time failure
# OILEDMACHINE-OVERLAY-TEST:  FAIL 1.63.1 (20250223).  Build time failure.  Next.js build worker exited with code: null and signal: SIGSEGV
# OILEDMACHINE-OVERLAY-TEST:  PASS 1.65.1 (20250226) with sharp 0.30.7.    Client side database mode only.
# OILEDMACHINE-OVERLAY-TEST:  PASS 1.111.4 (20250809) with sharp 0.34.3.    Client side database mode only.
# OILEDMACHINE-OVERLAY-TEST:  PASS 1.133.4 (20251003) with sharp 0.34.3.    Client side database mode only.
# OILEDMACHINE-OVERLAY-TEST:  FAIL 2.1.34 (20260302) with sharp 0.34.3.    Internal Server Error because missing or undocumented workaround for #10456 changes.  See https://github.com/lobehub/lobehub/issues/10835
# OILEDMACHINE-OVERLAY-TEST:  FAIL 2.1.44 (20260323) with sharp 0.34.3.    ERROR [Better Auth]: Error Error: Failed query: insert into "verifications"
# OILEDMACHINE-OVERLAY-TEST:  FAIL 2.1.44 (20260324) with sharp 0.34.3.    OAuth works but full migration to postgres-js driver is not complete. With USE="pwa postgres" and postgres-js 3.4.8, better-auth 1.5.6, drizzle-orm 0.45.1, drizzle-kit 0.30.6, better-call 1.3.2, @better-auth/passkey@1.5.6, @better-auth/expo@1.5.6
# OILEDMACHINE-OVERLAY-TEST:  PASS 2.1.44 (20260325) with sharp 0.34.3.
# OILEDMACHINE-OVERLAY-TEST:  PASS 2.1.46 (20260326) with sharp 0.34.3.

# E-mail login:  untested
# Electron:  untested
# IndexedDB (browser only) database support:  untested
# GitHub OAuth:  passed
# Ollama test "what is the speed of light?" with smollm:  passed
# PostgreSQL 17 (locally hosted server) database support:  passed
# PWA (browser load test):  passed
# Sharp:  passed
# Stability:  passed
# Text file RAG:  passed
# To test Sharp:  Settings > Appearance > Theme has 3 pictures
