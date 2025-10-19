# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO"
CXX_STANDARD=14
PYTHON_COMPAT=( "python3_"{8..11} )

CPU_FLAGS_ARM=(
	"cpu_flags_arm_crypto"
	"cpu_flags_arm_neon"
)

CPU_FLAGS_PPC=(
	"cpu_flags_ppc_altivec"
	"cpu_flags_ppc_crypto"
	"cpu_flags_ppc_vsx"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_aes"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_sse4_2"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX14[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}
)

inherit cflags-hardened cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot python-any-r1

SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="
	Apache-2.0
	test? (
		BSD
	)
"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="${PV%%.*}/${PV}"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_X86[@]}
test
ebuild_revision_17
"
REQUIRED_USE="
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
"
BDEPEND+="
	${PYTHON_DEPS}
	test? (
		=dev-cpp/gtest-9999[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		sys-libs/timezone-data
	)
"
RESTRICT="
	!test? (
		test
	)
	mirror
"
PATCHES=(
	"${FILESDIR}/${PN}-20200225.3-crypto-symbol.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

setup_aes_flags() {
	if [[ "${ARCH}" != "arm" ]] ; then
		sed -i -e 's|__ARM_CRYPTO_FLAGS__||' "absl/copts/copts.py" || die
	elif [[ "${ARCH}" == "arm" ]] && use cpu_flags_arm_neon ; then
		sed -i -e 's|__ARM_CRYPTO_FLAGS__|"-mfpu=neon"|' "absl/copts/copts.py" || die
	else
		sed -i -e 's|__ARM_CRYPTO_FLAGS__||' "absl/copts/copts.py" || die
	fi

	if [[ "${ARCH}" != "arm64" ]] ; then
		sed -i -e 's|__ARM64_CRYPTO_FLAGS__||' "absl/copts/copts.py" || die
	else
	# Handle armv8-r and armv8-a
		if use cpu_flags_arm_crypto && is-flagq '-march=armv8*' ; then
                        local oi=$(echo "${CXXFLAGS}" | grep -o -E -e "-march=armv[.0-9a-z+-]+")
                        local of=$(echo "${CXXFLAGS}" | grep -o -E -e "-march=armv[.0-9a-z+-]+" | sed -E -e "s|[+-]crypto||g")
			sed -i -e 's|__ARM64_CRYPTO_FLAGS__|${of}+crypto|' "absl/copts/copts.py" || die
		elif ! use cpu_flags_arm_crypto && is-flagq '-march=armv8*' ; then
                        local oi=$(echo "${CXXFLAGS}" | grep -o -E -e "-march=armv[.0-9a-z+-]+")
                        local of=$(echo "${CXXFLAGS}" | grep -o -E -e "-march=armv[.0-9a-z+-]+" | sed -E -e "s|[+-]crypto||g")
			sed -i -e 's|__ARM64_CRYPTO_FLAGS__|${of}-crypto|' "absl/copts/copts.py" || die
		fi
	fi

	if ! [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		sed -i -e 's|__X86_CRYPTO_FLAGS__||' "absl/copts/copts.py" || die
	elif use cpu_flags_x86_aes && use cpu_flags_x86_aes && use cpu_flags_x86_sse4_2 ; then
		sed -i -e 's|__X86_CRYPTO_FLAGS__|"-maes","-msse4.2","-mavx"|' "absl/copts/copts.py" || die
	elif use cpu_flags_x86_aes && use cpu_flags_x86_sse4_2 ; then
		sed -i -e 's|__X86_CRYPTO_FLAGS__|"-maes","-msse4.2","-mno-avx"|' "absl/copts/copts.py" || die
	elif use cpu_flags_x86_aes ; then
		sed -i -e 's|__X86_CRYPTO_FLAGS__|"-maes","-mno-sse4.2","-mno-avx"|' "absl/copts/copts.py" || die
	else
		sed -i -e 's|__X86_CRYPTO_FLAGS__|"-mno-aes","-mno-avx","-mno-sse4.2"|' "absl/copts/copts.py" || die
	fi

	if [[ "${ARCH}" =~ ("ppc"$|"ppc64") ]] ; then
		if use cpu_flags_ppc_altivec ; then
			append-flags "-maltivec"
		else
			append-flags "-mno-altivec"
		fi
		if use cpu_flags_ppc_crypto ; then
			append-flags "-mcrypto"
		else
			append-flags "-mno-crypto"
		fi
		if use cpu_flags_ppc_vsx ; then
			append-flags "-mvsx"
		else
			append-flags "-mno-vsx"
		fi
	fi
}

src_prepare() {
	cmake_src_prepare
	setup_aes_flags
	# Now generate cmake files
	python_fix_shebang "absl/copts/generate_copts.py"
	"absl/copts/generate_copts.py" || die
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DABSL_BUILD_TESTING=$(usex test ON OFF)
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_PROPAGATE_CXX_STD=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=TRUE
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${PV%%.*}"
		$(usex test -DBUILD_TESTING=ON '')
	)
	cmake-multilib_src_configure
}
