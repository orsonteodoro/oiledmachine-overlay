EAPI=8

# This applies to any package named hip* or HIP* or GPU agnostic package with a
# system-llvm USE flag.

ROCM_SLOT="5.4"

DESCRIPTION="Compiler selection for the HIP stack"
LICENSE="metapackage"
KEYWORDS="~amd64"
IUSE="system-llvm"
SLOT="${ROCM_SLOT}/${PV}"
RDEPEND="
	!dev-util/hip-compiler:0
"
