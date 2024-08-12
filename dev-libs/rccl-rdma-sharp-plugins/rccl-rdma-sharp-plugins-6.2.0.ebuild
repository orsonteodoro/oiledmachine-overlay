# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit autotools rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/rccl-rdma-sharp-plugins/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="rccl-rdma-sharp plugin enables RDMA and Switch based collectives \
(SHARP) with AMD's RCCL library"
HOMEPAGE="https://github.com/ROCm/rccl-rdma-sharp-plugins"
LICENSE="
	BSD
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="verbs ebuild-revision-0"
RDEPEND="
	~dev-util/hip-${PV}:${ROCM_SLOT}
	verbs? (
		sys-cluster/rdma-core
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
"
PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	default
	rocm_src_prepare
	eautoreconf
}

src_configure() {
	rocm_set_default_hipcc
	local myconf=(
		--prefix="${EROCM_PATH}"
		--with-hip="${EROCM_PATH}"
	)
	if use verbs ; then
		myconf+=(
			--with-verbs="${ESYSROOT}/usr"
		)
	fi
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	docinto "licenses"
	dodoc "LICENSE"
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
