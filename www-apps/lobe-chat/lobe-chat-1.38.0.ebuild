# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Ebuild using React 18

# node_modules/.pnpm/@types+mdx@2.0.13/node_modules/@types/mdx/index.d.ts

#
# China distro users, fork ebuild and regenerate the pnpm lockfile.
#
# Contents of /etc/portage/env/lobe-chat.conf:
#
#   USE_CN_MIRROR=true
#
# Contents of /etc/portage/package.env:
#
#   www-apps/lobe-chat lobe-chat.conf
#
# Generate the lockfile as follows:
#
#   OILEDMACHINE_OVERLAY_DIR="/usr/local/oiledmachine-overlay"
#   PATH="${OILEDMACHINE_OVERLAY_DIR}/scripts:${PATH}"
#   cd "${OILEDMACHINE_OVERLAY_DIR}/www-apps/lobe-chat"
#   PNPM_UPDATER_VERSIONS="1.38.0" pnpm_updater_update_locks.sh
#

# U22, U24, D12
# U24 - node 20 (release - live, debug - live)
# U22 - node 18 (check - live)

# @serwist/next needs pnpm workspaces

# Use `PNPM_UPDATER_VERSIONS="1.38.0" pnpm_updater_update_locks.sh` to update lockfile

MY_PN="LobeChat"

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_2
)
# See also https://github.com/vercel/next.js/blob/v15.1.6/.github/workflows/build_and_test.yml#L328
NODE_VERSION=22
NPM_SLOT="3"
PNPM_DEDUPE=0 # Still debugging
PNPM_SLOT="9"
NEXTJS_PV="14.2.8"
NPM_AUDIT_FIX_ARGS=(
	"--legacy-peer-deps"
)
NPM_DEDUPE_ARGS=(
	"--legacy-peer-deps"
)
NPM_INSTALL_ARGS=(
	"--legacy-peer-deps"
)
NPM_UNINSTALL_ARGS=(
	"--legacy-peer-deps"
)
PNPM_AUDIT_FIX=0
RUST_MAX_VER="1.71.1" # Inclusive
RUST_MIN_VER="1.76.0" # dependency graph:  next -> @swc/core -> rust.  llvm 17.0 for next.js 14.2.8 dependency of @swc/core 1.4.4
RUST_PV="${RUST_MIN_VER}"
SERWIST_CHOICE="no-change" # update, remove, no-change
SHARP_PV="0.33.5"
VIPS_PV="8.15.3"

inherit dhms desktop edo npm pnpm rust xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lobehub/lobe-chat.git"
	FALLBACK_COMMIT="f56dab7a48fc681e9ab9645b7a63c45e9cee680b" # Jan 21, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/lobehub/lobe-chat/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A modern-design progressive web app supporting AI chat, function call plugins, multiple open/closed LLM models, RAG, TTS, vision"
HOMEPAGE="
	https://lobehub.com/
	https://github.com/lobehub/lobe-chat
	https://pypi.org/project/tdir
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
		custom
	)
"
# The distro's Apache-2.0 license file does not contain all rights reserved
# custom - See https://github.com/lobehub/lobe-chat/blob/main/LICENSE
RESTRICT="binchecks mirror strip test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_X86[@]}
+indexdb +openrc postgres systemd +system-vips
ebuild_revision_9
"
REQUIRED_USE="
	!cpu_flags_x86_sse4_2? (
		system-vips
	)
	^^ (
		indexdb
		postgres
	)
	|| (
		openrc
		systemd
	)
"
VIPS_RDEPEND="
	>=net-libs/nodejs-14.15.0
	elibc_glibc? (
		>=sys-libs/glibc-2.17
	)
	elibc_musl? (
		>=sys-libs/musl-1.1.24
	)
	system-vips? (
		>=media-libs/vips-${VIPS_PV}[cxx,exif,lcms,webp]
	)
"
# xdg-open is from x11-misc/xdg-utils
RDEPEND+="
	${VIPS_RDEPEND}
	acct-group/lobe-chat
	acct-user/lobe-chat
	>=app-misc/ca-certificates-20240203
	>=net-misc/proxychains-3.1
	>=sys-devel/gcc-12.2.0
	net-libs/nodejs:${NODE_VERSION}[corepack,npm]
	net-libs/nodejs:=
	x11-misc/xdg-utils
	postgres? (
		>=dev-db/postgresql-16.4
	)
