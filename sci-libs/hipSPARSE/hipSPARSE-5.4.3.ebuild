# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
ROCM_VERSION="${PV}"

inherit cmake edo rocm toolchain-funcs

# Some test datasets are shared with rocSPARSE.
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz
	-> hipSPARSE-${PV}.tar.gz
	test? (
https://sparse.tamu.edu/MM/SNAP/amazon0312.tar.gz
	-> rocSPARSE_amazon0312.tar.gz
https://sparse.tamu.edu/MM/Muite/Chebyshev4.tar.gz
	-> rocSPARSE_Chebyshev4.tar.gz
https://sparse.tamu.edu/MM/FEMLAB/sme3Dc.tar.gz
	-> rocSPARSE_sme3Dc.tar.gz
https://sparse.tamu.edu/MM/Williams/webbase-1M.tar.gz
	-> rocSPARSE_webbase-1M.tar.gz
https://sparse.tamu.edu/MM/Bova/rma10.tar.gz
	-> rocSPARSE_rma10.tar.gz
https://sparse.tamu.edu/MM/JGD_BIBD/bibd_22_8.tar.gz
	-> rocSPARSE_bibd_22_8.tar.gz
https://sparse.tamu.edu/MM/Williams/mac_econ_fwd500.tar.gz
	-> rocSPARSE_mac_econ_fwd500.tar.gz
https://sparse.tamu.edu/MM/Williams/mc2depi.tar.gz
	-> rocSPARSE_mc2depi.tar.gz
https://sparse.tamu.edu/MM/Hamm/scircuit.tar.gz
	-> rocSPARSE_scircuit.tar.gz
https://sparse.tamu.edu/MM/Sandia/ASIC_320k.tar.gz
	-> rocSPARSE_ASIC_320k.tar.gz
https://sparse.tamu.edu/MM/GHS_psdef/bmwcra_1.tar.gz
	-> rocSPARSE_bmwcra_1.tar.gz
https://sparse.tamu.edu/MM/HB/nos1.tar.gz
	-> rocSPARSE_nos1.tar.gz
https://sparse.tamu.edu/MM/HB/nos2.tar.gz
	-> rocSPARSE_nos2.tar.gz
https://sparse.tamu.edu/MM/HB/nos3.tar.gz
	-> rocSPARSE_nos3.tar.gz
https://sparse.tamu.edu/MM/HB/nos4.tar.gz
	-> rocSPARSE_nos4.tar.gz
https://sparse.tamu.edu/MM/HB/nos5.tar.gz
	-> rocSPARSE_nos5.tar.gz
https://sparse.tamu.edu/MM/HB/nos6.tar.gz
	-> rocSPARSE_nos6.tar.gz
https://sparse.tamu.edu/MM/HB/nos7.tar.gz
	-> rocSPARSE_nos7.tar.gz
https://sparse.tamu.edu/MM/DNVS/shipsec1.tar.gz
	-> rocSPARSE_shipsec1.tar.gz
	)
"

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="cuda +rocm test r1"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	^^ (
		rocm
		cuda
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	~dev-util/hip-${PV}:${SLOT}
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	rocm? (
		~sci-libs/rocSPARSE-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		dev-cpp/gtest
		~dev-util/rocminfo-${PV}:${SLOT}
	)
"
S="${WORKDIR}/hipSPARSE-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-remove-matrices-unpacking.patch"
)

src_prepare() {
	sed \
		-e "s/PREFIX hipsparse//" \
		-e "/<INSTALL_INTERFACE/s,include,include/hipsparse," \
		-e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" \
		-i \
		library/CMakeLists.txt \
		|| die

	cmake_src_prepare

	# Removed the GIT dependency.
	sed \
		-e "/find_package(Git/d" \
		-i \
		cmake/Dependencies.cmake \
		|| die

	# Fixed the install path.
	sed -i \
		-e "s.set(CMAKE_INSTALL_LIBDIR.#set(CMAKE_INSTALL_LIBDIR." \
		CMakeLists.txt \
		|| die

	if use test; then
		mkdir -p "${BUILD_DIR}/clients/matrices" || die
	# Compile and use the mtx2bin converter.
	# Do not use any optimization flags!
		edo $(tc-getCXX) deps/convert.cpp -o deps/convert
		find "${WORKDIR}" \
			-maxdepth 2 \
			-regextype "grep" \
			-E \
			-regex ".*/(.*)/\1\.mtx" \
			-print0 | \
		while IFS= read -r -d '' mtxfile; do
			local bn=$(basename -s '.mtx' "${mtxfile}")
			local destination="${BUILD_DIR}/clients/matrices/${bn}.bin"
			ebegin "Converting ${mtxfile} to ${destination}"
			deps/convert "${mtxfile}" "${destination}"
			eend $?
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
		-DHIP_RUNTIME="ROCclr"
		-DUSE_CUDA=$(usex cuda ON OFF)
	)
	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	edob ./${PN,,}-test
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
