# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)

inherit libstdcxx-slot meson-multilib

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/glu.git"
	inherit git-r3
else
	SRC_URI="https://mesa.freedesktop.org/archive/glu/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="SGI-B-2.0"
SLOT="0"

DEPEND="media-libs/libglvnd[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	libstdcxx-slot_verify
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=shared
		-Dgl_provider=glvnd
	)
	meson_src_configure
}
