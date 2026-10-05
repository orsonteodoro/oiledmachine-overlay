# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The wrapper script was made mostly by AI generated code.

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="0.0.28" npm_updater_update_locks.sh

NODE_SLOT="22"
NPM_AUDIT_FATAL=0
NPM_TARBALL="lobehub-market-cli-${PV}.tgz"

KEYWORDS="~amd64"
S="${WORKDIR}/package"
SRC_URI="
https://registry.npmjs.org/@lobehub/market-cli/-/market-cli-${PV}.tgz -> lobehub-market-cli-${PV}.tgz
"

inherit secure-version secure-version-node npm

DESCRIPTION="Device registration, auth management, and browse and install LobeHub marketplace skills"
HOMEPAGE="
	https://www.npmjs.com/package/@lobehub/market-cli
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
ebuild_revision_8
"
RDEPEND+="
	app-admin/sudo
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODEJS_22_PV}:${NODE_SLOT}=
"

pkg_setup() {
	npm_pkg_setup
}

npm_dedupe_post() {
einfo "Called npm_update_lock_install_post()"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
einfo "npm_update_lock_install_post():  Updating lockfile"
		patch_lockfile() {
			sed -i -e "s|\"adm-zip\": \"^0.5.16\"|\"adm-zip\": \"^${NODE_ADM_ZIP_PV}\"|g" "package-lock.json" || die
		}

		patch_lockfile

		local pkgs=(
			"adm-zip@^${NODE_ADM_ZIP_PV}"
		)
		enpm add "${pkgs[@]}" -P "${pkgs[@]}"

		patch_lockfile

		enpm dedupe
	fi
}

src_unpack() {
	unpack ${A}
	npm_src_unpack
}

src_compile() {
	npm_src_compile
}

src_install() {
	cat "${FILESDIR}/lhm" > "${T}/lhm"
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/lhm" || die
	insinto "/opt/${PN}"
	doins -r *
	fperms 755 "/opt/${PN}/dist/cli.js"
	exeinto "/usr/bin"
	doexe "${T}/lhm"
	dosym "/usr/bin/lhm" "/usr/bin/lobehub-market-cli"
}

pkg_postinst() {
einfo "For new installation:  lhm register --name \"<name>\""
einfo "For installing skills:  lhm skills install <skill-id>"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
