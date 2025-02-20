# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
#   PNPM_UPDATER_VERSIONS="1.61.5" pnpm_updater_update_locks.sh
#

# U22, U24, D12
# U24 - node 20 (release - live, debug - live)
# U22 - node 18 (check - live)

# FIXME:
#
# ✓ Linting and checking validity of types    
#   Collecting page data  ..{
#  allowDangerousEmailAccountLinking: true,
#  clientId: undefined,
#  clientSecret: undefined,
#  platformType: 'WebsiteApp',
#  profile: [Function: profile]
#}
# ⚠ Using edge runtime on a page currently disables static generation for that page
# ✓ Collecting page data    
#   Generating static pages (8/802)  [  ==]TypeError: Failed to parse URL from http://localhost:undefined?key=undefined&method=revalidateTag&args=%5B%5B%5D%5D
#    at new Request (node:internal/deps/undici/undici:9580:19)
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#    ... 6 lines matching cause stack trace ...
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:38842
#    at async e_.execute (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:27880) {
#  [cause]: TypeError: Invalid URL
#      at new URL (node:internal/url:818:25)
#      at new Request (node:internal/deps/undici/undici:9578:25)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:6126
#      at h.trace (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:17611)
#      at c (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:5806)
#      at invokeRequest (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/invoke-request.js:17:18)
#      at invokeIpcMethod (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/request-utils.js:45:60)
#      at IncrementalCache.revalidateTag (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/incremental-cache/index.js:174:20)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:38842 {
#    code: 'ERR_INVALID_URL',
#    input: 'http://localhost:undefined?key=undefined&method=revalidateTag&args=%5B%5B%5D%5D'
#  }
#}
#   Generating static pages (10/802)  [    ]TypeError: Failed to parse URL from http://localhost:undefined?key=undefined&method=revalidateTag&args=%5B%5B%5D%5D
#    at new Request (node:internal/deps/undici/undici:9580:19)
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#    ... 6 lines matching cause stack trace ...
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:38842
#    at async e_.execute (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:27880) {
#  [cause]: TypeError: Invalid URL
#      at new URL (node:internal/url:818:25)
#      at new Request (node:internal/deps/undici/undici:9578:25)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:6126
#      at h.trace (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:17611)
#      at c (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:5806)
#      at invokeRequest (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/invoke-request.js:17:18)
#      at invokeIpcMethod (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/request-utils.js:45:60)
#      at IncrementalCache.revalidateTag (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/incremental-cache/index.js:174:20)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/compiled/next-server/app-route.runtime.prod.js:6:38842 {
#    code: 'ERR_INVALID_URL',
#    input: 'http://localhost:undefined?key=undefined&method=revalidateTag&args=%5B%5B%5D%5D'
#  }
#}
# [...]
#Error getting changelog lists: TypeError: Failed to parse URL from http://localhost:undefined?key=undefined&method=lock&args=%5B%22458c78d7a9eb27dc9351c988985bd97c20e088d465d2c121d1c645693f7bf59f%22%5D
#    at new Request (node:internal/deps/undici/undici:9580:19)
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#    ... 6 lines matching cause stack trace ...
#    at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:9681
#    at runNextTicks (node:internal/process/task_queues:65:5) {
#  [cause]: TypeError: Invalid URL
#      at new URL (node:internal/url:818:25)
#      at new Request (node:internal/deps/undici/undici:9578:25)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:2056
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:6126
#      at h.trace (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:17611)
#      at c (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:5806)
#      at invokeRequest (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/invoke-request.js:17:18)
#      at invokeIpcMethod (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/server-ipc/request-utils.js:45:60)
#      at IncrementalCache.lock (/var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/node_modules/.pnpm/next@14.2.23_@babel+core@7.26.9_@opentelemetry+api@1.9.0_@playwright+test@1.50.1_react-dom@19_n3tz2fn6v354t4irxbujgxfa5u/node_modules/next/dist/server/lib/incremental-cache/index.js:136:19)
#      at /var/tmp/portage/www-apps/lobe-chat-1.61.5/work/lobe-chat-1.61.5/.next/server/chunks/65192.js:2:9681 {
#    code: 'ERR_INVALID_URL',
#    input: 'http://localhost:undefined?key=undefined&method=lock&args=%5B%22458c78d7a9eb27dc9351c988985bd97c20e088d465d2c121d1c645693f7bf59f%22%5D'
#  }
#}
#
# The port and key are undefined.  The documentation is not helping.  Check the:
# https://github.com/lobehub/lobe-chat/blob/v1.61.5/docker-compose/local/zitadel/.env.zh-CN.example



