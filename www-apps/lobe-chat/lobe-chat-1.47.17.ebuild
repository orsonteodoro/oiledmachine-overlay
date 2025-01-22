# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22, D12

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_2
)
NODE_VERSION=22
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
VIPS_PV="8.14.5"

inherit dhms edo npm

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
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_X86[@]}
+indexdb +openrc postgres systemd +system-vips
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
	net-libs/nodejs:${NODE_VERSION}[corepack,npm]
	sys-apps/npm
"
DOCS=( "CHANGELOG.md" "README.md" )

# @FUNCTION: electron-app_set_sharp_env
# @DESCRIPTION:
# sharp env
electron-app_set_sharp_env() {
	export SHARP_IGNORE_GLOBAL_LIBVIPS=1
	if use system-vips ; then
		export SHARP_IGNORE_GLOBAL_LIBVIPS=0
einfo "Using system vips for sharp"
	else
einfo "Using vendored vips for sharp"
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
	export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${PN}-${PV%.*}"

	npm_pkg_setup
}

npm_unpack_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i \
			-e "s|bun run|npm run|g" \
			"${S}/package.json" \
			|| die
		enpm add "sharp@0.33.5" --prefer-offline ${NPM_INSTALL_ARGS[@]}
		enpm add "pg@8.13.1" --prefer-offline ${NPM_INSTALL_ARGS[@]}
		enpm add "drizzle-orm@0.38.2" --prefer-offline ${NPM_INSTALL_ARGS[@]}
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		npm_src_unpack
	fi
}

src_prepare() {
	default
}

