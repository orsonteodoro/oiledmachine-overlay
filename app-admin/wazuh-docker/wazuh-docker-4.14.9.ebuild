# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is AI generated and edited by ebuild maintainer.

inherit secure-version systemd

KEYWORDS="~amd64"
S="${WORKDIR}/wazuh-docker-${PV}"
SRC_URI="https://github.com/wazuh/wazuh-docker/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Wazuh central components (manager + indexer + dashboard) via official Docker Compose"
HOMEPAGE="https://documentation.wazuh.com/current/deployment-options/docker/"
LICENSE="GPL-2"
SLOT="0"
IUSE="multi-node"
RDEPEND="
	>=app-containers/docker-${DOCKER_PV}:=
	>=app-containers/docker-compose-2.20:=
	>=sys-apps/openrc-${OPENRC_PV}:=
"
# docker-compose may be provided by docker itself on some systems

src_prepare() {
ewarn "${PN} is under construction"
	default
	# Optional: strip any upstream files you don't want

	# app-admin/wazuh-docker – optional sanity check
	local map_count
	map_count=$(sysctl -n vm.max_map_count 2>/dev/null || echo 0)
	if [[ ${map_count} -lt 262144 ]]; then
ewarn
ewarn "The vm.max_map_count is ${map_count}. (It needs ≥ 262144 for the Wazuh indexer)."
ewarn
ewarn "Add this to your /etc/sysctl.d/99-wazuh.conf:"
ewarn
ewarn "  vm.max_map_count = 262144"
ewarn
ewarn "Then do:"
ewarn
ewarn "  sysctl -p /etc/sysctl.d/99-wazuh.conf"
ewarn
	fi
}

src_install() {
	local installdir="/opt/wazuh-docker"

	# Install the whole tree
	insinto "${installdir}"
	doins -r .

	# Keep only the stack the user chose
	if use multi-node; then
		rm -rf "${ED}${installdir}/single-node" || die
	else
		rm -rf "${ED}${installdir}/multi-node" || die
	fi

	# Make scripts executable
	fperms +x "${installdir}"/generate-indexer-certs.yml 2>/dev/null || true
	find "${ED}${installdir}" -name "*.sh" -exec chmod +x {} + || die

	# OpenRC service (optional but useful)
	newinitd "${FILESDIR}"/wazuh-docker.initd wazuh-docker
	newconfd "${FILESDIR}"/wazuh-docker.confd wazuh-docker

	systemd_dounit "${FILESDIR}"/wazuh-docker.service
	newconfd "${FILESDIR}"/wazuh-docker.confd wazuh-docker

	# README for the user
	dodoc README.md
}

pkg_postinst() {
elog
elog "The Wazuh Docker stack was installed to \`/opt/wazuh-docker\`."
elog "There are things that you still need to manually do."
elog
elog "1. Increase vm.max_map_count (required by the indexer):"
elog
elog "     echo 'vm.max_map_count=262144' >> /etc/sysctl.d/99-wazuh.conf"
elog "     sysctl -p /etc/sysctl.d/99-wazuh.conf"
elog
elog "2. Generate certificates (once):"
elog
	if use multi-node; then
elog "     cd /opt/wazuh-docker/multi-node"
	else
elog "     cd /opt/wazuh-docker/single-node"
	fi
elog "     docker compose -f generate-indexer-certs.yml run --rm generator"
elog
elog "3. Start the stack:"
elog
elog "     rc-service wazuh-docker start"
elog
elog "   or manually:"
elog
elog "     docker compose up -d"
elog
elog
elog "Dashboard default credentials: admin / SecretPassword"
elog "Docs: https://documentation.wazuh.com/current/deployment-options/docker/"
elog
elog
elog "Kernel features used by the agent:"
elog
elog "  - CONFIG_INOTIFY_USER : realtime FIM"
elog "  - CONFIG_AUDIT        : who-data (audit) + loginuid"
elog "  - CONFIG_BPF + BTF    : who-data (eBPF), kernel ≥ 5.8 preferred"
elog
elog
elog "Tune inotify watches if you monitor many files:"
elog
elog "  fs.inotify.max_user_watches = 1048576"
elog
}
