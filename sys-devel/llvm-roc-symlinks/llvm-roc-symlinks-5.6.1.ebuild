# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"
LLVM_SLOT="16"

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI=""

DESCRIPTION="llvm-roc symlinks"
HOMEPAGE=""
LICENSE="public-domain"
RESTRICT="mirror"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
IUSE+="ebuild-revision-4"
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
		"clang:amdclang"
		"clang++:amdclang++"
		"clang-cl:amdclang-cl"
		"clang-cpp:amdclang-cpp"
		"flang:amdflang"
		"lld:amdlld"

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
		if [[ "${name}" != "clang:clang" ]] ; then
			dosym \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${src_name}" \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "clang" ]] ; then
			dosym \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${src_name}" \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${CHOST}-${dest_name}-${LLVM_SLOT}"
		fi
		if [[ "${dest_name}" =~ "roc" ]] ; then
			dosym \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${src_name}" \
				"/opt/rocm-${ROCM_VERSION}/llvm/bin/${dest_name}"
		fi
		dosym \
			"/opt/rocm-${ROCM_VERSION}/llvm/bin/${src_name}" \
			"/opt/rocm-${ROCM_VERSION}/llvm/bin/${CHOST}-${dest_name}-${ROCM_SLOT}"
		dosym \
			"/opt/rocm-${ROCM_VERSION}/llvm/bin/${src_name}" \
			"/opt/rocm-${ROCM_VERSION}/llvm/bin/${CHOST}-${dest_name}-${ROCM_VERSION}"
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
