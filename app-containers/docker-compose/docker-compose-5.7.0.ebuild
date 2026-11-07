# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"app-containers/podman-9999"
	"dev-lang/go-9999"
)

inherit cflags-hardened chkl optfeature secure-version

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/compose/releases/download/v${PV}/compose-${PV}-vendor.tar.xz"
S="${WORKDIR}/compose-${PV}"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"
IUSE="
docker-cli podman
"
REQUIRED_USE="
	|| (
		docker-cli
		podman
	)
"
RDEPEND="
	docker-cli? (
		>=app-containers/docker-cli-${DOCKER_PV}:*
	)
	podman? (
		app-containers/podman:*[wrapper(+)]
		|| (
			~app-containers/podman-${PODMAN_6_PV}
			~app-containers/podman-${PODMAN_5_PV}
			=app-containers/podman-9999
		)
	)
"
BDEPEND=">=dev-lang/go-${GO_PV}:="

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	default
}

src_compile() {
	emake VERSION=v${PV}
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe bin/build/docker-compose
	dodoc README.md
}

pkg_postinst() {
	optfeature "credential store support" app-containers/docker-credential-helpers

	if ver_replacing -lt 2; then
		ewarn
		ewarn "docker-compose 2.x is a sub command of docker"
		ewarn "Use 'docker compose' from the command line instead of"
		ewarn "'docker-compose'"
		ewarn "If you need to keep 1.x around, please run the following"
		ewarn "command before your next --depclean"
		ewarn "# emerge --noreplace docker-compose:0"
	fi
}
