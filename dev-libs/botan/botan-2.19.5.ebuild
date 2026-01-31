# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:  Remove or make unused ciphers optional

MY_P="Botan-${PV}"

CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data"
CXX_STANDARD=11
PYTHON_COMPAT=( "python3_"{10..12} )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/botan.asc"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

declare -A ALGS=(
	["aes_armv8"]=0
	["aes_ni"]=0
	["aes_power8"]=0
	["aes_vperm"]=0
	["argon2_ssse3"]=0
	["chacha_avx2"]=0
	["chacha_simd32"]=0
	["ghash_cpu"]=0
	["ghash_vperm"]=0
	["idea_sse2"]=0
	["noekeon_simd"]=0
	["processor_rng"]=0
	["rdseed"]=0
	["serpent_avx2"]=0
	["serpent_simd"]=0
	["sha1_armv8"]=0
	["sha1_avx2"]=0
	["sha1_simd"]=0
	["sha1_x86"]=0
	["sha2_32_simd"]=0
	["sha2_32_x86"]=0
	["shacal2_avx2"]=0
	["shacal2_simd"]=0
	["shacal2_x86"]=0
	["simd_avx2"]=0
	["sm4_armv8"]=0
	["zfec_sse2"]=0
	["zfec_vperm"]=0
)

inherit cflags-hardened check-compiler-switch edo flag-o-matic libcxx-slot
inherit libstdcxx-slot multiprocessing python-r1 toolchain-funcs verify-sig

# We don't list 32-bit because of unpatched vulnerabilities in those arches.
KEYWORDS="
~amd64 ~arm64 ~hppa ~loong ~ppc64 ~riscv ~sparc
"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://botan.randombit.net/releases/${MY_P}.tar.xz
	verify-sig? (
https://botan.randombit.net/releases/${MY_P}.tar.xz.asc
	)
"

