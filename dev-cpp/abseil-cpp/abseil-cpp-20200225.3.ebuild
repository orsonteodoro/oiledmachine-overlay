# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO"
CXX_STANDARD=17 # Originally 11, 17 required by bear
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
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse3"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4_2"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cflags-hardened cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot python-any-r1

SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/abseil/abseil-cpp/commit/b957f0ccd00481cd4fd663d8320aa02ae0564f18.patch
	-> abseil-cpp-b957f0c.patch
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
cxx_standard_cxx11 cxx_standard_cxx14 +cxx_standard_cxx17 test
ebuild_revision_25
"
# Missing _mm_xor_si128 wrapper function for non sse2.
REQUIRED_USE="
	^^ (
		cxx_standard_cxx11
		cxx_standard_cxx17
	)
	amd64? (
		cpu_flags_x86_sse2
	)
	x86? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_sse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/patchelf
	test? (
		=dev-cpp/gtest-9999[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		sys-libs/timezone-data
	)
"
RESTRICT="
	test
	mirror
" # Configure time error with test
PATCHES=(
	"${DISTDIR}/${PN}-b957f0c.patch"
	"${FILESDIR}/${PN}-20200225.3-numeric_limits-fix.patch"
	"${FILESDIR}/${PN}-20200225.3-gcc-12-fix.patch"
	"${FILESDIR}/${PN}-20200225.3-gcc-13-fix.patch"
	"${FILESDIR}/${PN}-20200225.3-crypto-symbol.patch"
	"${FILESDIR}/${PN}-20200225.3-54fac21-backport.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

setup_aes_flags() {
	filter-flags '-m*fpu=neon'
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
		local oi=""
		local of=""
		local str=""
		local x
		if is-flagq '-march=armv*' || is-flagq '-mcpu=*' ; then
			oi=( $(echo "${CFLAGS}" | grep -o -E -e "-march=armv[.0-9a-z+-]+") )
			for x in ${oi[@]} ; do
				of=$(echo "${x}" | sed -E -e "s|[+-]crypto||g")
				replace-flags "${x}" "${of}+crypto"
				if use cpu_flags_arm_crypto ; then
					str=",\"${of}+crypto\""
				else
					str=",\"${of}-crypto\""
				fi
			done

			oi=( $(echo "${CFLAGS}" | grep -o -E -e "-mcpu=[.0-9a-z+-]+") )
			for x in ${oi[@]} ; do
				of=$(echo "${x}" | sed -E -e "s|[+-]crypto||g")
				replace-flags "${x}" "${of}+crypto"
				if use cpu_flags_arm_crypto ; then
					str=",\"${of}+crypto\""
				else
					str=",\"${of}-crypto\""
				fi
			done
			str="${str:1}"
			sed -i -e "s|__ARM64_CRYPTO_FLAGS__|${str}|" "absl/copts/copts.py" || die
		else
			sed -i -e "s|__ARM64_CRYPTO_FLAGS__||" "absl/copts/copts.py" || die
		fi
	fi

	filter-flags '-m*aes' '-m*sse4.2' '-m*avx'
	if ! [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		sed -i -e 's|__X86_CRYPTO_FLAGS__||' "absl/copts/copts.py" || die
	else
		local L=()
		local str=""
		if use cpu_flags_x86_aes ; then
			L+=(
				"-maes"
			)
			str+=',"-maes"'
		else
			L+=(
				"-mno-aes"
			)
			str+=',"-mno-aes"'
		fi

		if use cpu_flags_x86_sse4_2 ; then
			L+=(
				"-msse4.2"
			)
			str+=',"-msse4.2"'
		else
			L+=(
				"-mno-sse4.2"
			)
			str+=',"-mno-sse4.2"'
		fi

		if use cpu_flags_x86_avx ; then
			L+=(
				"-mavx"
			)
			str+=',"-mavx"'
		else
			L+=(
				"-mno-avx"
			)
			str+=',"-mno-avx"'
		fi
		str="${str:1}"

		append-flags "${L[@]}"
		sed -i -e "s|__X86_CRYPTO_FLAGS__|${str}|" "absl/copts/copts.py" || die
	fi

	filter-flags '-m*altivec' '-m*crypto' '-m*vsx'
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

setup_cpu_flags() {
	setup_aes_flags

	filter-flags '-msse2' '-mno-sse2'
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		if use cpu_flags_x86_sse2 ; then
			append-flags "-msse2"
		else
			append-flags "-mno-sse2"
		fi
	fi

	filter-flags '-msse3' '-mno-sse3'
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		if use cpu_flags_x86_sse3 ; then
			append-flags "-msse3"
		else
			append-flags "-mno-sse3"
		fi
	fi

	filter-flags '-mssse3' '-mno-ssse3'
	if [[ "${ARCH}" =~ ("amd64"|"x86") ]] ; then
		if use cpu_flags_x86_ssse3 ; then
			append-flags "-mssse3"
		else
			append-flags "-mno-ssse3"
		fi
	fi
}

src_prepare() {
	cmake_src_prepare
	setup_cpu_flags
	# Now generate cmake files
	python_fix_shebang "absl/copts/generate_copts.py"
	"absl/copts/generate_copts.py" || die
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(usex cxx_standard_cxx11 '-DCMAKE_CXX_STANDARD=11' '') # Default for this package and grpc
		$(usex cxx_standard_cxx14 '-DCMAKE_CXX_STANDARD=14' '')
		$(usex cxx_standard_cxx17 '-DCMAKE_CXX_STANDARD=17' '') # Required by Bear
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_PROPAGATE_CXX_STD=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=TRUE
		-DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/${PN}/${PV%%.*}"
	)

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	IFS=$'\n'
	local L=(
		$(find "${ED}" -name "*.so*")
	)
	local x
	for x in ${L[@]} ; do
		[[ -L "${x}" ]] && continue
einfo "Adding \$ORIGIN to RPATH for ${x}"
		patchelf \
			--add-rpath '$ORIGIN' \
			"${x}" \
			|| die
	done
	IFS=$' \t\n'
}
