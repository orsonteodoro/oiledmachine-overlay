# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

CXX_STANDARD=17
INSTALL_PREFIX="/usr/lib/bun-zig/${PV%%.*}"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)
LIBSTDCXX_USEDEP_DEV="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	#"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
	18 # Version sensitive
)
LIBCXX_USEDEP_DEV="llvm_slot_skip(+)"

LLVM_TARGETS=(
	"llvm_targets_X86"
	"llvm_targets_AArch64"
)

declare -A MAXRSS=(
	["amd64-debug"]="21000000000"
	["amd64-debug-llvm"]="21000000000"
	["amd64-release"]="21000000000"
	["arm64-debug"]="44918199637"
	["arm64-release"]="44918199637"
	["riscv-debug"]="68719476736"
	["riscv-release"]="68719476736"
)

inherit check-compiler-switch cmake dhms flag-o-matic flag-o-matic-om libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/oven-sh/zig.git"
	FALLBACK_COMMIT="027aabf4977d0362e908d9ef732aaa929605d563"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="027aabf4977d0362e908d9ef732aaa929605d563"
	KEYWORDS="~amd64"
	S="${WORKDIR}/zig-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/oven-sh/zig/archive/${EGIT_COMMIT}.tar.gz
	-> oven-sh-zig-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Bun fork of Zig"
HOMEPAGE="
	https://github.com/oven-sh/zig
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="${PV%%.*}"
IUSE+="
${LLVM_TARGETS[@]}
clang debug
ebuild_revision_7
"
REQUIRED_USE="
	clang
	|| (
		${LLVM_TARGETS[@]}
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
gen_depend_llvm() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},llvm_targets_AArch64?,llvm_targets_WebAssembly,llvm_targets_X86?]
				llvm-core/clang:=
				llvm-core/llvm:${s}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},llvm_targets_AArch64?,llvm_targets_WebAssembly,llvm_targets_X86?]
				llvm-core/llvm:=
				llvm-core/lld:${s}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},llvm_targets_AArch64?,llvm_targets_WebAssembly,llvm_targets_X86?]
				llvm-core/lld:=
			)
		"
	done
}

RDEPEND+="
"
DEPEND+="
	${RDEPEND}
	app-arch/zstd[static-libs]
	app-arch/zstd:=
	dev-libs/libxml2[static-libs]
	dev-libs/libxml2:=
	>=sys-libs/zlib-1.2.11[static-libs]
	sys-libs/zlib:=
"
BDEPEND+="
	$(gen_depend_llvm)
	>=dev-build/cmake-3.15
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-20231013-llvm-non-fatal.patch"
	"${FILESDIR}/${PN}-20240708-maxrss.patch"
)

_set_clang() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			export LLVM_SLOT="${s}"
			break
		fi
	done
	if [[ -z "${CC}" ]] ; then
eerror "Choose a LLVM slot for C++ standard ${CXX_STANDARD}.  Valid values:  ${LLVM_COMPAT[@]/#/llvm_slot_}"
eerror "Enable a llvm_slot_<x> flag."
		die
	fi

einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"

	if ! which "${CC}" ; then
eerror "${CC} is not found.  Emerge the compiler slot."
		die
	fi
	export CPP="${CC} -E"
	export AR="llvm-ar"
	export NM="llvm-nm"
	export OBJCOPY="llvm-objcopy"
	export OBJDUMP="llvm-objdump"
	export READELF="llvm-readelf"
	export STRIP="llvm-strip"
	export GCC_FLAGS=""
	strip-unsupported-flags
	${CC} --version || die
}

_set_gcc() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	export AR="ar"
	export NM="nm"
	export OBJCOPY="objcopy"
	export OBJDUMP="objdump"
	export READELF="readelf"
	export STRIP="strip"
	export GCC_FLAGS="-fno-allow-store-data-races"
	strip-unsupported-flags
}

_set_cxx() {
	if tc-is-clang && ! use clang ; then
eerror "Enable the clang USE flag or remove clang from CC/CXX"
		die
	fi
	_set_clang # Make llvm-config visible
	_set_gcc # Force gcc to avoid atomics errors
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	_set_cxx
	libcxx-slot_verify
	libstdcxx-slot_verify
	export MAKEOPTS="-j1"
ewarn "Total virtual memory should be 32 GiB to build"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}

	fi
}

src_prepare() {
	cmake_src_prepare

	local llvm_targets=""
	if [[ "${ARCH}" == "amd64" ]] ; then
		llvm_targets=";X86"
	elif [[ "${ARCH}" == "amd64" ]] ; then
		llvm_targets=";AArch64"
	else
eerror "ARCH=${ARCH} is not supported"
		die
	fi
	llvm_targets+=";WebAssembly"
	llvm_targets="${llvm_targets:1}"

	sed -i -e "s|AArch64;AMDGPU;ARM;AVR;BPF;Hexagon;Lanai;Mips;MSP430;NVPTX;PowerPC;RISCV;Sparc;SystemZ;VE;WebAssembly;X86;XCore|${llvm_targets}|g" \
		"cmake/Findllvm.cmake" \
		|| die

	local L=(
		"AArch64"
		"AMDGPU"
		"ARC"
		"ARM"
		"AVR"
		"BPF"
		"CSKY"
		"Hexagon"
		"Lanai"
		"LoongArch"
		"M68k"
		"Mips"
		"MSP430"
		"NVPTX"
		"PowerPC"
		"RISCV"
		"Sparc"
		"SPIRV"
		"SystemZ"
		"VE"
		"WebAssembly"
		"X86"
		"XCore"
		"Xtensa"
	)
	local x
	for x in "${L[@]}" ; do
		if ! has "llvm_targets_${x}" ${IUSE} ; then
einfo "Removing ${x} support (1)"
			sed -i \
				-e "/LLVMInitialize${x}Target/d" \
				-e "/LLVMInitialize${x}Asm/d" \
				"src/codegen/llvm.zig" \
				"src/codegen/llvm/bindings.zig" \
				|| die
		else
			if ! use "llvm_targets_${x}" ; then
einfo "Removing ${x} support (2)"
				sed -i \
					-e "/LLVMInitialize${x}Target/d" \
					-e "/LLVMInitialize${x}Asm/d" \
					"src/codegen/llvm.zig" \
					"src/codegen/llvm/bindings.zig" \
					|| die
			else
einfo "Added ${x} support"
			fi
		fi
	done
}

get_maxrss() {
	local debug=$(usex debug "debug" "release")
	local v=${MAXRSS["${ARCH}-${debug}"]}
	[[ -z "${v}" ]] && die "ARCH=${ARCH} is not supported"
	echo "${v}"
}

src_configure() {
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
		allow_lto=0
	fi

	fix_mb_len_max

	llvm-config --version || die

	local maxrss=$(get_maxrss)
einfo "MAXRSS:  ${maxrss}"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=RelWithDebInfo # Force -O2
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
		-DZIG_MAXRSS=${maxrss}
		-DZIG_NO_LIB=ON
		-DZIG_RELEASE_SAFE=$(usex debug)
		-DZIG_STATIC_LLVM=OFF
		-DZIG_STATIC_ZSTD=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	dhms_end
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"

	insinto "${INSTALL_PREFIX}/bin"
	doins -r "${S}/lib/"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
