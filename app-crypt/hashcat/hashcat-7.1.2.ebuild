# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

CXX_STANDARD=17 # Compiler default
PYTHON_COMPAT=( "python3_12" )

inherit hip-versions

ROCM_SLOTS=(
	"${HIP_6_4_VERSION}"
	"${HIP_7_0_VERSION}"
)
rocm_gen_iuse() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 "${s}")
		echo "
			rocm_${s_mm/./_}
		"
	done
}

inherit pax-utils python-single-r1 libcxx-slot libstdcxx-slot rocm toolchain-funcs

rocm_gen_rocm_required_use1() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 "${s}")
		echo "
			rocm_${s_mm/./_}? (
				rocm
			)
		"
	done
}
rocm_gen_rocm_required_use2() {
	echo "
		video_cards_amdgpu? (
			rocm? (
				|| (
	"
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 "${s}")
		echo "
			rocm_${s_mm/./_}
		"
	done
	echo "
				)
			)
		)
	"
}

gen_depend_rocm() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s2=$(ver_cut 1-2 ${s})
		echo "
			(
				~dev-util/hip-${s}:${s2}[${LIBSTDCXX_USEDEP},hsa,lc,rocm]
				~dev-libs/rocm-opencl-runtime-${s}:${s2}[${LIBSTDCXX_USEDEP}]
			)
		"
	done
}


if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="The World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
LICENSE="MIT"
RESTRICT="test"
SLOT="0"
IUSE="
$(rocm_gen_iuse)
doc
brain
intel-opencl-cpu-runtime
pocl
rocm
video_cards_amdgpu
video_cards_intel
video_cards_nvidia
ebuild_revision_1
"
REQUIRED_USE="
	$(rocm_gen_rocm_required_use1)
	$(rocm_gen_rocm_required_use2)
	rocm? (
		video_cards_amdgpu
	)
	^^ (
		intel-opencl-cpu-runtime
		pocl
		video_cards_amdgpu
		video_cards_intel
		video_cards_nvidia
	)
"
DEPEND="
	!video_cards_nvidia? (
		virtual/opencl
		dev-util/opencl-headers
	)
	app-arch/lzma
	app-arch/unrar
	sys-libs/zlib[minizip]
	brain? (
		dev-libs/xxhash
	)
	intel-opencl-cpu-runtime? (
		>=dev-util/intel-ocl-sdk-16.1.1
	)
	pocl? (
		dev-libs/pocl
	)
	video_cards_amdgpu? (
		!rocm? (
			dev-libs/amdgpu-pro-opencl-legacy
		)
		rocm? (
			$(gen_depend_rocm)
			dev-libs/rocm-opencl-runtime[${LIBSTDCXX_USEDEP}]
			dev-libs/rocm-opencl-runtime:=
			dev-util/hip[${LIBSTDCXX_USEDEP}]
			dev-util/hip:=
		)
	)
	video_cards_intel? (
		dev-libs/intel-compute-runtime
	)
	video_cards_nvidia? (
		virtual/cuda-compiler[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		virtual/cuda-compiler:=
		>=dev-util/nvidia-cuda-toolkit-12.9
		dev-util/nvidia-cuda-toolkit:=
		>=x11-drivers/nvidia-drivers-575.57
		virtual/opencl
	)
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
)

pkg_setup() {
	python-single-r1_pkg_setup
	if use rocm ; then
		if use rocm_6_4 ; then
			LLVM_SLOT=19
			ROCM_SLOT="6.4"
			ROCM_VERSION="${HIP_6_4_VERSION}"
		elif use rocm_6_4 ; then
			LLVM_SLOT=19
			ROCM_SLOT="6.4"
			ROCM_VERSION="${HIP_7_0_VERSION}"
		fi
		rocm_pkg_setup
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	if use rocm ; then
		rocm_src_prepare
	fi
	# Remove bundled stuff
	rm -r "deps/OpenCL-Headers" || die "Failed to remove bundled OpenCL Headers"
	rm -r "deps/xxHash" || die "Failed to remove bundled xxHash"

	# TODO: Gentoo's app-arch/lzma doesn't install the needed files
	#rm -r deps/LZMA-SDK || die "Failed to remove bundled LZMA-SDK"
	#rm -r deps || die "Failed to remove bundled deps"

	# Do not strip
	sed -i "/LFLAGS                  += -s/d" "src/Makefile" || die

	# Do not add random CFLAGS
	sed -i "s/-O2//" "src/Makefile" || die

	#sed -i "#LZMA_SDK_INCLUDE#d" src/Makefile || die

	# Respect CC, CXX, AR
	sed -i \
		-e 's/:= gcc/:= $(CC)/' \
		-e 's/:= g++/:= $(CXX)/' \
		-e 's/:= ar/:= $(AR)/' \
		src/Makefile || die

	export DOCUMENT_FOLDER="/usr/share/doc/${PF}"
	export LIBRARY_FOLDER="/usr/$(get_libdir)"
	export PREFIX="${EPREFIX}/usr"

	default

	sed -i -e "s|python3|${EPYTHON}|g" \
		$(grep -r -l -e "python3" "${WORKDIR}") \
		|| die
}

src_compile() {
	tc-export CC CXX AR

	# Use bundled unrar for now, bug #792720
	emake \
		ENABLE_BRAIN=$(usex brain 1 0) \
		ENABLE_CUBIN=$(usex video_cards_nvidia 1 0) \
		PRODUCTION=1 \
		SHARED=1 \
		USE_SYSTEM_LZMA=0 \
		USE_SYSTEM_OPENCL=1 \
		USE_SYSTEM_UNRAR=0 \
		USE_SYSTEM_XXHASH=1 \
		USE_SYSTEM_ZLIB=1 \
		VERSION_PURE="${PV}"

	pax-mark -mr hashcat
}

src_test() {
	if use video_cards_nvidia ; then
		addwrite "/dev/nvidia0"
		addwrite "/dev/nvidia-uvm"
		addwrite "/dev/nvidiactl"
		if [[ ! -w "/dev/nvidia0" ]]; then
			einfo "To run these tests, portage likely must be in the video group."
			einfo "Please run \"gpasswd -a portage video\" if the tests will fail"
		fi
	fi

	# This always exits with 255 despite success
	#./hashcat -b -m 2500 || die "Test failed"
	LD_PRELOAD="libhashcat.so.${PV}" \
	./hashcat -a 3 -m 1500 "nQCk49SiErOgk" || die "Test failed"
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		ENABLE_BRAIN=$(usex brain 1 0) \
		ENABLE_CUBIN=$(usex video_cards_nvidia 1 0) \
		PRODUCTION=1 \
		SHARED=1 \
		USE_SYSTEM_LZMA=0 \
		USE_SYSTEM_OPENCL=1 \
		USE_SYSTEM_UNRAR=1 \
		USE_SYSTEM_XXHASH=1 \
		USE_SYSTEM_ZLIB=1 \
		VERSION_PURE="${PV}" \
		install
	if use doc ; then
		dodoc -r "docs"
	fi
}

pkg_postinst() {
ewarn
ewarn "Using a single GPU alone is still slow.  For longer passwords,"
ewarn "consider using distributed multi machine hashcat methods instead."
ewarn
}
