# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22, U24, D12
# U24 - node 20 (release - live, debug - live)
# U22 - node 18 (check - live)

# FIXME:
# ⨯ Static worker exited with code: null and signal: SIGSEGV

# system-vips is required to avoid the following message
#  ⨯ Static worker exited with code: null and signal: SIGILL
# SIGILL is associated with illegal instruction which is usually caused by
# unsupported CPU instruction in older arches.

# @serwist/next needs pnpm workspaces

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_2
)
NODE_VERSION=20
NPM_SLOT="3"
PNPM_SLOT="9"
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
SERWIST_CHOICE="remove" # update or remove
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
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/lobehub/lobe-chat/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/lobehub/lobe-chat/commit/7e3aa09510e733ce7c53c2e961dca97dbc06a91e.patch
	-> lobe-chat-commit-7e3aa09.patch
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
RESTRICT="binchecks mirror strip test"
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
	>=sys-apps/pnpm-9.14.4:${PNPM_SLOT}
	>=sys-apps/npm-10.8.2:${NPM_SLOT}
	net-libs/nodejs:${NODE_VERSION}[corepack,npm]
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

check_tsc() {
	[[ -e "${ESYSROOT}/usr/bin/tsc" ]] || return
	# Fix:
	# error TS2304: Cannot find name 'HeadersIterator'
	# There is a bug where it bypasses the node_modules version.
	local tsc_pv=$("${ESYSROOT}/usr/bin/tsc" --version | cut -f 2 -d " ")
	if ver_test "${tsc_pv%.*}" -ne "5.7" ; then
eerror "You must \`emerge =dev-lang/typescript-5.7*\` to continue."
eerror "Switch \`eselect typescript\` to == 5.7.x"
		die
	fi
einfo "tsc version:  ${tsc_pv}"
}

pkg_setup() {
	dhms_start
	# If a "next" package is found in package.json, this should be added.
	# Otherwise, the license variable should be updated with additional
	# legal text.
	export NEXT_TELEMETRY_DISABLED=1

	# Prevent redownloads because they unusually bump more than once a day.
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${PN}-${PV%.*}"

	npm_pkg_setup
	pnpm_pkg_setup
einfo "PATH:  ${PATH}"
}

pnpm_unpack_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i \
			-e "s|bun run|npm run|g" \
			"${S}/package.json" \
			|| die
		epnpm uninstall "unplugin" ${PNPM_INSTALL_ARGS[@]}
		grep -e "ERR_PNPM_FETCH_404" "${T}/build.log" && die "Detected error.  Check pnpm add"
	else
		if use postgres ; then
			epnpm add "sharp@0.33.5" ${PNPM_INSTALL_ARGS[@]}
			epnpm add "pg@8.13.1" ${PNPM_INSTALL_ARGS[@]}
			epnpm add "drizzle-orm@0.38.2" ${PNPM_INSTALL_ARGS[@]}
		fi
	fi
	eapply "${FILESDIR}/${PN}-1.47.17-hardcoded-paths.patch"

	if [[ "${SERWIST_CHOICE}" == "remove" ]] ; then
		# Remove serwist, missing stable @serwist/utils
		eapply "${FILESDIR}/${PN}-1.48.3-drop-serwist.patch"
		if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
			epnpm uninstall "@serwist/next"
			epnpm uninstall "serwist"
			epnpm add "@ducanh2912/next-pwa@^10.2.8"
		fi
	else
		epnpm add "@serwist/utils@9.0.0-preview.26"
		epnpm add "@serwist/next@9.0.0-preview.26"
		epnpm add "serwist@9.0.0-preview.26"
	fi
}

pnpm_install_post() {
	epnpm uninstall "unplugin" ${PNPM_INSTALL_ARGS[@]}
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
		epnpm uninstall "unplugin" ${PNPM_INSTALL_ARGS[@]}
	fi
}

src_prepare() {
	default
}

setup_env() {
	if use postgres ; then
		export DATABASE_TEST_URL="postgresql://postgres:postgres@localhost:5432/postgres"
		export DATABASE_DRIVER="node"
		export NEXT_PUBLIC_SERVICE_MODE="server"
		export KEY_VAULTS_SECRET="LA7n9k3JdEcbSgml2sxfw+4TV1AzaaFU5+R176aQz4s="
		export S3_PUBLIC_DOMAIN="https://example.com"
		export APP_URL="https://home.com"
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
	source "${T}/lobe-chat.conf"
}

src_configure() {
	# Checks to see if toolchain is working or meets requirements
	epnpm --version
	check_tsc
}

src_compile() {
	if [[ -e "${S}/.next" ]] ; then
ewarn "Removing ${S}/.next"
		rm -rf "${S}/.next"
	fi
	# Fix:
	# FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS+=" --max-old-space-size=8192"

	if [[ "${NODE_VERSION}" == "18" ]] ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
	fi

	export NODE_OPTIONS+=" --use-openssl-ca"

	pnpm_hydrate
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"
# China users need to fork ebuild.  See Dockerfile for China contexts.

	setup_env
	check_tsc

	# This one looks broken because the .next/standalone folder is missing.
	#pnpm run "build:docker"

	export NODE_ENV=production
	export DOCKER=true

	tsc --version || die
	tsc next.config.ts --module commonjs --outDir . || die

	edo next build --debug
	edo pnpm run build-sitemap
	edo pnpm run build-sitemap
	edo pnpm run build-migrate-db
	grep -q -e "Build failed because of webpack errors" "${T}/build.log" && die "Detected error"
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
# Needs server.js
eerror "${S}/.next/standalone does not exist"
		die
	fi

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

	if [[ -e "${S}/.next/standalone" ]] ; then
		mv "${S}/.next/standalone/"* "${ED}${_PREFIX}" || die
	else
# Needs server.js
eerror "${S}/.next/standalone does not exist"
		die
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
