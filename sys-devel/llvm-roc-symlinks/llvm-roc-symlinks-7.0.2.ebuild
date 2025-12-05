# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT="19"
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="llvm-roc symlinks"
HOMEPAGE=""
LICENSE="public-domain"
RESTRICT="mirror"
SLOT="0/${ROCM_SLOT}"
IUSE+="ebuild_revision_11"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_install() {
	local names=(
	# Required for tensilelite in hipBLASLt
		"amdclang:amdclang"
		"amdclang++:amdclang++"
		"amdclang-${LLVM_SLOT}:amdclang-${LLVM_SLOT}"
		"amdclang-cl:amdclang-cl"
		"amdclang-cpp:amdclang-cpp"
		"amdflang:amdflang"
		"amdflang-classic:amdflang-classic"
		"amdflang-new:amdflang-new"
		"amdlld:amdlld"

		"clang:clang"
		"clang-cl:clang-cl"
		"clang-cpp:clang-cpp"
		"clang++:clang++"

		"clang:roc"
		"clang-cl:roc-cl"
		"clang-cpp:roc-cpp"
		"clang++:roc++"
	)
	for name in ${names[@]} ; do
		local src_name="${name%:*}"
		local dest_name="${name#*:}"
		if [[ "${dest_name}" =~ "amd" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/bin/${src_name}" \
				"/opt/rocm/bin/${dest_name}"
			continue
		fi
		if [[ "${name}" != "clang:clang" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/bin/${src_name}" \
				"/opt/rocm/lib/llvm/bin/${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "clang" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/bin/${src_name}" \
				"/opt/rocm/lib/llvm/bin/${CHOST}-${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "roc" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/bin/${src_name}" \
				"/opt/rocm/lib/llvm/bin/${dest_name}"
		fi
		dosym \
			"/opt/rocm/lib/llvm/bin/${src_name}" \
			"/opt/rocm/lib/llvm/bin/${CHOST}-${dest_name}-${ROCM_SLOT}"
		dosym \
			"/opt/rocm/lib/llvm/bin/${src_name}" \
			"/opt/rocm/lib/llvm/bin/${CHOST}-${dest_name}"
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
