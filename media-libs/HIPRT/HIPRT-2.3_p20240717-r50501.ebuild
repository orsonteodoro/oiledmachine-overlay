# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No CMAKE arg yet
_AMDGPU_TARGETS_COMPAT=(
	"gfx900"
	"gfx902"
	"gfx904"
	"gfx906"
	"gfx908"
	"gfx909"
	"gfx90a"
	"gfx90c"
	"gfx940"
	"gfx941"
	"gfx942"
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1013"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1033"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
)

HIP_SUPPORT_CUDA=1
LLVM_SLOT=16
ROCM_SLOT="5.5"
inherit hip-versions
ROCM_VERSION="${HIP_5_5_VERSION}"
EGIT_COMMIT="4996b9794cdbc3852fad6e2ae0dbab1e48f2e5f0"

inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/HIPRT-${EGIT_COMMIT}"
SRC_URI="
https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="HIP RT is a ray tracing library in HIP"
HOMEPAGE="
	https://github.com/GPUOpen-LibrariesAndSDKs/HIPRTSDK
	https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	BSD
	MIT
	public-domain
	|| (
		Apache-2.0-with-LLVM-exceptions
		GPL-3
	)
"
# license.txt - ( all-rights-reserved MIT ) Apache-2.0 BSD MIT public-domain || ( Apache-2.0-with-LLVM-exceptions GPL-3 )
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
IUSE="-bake-kernels -bitcode cuda encrypt precompile rocm system-orochi test ebuild_revision_9"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	?? (
		bake-kernels
		bitcode
	)
	^^ (
		cuda
		rocm
	)
	bake-kernels? (
		!system-orochi
	)
"
RDEPEND="
	dev-util/hip:${SLOT}
	!system-orochi? (
		!=dev-libs/Orochi-2.00*:${SLOT}
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	system-orochi? (
		=dev-libs/Orochi-2.00*:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIP_CLANG_DEPEND}
	>=dev-build/cmake-3.10
	dev-util/premake:5
"
PATCHES=(
	"${FILESDIR}/${PN}-2.3_p20240717-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-cuda-option.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-install-paths.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-bakekernel.patch"
)
DOCS=( "README.md" )

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

build_easy_encryption() {
	pushd "contrib/easy-encryption" >/dev/null 2>&1 || die
		premake5 gmake || die
		make || die
		make config=release_x64 || die
		mv \
			"${S}/contrib/easy-encryption/dist/bin/Release/ee64" \
			"${S}/contrib/easy-encryption/bin/linux/ee64" \
			|| die
	popd >/dev/null 2>&1 || die
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare

	rm "contrib/easy-encryption/bin/linux/ee64" || die
	build_easy_encryption

	# Test build
	echo "lol world" > "contrib/easy-encryption/bin/linux/message.plaintext"
	"contrib/easy-encryption/bin/linux/ee64" \
		"contrib/easy-encryption/bin/linux/message.plaintext" \
		"contrib/easy-encryption/bin/linux/message.ciphertext" \
		key \
		0 \
		|| die
	"contrib/easy-encryption/bin/linux/ee64" \
		"contrib/easy-encryption/bin/linux/message.ciphertext" \
		"contrib/easy-encryption/bin/linux/message.plaintext2" \
		key \
		1 \
		|| die
	cat "contrib/easy-encryption/bin/linux/message.plaintext2" \
		| grep -q -e "lol world" \
		|| die
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

	export HIP_PATH="/opt/rocm-${ROCM_VERSION}"
	local mycmakeargs=(
		-DBITCODE=$(usex bitcode)
		-DCMAKE_INSTALL_LIBDIR="$(rocm_get_libdir)"
		-DCMAKE_INSTALL_PREFIX="/opt/rocm-${ROCM_VERSION}"
		-DGENERATE_BAKE_KERNEL=$(usex bake-kernels)
		-DHIP_PATH="/opt/rocm-${ROCM_VERSION}"
		-DHIPRT_PREFER_HIP_5=ON
		-DNO_ENCRYPT=$(usex !encrypt)
		-DNO_UNITTEST=$(usex !test)
		-DPRECOMPILE=$(usex precompile)
		-DUSE_CUDA=$(usex cuda)
	)
	if ! use encrypt && ! use bake-kernels ; then
		mycmakeargs+=(
			-DBAKE_KERNEL=OFF
		)
	else
		mycmakeargs+=(
			-DBAKE_KERNEL=ON
		)
	fi
	if use cuda ; then
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
#			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_SYMLINK_LIBS=OFF
		)
	fi
	rocm_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
	dodoc "license.txt"
	rocm_mv_docs
	insinto "/opt/rocm-${ROCM_VERSION}/share/${PN}"
	doins "version.txt"
	insinto "/opt/rocm-${ROCM_VERSION}/include/hiprt"
	doins -r "hiprt/impl"
	if ! use system-orochi ; then
		insinto "/opt/rocm-${ROCM_VERSION}/include"
		doins -r "contrib/Orochi"
	fi
}
