# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="5.3.0" npm_updater_update_locks.sh

NODE_SLOT="22"
NPM_AUDIT_FATAL=0

NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)

NPM_DEDUPE_ARGS=(
	"--prefer-offline"
)

NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

inherit secure-version secure-version-node npm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderUI.git"
	FALLBACK_COMMIT="6d7e10fbfbc6aae651c5c4f977428e9b7ee56453"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-R${PV}"
	SRC_URI="
https://github.com/rdkcentral/ThunderUI/archive/refs/tags/R${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="ThunderUI is the development and test UI that runs on top of Thunder"
HOMEPAGE="
	https://github.com/rdkcentral/ThunderUI
"
LICENSE="
	ISC
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
ebuild_revision_8
"
RDEPEND+="
	net-libs/nodejs:${NODE_SLOT}[webassembly(+)]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "readme.md" )

npm_dedupe_post() {
einfo "Called npm_update_lock_install_post()"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
einfo "npm_update_lock_install_post():  Updating lockfile"
		patch_lockfile() {
			sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^${NODE_BRACES_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"decode-uri-component\": \"^0.2.0\"|\"decode-uri-component\": \"^${NODE_DECODE_URI_COMPONENT_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"postcss\": \"^7.0.5\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.6\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.32\"|\"postcss\": \"^${NODE_POSTCSS_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"serialize-javascript\": \"^4.0.0\"|\"serialize-javascript\": \"^${NODE_SERIALIZE_JAVASCRIPT_PV}\"|g" "package-lock.json" || die

			sed -i -e "s|\"uuid\": \"^3.3.2\"|\"uuid\": \"^${NODE_UUID_11_PV}\"|g" "package-lock.json" || die
		}
		patch_lockfile

		local pkgs=(
			"braces@^${NODE_BRACES_PV}"
			"decode-uri-component@^${NODE_DECODE_URI_COMPONENT_PV}"
			"postcss@^${NODE_POSTCSS_PV}"
			"serialize-javascript@^${NODE_SERIALIZE_JAVASCRIPT_PV}"
			"uuid@^${NODE_UUID_11_PV}"
		)
		enpm add "${pkgs[@]}" -D "${NPM_INSTALL_ARGS[@]}"

		patch_lockfile

		enpm dedupe "${NPM_DEDUPE_ARGS[@]}"

		patch_lockfile
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		npm_src_unpack
	fi
}

src_configure() {
	:
}

src_compile() {
	npm_hydrate
	export NODE_OPTIONS="--openssl-legacy-provider"
	enpm run build
}

src_install() {
	insinto "/usr/share/Thunder/Controller/UI"
	doins -r "dist/"*
	docinto "licenses"
	dodoc "COPYING"
	dodoc "LICENSE"
	dodoc "NOTICE"
	docinto "ReleaseNotes"
	dodoc "ReleaseNotes/ReleaseNotes_R5.0.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
