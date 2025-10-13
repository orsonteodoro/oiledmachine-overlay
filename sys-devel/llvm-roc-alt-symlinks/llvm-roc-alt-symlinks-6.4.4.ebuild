# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"
LLVM_SLOT="19"

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="llvm-roc-alt symlinks"
HOMEPAGE=""
LICENSE="public-domain"
RESTRICT="mirror"
SLOT="0/${ROCM_SLOT}"
IUSE+="ebuild_revision_0"
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
		"clang:clang"
		"clang-cl:clang-cl"
		"clang-cpp:clang-cpp"
		"clang++:clang++"

		"clang:aocc"
		"clang-cl:aocc-cl"
		"clang-cpp:aocc-cpp"
		"clang++:aocc++"
	)
	for name in ${names[@]} ; do
		local src_name="${name%:*}"
		local dest_name="${name#*:}"
		if [[ "${name}" != "clang:clang" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/alt/bin/${src_name}" \
				"/opt/rocm/lib/llvm/alt/bin/${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "clang" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/alt/bin/${src_name}" \
				"/opt/rocm/lib/llvm/alt/bin/${CHOST}-${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "roc" ]] ; then
			dosym \
				"/opt/rocm/lib/llvm/alt/bin/${src_name}" \
				"/opt/rocm/lib/llvm/alt/bin/${dest_name}"
		fi
		dosym \
			"/opt/rocm/lib/llvm/alt/bin/${src_name}" \
			"/opt/rocm/lib/llvm/alt/bin/${CHOST}-${dest_name}-${ROCM_SLOT}"
		dosym \
			"/opt/rocm/lib/llvm/alt/bin/${src_name}" \
			"/opt/rocm/lib/llvm/alt/bin/${CHOST}-${dest_name}"
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
