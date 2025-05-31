# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
CFLAGS_HARDENED_CI_SANITIZERS="asan msan ubsan"
CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan tsan ubsan"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO NPD IO"
CRATES="
	syn@2.0.68
	proc-macro2@1.0.86
	quote@1.0.33
	unicode-ident@1.0.12
	paste@1.0.14
"
GCC_SLOT=12
LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.121"
LIBDRM_USEDEP="\
video_cards_freedreno?,\
video_cards_intel?,\
video_cards_nouveau?,\
video_cards_vc4?,\
video_cards_vivante?,\
video_cards_vmware?,\
"
LLVM_COMPAT=( {19..15} )
MY_P="${P/_/-}"
PATENT_STATUS=(
	"patent_status_nonfree"
)
PYTHON_COMPAT=( "python3_"{10..13} )
RADEON_CARDS=(
	"r300"
	"r600"
	"radeon"
	"radeonsi"
)
RUST_MAX_VER="1.85.0" # Inclusive
RUST_MIN_VER="1.71.1"
RUST_MULTILIB=1
RUST_OPTIONAL=1
UOPTS_BOLT_EXCLUDE_BINS="libglapi.so.0.0.0"
UOPTS_BOLT_EXCLUDE_FLAGS=( "-hugify" ) # Broken
UOPTS_SUPPORT_EBOLT=1
UOPTS_SUPPORT_EPGO=1
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
VIDEO_CARDS=(
	${RADEON_CARDS[@]}
	"d3d12"
	"freedreno"
	"intel"
	"lavapipe"
	"lima"
	"nouveau"
	"nvk"
	"panfrost"
	"v3d"
	"vc4"
	"virgl"
	"vivante"
	"vmware"
	"zink"
)

# Bug
inherit cargo
inherit cflags-hardened check-compiler-switch flag-o-matic llvm-r1 python-any-r1 linux-info meson multilib-build toolchain-funcs uopts

LLVM_USE_DEPS="llvm_targets_AMDGPU(+),${MULTILIB_USEDEP}"

for card in ${VIDEO_CARDS[@]} ; do
	IUSE_VIDEO_CARDS+="
		video_cards_${card}
	"
done
unset card

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	KEYWORDS="
~amd64 ~amd64-linux ~arm ~arm-linux ~arm64 ~arm64-linux ~loong ~mips ~ppc ~ppc64
~riscv ~s390 ~sparc ~x86 ~x86-linux
	"
	SRC_URI="
		https://archive.mesa3d.org/${MY_P}.tar.xz
	"
fi
S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR="${S}"

