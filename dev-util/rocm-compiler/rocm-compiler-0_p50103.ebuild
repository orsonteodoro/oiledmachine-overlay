EAPI=8

# This package applies to any package named roc* or ROC* or has only ROCm GPU
# support with a system-llvm USE flag.

ROCM_SLOT="5.1"

DESCRIPTION="Compiler selection for the ROCm stack"
LICENSE="metapackage"
KEYWORDS="~amd64"
IUSE="system-llvm"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	!dev-util/rocm-compiler:0
"
