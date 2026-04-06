# Copyright 2026 Orson Teodoro <your.email@example.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/searxng/searxng.git"
EGIT_BRANCH="master"
FALLBACK_COMMIT="e12b722ddc0ce75980e639246bdce83ceebdd102" # Apr 6, 2026
FALLBACK_TAG="2026.4.6-e12b722dd"
IUSE+=" fallback-commit"

inherit git-r3

DESCRIPTION="Official SearXNG container setup (docker-compose) for local CLI use with searxngr"
HOMEPAGE="https://docs.searxng.org/admin/installation-docker.html"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
RDEPEND="
	acct-group/searxng
	acct-group/searxng-valkey
	acct-user/searxng
	acct-user/searxng-valkey
	app-containers/docker
	app-containers/docker-compose
"
BDEPEND="
	dev-libs/openssl
"
PATCHES=(
	"${FILESDIR}/${PN}-20260328-docker-compose-changes.patch"
)

src_unpack() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_src_unpack
}

src_prepare() {
	default
}

src_configure() {
	cat "${FILESDIR}/searxng.env" > "${T}/searxng.env" || die
	if use fallback-commit ; then
		sed -i -e "s|@SEARXNG_VERSION@|${FALLBACK_TAG}|g" "${T}/searxng.env" || die
	else
		sed -i -e "s|@SEARXNG_VERSION@|latest|g" "${T}/searxng.env" || die
	fi
}

src_compile() {
	:
}

src_install() {
        local searxng_uid=$(id -u "searxng")
        local searxng_gid=$(id -g "searxng")
        local valkey_uid=$(id -u "searxng-valkey")
        local valkey_gid=$(id -g "searxng-valkey")
	# Install the container directory
	insinto "/etc/searxng"
	newins "container/docker-compose.yml" "docker-compose.yml"
	sed -i \
		-e "s|@SEARXNG_CORE_UID@|${searxng_uid}|g" \
		-e "s|@SEARXNG_CORE_GID@|${searxng_gid}|g" \
		-e "s|@VALKEY_UID@|${valkey_uid}|g" \
		-e "s|@VALKEY_GID@|${valkey_gid}|g" \
		"${ED}/etc/searxng/docker-compose.yml" \
		|| die

	insinto "/etc/searxng"
	newins "${T}/searxng.env" ".env"

	local secret_key="SearXNG"$(openssl rand -hex 32)$(openssl rand -hex 32)
	cat "${FILESDIR}/settings.yml" | sed -e "s|@SECRET_KEY@|${secret_key}|g" > "${T}/settings.yml" || die
	insinto "/etc/searxng/core-config"
	doins "${T}/settings.yml"

	# Install a convenient wrapper script
	newbin "${FILESDIR}/searxng-container" "searxng-container"

	dodoc "README.rst"

	fowners -R "searxng:searxng" "/etc/searxng"
	fperms 0750 "/etc/searxng"
	fperms 0600 "/etc/searxng/core-config/settings.yml"
	fperms 0600 "/etc/searxng/.env"

	keepdir "/var/cache/searxng"
	fowners "searxng:searxng" "/var/cache/searxng"
	fperms 0750 "/var/cache/searxng"

	keepdir "/etc/searxng/valkey-data"
	fowners -R "searxng-valkey:searxng-valkey" "/etc/searxng/valkey-data"
}

pkg_postinst() {
einfo "SearXNG container files are installed to /etc/searxng-container"
einfo
einfo "First-time setup:"
einfo
einfo "The environment config was stored in /etc/searxng/searxng.env"
einfo "The settings.yml config was stored in /etc/searxng/settings.yml"
einfo "Edit the environment config to customize the BASE_URL=http://127.0.0.1:8080/ for local CLI use."
einfo
einfo "Useful commands:"
einfo
einfo "  searxng-container up      # Start"
einfo "  searxng-container down    # Stop"
einfo "  searxng-container pull    # Update image"
einfo "  searxng-container logs    # View logs"
einfo
einfo "To use the searxngr client:"
einfo
einfo "  searxngr --searxng-url http://127.0.0.1:8080 \"your query\""
einfo
einfo "To use the web browser interface, enter the following to the address bar:"
einfo
einfo  "  http://127.0.0.1:8080"
einfo
einfo "A recommended alias for the command line:"
einfo
einfo "  alias sx='searxngr --searxng-url http://127.0.0.1:8080'"
einfo
einfo
einfo "To fix \"WARNING Memory overcommit must be enabled\":"
einfo
einfo "Temporary fix:"
einfo
einfo "  sudo sysctl vm.overcommit_memory=1"
einfo
einfo "Permanent fix:"
einfo
einfo "  echo 'vm.overcommit_memory = 1' | sudo tee -a /etc/sysctl.conf"
einfo "  sudo sysctl -p"
einfo
einfo "After applying the fix:"
einfo
einfo "  searxng-container stop"
einfo "  searxng-container start"
einfo
einfo "sysctl is provided by the sys-process/procps package."
einfo
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED searxng-docker-9999 (e12b722, 20260406)
# JSON test with searxngr:  passed
# Web interface test:  passed
# Testing:  searxngr --searxng-url http://127.0.0.1:8080 "gentoo"
