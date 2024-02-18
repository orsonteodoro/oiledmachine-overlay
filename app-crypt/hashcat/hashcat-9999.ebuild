# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 )

inherit pax-utils python-single-r1 rocm toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
LICENSE="MIT"
SLOT="0"

LLVM_MAX_SLOT=14
ROCM_SLOTS=(
	5.3.3
	5.4.3
	5.5.1
	5.6.1
	5.7.1
)
rocm_gen_iuse() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 ${s})
		echo "
			rocm_${s_mm/./_}
		"
	done
}
IUSE="
$(rocm_gen_iuse)
brain
intel-opencl-cpu-runtime
orca
pocl
rocm
video_cards_amdgpu
video_cards_intel
video_cards_nvidia
"
rocm_gen_rocm_required_use1() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 ${s})
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
			|| (
	"
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s_mm=$(ver_cut 1-2 ${s})
		echo "
			rocm_${s_mm/./_}
		"
	done
	echo "
			)
		)
	"
}

gen_depend_rocm() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			~dev-util/hip-${s}:$(ver_cut 1-2 ${s})[hsa,lc,rocm]
		"
	done
}

REQUIRED_USE="
	$(rocm_gen_rocm_required_use1)
	$(rocm_gen_rocm_required_use2)
	orca? (
		video_cards_amdgpu
	)
	rocm? (
		video_cards_amdgpu
	)
	video_cards_amdgpu? (
		|| (
			orca
			rocm
		)
	)
	^^ (
		intel-opencl-cpu-runtime
		pocl
		video_cards_amdgpu
		video_cards_intel
		video_cards_nvidia
	)
"
RESTRICT="test"
DEPEND="
	!video_cards_nvidia? (
		virtual/opencl
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
		orca? (
			dev-libs/amdgpu-pro-opencl
		)
		rocm? (
			$(gen_depend_rocm)
			dev-libs/rocm-opencl-runtime
		)
	)
	video_cards_intel? (
		dev-libs/intel-compute-runtime
	)
	video_cards_nvidia? (
		>=dev-util/nvidia-cuda-toolkit-9
		>x11-drivers/nvidia-drivers-440.64
		virtual/opencl
	)
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	if use video_cards_amdgpu ; then
		python-single-r1_pkg_setup
		if use rocm_5_3 ; then
			LLVM_MAX_SLOT=15
			ROCM_SLOT="5.3"
		elif use rocm_5_4 ; then
			LLVM_MAX_SLOT=15
			ROCM_SLOT="5.4"
		elif use rocm_5_5 ; then
			LLVM_MAX_SLOT=16
			ROCM_SLOT="5.5"
		elif use rocm_5_6 ; then
			LLVM_MAX_SLOT=16
			ROCM_SLOT="5.6"
		elif use rocm_5_7 ; then
			LLVM_MAX_SLOT=17
			ROCM_SLOT="5.7"
		fi
		rocm_pkg_setup
	fi
}

src_prepare() {
	if use video_cards_amdgpu ; then
		rocm_src_prepare
	fi
	# Remove bundled stuff
	rm -r deps/OpenCL-Headers || die "Failed to remove bundled OpenCL Headers"
	rm -r deps/xxHash || die "Failed to remove bundled xxHash"

	# TODO: Gentoo's app-arch/lzma doesn't install the needed files
	#rm -r deps/LZMA-SDK || die "Failed to remove bundled LZMA-SDK"
	#rm -r deps || die "Failed to remove bundled deps"

	# Do not strip
	sed -i "/LFLAGS                  += -s/d" src/Makefile || die

	# Do not add random CFLAGS
	sed -i "s/-O2//" src/Makefile || die

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
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
		addwrite /dev/nvidiactl
		if [[ ! -w "/dev/nvidia0" ]]; then
			einfo "To run these tests, portage likely must be in the video group."
			einfo "Please run \"gpasswd -a portage video\" if the tests will fail"
		fi
	fi

	# This always exits with 255 despite success
	#./hashcat -b -m 2500 || die "Test failed"
	LD_PRELOAD="libhashcat.so.${PV}" \
	./hashcat -a 3 -m 1500 nQCk49SiErOgk || die "Test failed"
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
}