"
DEPEND+="
	${RDEPEND}
"
VIPS_BDEPEND="
	virtual/pkgconfig
"
BDEPEND+="
	${VIPS_BDEPEND}
	>=sys-apps/pnpm-9.14.4:${PNPM_SLOT}
	>=sys-apps/npm-10.8.2:${NPM_SLOT}
	net-libs/nodejs:${NODE_VERSION}[corepack,npm]
	net-libs/nodejs:=
	|| (
		dev-lang/rust:${RUST_PV}
		dev-lang/rust-bin:${RUST_PV}
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

# Do not remove function.
# @FUNCTION: _set_sharp_env
# @DESCRIPTION:
# sharp env
_set_sharp_env() {
	unset SHARP_IGNORE_GLOBAL_LIBVIPS
	unset SHARP_FORCE_GLOBAL_LIBVIPS
	if use system-vips ; then
einfo "Using system vips for sharp"
		export SHARP_FORCE_GLOBAL_LIBVIPS=1
	else
einfo "Using vendored vips for sharp"
		export SHARP_IGNORE_GLOBAL_LIBVIPS=1
	fi
}

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
	export NODE_OPTIONS=" --max-old-space-size=8192" # Breaks with 4096
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"

	# The build variables below can be set in /etc/portage/env/lobe-chat.conf
	# Then referenced in /etc/portage/package.env with a `www-apps/lobe-chat lobe-chat.conf` line.

	export NEXT_PUBLIC_BASE_PATH="${NEXT_PUBLIC_BASE_PATH}"

	# Sentry (debug, session replay, performance monitoring)
	export NEXT_PUBLIC_SENTRY_DSN="${NEXT_PUBLIC_SENTRY_DSN}"
	export SENTRY_ORG=""
	export SENTRY_PROJECT=""

	# Posthog (analytics)
	export NEXT_PUBLIC_ANALYTICS_POSTHOG="${NEXT_PUBLIC_ANALYTICS_POSTHOG}"
	export NEXT_PUBLIC_POSTHOG_HOST="${NEXT_PUBLIC_POSTHOG_HOST}"
	export NEXT_PUBLIC_POSTHOG_KEY="${NEXT_PUBLIC_POSTHOG_KEY}"

	# Umami (analytics)
	export NEXT_PUBLIC_ANALYTICS_UMAMI="${NEXT_PUBLIC_ANALYTICS_UMAMI}"
	export NEXT_PUBLIC_UMAMI_SCRIPT_URL="${NEXT_PUBLIC_UMAMI_SCRIPT_URL}"
	export NEXT_PUBLIC_UMAMI_WEBSITE_ID="${NEXT_PUBLIC_UMAMI_WEBSITE_ID}"

einfo "Inspecting per-package environment variables."
einfo
einfo "To set up per-package environment variables see"
einfo "https://wiki.gentoo.org/wiki//etc/portage/package.env"
einfo
	if [[ -z "${APP_URL}" ]] ; then
		export APP_URL="http://localhost:3210"
ewarn "APP_URL:  ${APP_URL} (user-definable, per-package environment variable)"
	else
		export APP_URL
	fi
	if [[ -z "${NEXTAUTH_URL}" ]] ; then
		export NEXTAUTH_URL="http://localhost:3210/api/auth"
ewarn "NEXTAUTH_URL:  ${NEXTAUTH_URL} (user-definable, per-package environment variable)"
	else
		export NEXTAUTH_URL
	fi
	if [[ -z "${NEXT_AUTH_SSO_PROVIDERS}" ]] ; then
# It should be explicit for a reproducible build.
eerror
eerror "Missing NEXT_AUTH_SSO_PROVIDERS per-package environment variable.  For"
eerror "possible values, see"
eerror
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#next-auth"
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#advanced-configuration"
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth/next-auth/github"
eerror "  https://next-auth.js.org/providers"
eerror
eerror "This per-package environment variable is configurable."
eerror "Ebuild development uses github as the SSO (Single Sign-On) provider."
eerror
		die
	else
		export NEXT_AUTH_SSO_PROVIDERS
	fi
	if [[ -z "${NEXT_AUTH_SECRET}" ]] ; then
eerror
eerror "Missing NEXT_AUTH_SECRET per-package environment variable.  To generate"
eerror "a secret, see"
eerror
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#next-auth"
eerror
eerror "This per-package environment variable is configurable."
eerror
		die
	else
		export NEXT_AUTH_SECRET
	fi
	if [[ -z "${AUTH_GITHUB_ID}" ]] ; then
ewarn
ewarn "Missing AUTH_GITHUB_ID per-package environment variable."
ewarn
ewarn "You may use another provider, but the github provider is the primary"
ewarn "OAuth provider used for developing this ebuild."
ewarn
ewarn "See https://lobehub.com/docs/self-hosting/advanced/auth/next-auth/github"
ewarn
	else
		export AUTH_GITHUB_ID
	fi
}

