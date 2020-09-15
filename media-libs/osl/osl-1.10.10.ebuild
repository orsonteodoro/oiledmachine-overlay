# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake llvm toolchain-funcs

# check this on updates
LLVM_MAX_SLOT=10

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="http://opensource.imageworks.com/?p=osl"
SRC_URI="https://github.com/imageworks/OpenShadingLanguage/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="doc partio qt5 test ${CPU_FEATURES[@]%:*}"

# See https://github.com/imageworks/OpenShadingLanguage/blob/Release-1.10.10/INSTALL.md
RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	media-libs/openexr:=
	media-libs/openimageio:=
	<sys-devel/clang-11:=
	>=sys-devel/clang-4:=
	sys-libs/zlib:=
	partio? ( media-libs/partio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"

DEPEND="${RDEPEND}
	media-libs/mesa:="
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.5-fix-install-shaders.patch"
)

# Restricting tests as Make file handles them differently
RESTRICT="test"

S="${WORKDIR}/OpenShadingLanguage-Release-${PV}"

llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	# From the strace, blender will load MESA indirectly if
	# it was compiled with cycles with OSL.

	# Mesa uses c++14 so it requires LLVM10.
	local mesa_llvm_ver=
	if cat "${EROOT}/var/db/pkg/media-libs/mesa-"*"/REQUIRES" \
		| grep -q -F -e "LLVM-" ; then
		mesa_llvm_ver=$(cat \
	"${EROOT}/var/db/pkg/media-libs/mesa-"*"/REQUIRES" \
			| grep -E -o -e "LLVM-[0-9]+" \
			| head -n 1 | grep -E -o -e "[0-9]+")
	elif cat "${EROOT}/var/db/pkg/media-libs/mesa-"*"/REQUIRES" \
		| grep -q -F -e "libLLVMAnalysis.so.9" ; then
		mesa_llvm_ver=9
	fi

	# Blender only uses c++11 so it requires LLVM9 or below.

	# The problem is that when cycles with osl loads two different LLVM
	# versions, it prevents blender from loading leading to:

	# : CommandLine Error: Option 'help-list' registered more than once!
	# LLVM ERROR: inconsistency in registered CommandLine options

	OSL_LLVM_VERSION_OVERRIDE=${OSL_LLVM_VERSION_OVERRIDE:=${mesa_llvm_ver}}

	# For llvm-config
	export PATH=$(echo "${PATH}" | tr ":" "\n" \
	| sed -e "/llvm/d" \
	| sed -e "/[/]usr[/]local[/]sbin/a /usr/lib/llvm/${OSL_LLVM_VERSION_OVERRIDE}/bin" \
	| tr "\n" ":")
	export LLVM_V=$(llvm-config --version | cut -f 1 -d ".")
	einfo "MESA LLVM version:  ${mesa_llvm_ver}"
	einfo "llvm-config version:  ${LLVM_V}"
}

src_configure() {
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	use_cpp=11
	if [[ "${LLVM_V}" == 10 ]] ; then
		use_cpp=14
	fi

	local gcc=$(tc-getCC)
	# LLVM needs CPP11. Do not disable.
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DENABLERTTI=OFF
		-DINSTALL_DOCS=$(usex doc)
		-DLLVM_STATIC=ON
		-DOSL_BUILD_TESTS=$(usex test)
		-DSTOP_ON_WARNING=OFF
		-DUSE_CPP=${use_cpp}
		-DUSE_PARTIO=$(usex partio)
		-DUSE_QT=$(usex qt5)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake_src_configure
}
