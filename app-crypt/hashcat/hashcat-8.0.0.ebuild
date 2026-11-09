# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# This ebuild uses AI synthetic data and inference.

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CFLAGS_HARDENED_USE_CASE="security-critical sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_USE_CASE="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17 # Compiler default
PYTHON_COMPAT=( "python3_"{11..15} )
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1

BACKENDS=(
	iocl
	neo
	pocl
	rocm
	rusticl
	video_cards_intel
	video_cards_nvidia
)

declare -A GIT_CRATES=(
)

DISABLE_CRATES="
dynamic_hash-0.1.0
generic_hash-0.1.0
hashcat-sys-0.1.0
random-8.0.0
"

# From "./convert-cargo-lock.sh 8.0.0 8.0.0"
CRATES="
aho-corasick-1.1.3
base64-0.22.1
bcrypt-0.17.1
bindgen-0.72.1
bitflags-2.9.2
bitflags-2.9.3
bitflags-2.9.4
block-buffer-0.10.4
blowfish-0.9.1
byteorder-1.5.0
cexpr-0.6.0
cfg-if-1.0.1
cfg-if-1.0.3
cipher-0.4.4
clang-sys-1.8.1
cpufeatures-0.2.17
crypto-common-0.1.6
digest-0.10.7
either-1.15.0
equivalent-1.0.2
generic-array-0.14.7
getrandom-0.3.3
glob-0.3.3
hashbrown-0.17.1
hex-0.4.3
hmac-0.12.1
indexmap-2.14.0
inout-0.1.4
itertools-0.13.0
keccak-0.1.6
libc-0.2.175
libc-0.2.176
libloading-0.8.8
libloading-0.8.9
log-0.4.27
log-0.4.28
md2-0.10.2
md4-0.10.2
md-5-0.10.6
memchr-2.7.5
memchr-2.7.6
minimal-lexical-0.2.1
nom-7.1.3
pbkdf2-0.12.2
prettyplease-0.2.37
proc-macro2-1.0.101
proc-macro2-1.0.107
quote-1.0.40
quote-1.0.41
quote-1.0.47
r-efi-5.3.0
regex-1.11.1
regex-1.11.2
regex-1.11.3
regex-automata-0.4.10
regex-automata-0.4.11
regex-automata-0.4.9
regex-syntax-0.8.5
regex-syntax-0.8.6
rustc-hash-2.1.1
serde_core-1.0.229
serde_derive-1.0.229
serde_spanned-1.1.1
sha1-0.10.6
sha2-0.10.9
sha3-0.10.8
shlex-1.3.0
subtle-2.6.1
syn-2.0.106
syn-3.0.3
thread_local-1.1.9
toml-1.1.4+spec-1.1.0
toml_datetime-1.1.1+spec-1.1.0
toml_parser-1.1.3+spec-1.1.0
toml_writer-1.1.2+spec-1.1.0
typenum-1.18.0
unicode-ident-1.0.18
unicode-ident-1.0.19
unicode-ident-1.0.24
version_check-0.9.5
wasi-0.14.2+wasi-0.2.4
windows_aarch64_gnullvm-0.53.0
windows_aarch64_msvc-0.53.0
windows_i686_gnu-0.53.0
windows_i686_gnullvm-0.53.0
windows_i686_msvc-0.53.0
windows-link-0.1.3
windows-link-0.2.1
windows-targets-0.53.3
windows_x86_64_gnu-0.53.0
windows_x86_64_gnullvm-0.53.0
windows_x86_64_msvc-0.53.0
winnow-1.0.4
winresource-0.1.31
wit-bindgen-rt-0.39.0
zeroize-1.8.1
"

CHKL_TIMESTAMPS=(
	"media-libs/mesa-9999"
	"sci-ml/therock-9999"
)

inherit cargo cflags-hardened chkl libcxx-slot libstdcxx-slot pax-utils python-single-r1 rocm-r1
inherit rust rustflags-hardened secure-version toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
else
	KEYWORDS="~amd64"
	SRC_URI="
		$(cargo_crate_uris ${CRATES})
		https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="The World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
LICENSE="MIT"
RESTRICT="mirror test" # Speed up downloads and stop snooping
SLOT="0"
IUSE="
${BACKENDS[@]}
doc brain cuda rocm video_cards_nvidia
ebuild_revision_4
"
REQUIRED_USE="
	^^ (
		${BACKENDS[@]}
	)
"
RDEPEND="
	!cuda? (
		dev-util/opencl-headers:=
		virtual/opencl:=
	)
	app-arch/lzma:=
	virtual/opencl:=[iocl?,neo?,pocl?,rusticl?,video_cards_intel?,video_cards_nvidia?]
	>=virtual/zlib-${ZLIB_PV}:=[minizip]
	rocm? (
		>=sci-ml/therock-${THEROCK_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	video_cards_nvidia? (
		!cuda? (
			x11-drivers/nvidia-drivers:=
			virtual/opencl:*
		)
		cuda? (
			virtual/cuda-compiler:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			>=dev-util/nvidia-cuda-toolkit-12.9:=
			>=x11-drivers/nvidia-drivers-575.57:=
		)
	)
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
)

pkg_setup() {
	python-single-r1_pkg_setup
	rust_pkg_setup
	if use rocm ; then
		LLVM_SLOT="${ROCM_LLVM_SLOT}"
		rocm-r1_pkg_setup
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
#	die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_prepare() {
	# Remove bundled stuff
	rm -r "deps/OpenCL-Headers" || die "Failed to remove bundled OpenCL Headers"

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

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	rustflags-hardened_append	# For -sys crates
	default
}

src_compile() {
	tc-export CC CXX AR

	emake \
		ENABLE_BRAIN=$(usex brain 1 0) \
		ENABLE_CUBIN=$(usex cuda 1 0) \
		PRODUCTION=1 \
		SHARED=1 \
		USE_SYSTEM_OPENCL=1 \
		VERSION_PURE="${PV}"

	pax-mark -mr hashcat
}

src_test() {
	if use cuda ; then
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
		ENABLE_CUBIN=$(usex cuda 1 0) \
		PRODUCTION=1 \
		SHARED=1 \
		USE_SYSTEM_OPENCL=1 \
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