# Placeholders
setup_ci_test_env() {
	if use postgres ; then
		export DATABASE_TEST_URL="postgresql://postgres:postgres@localhost:5432/postgres"
		export DATABASE_DRIVER="node"
		export NEXT_PUBLIC_SERVICE_MODE="server"
		export KEY_VAULTS_SECRET="LA7n9k3JdEcbSgml2sxfw+4TV1AzaaFU5+R176aQz4s="
		export S3_PUBLIC_DOMAIN="https://example.com"
		export APP_URL="https://home.com"
	fi
}

# For test or production env
setup_test_env() {
	export NODE_ENV="production"

	export NODE_OPTIONS=""
#	if ver_test "${NODE_VERSION}" -eq "18" ;  then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
#	fi

	if ver_test "${NODE_VERSION}" -ge "22" ;  then
		export NODE_OPTIONS+=" --use-openssl-ca"
	fi
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"

	local next_public_service_mode="client"
	if use postgres ; then
		next_public_service_mode="server"
	fi
	cat "${FILESDIR}/lobe-chat.conf" > "${T}/lobe-chat.conf"
	sed -i \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		-e "s|@NEXT_PUBLIC_SERVICE_MODE@|${next_public_service_mode}|g" \
		"${T}/lobe-chat.conf" \
		|| die
	#source "${T}/lobe-chat.conf"
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
einfo "PATH:  ${PATH}"
	check_virtual_mem

	# Rebuild sharp without prebuilt vips.
	# Prebuilt vips is built with sse4.2 which breaks on older processors.
	# Reference:  https://sharp.pixelplumbing.com/install#prebuilt-binaries
	_set_sharp_env

	rust_pkg_setup
	if has_version "dev-lang/rust-bin:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "binary"
	elif has_version "dev-lang/rust:${RUST_PV}" ; then
		rust_prepend_path "${RUST_PV}" "source"
	else
eerror "Rust ${RUST_PV} required for @swc/core"
		die
	fi
}

