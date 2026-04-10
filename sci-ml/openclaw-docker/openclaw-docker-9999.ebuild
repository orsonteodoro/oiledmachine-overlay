# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/openclaw/openclaw/pkgs/container/openclaw
EGIT_REPO_URI="https://github.com/openclaw/openclaw.git"
FALLBACK_COMMIT="4eb716062250cabc25bc3b5591994ce00e5c3f9e"
FALLBACK_TAG="2026.4.9"
KEYWORDS="~amd64"
IUSE+=" fallback-commit"
inherit git-r3

DESCRIPTION="OpenClaw - Personal AI assistant gateway (Docker Compose + OpenRC)"
HOMEPAGE="https://github.com/openclaw/openclaw"
LICENSE="MIT"
SLOT="0"
IUSE+=" ebuild_revision_2"
RDEPEND="
	acct-group/openclaw
	acct-user/openclaw
	app-containers/docker
	app-containers/docker-compose
	app-containers/docker-init
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

src_unpack() {
	git-r3_src_unpack || die
}

src_prepare() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	default

	eapply "${FILESDIR}/openclaw-4eb7160-docker-compose.patch"

	# === PLACEHOLDER REPLACEMENT (you can manually patch before this) ===
	# Fallback sed replacement
	local openclaw_uid=$(id -u "openclaw")
	local openclaw_gid=$(id -g "openclaw")
	local openclaw_tag="latest"
	use fallback-commit && openclaw_tag="${FALLBACK_TAG}"
	sed -i \
		-e "s|@OPENCLAW_UID@|${openclaw_uid}|g" \
		-e "s|@OPENCLAW_GID@|${openclaw_gid}|g" \
		-e "s|@OPENCLAW_TAG@|${openclaw_tag}|g" \
		"docker-compose.yml" \
		|| die "sed placeholder replacement failed"
	sed -i -e "" "scripts/docker/setup.sh" || die

	# Force pre-built image in docker-compose.yml (skip local build)
	# Avoid using non-portable bun during local Docker build.
	sed -i \
		-e 's|image:.*openclaw:local|image: ghcr.io/openclaw/openclaw:@OPENCLAW_TAG@|g' \
		-e 's|build: \.|# build: .  # disabled - using pre-built image|g' \
		"docker-compose.yml" || true
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	# Install Docker-related files to /opt/openclaw
	insinto "/opt/openclaw"
	doins -r .

	insinto "/opt/openclaw/scripts/docker"
	doins "scripts/docker/setup.sh"

	fperms +x "/opt/openclaw/docker-setup.sh"
	fperms +x "/opt/openclaw/scripts/docker/setup.sh"

	exeinto "/usr/bin"
	cat "${FILESDIR}/openclaw" > "${T}/openclaw"
	local openclaw_tag="latest"
	use fallback-commit && openclaw_tag="${FALLBACK_TAG}"
	sed -i -e "s|@OPENCLAW_TAG@|${openclaw_tag}|g" "${T}/openclaw" || die
	doexe "${T}/openclaw"

	# Install OpenRC init script
	newinitd "${FILESDIR}/openclaw.initd" "openclaw"

	# Install systemd unit into files/ (for reference or optional use)
	insinto "/usr/lib/systemd/system"
	newins "${FILESDIR}/openclaw.service" "openclaw.service"

	# Create persistent data directory
	keepdir "/var/lib/openclaw"
	fowners "root:docker" "/var/lib/openclaw"
	fperms 0775 "/var/lib/openclaw"
}

pkg_postinst() {
	local openclaw_tag="latest"
	use fallback-commit && openclaw_tag="${FALLBACK_TAG}"
einfo "OpenClaw has been installed."
einfo
einfo "First run the official setup script (/usr/bin/openclaw)."
einfo "Do this before running init scripts."
einfo
einfo "By default /usr/bin/openclaw uses the official pre-built Docker image:"
einfo
einfo "   ghcr.io/openclaw/openclaw:${openclaw_tag}"
einfo
einfo "This skips the local build (which requires Bun)."
einfo
einfo "To override image/tag, replace <tag>:"
einfo
einfo "   OPENCLAW_IMAGE=ghcr.io/openclaw/openclaw:<tag> openclaw"
einfo
einfo "OpenRC users start and autorun on boot the service with:"
einfo
einfo "   rc-update add openclaw default"
einfo "   rc-service openclaw start"
einfo
einfo "systemd users start and autorun on boot the service with:"
einfo
einfo "   systemctl start openclaw.service"
einfo "   systemctl enable openclaw.service"
einfo
einfo "Control UI: http://localhost:18789"
einfo "After onboarding, connect LobeHub to http://127.0.0.1:18789"
einfo
einfo "To update later: emerge --ask --oneshot =openclaw-9999"
}
