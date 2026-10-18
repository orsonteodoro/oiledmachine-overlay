# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_APPEND_GOFLAGS=1
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-lang/go-9999"
)

inherit cflags-hardened chkl shell-completion go-env go-module secure-version toolchain-funcs

# update this on every bump
GIT_COMMIT="dfc520dcc28994c4c699b9b219fd2f5a6bcec0ff"

DESCRIPTION="the command line binary for docker"
HOMEPAGE="https://www.docker.com/"
SRC_URI="https://github.com/docker/cli/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cli-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-docker:* )"
BDEPEND="
	dev-go/go-md2man
	>=dev-lang/go-${GO_PV}:=
"

RESTRICT="installsources strip test"

src_prepare() {
	default
	sed -i 's@dockerd\?\.exe@@g' contrib/completion/bash/docker || die
	ln -s vendor.mod go.mod || die
	ln -s vendor.sum go.sum || die
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
}

src_compile() {
	export DISABLE_WARN_OUTSIDE_CONTAINER=1

	local myemakeargs=(
		VERSION="${PV}"
		GITCOMMIT="${GIT_COMMIT}"
	)

	emake "${myemakeargs[@]}" dynbinary
	CGO_ENABLED=0 tc-env_build go-env_run emake "${myemakeargs[@]}" manpages
}

src_install() {
	dobin build/docker
	doman man/man?/*
	dobashcomp contrib/completion/bash/docker
	bashcomp_alias docker dockerd
	dofishcomp contrib/completion/fish/docker.fish
	dozshcomp contrib/completion/zsh/_*
}

pkg_postinst() {
	has_version "app-containers/docker-buildx" && return
	ewarn "the 'docker build' command is deprecated and will be removed in a"
	ewarn "future release. If you need this functionality, install"
	ewarn "app-containers/docker-buildx."
}
