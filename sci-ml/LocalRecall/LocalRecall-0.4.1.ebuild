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
ebuild_revision_2
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
	export VERBOSE=1
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

	insinto "/etc/conf.d"
	cat "${FILESDIR}/local-recall.conf" > "${T}/local-recall.conf"

	local collection_db_path=${COLLECTION_DB_PATH:-"collections"}
	local embedding_model=${EMBEDDING_MODEL:-"granite-embedding-107m-multilingual"}
	local file_assets=${FILE_ASSETS:-"assets"}
	local listening_address=${LISTENING_ADDRESS:-":8080"}
	local openai_base_url=${OPENAI_BASE_URL:-"http://localai:8080"}
	local vector_engine=${VECTOR_ENGINE:-"chromem"}

einfo "COLLECTION_DB_PATH:  ${collection_db_path}"
einfo "EMBEDDING_MODEL:  ${embedding_model}"
einfo "FILE_ASSETS:  ${file_assets}"
einfo "LISTENING_ADDRESS:  ${listening_address}"
einfo "OPENAI_BASE_URL:  ${openai_base_url}"
einfo "VECTOR_ENGINE:  ${vector_engine}"

	sed -i \
		-e "s|@COLLECTION_DB_PATH@|${collection_db_path}|" \
		-e "s|@EMBEDDING_MODEL@|${embedding_model}|" \
		-e "s|@FILE_ASSETS@|${file_assets}|" \
		-e "s|@LISTENING_ADDRESS@|${listening_address}|" \
		-e "s|@OPENAI_BASE_URL@|${openai_base_url}|" \
		-e "s|@VECTOR_ENGINE@|${vector_engine}|" \
		"${T}/local-recall.conf" \
		|| die
	newins "${T}/local-recall.conf" "local-recall"

	fperms 0640 "/etc/conf.d/local-recall"

	exeinto "/opt/local-recall"
	doexe "localrecall"

	exeinto "/usr/bin"
	doexe "${FILESDIR}/local-recall-start-server"
}

# OILEDMACHINE-OVERLAY-META:  orphaned
# OILEDMACHINE-OVERLAY-TEST:  TESTING
# load-test:  pass
# production-test:  untested