src_compile() {
	# Fix:
	# FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS+=" --max_old_space_size=4096"
	npm_hydrate
# China users need to fork ebuild.  See Dockerfile for China contexts.

	# This one looks broken because the .next/standalone folder is missing.
	enpm run "build:docker"
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

	if [[ -e "${S}/.next/standalone" ]] ; then
		insinto "${_PREFIX}"
		doins -r "${S}/.next/standalone/"*
	else
ewarn "${S}/.next/standalone does not exist"
	fi

	insinto "${_PREFIX}"
	doins -r "${S}/node_modules"
	doins "${S}/scripts/serverLauncher/startServer.js"

	insinto "${_PREFIX}"
	doins -r "${S}/src/database/migrations"
	doins "${S}/scripts/migrateServerDB/docker.cjs"
	doins "${S}/scripts/migrateServerDB/errorHint.js"

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

	if [[ -e "${S}/.next/standalone" ]] ; then
		mv "${S}/.next/standalone/"* "${ED}${_PREFIX}" || die
	else
ewarn "${S}/.next/standalone does not exist"
	fi

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

cat <<EOF > "${T}/${PN}.conf" || die

NODEJS_VERSION="${NODE_VERSION}"

# Server-Side Database support
# See https://lobehub.com/docs/self-hosting/server-database
NEXT_PUBLIC_SERVICE_MODE=${next_public_service_mode} # client or server
DATABASE_URL="postgres://username:password@host:port/database"
DATABASE_DRIVER="node" # node for docker image or neon for vercel
KEY_VAULTS_SECRET="" # Obtained from `openssl rand -base64 32`
APP_URL="" # Example:  http://app.com

# Auth support for client id via Clerk or NextAuth

# Clerk (SaaS based)
# See https://lobehub.com/docs/self-hosting/server-database#clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=""
CLERK_SECRET_KEY=""
CLERK_WEBHOOK_SECRET=""

# NextAuth (recommended)
# See https://lobehub.com/docs/self-hosting/server-database#next-auth
NEXT_AUTH_SECRET="" # Required
NEXTAUTH_URL="" # Required
NEXT_AUTH_SSO_PROVIDERS="" # Optional

# S3 storage
# See https://lobehub.com/docs/self-hosting/advanced/s3
NEXT_PUBLIC_S3_DOMAIN=""
S3_ACCESS_KEY_ID=""
S3_SECRET_ACCESS_KEY=""
S3_ENDPOINT=""
S3_BUCKET=""
S3_REGION=""
S3_SET_ACL=""
S3_PUBLIC_DOMAIN=""
S3_ENABLE_PATH_STYLE=""

USE_CN_MIRROR=\${USE_CN_MIRROR:-}
NEXT_PUBLIC_BASE_PATH=\${NEXT_PUBLIC_BASE_PATH:-}
NEXT_PUBLIC_SENTRY_DSN=\${NEXT_PUBLIC_SENTRY_DSN:-}
NEXT_PUBLIC_ANALYTICS_POSTHOG=\${NEXT_PUBLIC_ANALYTICS_POSTHOG:-}
NEXT_PUBLIC_POSTHOG_HOST=\${NEXT_PUBLIC_POSTHOG_HOST:-}
NEXT_PUBLIC_POSTHOG_KEY=\${NEXT_PUBLIC_POSTHOG_KEY:-}
NEXT_PUBLIC_ANALYTICS_UMAMI=\${NEXT_PUBLIC_ANALYTICS_UMAMI:-}
NEXT_PUBLIC_UMAMI_SCRIPT_URL=\${NEXT_PUBLIC_UMAMI_SCRIPT_URL:-}
NEXT_PUBLIC_UMAMI_WEBSITE_ID=\${NEXT_PUBLIC_UMAMI_WEBSITE_ID:-}

ENV NEXT_PUBLIC_BASE_PATH="\${NEXT_PUBLIC_BASE_PATH}"

# Sentry
NEXT_PUBLIC_SENTRY_DSN="\${NEXT_PUBLIC_SENTRY_DSN}"
SENTRY_ORG=""
SENTRY_PROJECT=""

# Posthog
NEXT_PUBLIC_ANALYTICS_POSTHOG="\${NEXT_PUBLIC_ANALYTICS_POSTHOG}"
NEXT_PUBLIC_POSTHOG_HOST="\${NEXT_PUBLIC_POSTHOG_HOST}"
NEXT_PUBLIC_POSTHOG_KEY="\${NEXT_PUBLIC_POSTHOG_KEY}"

# Umami
NEXT_PUBLIC_ANALYTICS_UMAMI="\${NEXT_PUBLIC_ANALYTICS_UMAMI}"
NEXT_PUBLIC_UMAMI_SCRIPT_URL="\${NEXT_PUBLIC_UMAMI_SCRIPT_URL}"
NEXT_PUBLIC_UMAMI_WEBSITE_ID="\${NEXT_PUBLIC_UMAMI_WEBSITE_ID}"

# Node
NODE_OPTIONS="--max-old-space-size=8192"

NODE_ENV="production"
NODE_OPTIONS="--dns-result-order=ipv4first --use-openssl-ca"
NODE_EXTRA_CA_CERTS=""
NODE_TLS_REJECT_UNAUTHORIZED=""
SSL_CERT_DIR="/etc/ssl/certs/ca-certificates.crt"

# Set hostname to localhost
HOSTNAME="0.0.0.0"
PORT="3210"

# General Variables
ACCESS_CODE=""
API_KEY_SELECT_MODE=""
DEFAULT_AGENT_CONFIG=""
SYSTEM_AGENT=""
FEATURE_FLAGS=""
PROXY_URL=""

# AI21
AI21_API_KEY=""
AI21_MODEL_LIST=""

# Ai360
AI360_API_KEY=""
AI360_MODEL_LIST=""

# Anthropic
ANTHROPIC_API_KEY=""
ANTHROPIC_MODEL_LIST=""
ANTHROPIC_PROXY_URL=""

# Amazon Bedrock
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_REGION=""
AWS_BEDROCK_MODEL_LIST=""

# Azure OpenAI
AZURE_API_KEY=""
AZURE_API_VERSION=""
AZURE_ENDPOINT=""
AZURE_MODEL_LIST=""

# Baichuan
BAICHUAN_API_KEY=""
BAICHUAN_MODEL_LIST=""

# Cloudflare
CLOUDFLARE_API_KEY=""
CLOUDFLARE_BASE_URL_OR_ACCOUNT_ID=""
CLOUDFLARE_MODEL_LIST=""

# DeepSeek
DEEPSEEK_API_KEY=""
DEEPSEEK_MODEL_LIST=""

# Fireworks AI
FIREWORKSAI_API_KEY=""
FIREWORKSAI_MODEL_LIST=""

# Gitee AI
GITEE_AI_API_KEY=""
GITEE_AI_MODEL_LIST=""

# GitHub
GITHUB_TOKEN=""
GITHUB_MODEL_LIST=""

# Google
GOOGLE_API_KEY=""
GOOGLE_MODEL_LIST=""
GOOGLE_PROXY_URL=""

# Groq
GROQ_API_KEY=""
GROQ_MODEL_LIST=""
GROQ_PROXY_URL=""

# Higress
HIGRESS_API_KEY=""
HIGRESS_MODEL_LIST=""
HIGRESS_PROXY_URL=""

# HuggingFace
HUGGINGFACE_API_KEY=""
HUGGINGFACE_MODEL_LIST=""
HUGGINGFACE_PROXY_URL=""

# Hunyuan
HUNYUAN_API_KEY=""
HUNYUAN_MODEL_LIST=""

# InternLM
INTERNLM_API_KEY=""
INTERNLM_MODEL_LIST=""

# Minimax
MINIMAX_API_KEY=""
MINIMAX_MODEL_LIST=""

# Mistral
MISTRAL_API_KEY=""
MISTRAL_MODEL_LIST=""

# Moonshot
MOONSHOT_API_KEY=""
MOONSHOT_MODEL_LIST=""
MOONSHOT_PROXY_URL=""

# Novita
NOVITA_API_KEY=""
NOVITA_MODEL_LIST=""

# Ollama
ENABLED_OLLAMA=""
OLLAMA_MODEL_LIST=""
OLLAMA_PROXY_URL=""

# OpenAI
OPENAI_API_KEY=""
OPENAI_MODEL_LIST=""
OPENAI_PROXY_URL=""

# OpenRouter
OPENROUTER_API_KEY=""
OPENROUTER_MODEL_LIST=""

# Perplexity
PERPLEXITY_API_KEY=""
PERPLEXITY_MODEL_LIST=""
PERPLEXITY_PROXY_URL=""

# Qwen
QWEN_API_KEY=""
QWEN_MODEL_LIST=""
QWEN_PROXY_URL=""

# SenseNova
SENSENOVA_API_KEY=""
SENSENOVA_MODEL_LIST=""

# SiliconCloud
SILICONCLOUD_API_KEY=""
SILICONCLOUD_MODEL_LIST=""
SILICONCLOUD_PROXY_URL=""

# Spark
SPARK_API_KEY=""
SPARK_MODEL_LIST=""

# Stepfun
STEPFUN_API_KEY=""
STEPFUN_MODEL_LIST=""

# Taichu
TAICHU_API_KEY=""
TAICHU_MODEL_LIST=""

# TogetherAI
TOGETHERAI_API_KEY=""
TOGETHERAI_MODEL_LIST=""

# Upstage
UPSTAGE_API_KEY=""
UPSTAGE_MODEL_LIST=""

# Wenxin
WENXIN_ACCESS_KEY=""
WENXIN_SECRET_KEY=""
WENXIN_MODEL_LIST=""

# xAI
XAI_API_KEY=""
XAI_MODEL_LIST=""
XAI_PROXY_URL=""

# 01.AI
ZEROONE_API_KEY=""
ZEROONE_MODEL_LIST=""

# Zhipu
ZHIPU_API_KEY=""
ZHIPU_MODEL_LIST=""
EOF
	insinto "/etc/${PN}"
	doins "${T}/${PN}.conf"
	fperms 0660 "/etc/${PN}/lobe-chat.conf"
}

gen_standalone_wrapper() {
cat <<EOF > "${T}/${PN}-start-server" || die
#!/bin/bash
NODE_VERSION=${NODE_VERSION}
main() {
	source "/etc/${PN}/${PN}.conf"
	node "/opt/${PN}/startServer.js"
}
main
EOF

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
