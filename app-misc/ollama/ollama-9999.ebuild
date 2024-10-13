# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20
# For depends see
# https://github.com/ollama/ollama/blob/main/docs/development.md
# ROCm:  https://github.com/ollama/ollama/blob/main/.github/workflows/test.yaml#L119
# CUDA:  https://github.com/ollama/ollama/blob/main/.github/workflows/release.yaml#L194
ROCM_VERSION="6.1.2"

inherit go-module hip-versions

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ollama/ollama.git"
	inherit git-r3
else
	SRC_URI="
https://github.com/ollama/ollama/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models."
HOMEPAGE="https://ollama.com"
LICENSE="MIT"
SLOT="0"
IUSE="cuda rocm systemd"
RDEPEND="
	acct-group/ollama
	acct-user/ollama
"
IDEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.24
	>=dev-lang/go-1.22.0
	>=sys-devel/gcc-11.4.0
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
			=dev-util/nvidia-cuda-toolkit-12.4*
		)
	)
	rocm? (
		=dev-libs/rocm-opencl-runtime-${HIP_6_1_VERSION}:${ROCM_VERSION%.*}
		sci-libs/clblast
	)
"

pkg_pretend() {
	if use rocm ; then
ewarn "ROCm support for ${PN} is experimental."
	fi
	if use cuda ; then
ewarn "CUDA support for ${PN} is experimental."
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		git-r3_src_unpack
		go-module_live_vendor
	else
eerror "FIXME:  Incomplete"
		die
	fi
}

src_compile() {
	VERSION=$(
		git describe --tags --first-parent --abbrev=7 --long --dirty --always \
		| sed -e "s/^v//g"
		assert
	)
	export GOFLAGS="'-ldflags=-w -s \"-X=github.com/${PN}/${PN}/version.Version=${VERSION}\"'"

	ego generate ./...
	ego build .
}

src_install() {
	dobin "${PN}"
	if use systemd ; then
		doinitd "${FILESDIR}/${PN}"
	fi
}

pkg_preinst() {
	keepdir "/var/log/${PN}"
	fowners "${PN}:${PN}" "/var/log/${PN}"
}

pkg_postinst() {
einfo
einfo "Quick guide:"
einfo
einfo "  ${PN} serve"
einfo "  ${PN} run llama3:70b"
einfo
einfo "Models are available at https://ollama.com/library"
einfo
}