pnpm_unpack_post() {
	gen_git_tag "${S}" "v${PV}"

	setup_cn_mirror_env

	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i \
			-e "s|bun run|npm run|g" \
			"${S}/package.json" \
			|| die
		grep -e "ERR_PNPM_FETCH_404" "${T}/build.log" && die "Detected error.  Check pnpm add"
	else
		if use postgres ; then
			local pkgs=(
				"sharp@${SHARP_PV}"
				"pg@8.13.1"
				"drizzle-orm@0.38.2"
			)
			epnpm add ${PNPM_INSTALL_ARGS[@]} ${pkgs[@]}
		fi
	fi

# The prebuilt vips could be causing the segfault.  The sharp package need to
# reference the system's vips package not the prebuilt one.
	eapply "${FILESDIR}/${PN}-1.38.0-hardcoded-paths.patch"
	eapply "${FILESDIR}/${PN}-1.38.0-next-config.patch"

#	if [[ "${PNPM_UPDATE_LOCK}" != "1" ]] ; then
#		eapply "${FILESDIR}/lobe-chat-1.62.4-pnpm-patches.patch" # undo
#		mkdir -p "${S}/patches" || die
#		cat "${FILESDIR}/types__mdx-2.0.13.patch" > "${S}/patches/@types__mdx@2.0.13.patch" || die
#		cat "${FILESDIR}/pdf-parse-1.1.1.patch" > "${S}/patches/pdf-parse@1.1.1.patch" || die
#	fi

#	if ver_test "${NEXTJS_PV%%.*}" -lt "15" ; then
		# Not compatiable with Next.js 14
#		sed -i -e "/webpackMemoryOptimizations/d" "next.config.ts" || die
#		sed -i -e "/hmrRefreshes/d" "next.config.ts" || die
#		sed -i -e "/serverExternalPackages/d" "next.config.ts" || die
#		sed -i -e "/@ts-expect-error/d" "src/features/MobileSwitchLoading/index.tsx" || die
#	fi

	local pkgs
	if [[ "${SERWIST_CHOICE}" == "no-change" ]] ; then
		:
	elif [[ "${SERWIST_CHOICE}" == "remove" ]] ; then
		# Remove serwist, missing stable @serwist/utils
		eapply "${FILESDIR}/${PN}-1.48.3-drop-serwist.patch"
		if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
			pkgs=(
				"@serwist/next"
				"serwist"
			)
			epnpm uninstall ${pkgs[@]}

			pkgs=(
				"@ducanh2912/next-pwa@^10.2.8"
			)
			epnpm add -D ${pkgs[@]}
		fi
	else
		pkgs=(
			"@serwist/utils@9.0.0-preview.26"
			"@serwist/next@9.0.0-preview.26"
		)
		epnpm add ${pkgs[@]}

		pkgs=(
			"serwist@9.0.0-preview.26"
		)
		epnpm add -D ${pkgs[@]}
	fi
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
	# Fixes to unmet peer or missing references
		pkgs=(
#			"@langchain/core@0.3.39"
			"next@${NEXTJS_PV}"
#			"officeparser@4.0.4"
			"react@18.3.1"
			"react-dom@18.3.1"
#			"svix@1.45.1"
#			"tree-sitter@^0.21.1"
#			"zustand-utils@1.3.2"	# Breaks build
		)
		epnpm add ${pkgs[@]}
		pkgs=(
			"@octokit/core@4.2.4"
			"@octokit/plugin-paginate-rest@7.1.2"	# octokit 4
			"@octokit/plugin-throttling@6.1.0"	# octokit 4
			"stylelint@14.16.1"
			"stylelint@16.1.0"
		)
#		epnpm add -D ${pkgs[@]}
	fi
}

pnpm_audit_post() {
	local pkgs
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i -e "s|\"vitest\": \"~1.2.2\"|\"vitest\": \"1.6.1\"|g" "package.json" || die
		pkgs=(
			"vitest@1.6.1"
		)
#		epnpm add -D ${pkgs[@]} ${PNPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical
	fi
}

pnpm_dedupe_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		patch_lockfile() {
			sed -i -e "s|'@apidevtools/json-schema-ref-parser': 11.1.0|'@apidevtools/json-schema-ref-parser': 11.2.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.18.20|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.19.12|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.21.4|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.21.5|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.23.1|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: 0.24.2|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
			sed -i -e "s|esbuild: '>=0.12 <1'|esbuild: 0.25.0|g" "pnpm-lock.yaml" || die
		}

#		patch_lockfile
ewarn "QA:  Manually remove @apidevtools/json-schema-ref-parser@11.1.0 from ${S}/pnpm-lock.yaml"
#		epnpm add "@apidevtools/json-schema-ref-parser@11.2.0" ${PNPM_INSTALL_ARGS[@]}		# CVE-2024-29651; DoS, DT, ID; High
ewarn "QA:  Manually remove <esbuild-0.25.0 from ${S}/pnpm-lock.yaml"
#		epnpm add "esbuild@0.25.0"								# GHSA-67mh-4wv8-2f99
		epnpm add "sharp@${SHARP_PV}"
		patch_lockfile
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		_npm_setup_offline_cache
		_pnpm_setup_offline_cache
		pnpm_src_unpack
		epnpm add "sharp@${SHARP_PV}"
