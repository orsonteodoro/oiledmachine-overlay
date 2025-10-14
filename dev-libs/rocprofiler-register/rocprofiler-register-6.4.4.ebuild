# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FMT_COMMIT="6c845f57e5db589208ff0c2808238587cafafa82"
GLOG_COMMIT="3a0d4d22c5ae0b9a2216988411cfa6bf860cc372"
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-compiler-switch cmake flag-o-matic rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/rocprofiler-register.git"
	EGIT_BRANCH="amd-mainline"
	FALLBACK_COMMIT="f785235543aafe0bf49b1fcc304375ab0766e5aa" # Dec 21, 2023
	IUSE+=" fallback-commit"
	inherit git-r3
else
	S_GLOG="${WORKDIR}/glog-${GLOG_COMMIT}"
	S_FMT="${WORKDIR}/fmt-${FMT_COMMIT}"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/rocprofiler-register/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT}.tar.gz
	-> fmt-${FMT_COMMIT:0:7}.tar.gz
https://github.com/google/glog/archive/${GLOG_COMMIT}.tar.gz
	-> glog-${GLOG_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="The rocprofiler-register helper library"
HOMEPAGE="https://github.com/ROCm/rocprofiler-register"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
"
# all-rights-reserved MIT - source/include/rocprofiler-register/version.h.in
# MIT - LICENSE
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror" # Speed up downloads
SLOT="0/${ROCM_SLOT}"
IUSE+=" samples static-libs test ebuild_revision_10"
# glog downgraded originally 0.7.0
RDEPEND="
	>=dev-cpp/glog-0.6.0
	>=dev-libs/libfmt-10.1.0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.16
"
PATCHES=(
	"${FILESDIR}/${PN}-6.1.2-include-cpack.patch"
	"${FILESDIR}/${PN}-6.1.2-offline-install.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		rm -rf \
			"${S}/external/fmt" \
			"${S}/external/glog" \
			|| die
		mv \
			"${S_GLOG}" \
			"${S}/external/glog" \
			|| die
		mv \
			"${S_FMT}" \
			"${S}/external/fmt" \
			|| die
	fi
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_clang

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DROCPROFILER_REGISTER_BUILD_GLOG=ON
		-DROCPROFILER_REGISTER_BUILD_FMT=ON
		-DROCPROFILER_REGISTER_BUILD_SAMPLES=$(usex samples)
		-DROCPROFILER_REGISTER_BUILD_TESTS=$(usex test)
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