# FIXME:
# ⨯ Static worker exited with code: null and signal: SIGSEGV

# system-vips is required to avoid the following message
#  ⨯ Static worker exited with code: null and signal: SIGILL
# SIGILL is associated with illegal instruction which is usually caused by
# unsupported CPU instruction in older arches.

# @serwist/next needs pnpm workspaces

# Use `PNPM_UPDATER_VERSIONS="1.52.4" pnpm_updater_update_locks.sh` to update lockfile

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_2
)
# See also https://github.com/vercel/next.js/blob/v15.1.6/.github/workflows/build_and_test.yml#L328
NODE_VERSION=22
NPM_SLOT="3"
PNPM_DEDUPE=0 # Still debugging
PNPM_SLOT="9"
NEXTJS_PV="15.1.7" # 15.1.7 (upstream), or 14.2.23 (known working in other projects/ebuilds)
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
SERWIST_CHOICE="no-change" # update, remove, no-change
SHARP_PV="0.32.6" # 0.32.6 (working), 0.33.5 (upstream, possible segfault)
VIPS_PV="8.14.5"

inherit dhms edo npm pnpm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lobehub/lobe-chat.git"
	FALLBACK_COMMIT="f56dab7a48fc681e9ab9645b7a63c45e9cee680b" # Jan 21, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Ebuild unfinished
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
ebuild_revision_2
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
		>=media-libs/vips-${VIPS_PV}[gif,webp]
	)
"
RDEPEND+="
	${VIPS_RDEPEND}
	acct-group/lobe-chat
	acct-user/lobe-chat
	>=app-misc/ca-certificates-20240203
	>=net-misc/proxychains-3.1
	>=sys-devel/gcc-12.2.0
	net-libs/nodejs:${NODE_VERSION}[corepack,npm]
	net-libs/nodejs:=
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
	net-libs/nodejs:${NODE_VERSION}[corepack,npm,pointer-compression]
	net-libs/nodejs:=
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

	if [[ -z "${APP_URL}" ]] ; then
		export APP_URL="http://localhost:3210"
ewarn "APP_URL:  ${APP_URL} (Using fallback.  This environment variable is configurable.)"
	fi
	if [[ -z "${NEXTAUTH_URL}" ]] ; then
		export NEXTAUTH_URL="http://localhost:3210/api/auth"
ewarn "NEXTAUTH_URL:  ${NEXTAUTH_URL} (Using fallback.  This environment variable is configurable.)"
	fi
	if [[ -z "${NEXT_AUTH_SSO_PROVIDERS}" ]] ; then
# It should be explicit for reproducible build.
eerror
eerror "Missing NEXT_AUTH_SSO_PROVIDERS.  For possible values, see"
eerror
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#next-auth"
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#advanced-configuration"
eerror "  https://next-auth.js.org/providers"
eerror
eerror "This environment variable is configurable."
eerror
		die
	fi
	if [[ -z "${NEXT_AUTH_SECRET}" ]] ; then
eerror
eerror "Missing NEXT_AUTH_SECRET.  To generate a secret, see"
eerror
eerror "  https://lobehub.com/docs/self-hosting/advanced/auth#next-auth"
eerror
eerror "This environment variable is configurable."
eerror
		die
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

