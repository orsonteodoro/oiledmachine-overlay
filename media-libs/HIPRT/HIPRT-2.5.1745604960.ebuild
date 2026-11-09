# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The 3rd version component, using 1-based indexing, is based on the Unix timestamp.
# date --date="Apr 25, 2025 11:16 AM PDT" "+%s"

MY_PV="2.5.48ee995" # Not tagged, an approximation since it is untagged in next-release-7 branch

# Versioning based on GH search: committer-date:<=YYYYMMDD [of dev-util/hip tag]

CXX_STANDARD=17
EGIT_COMMIT="606b4886efabce918dd0634ef71c06615a47c83b" # Same as Blender 5.2 vendored, containing fPIC fix
HIP_SUPPORT_CUDA=1
LLVM_SLOT=24

# See https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/blob/606b4886efabce918dd0634ef71c06615a47c83b/scripts/bitcodes/common_tools.py#L51

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_10_1[@]}"
)

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot secure-version rocm-r1

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
SLOT="0/${ROCM_SLOT}"
IUSE="
-bake-kernels -bitcode cuda encrypt precompile rocm system-orochi test
ebuild_revision_11
"
REQUIRED_USE="
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
	>=sci-ml/therock-${THEROCK_PV}:=
	!system-orochi? (
		!dev-libs/Orochi
	)
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	system-orochi? (
		=dev-libs/Orochi-3.00*:=
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
	"${FILESDIR}/${PN}-2.5_p20250327-install-paths.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-bakekernel.patch"
)
DOCS=( "README.md" )

pkg_setup() {
	check-compiler-switch_start
	rocm-r1_pkg_setup
	libstdcxx-slot_verify
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
	rocm-r1_set_default_clang

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

	export HIP_PATH="${ROCM_PATH}"
	local mycmakeargs=(
		-DBITCODE=$(usex bitcode)
		-DCMAKE_INSTALL_LIBDIR="$(rocm_get_libdir)"
		-DCMAKE_INSTALL_PREFIX="${ROCM_PATH}"
		-DFORCE_DISABLE_CUDA=$(usex !cuda)
		-DGENERATE_BAKE_KERNEL=$(usex bake-kernels)
		-DHIP_PATH="${ROCM_PATH}"
		-DHIPRT_PREFER_HIP_5=ON
		-DNO_ENCRYPT=$(usex !encrypt)
		-DNO_UNITTEST=$(usex !test)
		-DPRECOMPILE=$(usex precompile)
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
	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
	dodoc "license.txt"
	insinto "${ROCM_PATH}/share/${PN}"
	doins "version.txt"
	insinto "${ROCM_PATH}/include/hiprt"
	doins -r "hiprt/impl"
	if ! use system-orochi ; then
		insinto "${ROCM_PATH}/include"
		doins -r "contrib/Orochi"
	fi
}
