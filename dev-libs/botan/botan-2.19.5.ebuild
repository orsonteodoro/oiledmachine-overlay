# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:  Remove or make unused ciphers optional

MY_P="Botan-${PV}"

CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data"
CPU_FLAGS_ARM=(
	"cpu_flags_arm_aes"
	"cpu_flags_arm_neon"
)
CPU_FLAGS_PPC=(
	"cpu_flags_ppc_altivec"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_aes"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_popcnt"
	"cpu_flags_x86_rdrand"
	"cpu_flags_x86_sha"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4_1"
	"cpu_flags_x86_sse4_2"
)
PYTHON_COMPAT=( "python3_"{10..12} )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/botan.asc"

inherit cflags-hardened check-compiler-switch edo flag-o-matic multiprocessing python-r1
inherit toolchain-funcs verify-sig

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
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_X86[@]}
doc boost bzip2 lzma python static-libs sqlite test tools zlib
ebuild_revision_29
"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
	)
"

# NOTE: Boost is needed at runtime too for the CLI tool.
DEPEND="
	boost? (
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
	# TODO: x86 RDSEED (new CPU_FLAGS_X86?)
	# TODO: POWER Crypto (new CPU_FLAGS_PPC?)
		$(usev !cpu_flags_arm_aes '--disable-armv8crypto')
		$(usev !cpu_flags_arm_neon '--disable-neon')
		$(usev !cpu_flags_ppc_altivec '--disable-altivec')
		$(usev !cpu_flags_x86_aes '--disable-aes-ni')
		$(usev !cpu_flags_x86_avx2 '--disable-avx2')
		$(usev !cpu_flags_x86_popcnt '--disable-bmi2')
		$(usev !cpu_flags_x86_rdrand '--disable-rdrand')
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