DESCRIPTION="C++ crypto library"
HOMEPAGE="https://botan.randombit.net/"
LICENSE="BSD-2"
# New major versions are parallel-installable
SLOT="$(ver_cut 1)/$(ver_cut 1-2)" # soname version
IUSE="
doc boost bzip2 lzma python static-libs sqlite test tools zlib
ebuild_revision_40
"
CPU_USE=(
	"cpu_flags_arm_"{"crypto","neon","pmull"}
	"cpu_flags_ppc_"{"altivec","power8","power9"}
	"cpu_flags_x86_"{"aes","avx2","bmi2","clmul","rdrnd","rdseed","sha","sse2","sse4_1","ssse3"}
)
IUSE+=" ${CPU_USE[@]}"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_bmi2? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_aes? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_sha? (
		cpu_flags_x86_aes
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_rdseed? (
		cpu_flags_x86_sse4_1
	)
	cpu_flags_x86_rdrnd? (
		cpu_flags_x86_sse4_1
	)
"

# NOTE: Boost is needed at runtime too for the CLI tool.
DEPEND="
	boost? (
		dev-libs/boost[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
	)
	bzip2? (
		>=app-arch/bzip2-1.0.5:=
	)
	lzma? (
		app-arch/xz-utils:=
	)
	python? (
		${PYTHON_DEPS}
	)
	sqlite? (
		dev-db/sqlite:3=
	)
	zlib? (
		>=sys-libs/zlib-1.2.3:=
	)
"
RDEPEND="
	${DEPEND}
	!<dev-libs/botan-3.0.0-r1:3[tools]
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
		)
	')
	verify-sig? (
		sec-keys/openpgp-keys-botan
	)
"

# NOTE: Considering patching Botan?
# Please see upstream's guidance:
# https://botan.randombit.net/handbook/packaging.html#minimize-distribution-patches

PATCHES=(
	"${FILESDIR}/${P}-no-distutils.patch"
	"${FILESDIR}/${P}-boost-1.87.patch"
	"${FILESDIR}/${P}-cloudflare.patch"
)

python_check_deps() {
	use doc || return 0
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	check-compiler-switch_start
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	python_setup

	local disable_modules=(
		$(usev !boost 'boost')
	)

	if [[ -z "${DISABLE_MODULES}" ]] ; then
elog "Disabling module(s): ${disable_modules[@]}"
	fi

	local chostarch="${CHOST%%-*}"

	# Arch specific wrangling
	local myos=
	case "${CHOST}" in
		*-darwin*)
			myos="darwin"
			;;
		*)
			myos="linux"

			if [[ "${CHOST}" == *"hppa"* ]] ; then
				chostarch="parisc"
			elif [[ "${ABI}" == "sparc64" ]] ; then
				chostarch="sparc64"
			elif [[ "${ABI}" == "sparc32" ]] ; then
				chostarch="sparc32"
			fi
			;;
	esac

	local pythonvers=()
	if use python ; then
		_append() {
			pythonvers+=(
				${EPYTHON/python/}
			)
		}

		python_foreach_impl _append
	fi

	local myargs=(
		# Intrinsics
		$(usev !cpu_flags_arm_crypto '--disable-armv8crypto')
		$(usev !cpu_flags_arm_neon '--disable-neon')
		$(usev !cpu_flags_ppc_altivec '--disable-altivec')
		$(usev !cpu_flags_x86_aes '--disable-aes-ni')
		$(usev !cpu_flags_x86_sha '--disable-sha-ni')
		$(usev !cpu_flags_x86_avx2 '--disable-avx2')
		$(usev !cpu_flags_x86_bmi2 '--disable-bmi2')
		$(usev !cpu_flags_x86_popcnt '--disable-bmi2')
		$(usev !cpu_flags_x86_rdrnd '--disable-rdrnd')
		$(usev !cpu_flags_x86_rdseed '--disable-rdseed')
		$(usev !cpu_flags_x86_sha '--disable-sha-ni')
		$(usev !cpu_flags_x86_sse2 '--disable-sse2')
		$(usev !cpu_flags_x86_ssse3 '--disable-ssse3')
		$(usev !cpu_flags_x86_sse4_1 '--disable-sse4.1')
		$(usev !cpu_flags_x86_sse4_2 '--disable-sse4.2')

	# HPPA's GCC doesn't support SSP
		$(usev hppa '--without-stack-protector')

		$(use_with boost)
		$(use_with bzip2)
		$(use_with doc documentation)
		$(use_with doc sphinx)
		$(use_with lzma)
		$(use_enable static-libs static-library)
		$(use_with sqlite sqlite3)
		$(use_with zlib)

		--cpu="${chostarch}"
		--docdir="share/doc"
		--disable-modules=$(IFS=","; echo "${disable_modules[*]}")
		--distribution-info="Gentoo ${PVR}"
		--libdir="$(get_libdir)"
	# Avoid collisions between slots for tools (bug #905700)
		--program-suffix=$(ver_cut 1)

	# Don't install Python bindings automatically
	# (do it manually later in the right place)
	# bug #723096
		--no-install-python-module

		--os="${myos}"
		--prefix="${EPREFIX}/usr"
		--with-endian="$(tc-endian)"
		--with-python-version=$(IFS=","; echo "${pythonvers[*]}")
	)

	if ! use cpu_flags_ppc_power8 && ! use cpu_flags_ppc_power8 ; then
		myargs+=(
			--disable-powercrypto
		)
	fi

	local ARM_CRYPTO_OPTIONS=(
		"sha1_armv8"
		"sm4_armv8"
	)

	local ARM_NEON_OPTIONS=(
		"aes_armv8"
		"chacha_simd32"
		"noekeon_simd"
		"serpent_simd"
		"sha1_simd"
		"shacal2_simd"
		"zfec_vperm"
	)

	local ARM_PMULL_OPTIONS=(
		"ghash_cpu"
	)

	local PPC_ALTIVEC_OPTIONS=(
		"aes_vperm"
		"chacha_simd32"
		"serpent_simd"
		"shacal2_simd"
		"noekeon_simd"
	)

	local PPC_POWER8_OPTIONS=(
		"aes_power8"
	)

	local PPC_POWER9_OPTIONS=(
		"aes_power8"
		"processor_rng"
	)

	local X86_AES_OPTIONS=(
		"aes_ni"
	)

	local X86_AVX2_OPTIONS=(
		"chacha_avx2"
		"serpent_avx2"
		"sha1_avx2"
		"shacal2_avx2"
		"simd_avx2"
	)

	local X86_BMI2_OPTIONS=(
		"sha2_32_bmi2"
		"sha2_64_bmi2"
		"sha3_bmi2"
	)

	local X86_CLMUL_OPTIONS=(
		"ghash_cpu"
	)

	local X86_RDRND_OPTIONS=(
		"processor_rng"
	)

	local X86_RDSEED_OPTIONS=(
		"rdseed"
	)

	local X86_SHA_OPTIONS=(
		"shacal2_x86"
		"sha1_x86"
		"sha2_32_x86"
	)

	local X86_SSE2_OPTIONS=(
		"idea_sse2"
		"zfec_sse2"
	)

	local X86_SSSE3_OPTIONS=(
		"argon2_ssse3"
		"chacha_simd32"
		"noekeon_simd"
		"serpent_simd"
		"sha1_simd"
		"sha2_32_simd"
		"aes_vperm"
		"ghash_vperm"
		"zfec_vperm"
	)

	local x

	if use cpu_flags_arm_crypto ; then
		for x in ${ARM_CRYPTO_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_arm_neon ; then
		for x in ${ARM_NEON_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_arm_pmull ; then
		for x in ${ARM_PMULL_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_ppc_altivec ; then
		for x in ${PPC_ALTIVEC_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_ppc_power8 ; then
		for x in ${PPC_POWER8_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_ppc_power9 ; then
		for x in ${PPC_POWER9_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_sha ; then
		for x in ${X86_SHA_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_aes ; then
		for x in ${X86_AES_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_avx2 ; then
		for x in ${X86_AVX2_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_bmi2 ; then
		for x in ${X86_BMI2_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_clmul ; then
		for x in ${X86_CLMUL_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_sse2 ; then
		for x in ${X86_SSE2_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_ssse3 ; then
		for x in ${X86_SSSE3_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_rdseed ; then
		for x in ${X86_RDSEED_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	if use cpu_flags_x86_rdrnd ; then
		for x in ${X86_RDRND_OPTIONS[@]} ; do
			ALGS["${x}"]=1
		done
	fi

	local simd=0
	local enabled_modules=""
	local disabled_modules=""
	for x in ${!ALGS[@]} ; do
		if [[ "${ALGS[${x}]}" == "1" ]] ; then
			simd=1
			enabled_modules+=",${x}"
		elif [[ "${ALGS[${x}]}" == "0" ]] ; then
			disabled_modules+=",${x}"
		else
ewarn "QA:  ${x} does not exist."
		fi
	done

	if [[ -n "${enabled_modules}" ]] ; then
		enabled_modules="${enabled_modules:1}"
		myargs+=(
			--enable-modules="${enabled_modules}"
		)
	fi
	if [[ -n "${disabled_modules}" ]] ; then
		disabled_modules="${disabled_modules:1}"
		myargs+=(
			--disable-modules="${disabled_modules}"
		)
	fi

	if (( ${simd} == 0 )) ; then
		myargs+=(
			--cpu="generic"
		)
	fi

	local build_targets=(
		shared
		$(usev static-libs static)
		$(usev test tests)
		$(usev tools cli)
	)

	myargs+=(
		--build-targets=$(IFS=","; echo "${build_targets[*]}")
	)

	if use elibc_glibc && use kernel_linux ; then
		myargs+=(
			--with-os-features="getrandom,getentropy"
		)
	fi

	tc-export AR CC CXX

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local sanitizers=()
	if is-flagq "-fsanitize=address" ; then
		sanitizers+=(
			"address"
		)
	fi
	if is-flagq "-fsanitize=undefined" ; then
		sanitizers+=(
			"undefined"
		)
	fi
	filter-flags '-fsanitize=*'
	myargs+=(
		--enable-sanitizers=$(IFS=","; echo "${sanitizers[*]}")
	)

	edo ${EPYTHON} \
		"configure.py" \
		--verbose "${myargs[@]}"
}

src_test() {
	LD_LIBRARY_PATH="${S}" \
	edo ./botan-test$(ver_cut 1) \
		--test-threads="$(makeopts_jobs)"
}

src_install() {
	default

	if [[ -d "${ED}/usr/share/doc/${P}" && "${P}" != "${PF}" ]] ; then
	# --docdir in configure controls the parent directory unfortunately
		mv \
			"${ED}/usr/share/doc/${P}" \
			"${ED}/usr/share/doc/${PF}" \
			|| die
	fi

	# Manually install the Python bindings (bug #723096)
	if use python ; then
		python_foreach_impl python_domodule "src/python/botan"$(ver_cut 1)".py"
	fi
}
