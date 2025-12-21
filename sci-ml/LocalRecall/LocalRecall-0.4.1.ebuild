# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="local-recall"

inherit go-download-cache sandbox-changes

KEYWORDS="~amd64"
SRC_URI="
https://github.com/mudler/LocalRecall/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="A REST-ful API and knowledge base management system that provides persistent memory and storage capabilities for AI agents"
HOMEPAGE="
	https://github.com/mudler/LocalRecall
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
openrc systemd
"
REQUIRED_USE="
	|| (
		openrc
		systemd
	)
"
RDEPEND+="
	acct-group/${MY_PN}
	acct-user/${MY_PN}
"
DEPEND+="
"
BDEPEND+="
	>=dev-lang/go-1.16
"
DOCS=( "README.md" )
PATCHES=(
)

pkg_setup() {
	sandbox-changes_no_network_sandbox "For downloading micropackages"
}

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add * || die
		git commit -m "Dummy" || die
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		#gen_git_tag "${S}" "v${PV}"
	fi
}

src_compile() {
	go-download-cache_setup
	emake "build"
}

src_install() {
	if use openrc ; then
		exeinto "/etc/init.d"
		newexe "${FILESDIR}/${MY_PN}.openrc" "${MY_PN}"
	fi
	if use systemd ; then
		insinto "/usr/lib/systemd/system"
		newins "${FILESDIR}/${MY_PN}.systemd" "${MY_PN}.service"
	fi

	exeinto "/opt/local-recall"
	doexe "localrecall"

	exeinto "/usr/bin"
	doexe "${FILESDIR}/local-recall-start-server"
}