# This should be {CARGO_CRATE_URIS//.crate/.tar.gz} to correspond to the wrap files,
# but there are "stale" distfiles on the mirrors with the wrong names.
# export MESON_PACKAGE_CACHE_DIR="${DISTDIR}"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"
LICENSE="MIT SGI-B-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE+="
${IUSE_VIDEO_CARDS}
${LLVM_COMPAT[@]/#/llvm_slot_}
${PATENT_STATUS[@]}
cpu_flags_x86_sse2 d3d9 debug +llvm lm-sensors opencl +opengl
osmesa selinux test unwind vaapi valgrind vdpau vulkan
wayland +X xa +zstd
ebuild_revision_4
"
REQUIRED_USE="
	d3d9? (
		|| (
			video_cards_freedreno
			video_cards_intel
			video_cards_nouveau
			video_cards_panfrost
			video_cards_r300
			video_cards_r600
			video_cards_radeonsi
			video_cards_vmware
			video_cards_zink
		)
	)
	video_cards_lavapipe? (
		llvm
		vulkan
	)
	video_cards_nvk? (
		vulkan video_cards_nouveau
	)
	video_cards_radeon? (
		amd64? (
			llvm
		)
		x86? (
			llvm
		)
	)
	video_cards_r300?   (
		amd64? (
			llvm
		)
		x86? (
			llvm
		)
	)
	video_cards_zink? (
		vulkan
		opengl
	)
	vdpau? (
		X
	)
	xa? (
		X
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
RDEPEND="
	${LIBDRM_DEPSTRING}[${LIBDRM_USEDEP}${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-util/spirv-tools-1.3.231.0[${MULTILIB_USEDEP}]
	>=media-libs/libglvnd-1.3.2[X?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.9[${MULTILIB_USEDEP}]
	virtual/patent-status[patent_status_nonfree=]
	llvm? (
		video_cards_r600? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
		video_cards_radeon? (
			virtual/libelf:0=[${MULTILIB_USEDEP}]
		)
	)
	lm-sensors? (
		sys-apps/lm-sensors:=[${MULTILIB_USEDEP}]
	)
	opencl? (
		>=virtual/opencl-3
		llvm-core/libclc[spirv(-)]
		virtual/libelf:0=
	)
	selinux? (
		sys-libs/libselinux[${MULTILIB_USEDEP}]
	)
	unwind? (
		sys-libs/libunwind[${MULTILIB_USEDEP}]
	)
	vaapi? (
		>=media-libs/libva-1.7.3:=[${MULTILIB_USEDEP}]
	)
	vdpau? (
		>=x11-libs/libvdpau-1.5:=[${MULTILIB_USEDEP}]
	)
	video_cards_radeonsi? (
		virtual/libelf:0=[${MULTILIB_USEDEP}]
	)
	video_cards_zink? (
		media-libs/vulkan-loader:=[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.17:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxshmfence-1.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-keysyms[${MULTILIB_USEDEP}]
	)
	zstd? (
		app-arch/zstd:=[${MULTILIB_USEDEP}]
	)
"
for card in ${RADEON_CARDS[@]} ; do
	RDEPEND="
		${RDEPEND}
		video_cards_${card}? (
			${LIBDRM_DEPSTRING}[video_cards_radeon]
		)
	"
done
unset card
RDEPEND="
	${RDEPEND}
	video_cards_radeonsi? (
		${LIBDRM_DEPSTRING}[video_cards_amdgpu]
	)
"
# Please keep the LLVM dependency block separate. Since LLVM is slotted, \
# we need to *really* make sure we're not pulling one than more slot \
# simultaneously. \
gen_llvm_depstr() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				!opencl? (
					llvm-core/llvm:${s}[${LLVM_USE_DEPS}]
				)
				opencl? (
					dev-util/spirv-llvm-translator:${s}
					llvm-core/clang:${s}[${LLVM_USE_DEPS}]
				)
			)
		"
	done
}
LLVM_DEPSTR="
	$(gen_llvm_depstr)
	!opencl? (
		llvm-core/llvm:=[${LLVM_USE_DEPS}]
	)
	opencl? (
		llvm-core/clang:=[${LLVM_USE_DEPS}]
	)
"
RDEPEND="
	${RDEPEND}
	llvm? (
		${LLVM_DEPSTR}
	)
"
unset {LLVM,PER_SLOT}_DEPSTR
DEPEND="
	${RDEPEND}
	valgrind? (
		dev-debug/valgrind
	)
	video_cards_d3d12? (
		>=dev-util/directx-headers-1.614.1[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-protocols-1.38
	)
	X? (
		x11-base/xorg-proto
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	$(python_gen_any_dep "
		>=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]
		dev-python/packaging[\${PYTHON_USEDEP}]
		dev-python/pyyaml[\${PYTHON_USEDEP}]
	")
	${PYTHON_DEPS}
	>=dev-build/meson-1.3.1
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	opencl? (
		>=dev-util/bindgen-0.58.0
		llvm_slot_15? (
			|| (
				=dev-lang/rust-1.69*
				=dev-lang/rust-1.68*
				=dev-lang/rust-1.67*
				=dev-lang/rust-1.66*
				=dev-lang/rust-1.65*
				=dev-lang/rust-bin-1.69*
				=dev-lang/rust-bin-1.68*
				=dev-lang/rust-bin-1.67*
				=dev-lang/rust-bin-1.66*
				=dev-lang/rust-bin-1.65*
			)
		)
		llvm_slot_16? (
			|| (
				=dev-lang/rust-1.72*
				=dev-lang/rust-1.71*
				=dev-lang/rust-1.70*
				=dev-lang/rust-bin-1.72*
				=dev-lang/rust-bin-1.71*
				=dev-lang/rust-bin-1.70*
			)
		)
		llvm_slot_17? (
			|| (
				=dev-lang/rust-1.77*
				=dev-lang/rust-1.75*
				=dev-lang/rust-1.75*
				=dev-lang/rust-1.74*
				=dev-lang/rust-1.73*
				=dev-lang/rust-bin-1.77*
				=dev-lang/rust-bin-1.75*
				=dev-lang/rust-bin-1.75*
				=dev-lang/rust-bin-1.74*
				=dev-lang/rust-bin-1.73*
			)
		)
		llvm_slot_18? (
			|| (
				=dev-lang/rust-1.81*
				=dev-lang/rust-1.80*
				=dev-lang/rust-1.79*
				=dev-lang/rust-1.78*
				=dev-lang/rust-bin-1.81*
				=dev-lang/rust-bin-1.80*
				=dev-lang/rust-bin-1.79*
				=dev-lang/rust-bin-1.78*
			)
		)
		llvm_slot_19? (
			|| (
				=dev-lang/rust-1.82*
				=dev-lang/rust-1.83*
				=dev-lang/rust-1.84*
				=dev-lang/rust-1.85*
				=dev-lang/rust-bin-1.82*
				=dev-lang/rust-bin-1.83*
				=dev-lang/rust-bin-1.84*
				=dev-lang/rust-bin-1.85*
			)
		)
		|| (
			dev-lang/rust:=
			dev-lang/rust-bin:=
		)
	)
	video_cards_intel? (
		$(python_gen_any_dep "
			dev-python/ply[\${PYTHON_USEDEP}]
		")
		llvm-core/libclc[spirv(-)]
		~dev-util/intel_clc-${PV}
	)
	vulkan? (
		dev-util/glslang
		video_cards_nvk? (
			>=dev-util/bindgen-0.68.1
			>=dev-util/cbindgen-0.26.0
			|| (
				(
					>=dev-lang/rust-1.74.1
					dev-lang/rust:=
				)
				(
					>=dev-lang/rust-bin-1.74.1
					dev-lang/rust-bin:=
				)
			)
		)
	)
	wayland? (
		dev-util/wayland-scanner
	)
"
QA_WX_LOAD="
	x86? (
		usr/lib/libglapi.so.0.0.0
		usr/lib/libGLX_mesa.so.0.0.0
		usr/lib/libOSMesa.so.8.0.0
	)
"

llvm_check_deps() {
	if use opencl ; then
		has_version "llvm-core/clang:${LLVM_SLOT}[${LLVM_USE_DEPS}]" || return 1
		has_version "dev-util/spirv-llvm-translator:${LLVM_SLOT}" || return 1
	fi
	has_version "llvm-core/llvm:${LLVM_SLOT}[${LLVM_USE_DEPS}]"
}

ignore_video_card_use() {
	local missing=1
	local flag="${1}"
	shift
	local cards=( $@ )
	if use ${flag} ; then
		for name in ${cards[@]} ; do
			if use "video_cards_${name}" ; then
				missing=0
			fi
		done
	fi
	if (( ${missing} == 1 )) ; then
ewarn "Ignoring USE=${flag} since VIDEO_CARDS does not contain -- ${cards[@]}"
	fi
}

# $1 - VIDEO_CARDS flag (check skipped for "--")
# other args - names of DRI drivers to enable
gallium_enable() {
	if [[ $1 == -- ]] || use $1 ; then
		shift
		GALLIUM_DRIVERS+=( "$@" )
	fi
}

vulkan_enable() {
	if [[ $1 == -- ]] || use $1 ; then
		shift
		VULKAN_DRIVERS+=( "$@" )
	fi
}

python_check_deps() {
	python_has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]" \
		|| return 1
	python_has_version -b "dev-python/packaging[${PYTHON_USEDEP}]" \
		&& python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" \
		|| return 1
	if use llvm && use vulkan && use video_cards_intel && use amd64 ; then
		python_has_version -b "dev-python/ply[${PYTHON_USEDEP}]" \
			|| return 1
	fi
}

check_libstdcxx() {
# Prevent error:
#../mesa-24.0.4/src/util/fossilize_db.c:360:20: error: use of undeclared identifier 'PATH_MAX'
#   char list_entry[PATH_MAX];
#                   ^
#../mesa-24.0.4/src/util/fossilize_db.c:428:50: error: use of undeclared identifier 'NAME_MAX'
#   char buf[10 * (sizeof(struct inotify_event) + NAME_MAX + 1)];
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${GCC_SLOT}" ; then
eerror
eerror "You must switch to GCC ${GCC_SLOT}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${GCC_SLOT}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
#		die
	fi
}

# From toolchain-funcs.eclass.
# Fixes inherit bug
# @FUNCTION: tc-is-lto
# @RETURN: Shell true if we are using LTO, shell false otherwise
tc-is-lto() {
        local f="${T}/test-lto.o"

        case $(tc-get-compiler-type) in
                clang)
                        $(tc-getCC) ${CFLAGS} -c -o "${f}" -x c - <<<"" || die
                        # If LTO is used, clang will output bytecode and llvm-bcanalyzer
                        # will run successfully.  Otherwise, it will output plain object
                        # file and llvm-bcanalyzer will exit with error.
                        llvm-bcanalyzer "${f}" &>/dev/null && return 0
                        ;;
                gcc)
                        $(tc-getCC) ${CFLAGS} -c -o "${f}" -x c - <<<"" || die
                        [[ $($(tc-getREADELF) -S "${f}") == *.gnu.lto* ]] && return 0
                        ;;
        esac
        return 1
}

pkg_pretend() {
	ignore_video_card_use "vulkan" "d3d12" "freedreno" "intel" "lavapipe" "nouveau" "nvk" "panfrost" "radeonsi" "v3d" "virgl"
	ignore_video_card_use "vaapi" "d3d12" "nouveau" "r600" "radeonsi" "virgl"
	ignore_video_card_use "vdpau" "d3d12" "nouveau" "r300" "r600" "radeonsi" "virgl"
	ignore_video_card_use "xa" "freedreno" "intel" "nouveau" "vmware"

	if ! use llvm ; then
		if use opencl ; then
ewarn "Ignoring USE=opencl since USE does not contain llvm"
		fi
	fi

	if use osmesa && ! use llvm ; then
ewarn "OSMesa will be slow without enabling USE=llvm"
	fi
}

pkg_setup() {
	check-compiler-switch_start
	check_libstdcxx
	# Warning message for bug 459306
	if use llvm && has_version "llvm-core/llvm[!debug=]" ; then
ewarn
ewarn "Mismatch between debug USE flags in media-libs/mesa and llvm-core/llvm"
ewarn "detected! This can cause problems. For details, see bug 459306."
ewarn
	fi

	if use video_cards_intel ||
	   use video_cards_radeonsi \
	; then
		if kernel_is -ge 5 11 3 ; then
			CONFIG_CHECK="~KCMP"
		elif kernel_is -ge 5 11 ; then
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		elif kernel_is -ge 5 10 20 ; then
			CONFIG_CHECK="~KCMP"
		else
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		fi
		linux-info_pkg_setup
	fi

	if use llvm ; then
		local llvm_slot
		for llvm_slot in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${llvm_slot}" ; then
				LLVM_SLOT="${llvm_slot}"
				break
			fi
		done
		llvm-r1_pkg_setup
einfo "PATH=${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"
	fi
	python-any-r1_pkg_setup
	uopts_setup

	if use opencl || ( use vulkan && use video_cards_nvk ) ; then
		rust_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" == "9999" ]] ; then
		git-r3_src_unpack
	else
		unpack "${MY_P}.tar.xz"
	fi

	# We need this because we cannot tell meson to use DISTDIR yet
	pushd "${DISTDIR}" >/dev/null 2>&1 || die
		mkdir -p "${S}/subprojects/packagecache" || die
		local i
		for i in *".crate" ; do
			ln -s \
				"${PWD}/${i}" \
				"${S}/subprojects/packagecache/${i/.crate/}.tar.gz" \
				|| die
		done
	popd >/dev/null 2>&1 || die
}

src_prepare() {
	default
	sed -i \
		-e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," \
		bin/symbols-check.py \
		|| die # bug #830728

	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

_src_configure_compiler() {
	if use llvm ; then
		local llvm_slot
		for llvm_slot in ${LLVM_COMPAT[@]} ; do
			use "llvm_slot_${llvm_slot}" && break
		done
		export CC="${CHOST}-clang-${llvm_slot}"
		export CXX="${CHOST}-clang++-${llvm_slot}"
		export CPP="${CC} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
	fi
	strip-unsupported-flags
}

src_configure() { :; }

_src_configure() {
	local emesonargs=()

	# bug #932591 and https://gitlab.freedesktop.org/mesa/mesa/-/issues/11140
	filter-lto

	uopts_src_configure

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local platforms
	use X && platforms+="x11"
	use wayland && platforms+=",wayland"
	emesonargs+=(
		-Dplatforms=${platforms#,}
	)

	if use video_cards_freedreno ||
	   use video_cards_intel || # crocus i915 iris
	   use video_cards_nouveau ||
	   use video_cards_panfrost ||
	   use video_cards_r300 ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_vmware || # svga
	   use video_cards_zink \
	; then
		emesonargs+=(
			$(meson_use d3d9 gallium-nine)
		)
	else
		emesonargs+=(
			-Dgallium-nine=false
		)
	fi

	if use video_cards_d3d12 ||
	   use video_cards_nouveau ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_virgl \
	; then
		emesonargs+=(
			$(meson_feature vaapi gallium-va)
		)
		use vaapi && emesonargs+=(
			-Dva-libs-path="${EPREFIX}/usr/$(get_libdir)/va/drivers"
		)
	else
		emesonargs+=(
			-Dgallium-va=disabled
		)
	fi

	if use video_cards_d3d12 ; then
		emesonargs+=(
			$(meson_feature vaapi gallium-d3d12-video)
		)
	fi

	if use video_cards_d3d12 ||
	   use video_cards_nouveau ||
	   use video_cards_r600 ||
	   use video_cards_radeonsi ||
	   use video_cards_virgl \
	; then
		emesonargs+=(
			$(meson_feature vdpau gallium-vdpau)
		)
	else
		emesonargs+=(
			-Dgallium-vdpau=disabled
		)
	fi

	if use video_cards_freedreno ||
	   use video_cards_intel ||
	   use video_cards_nouveau ||
	   use video_cards_vmware \
	; then
		emesonargs+=(
			$(meson_feature xa gallium-xa)
		)
	else
		emesonargs+=(
			-Dgallium-xa=disabled
		)
	fi

	gallium_enable !llvm softpipe
	gallium_enable llvm llvmpipe
	gallium_enable video_cards_d3d12 d3d12
	gallium_enable video_cards_freedreno freedreno
	gallium_enable video_cards_intel crocus i915 iris
	gallium_enable video_cards_lima lima
	gallium_enable video_cards_nouveau nouveau
	gallium_enable video_cards_panfrost panfrost
	gallium_enable video_cards_r300 r300
	gallium_enable video_cards_r600 r600
	gallium_enable video_cards_radeonsi radeonsi
	gallium_enable video_cards_v3d v3d
	gallium_enable video_cards_vc4 vc4
	gallium_enable video_cards_virgl virgl
	gallium_enable video_cards_vivante etnaviv
	gallium_enable video_cards_vmware svga
	gallium_enable video_cards_zink zink

	if \
		! use video_cards_r300 && \
		! use video_cards_r600 \
	; then
		gallium_enable video_cards_radeon r300 r600
	fi

	if use llvm && use opencl ; then
		PKG_CONFIG_PATH="$(get_llvm_prefix)/$(get_libdir)/pkgconfig"
	# See https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/docs/rusticl.rst
		emesonargs+=(
			$(meson_native_true gallium-rusticl)
			-Drust_std=2021
		)
	fi

	if use vulkan ; then
		vulkan_enable video_cards_d3d12 microsoft-experimental
		vulkan_enable video_cards_freedreno freedreno
		vulkan_enable video_cards_intel intel intel_hasvk
		vulkan_enable video_cards_lavapipe swrast
		vulkan_enable video_cards_panfrost panfrost
		vulkan_enable video_cards_radeonsi amd
		vulkan_enable video_cards_v3d broadcom
		vulkan_enable video_cards_vc4 broadcom
		vulkan_enable video_cards_virgl virtio
		if use video_cards_nvk; then
			vulkan_enable video_cards_nvk nouveau
			if ! multilib_is_native_abi; then
				echo -e "[binaries]\nrust = ['rustc', '--target=$(rust_abi $CBUILD)']" > "${T}/rust_fix.ini"
				emesonargs+=(
					--native-file "${T}"/rust_fix.ini
				)
			fi
		fi
		emesonargs+=(
			-Dvulkan-layers=device-select,overlay
		)
	fi

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	if use opengl && use X ; then
		emesonargs+=(
			-Dglx=dri
		)
	else
		emesonargs+=(
			-Dglx=disabled
		)
	fi

	if [[ "${ABI}" == "amd64" ]]; then
		emesonargs+=(
			$(meson_feature video_cards_intel intel-rt)
		)
	fi

	use debug && EMESON_BUILDTYPE="debug"

	emesonargs+=(
		$(meson_feature opengl gbm)
		$(meson_feature opengl gles1)
		$(meson_feature opengl gles2)
		$(meson_feature opengl glvnd)
		$(meson_feature opengl egl)
		$(meson_feature llvm)
		$(meson_feature lm-sensors lmsensors)
		$(meson_feature unwind libunwind)
		$(meson_feature zstd)
		$(meson_use cpu_flags_x86_sse2 sse2)
		$(meson_use opengl)
		$(meson_use osmesa)
		$(meson_use selinux)
		$(meson_use test build-tests)
		-Db_ndebug=$(usex debug false true)
		-Dexpat=enabled
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dintel-clc=$(usex video_cards_intel system auto)
		-Dlegacy-x11=dri2
		-Dshared-glapi=enabled
		-Dvalgrind=$(usex valgrind auto disabled)
		-Dvideo-codecs=$(usex patent_status_nonfree "all" "all_free")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
	)
	meson_src_configure

	if ! multilib_is_native_abi && use video_cards_nvk ; then
		sed -i -E \
			-e '{N; s/(rule rust_COMPILER_FOR_BUILD\n command = rustc) --target=[a-zA-Z0-9=:-]+ (.*) -C link-arg=-m[[:digit:]]+/\1 \2/g}' \
			"build.ninja" \
			|| die
	fi
}

_src_compile() {
	if [[ "${ABI}" == "x86" ]] ; then
		# Bug 939803
		BINDGEN_EXTRA_CLANG_ARGS="-m32" \
		meson_src_compile
	else
		meson_src_compile
	fi
}

src_compile() {
	compile_abi() {
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

_src_test() {
	meson_src_test -t 100
}

src_test() {
	test_abi() {
		_src_test
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		meson_src_install
		uopts_src_install
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo, bolt