#		epnpm add "svix@1.45.1"
	fi
}

src_prepare() {
	default
}

src_configure() {
	# Checks to see if toolchain is working or meets requirements
	epnpm --version
}

src_compile() {
	if [[ -e "${S}/.next" ]] ; then
ewarn "Removing ${S}/.next"
		rm -rf "${S}/.next"
	fi

	npm_hydrate
	pnpm_hydrate

	setup_build_env

	tsc --version || die

	# Force rebuild to prevent illegal instruction
	edo npm rebuild sharp

#	if ver_test "${NEXTJS_PV%%.*}" -lt "15" ; then
#	# tsc will ignore tsconfig.json, so it must be explicit.
#einfo "Building next.config.js"
#		tsc \
#			next.config.ts \
#			--allowJs \
#			--esModuleInterop "true" \
#			--jsx "preserve" \
#			--lib "dom,dom.iterable,esnext,webworker" \
#			--module "esnext" \
#			--moduleResolution "bundler" \
#			--noCheck \
#			--outDir "." \
#			--skipDefaultLibCheck \
#			--target "esnext" \
#			--typeRoots "./node_modules/@types" \
#			--types "react,react-dom" \
#			|| die
#		mv "next.config."{"js","mjs"} || die
#einfo "End build of next.config.js"
		#grep -q -E -e "Found [0-9]+ error." "${T}/build.log" && die "Detected error"
		#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"
#	fi

#	edo npm run "build:docker"

	edo next build --debug
	grep -q -e "Next.js build worker exited with code" "${T}/build.log" && die "Detected error"
	grep -q -e "Failed to load next.config.js" "${T}/build.log" && die "Detected error"
	edo npm run build-sitemap
	edo npm run build-sitemap
	edo npm run build-migrate-db


	grep -q -e "Build failed because of webpack errors" "${T}/build.log" && die "Detected error"
	grep -q -e "Failed to compile" "${T}/build.log" && die "Detected error"
	#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"

	if ! [[ -e "${S}/.next/standalone/server.js" ]] ; then
eerror "Build failure.  Missing ${S}/.next/standalone/server.js"
		die
	fi

	# Change hardcoded paths
	sed -i -e "s|${S}|/opt/${PN}|g" $(grep -l -r -e "${S}" "${S}/.next") || die
}

# Slow
_install_webapp_v1() {
	local _PREFIX="/opt/${PN}"
	insinto "${_PREFIX}"
	doins -r "${S}/package.json"
	doins -r "${S}/.npmrc"
	doins -r "${S}/public"

	insinto "${_PREFIX}/.next"
	doins -r "${S}/.next/static"

	insinto "${_PREFIX}"
	doins -r "${S}/.next/standalone/"* # contains node_modules, .next, server.js

	insinto "${_PREFIX}/node_modules"
	doins -r "${S}/node_modules/.pnpm"
	doins "${S}/scripts/serverLauncher/startServer.js"

	if use postgres ; then
		insinto "${_PREFIX}"
		doins -r "${S}/src/database/migrations"
		doins "${S}/scripts/migrateServerDB/docker.cjs"
		doins "${S}/scripts/migrateServerDB/errorHint.js"
	fi

	fowners -R "${PN}:${PN}" "${_PREFIX}"
}

# Use OS tricks
_install_webapp_v2() {
	local _PREFIX="/opt/${PN}"
	dodir "${_PREFIX}"
	mv "${S}/package.json" "${ED}${_PREFIX}" || die
	mv "${S}/.npmrc" "${ED}${_PREFIX}" || die
	mv "${S}/public" "${ED}${_PREFIX}" || die

	mkdir -p "${ED}${_PREFIX}/.next" || die
	mv "${S}/.next/static" "${ED}${_PREFIX}/.next" || die

	cp -aT "${S}/.next/standalone" "${ED}${_PREFIX}" || die # contains node_modules, .next, server.js

	cp -aT "${S}/node_modules" "${ED}${_PREFIX}/node_modules" || die
	mv "${S}/scripts/serverLauncher/startServer.js" "${ED}${_PREFIX}" || die

	mv "${S}/src/database/migrations" "${ED}${_PREFIX}" || die
	mv "${S}/scripts/migrateServerDB/docker.cjs" "${ED}${_PREFIX}" || die
	mv "${S}/scripts/migrateServerDB/errorHint.js" "${ED}${_PREFIX}" || die

	# Sanitize permissions
	chown -R "${PN}:${PN}" "${ED}${_PREFIX}" || die
	find "${ED}" -type f -print0 | xargs -0 chmod 0644 || die
	find "${ED}" -type d -print0 | xargs -0 chmod 0755 || die
}

