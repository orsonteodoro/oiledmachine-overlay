# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_VERSION="20"

inherit npm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/rdkcentral/ThunderUI.git"
	FALLBACK_COMMIT="598fec0f931b1ed334810dfc505252a1d7d54ddf" # Feb 10, 2025
	IUSE+=" fallback-commit"
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_5
"
RDEPEND+="
	net-libs/nodejs:18[webassembly(+)]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "readme.md" )

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		# DoS = Denial of Service
		# DT = Data Tampering
		# ID = Information Disclosure
		# SS = Subsequent System (Indirect System)
		# VS = Vulnerable System (Direct System)
		# ZC = Zero Click Attack
		patch_lockfile() {
			sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.5\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.6\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.14\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
			sed -i -e "s|\"postcss\": \"^7.0.32\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
			sed -i -e "s|\"serialize-javascript\": \"^4.0.0\"|\"serialize-javascript\": \"^6.0.2\"|g" "package-lock.json" || die
			sed -i -e "s|\"pbkdf2\": \"^3.1.2\"|\"pbkdf2\": \"^3.1.3\"|g" "package-lock.json" || die

			sed -i -e "s|\"sha.js\": \"^2.4.0\"|\"sha.js\": \"^2.4.12\"|g" "package-lock.json" || die
			sed -i -e "s|\"sha.js\": \"^2.4.8\"|\"sha.js\": \"^2.4.12\"|g" "package-lock.json" || die
			sed -i -e "s|\"sha.js\": \"^2.4.11\"|\"sha.js\": \"^2.4.12\"|g" "package-lock.json" || die
		}
		patch_lockfile

		local pkgs=(
			"braces@3.0.3"				# CVE-2024-4068; DoS; High
			"postcss@8.4.31"			# CVE-2023-44270; DT; Medium
			"serialize-javascript@^6.0.2"		# CVE-2024-11831; DT, ID; Medium

			"pbkdf2@3.1.3"				# CVE-2025-6547; ZC, VS(DT), SS(DoS, DT, ID)
								# CVE-2025-6545; ZC, VS(DT, ID), SS(DoS, DT, ID)

			"sha.js@2.4.12"				# CVE-2025-9288; ZC, VS(DoS, DT), SS(DT, ID)
		)
		enpm add "${pkgs[@]}" -D #--prefer-offline
		patch_lockfile
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