# @FUNCTION: electron-app_set_sharp_env
# @DESCRIPTION:
# sharp env
electron-app_set_sharp_env() {
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
	electron-app_set_sharp_env # Disabled vendored vips lib
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
	eapply "${FILESDIR}/${PN}-1.47.17-hardcoded-paths.patch"
	eapply "${FILESDIR}/${PN}-1.55.4-next-config.patch"

#	eapply "${FILESDIR}/lobe-chat-1.62.0-pnpm-patches.patch"
#	mkdir -p "${S}/patches" || die
#	cat "${FILESDIR}/types__mdx-2.0.13.patch" > "${S}/patches/@types__mdx@2.0.13.patch" || die

	if ver_test "${NEXTJS_PV%%.*}" -lt "15" ; then
		# Not compatiable with Next.js 14
		sed -i -e "/webpackMemoryOptimizations/d" "next.config.ts" || die
		sed -i -e "/hmrRefreshes/d" "next.config.ts" || die
		sed -i -e "/serverExternalPackages/d" "next.config.ts" || die
		sed -i -e "/@ts-expect-error/d" "src/features/MobileSwitchLoading/index.tsx" || die
	fi

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
		pkgs=(
	# Testing section
	# Downgrade to working copy to avoid possible webpack error
	# next.js issue 69096
			"next@${NEXTJS_PV}"
		)
		epnpm add ${pkgs[@]}
	fi
}

pnpm_audit_post() {
	local pkgs
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i -e "s|\"vitest\": \"~1.2.2\"|\"vitest\": \"1.6.1\"|g" "package.json" || die
		pkgs=(
			"vitest@1.6.1"
		)
		epnpm add -D ${pkgs[@]} ${PNPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical
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

		patch_lockfile
ewarn "QA:  Manually remove @apidevtools/json-schema-ref-parser@11.1.0 from ${S}/pnpm-lock.yaml"
		epnpm add "@apidevtools/json-schema-ref-parser@11.2.0" ${PNPM_INSTALL_ARGS[@]}		# CVE-2024-29651; DoS, DT, ID; High
ewarn "QA:  Manually remove <esbuild-0.25.0 from ${S}/pnpm-lock.yaml"
		epnpm add "esbuild@0.25.0"								# GHSA-67mh-4wv8-2f99
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
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"

	setup_build_env

	tsc --version || die

	# Force rebuild to prevent illegal instruction
	edo npm rebuild sharp

	if ver_test "${NEXTJS_PV%%.*}" -lt "15" ; then
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

#	edo npm run "build:docker"

	edo next build --debug
	grep -q -E -e "Failed to load next.config.js" "${T}/build.log" && die "Detected error"
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
	doins -r "${S}/.next/standalone/"*

	insinto "${_PREFIX}"
	doins -r "${S}/node_modules"
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

	mv "${S}/.next/standalone/"* "${ED}${_PREFIX}" || die

	mv "${S}/node_modules" "${ED}${_PREFIX}" || die
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
		"${T}/${PN}.conf" \
		|| die
	sed -i \
		-e "s|@NODE_VERSION@|${NODE_VERSION}|g" \
		-e "s|@NEXT_PUBLIC_SERVICE_MODE@|${next_public_service_mode}|g" \
		"${T}/${PN}.conf" \
		|| die
	insinto "/etc/${PN}"
	doins "${T}/${PN}.conf"
	fperms 0660 "/etc/${PN}/lobe-chat.conf"
}

gen_standalone_wrapper() {
	cat \
		"${FILESDIR}/${PN}-start-server" \
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
	addwrite "/opt/${PN}"
	rm -rf "/opt/${PN}/"*
	mv "${ED}/opt/${PN}/"* "/opt/${PN}"
	mv "${ED}/opt/${PN}/.next" "/opt/${PN}"
	mv "${ED}/opt/${PN}/.npmrc" "/opt/${PN}"
	dhms_end
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		rm -rf "/opt/${PN}"
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