gen_config() {
	local next_public_service_mode="client"
	if use postgres ; then
		next_public_service_mode="server"
	fi

	cat \
		"${FILESDIR}/${PN}.conf" \
		> \
		"${T}/${PN}.conf" \
		|| die
	sed -i \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		-e "s|@NEXT_PUBLIC_SERVICE_MODE@|${next_public_service_mode}|g" \
		-e "s|@HOSTNAME@|${lobechat_hostname}|g" \
		-e "s|@PORT@|${lobechat_port}|g" \
		"${T}/${PN}.conf" \
		|| die
	insinto "/etc/${PN}"
	doins "${T}/${PN}.conf"
	fperms 0660 "/etc/${PN}/lobe-chat.conf"
}

gen_standalone_wrapper() {
	cat \
		"${FILESDIR}/${PN}-start-server" \
		> \
		"${T}/${PN}-start-server" \
		|| die
	sed -i \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		"${T}/${PN}-start-server" \
		|| die

	exeinto "/usr/bin"
	doexe "${T}/${PN}-start-server"
	fperms 0755 "/usr/bin/${PN}-start-server"
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"

	# Include hidden files/dirs with *
	shopt -s dotglob

	addwrite "/opt/${PN}"
	rm -rf "/opt/${PN}/"*

	local lobechat_hostname=${LOBECHAT_HOSTNAME:-3210}
	local lobechat_port=${LOBECHAT_PORT:-"localhost"}

einfo "LOBECHAT_HOSTNAME:  ${lobechat_hostname} (user-definable, per-package environment variable)"
einfo "LOBECHAT_PORT:  ${lobechat_port} (user-definable, per-package environment variable)"

	_install_webapp_v2
	gen_config
	gen_standalone_wrapper
	if use openrc ; then
		newinitd "${FILESDIR}/${PN}.openrc" "${PN}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		newins "${FILESDIR}/${PN}.systemd" "${PN}.service"
	fi

	# Bypass normal merge to speed up merge using OS tricks
	# Essentially portage does a k*O(n) problem with copy, scanelf, md5,
	# etc. versus a simple pointer change with the code below.
	mv "${ED}/opt/${PN}/"* "/opt/${PN}"
	keepdir "/opt/${PN}"
ewarn "An install speed up trick is used."
ewarn "You may need to emerge again if missing /opt/lobe-chat/startServer.js"

	# Exclude hidden files/dirs with *
	shopt -u dotglob

	exeinto "/usr/bin"
	cat \
		"${FILESDIR}/${PN}" \
		> \
		"${T}/${PN}" \
		|| die

	local lobechat_uri=${LOBECHAT_URI:-"http://${lobechat_hostname}:${lobechat_port}"}
einfo "LOBECHAT_URI:  ${lobechat_uri}"
	sed -i \
		-e "s|@LOBECHAT_URI@|${lobechat_uri}|g" \
		|| die
	doexe "${T}/${PN}"

	newicon \
		"/opt/${PN}/public/icons/icon-512x512.png" \
		"${PN}.png"

	make_desktop_entry \
		"${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Education;ArtificialIntelligence"

	keepdir "/var/cache/${PN}"
	fowners "${PN}:${PN}" "/var/cache/${PN}"

	keepdir "/opt/${PN}/.next"
	dosym \
		"/var/cache/${PN}" \
		"/opt/${PN}/.next/cache"

	dhms_end
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/opt/${PN}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.38.0 20240222
# Browser load test: passed
