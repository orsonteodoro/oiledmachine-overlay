# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_SLOT="22"
PNPM_TARBALL="lobehub-cli-${PV}.tgz"
PNPM_INSTALL_ARGS=( "--ignore-workspace" "--no-optional" )

KEYWORDS="~amd64"
S="${WORKDIR}/package"

SRC_URI="
	https://registry.npmjs.org/@lobehub/cli/-/cli-${PV}.tgz -> ${PNPM_TARBALL}
"

inherit pnpm

DESCRIPTION="Manage and connect to LobeHub services"
HOMEPAGE="
	https://www.npmjs.com/package/@lobehub/cli
	https://github.com/lobehub/lobehub/tree/canary/apps/cli
"
LICENSE="Apache-2.0"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"

IUSE=""

RDEPEND="
	app-admin/sudo
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	net-libs/nodejs:${NODE_SLOT}
"

pkg_setup() {
	pnpm_pkg_setup
}

pnpm_unpack_post() {
	sed -i -e 's|bunx|npx|g' -e 's|bun|pnpm|g' "${S}/package.json" || die
	sed -i -e "/workspace:/d" "${S}/package.json" || die
}

# Aggressive patching of workspace:* protocols
pnpm_unpack_post2() {
    einfo "Patching workspace:* references and removing internal @lobechat packages..."

    # 1. Replace ALL workspace:* / workspace:^ / workspace:~ with "*"
    find "${S}" -name "package.json" -exec sed -i -E 's|"workspace:[^"]*"|"*"|g' {} + || die

    # 2. Specifically remove or replace the problematic device-gateway-client
    #    (and any other @lobechat/* that are not on npm)
    find "${S}" -name "package.json" -exec sed -i -E \
        's|"@lobechat/device-gateway-client"[^,}]*|"@lobechat/device-gateway-client": "*"|' {} + || die

    # Optional: remove the entire line if "*" still causes issues (more aggressive)
    # find "${S}" -name "package.json" -exec sed -i '/@lobechat\/device-gateway-client/d' {} + || die

    # 3. bun → pnpm and bunx → npx
    sed -i -e 's|bunx|npx|g' -e 's|bun|pnpm|g' "${S}/package.json" || die

    # 4. Create .npmrc to make pnpm less strict
    cat > "${S}/.npmrc" <<EOF || die
public-hoist-pattern=*
shamefully-hoist=true
node-linker=hoisted
ignore-workspace=true
strict-peer-dependencies=false
EOF
}

src_unpack() {
	unpack ${A}
	pnpm_src_unpack
}

src_prepare() {
	default
	pnpm_unpack_post   # run our custom post-unpack patching
}

src_compile() {
	# Install dependencies (including optional native bindings)
	einfo "Installing dependencies..."
	pnpm install --ignore-workspace --frozen-lockfile || die

	# Force the correct Rolldown native binding (just in case)
	pnpm install --ignore-workspace @rolldown/binding-linux-x64-gnu --save-optional || true

	# SKIP the build step — the package is already pre-built
	einfo "Package appears to be pre-built. Skipping 'pnpm run build' (tsdown would fail on missing sources)."
}

src_install() {
	# Install the built package
	insinto "/opt/${PN}"
	doins -r .

	# Make the CLI executable
	fperms 0755 "/opt/${PN}/dist/index.js" || die

	cat "${FILESDIR}/lh" > "${T}/lh"
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/lh" || die

	exeinto "/usr/bin"
	doexe "${T}/lh"

	dosym "/usr/bin/lh" "/usr/bin/lobehub-cli"
	dosym "/usr/bin/lh" "/usr/bin/lobe"
}

pkg_postinst() {
einfo "LobeHub CLI installed"
einfo
einfo "Server configuration:"
einfo
einfo "  Default server: http://localhost:3210"
einfo "  Override with:  LOBEHUB_SERVER=http://your-server:3210 lh ..."
einfo "  Or use flag:    lh login --server http://192.168.1.100:3210"
einfo
einfo "Note about login:"
einfo
einfo "  'lh login' uses Device Authorization (OIDC)."
einfo "  If you see 'OIDC is not enabled', enable OIDC on your LobeHub server"
einfo "  by setting ENABLE_OIDC=1 and generating JWKS_KEY in your server config."
einfo
einfo "Run 'lh --help' for more commands."
}
