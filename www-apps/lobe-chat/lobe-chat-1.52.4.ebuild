# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
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

# Use `PNPM_UPDATER_VERSIONS="1.52.4" pnpm_updater_update_locks.sh` to update lockfile

CPU_FLAGS_X86=(
	cpu_flags_x86_sse4_2
)
# See also https://github.com/vercel/next.js/blob/v15.1.6/.github/workflows/build_and_test.yml#L328
NODE_VERSION=20 # See .nvmrc
_NODE_VERSION="20.9.0"
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
SERWIST_CHOICE="no-change" # update, remove, no-change
VIPS_PV="8.14.5"

inherit dhms edo npm pnpm yarn

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
	=net-libs/nodejs-${_NODE_VERSION%.*}:${NODE_VERSION}[corepack,npm]
	net-libs/nodejs:=
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

check_exact_node_version() {
	local node_pv=$(node --version \
		| sed -e "s|v||g")
	if ver_test "${node_pv%.*}" -ne "${_NODE_VERSION%.*}" ; then
eerror
eerror "You must switch to node ${_NODE_VERSION%.*}.x to build/use ${PN}."
eerror "See \`eselect nodejs\` for details."
eerror
eerror "Actual node version:  ${node_pv}"
eerror "Expected node version:  ${_NODE_VERSION%.*}.x"
eerror
die
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
	export YARN_CACHE_FOLDER="${EDISTDIR}/yarn-download-cache-${YARN_SLOT}/${CATEGORY}/${PN}"
	export PNPM_CACHE_FOLDER="${EDISTDIR}/pnpm-download-cache-${PNPM_SLOT}/${CATEGORY}/${PN}"

	addwrite "${EDISTDIR}"
	npm_pkg_setup
	yarn_pkg_setup
	pnpm_pkg_setup
einfo "PATH:  ${PATH}"
	#check_exact_node_version
}

pnpm_unpack_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i \
			-e "s|bun run|npm run|g" \
			"${S}/package.json" \
			|| die
		grep -e "ERR_PNPM_FETCH_404" "${T}/build.log" && die "Detected error.  Check pnpm add"
	else
		if use postgres ; then
			epnpm add "sharp@0.33.5" ${PNPM_INSTALL_ARGS[@]}
			epnpm add "pg@8.13.1" ${PNPM_INSTALL_ARGS[@]}
			epnpm add "drizzle-orm@0.38.2" ${PNPM_INSTALL_ARGS[@]}
		fi
	fi
	eapply "${FILESDIR}/${PN}-1.47.17-hardcoded-paths.patch"
#	eapply "${FILESDIR}/${PN}-1.49.3-docker-standalone.patch"
	eapply "${FILESDIR}/${PN}-1.49.5-disable-memory-optimizations.patch"

	if [[ "${SERWIST_CHOICE}" == "no-change" ]] ; then
		:
	elif [[ "${SERWIST_CHOICE}" == "remove" ]] ; then
		# Remove serwist, missing stable @serwist/utils
		eapply "${FILESDIR}/${PN}-1.48.3-drop-serwist.patch"
		if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
			epnpm uninstall "@serwist/next"
			epnpm uninstall "serwist"
			epnpm add -D "@ducanh2912/next-pwa@^10.2.8"
		fi
	else
		epnpm add "@serwist/utils@9.0.0-preview.26"
		epnpm add "@serwist/next@9.0.0-preview.26"
		epnpm add -D "serwist@9.0.0-preview.26"
	fi
#	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
#		epnpm add "@types/react@^19.0.3"
#		epnpm add -D "webpack@^5.97.1"
#	fi
}

patch_lockfile() {
	sed -i -e "s|'@apidevtools/json-schema-ref-parser': 11.1.0|'@apidevtools/json-schema-ref-parser': 11.2.0|g" "pnpm-lock.yaml" || die
}

pnpm_audit_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
		sed -i -e "s|\"vitest\": \"~1.2.2\"|\"vitest\": \"1.6.1\"|g" "package.json" || die
		epnpm add -D "vitest@1.6.1" ${PNPM_INSTALL_ARGS[@]}						# CVE-2025-24964; DoS, DT, ID; Critical

		patch_lockfile
		epnpm add "@apidevtools/json-schema-ref-parser@11.2.0" ${PNPM_INSTALL_ARGS[@]}			# CVE-2024-29651; DoS, DT, ID; High
		patch_lockfile
	fi
}

pnpm_dedupe_post() {
	if [[ "${PNPM_UPDATE_LOCK}" == "1" ]] ; then
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
		_yarn_setup_offline_cache
		_pnpm_setup_offline_cache
		pnpm_src_unpack
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
}

src_compile() {
	if [[ -e "${S}/.next" ]] ; then
ewarn "Removing ${S}/.next"
		rm -rf "${S}/.next"
	fi
	# Fix:
	# FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
	export NODE_OPTIONS+=" --max-old-space-size=8192"

#	if [[ "${NODE_VERSION}" == "18" ]] ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
#	fi

	export NODE_OPTIONS+=" --use-openssl-ca"

	npm_hydrate
	yarn_hydrate
	pnpm_hydrate
einfo "NODE_OPTIONS:  ${NODE_OPTIONS}"
# China users need to fork ebuild.  See Dockerfile for China contexts.

	setup_env

	export NODE_ENV=production
	export DOCKER=true

	tsc --version || die

	# tsc will ignore tsconfig.json, so it must be explicit.
#einfo "Building next.config.js"
#	tsc \
#		next.config.ts \
#		--allowJs \
#		--esModuleInterop "true" \
#		--jsx "preserve" \
#		--lib "dom,dom.iterable,esnext,webworker" \
#		--module "esnext" \
#		--moduleResolution "bundler" \
#		--outDir "." \
#		--skipDefaultLibCheck \
#		--target "esnext" \
#		--typeRoots "./node_modules/@types" \
#		--types "react,react-dom" \
#		|| die
#	mv "next.config."{"js","mjs"} || die

#einfo "End build of next.config.js"
	#grep -q -E -e "Found [0-9]+ error." "${T}/build.log" && die "Detected error"
	#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"

	# This one looks broken because the .next/standalone folder is missing.
	pnpm run "build:docker"

#	edo next build --debug
	grep -q -E -e "Failed to load next.config.js" "${T}/build.log" && die "Detected error"
#	edo npm run build-sitemap
#	edo npm run build-sitemap
#	edo npm run build-migrate-db
	grep -q -e "Build failed because of webpack errors" "${T}/build.log" && die "Detected error"
	grep -q -e "Failed to compile" "${T}/build.log" && die "Detected error"
	#grep -q -E -e "error TS[0-9]+" "${T}/build.log" && die "Detected error"
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
