# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For packagers, do not convert the ebuild to native (aka split ebuilds).
# It will increase the blast radius effectively giving attacker privileged mode.

# This ebuild contains AI generated ebuild/artifacts + human edited ebuild.
# This ebuild contains AI synthetic data.

# See https://github.com/openclaw/openclaw/pkgs/container/openclaw
EGIT_REPO_URI="https://github.com/openclaw/openclaw.git"
FALLBACK_COMMIT="4eb716062250cabc25bc3b5591994ce00e5c3f9e"
FALLBACK_TAG="2026.4.9"
#KEYWORDS="~amd64" # Need to fix file ownership/permissions issue
IUSE+=" fallback-commit"
inherit git-r3

DESCRIPTION="OpenClaw - Personal AI assistant gateway (Docker Compose + OpenRC)"
HOMEPAGE="https://github.com/openclaw/openclaw"
LICENSE="MIT"
SLOT="0"
IUSE+=" ebuild_revision_8"
RDEPEND="
	acct-group/openclaw
	acct-user/openclaw
	app-containers/docker[container-init]
	app-containers/docker-compose
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

src_unpack() {
#
# For the security, some of it could be disinformation, psyops, or marketing smears.
#
# You have 3 choices:
#
# 1. Non-free cloud hosted AI agent
# 2. Free locally hosted AI agent (e.g. openclaw)
# 3. No AI agent
#
# This is a user data sovereignty issue in the age of deplatforming.
# You can give your crown jewels to a cloud hosted AI agent to be later deplatformed, blackmailed, controlled, or stolen in maybe a data center breach.
# You can keep your crown jewels on your site without being controlled with a security risk to malicious threat actors.
# You can abstain from AI agents without opening the evil Pandora's box.
#
ewarn
ewarn "The ${PN} ebuild is provided for testing purposes or testing/research evaluation"
ewarn "of Web RAG for LobeHub not for production use because of security reasons."
ewarn
ewarn "Security estimated score and use case:"
ewarn
ewarn "| Configuration           | Security score      | Suggested use case                                            |"
ewarn "| ---                     | ---                 | ---                                                           |"
ewarn "| Decontainerized native  |  ~10-20 out of 100  | Isolated development machine                                  |"
ewarn "| In docker               |  ~50-60 out of 100  | Standard business automation, personal AI assistants          |"
ewarn "| In docker in a VM       |  ~80-90 out of 100  | Production tasks accessing sensitive data or internal network |"
ewarn
	git-r3_src_unpack || die
}

src_prepare() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	default

	eapply "${FILESDIR}/openclaw-4eb7160-docker-compose.patch"
	eapply "${FILESDIR}/openclaw-2d126fc-file-permissions.patch"

	# === PLACEHOLDER REPLACEMENT (you can manually patch before this) ===
	# Fallback sed replacement
	local openclaw_uid=$(id -u "openclaw")
	local openclaw_gid=$(id -g "openclaw")
	local openclaw_tag="latest"
	local docker_gid=48
	use fallback-commit && openclaw_tag="${FALLBACK_TAG}"
	sed -i \
		-e "s|@OPENCLAW_UID@|${openclaw_uid}|g" \
		-e "s|@OPENCLAW_GID@|${openclaw_gid}|g" \
		-e "s|@OPENCLAW_TAG@|${openclaw_tag}|g" \
		-e "s|@DOCKER_GID@|${docker_gid}|g" \
		"docker-compose.yml" \
		"scripts/docker/setup.sh" \
		|| die "sed placeholder replacement failed"

	# Force pre-built image in docker-compose.yml (skip local build)
	# Avoid using non-portable bun during local Docker build.
	sed -i \
		-e 's|image:.*openclaw:local|image: ghcr.io/openclaw/openclaw:@OPENCLAW_TAG@|g' \
		-e 's|build: \.|# build: .  # disabled - using pre-built image|g' \
		"docker-compose.yml" \
		|| true

	# Fix .env file - critical part
	if [[ -f ".env" ]]; then
		sed -i \
			-e 's|OPENCLAW_CONFIG_DIR=.*|OPENCLAW_CONFIG_DIR=/home/node/.openclaw|' \
			-e 's|OPENCLAW_WORKSPACE_DIR=.*|OPENCLAW_WORKSPACE_DIR=/home/node/.openclaw/workspace|' \
			".env" || true
	fi
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

	# Data dir already created by acct-user/openclaw
}

pkg_postinst() {
	if [[ -e "${EROOT}/var/lib/openclaw" ]] ; then
		local openclaw_uid=$(id -u "openclaw")
		local openclaw_gid=$(id -g "openclaw")
		chown -R "${openclaw_uid}:${openclaw_gid}" "${EROOT}/var/lib/openclaw" 2>/dev/null || true
		chmod -R 0770 "${EROOT}/var/lib/openclaw" 2>/dev/null || true
	fi

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
einfo
einfo "The .env file has been automatically fixed to use /home/node/.openclaw"
einfo "to avoid permission errors with the pre-built image."
einfo
}
