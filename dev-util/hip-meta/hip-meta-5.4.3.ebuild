# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/ROCm/ROCm/blob/docs/5.4.3/docs/release/gpu_os_support.md
AMDGPU_TARGETS_COMPAT=(
	gfx906
	gfx908
	gfx90a
	gfx1030
)

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit rocm

KEYWORDS="~amd64"

DESCRIPTION="HIP metapackage"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	cuda
	hip-dev
	hipfort
	hiprand
	migraphx
	mivisionx
	rocm
"
REQUIRED_USE="
"
RDEPEND="
	hip-dev? (
		>=dev-lang/perl-5.0
		sys-apps/file
		sys-libs/glibc
		dev-perl/URI-Encode
		dev-perl/File-BaseDir
		dev-perl/File-Copy-Recursive
		dev-perl/File-Listing
		dev-perl/File-Which
		~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
		~dev-util/hip-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	)
	hipfort? (
		~dev-util/hipfort-${PV}:${ROCM_SLOT}
	)
	hiprand? (
		~sci-libs/hipRAND-${PV}:${ROCM_SLOT}[cuda?,rocm?]
	)
	migraphx? (
		cuda? (
			~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}[cpu]
		)
		rocm? (
			~sci-libs/MIGraphX-${PV}:${ROCM_SLOT}$(get_rocm_usedep MIGRAPHX)
		)
	)
	mivisionx? (
		cuda? (
			~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[opencl]
		)
		rocm? (
			~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}[rocm]
		)
	)

"
