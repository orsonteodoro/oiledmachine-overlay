# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PGOing this library is justified because the size of the library is over a
# 1000 4k pages in size.

# asan breaks test suite.  ubsan works with test suite.
# ubsan breaks dev-util/ruff
#CFLAGS_HARDENED_SANITIZERS="undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO"
GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, ROCm-6.2, ROCm-6.3, ROCm-6.4, ROCm-7.0, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/jemalloc/jemalloc.h"
)
TRAINERS=(
	"jemalloc_trainers_test_suite"
	"jemalloc_trainers_stress_test"
)
TRAIN_TEST_DURATION=1800 # 30 min
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=0 # bolt and asan/ubsan are mutually exclusive
UOPTS_SUPPORT_TPGO=1

inherit autotools cflags-hardened check-compiler-switch flag-o-matic libstdcxx-slot multilib-minimal uopts

KEYWORDS+=" ~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

DESCRIPTION="A general-purpose scalable concurrent allocator"
HOMEPAGE="
	http://jemalloc.net/
	https://github.com/jemalloc/jemalloc
"
LICENSE="
	BSD-2
	BSD
	custom
	GPL-3+
	HPND
"
# custom - m4/ax_cxx_compile_stdcxx.m4
# BSD - include/msvc_compat/C99/stdint.h
# BSD-2 - COPYING
# GPL-3+ - build-aux/config.guess
# HPND - build-aux/install-sh
SLOT="0/2"
IUSE+="
${TRAINERS[@]}
custom-cflags debug lazy-lock prof static-libs stats test xmalloc
ebuild_revision_41
"
REQUIRED_USE+="
	!custom-cflags? (
		!pgo
	)
	pgo? (
		custom-cflags
		|| (
			${TRAINERS[@]}
		)
	)
	jemalloc_trainers_test_suite? (
		pgo
	)
	jemalloc_trainers_stress_test? (
		pgo
	)
"
HTML_DOCS=( "doc/jemalloc.html" )

pkg_setup() {
	check-compiler-switch_start
	uopts_setup
	if use test && [[ "${FEATURES}" =~ "userpriv" ]] && [[ -n "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" ]] ; then
eerror "FEATURES=\"${FEATURES} -userpriv\" needs to be added as a per-package env file in order to run tests."
		die
	fi
	libstdcxx-slot_verify
}

src_prepare() {
	default

	if use custom-cflags ; then
		eapply "${FILESDIR}/${PN}-5.3.0-gentoo-fixups.patch"
		# -g3 flag introduced in f3340ca8d5b89ce8f2ec5b3721871029e0fa70ac (circa 2009) : Add configure tests for CFLAGS settings.
		if ! use test ; then
			sed -i -e "/-g3/d" configure.ac || die
		fi
	else
		strip-flags
		filter-flags -O*
	fi

	eautoreconf

	prepare_abi() {
		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}" || die
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() { :; }

_src_configure_compiler() {
	# clang breaks tests
	export CC="gcc"
	export CXX="g++"
	export CPP="${CC} -E"
	strip-unsupported-flags
}

_src_configure() {
	strip-unsupported-flags

	if [[ -n "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" ]] ; then
		if tc-is-clang && [[ "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" =~ "clang" ]] ; then
einfo "Adding -static-libsan for Clang $(clang-major-version)"
			export LIBS+=" -static-libsan"
		fi
		if tc-is-gcc && [[ "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" =~ "gcc" ]] && [[ "${CFLAGS_HARDENED_SANITIZERS}" =~ (^|" ")"address" ]] ; then
			local lib_name="libasan.a"
einfo "Adding ${lib_name} for GCC $(gcc-major-version)"
			export LIBS+=" "$(${CC} -print-file-name="${lib_name}")
		fi
		if tc-is-gcc && [[ "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" =~ "gcc" ]] && [[ "${CFLAGS_HARDENED_SANITIZERS}" =~ "undefined" ]] ; then
			local lib_name="libubsan.a"
einfo "Adding ${lib_name} for GCC $(gcc-major-version)"
			export LIBS+=" "$(${CC} -print-file-name="${lib_name}")
		fi
	fi

	[[ "${PGO_PHASE}" == "PGI" ]] && export LIBS+=" -lgcov"
	[[ "${PGO_PHASE}" == "PGO" ]] && export LIBS="${LIBS//-lgcov/}"

	uopts_src_configure

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

	filter-flags -fprofile-arcs
	if [[ "${PGO_PHASE}" == "PGI" ]] ; then
		append-flags -fprofile-arcs
	fi
	if [[ "${PGO_PHASE}" == "PGO" ]] ; then
		tc-is-gcc && append-flags -Wno-error="coverage-mismatch"
	fi
	cflags-hardened_append
	local myconf=(
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)
	ECONF_SOURCE="${S}-${MULTILIB_ABI_FLAG}.${ABI}" econf "${myconf[@]}"
}

_src_compile() {
	BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	cd "${BUILD_DIR}" || die
	emake
}

src_compile() {
	compile_abi() {
		BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		cd "${BUILD_DIR}" || die
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

_test_trainer_wrapper() {
	local use_id="jemalloc_trainers_test_suite"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}"
make check || true
EOF
chmod +x "${d}/${use_id}" || die
}

_stress_test_trainer_wrapper() {
	local use_id="jemalloc_trainers_stress_test"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}"
make stress || true
EOF
chmod +x "${d}/${use_id}" || die
}

_src_pre_train() {
	use jemalloc_trainers_test_suite && _test_trainer_wrapper
	use jemalloc_trainers_stress_test && _stress_test_trainer_wrapper
}

train_trainer_list() {
	use jemalloc_trainers_test_suite && echo "jemalloc_trainers_test_suite"
	use jemalloc_trainers_stress_test && echo "jemalloc_trainers_stress_test"
}

train_get_trainer_exe() {
	local trainer="${1}"
	local s="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	echo "${s}/${trainer}"
}

train_override_duration() {
	local trainer="${1}"
	# 10 min slack is added for older computers.
	if [[ "${trainer}" == "jemalloc_trainers_test_suite" ]] ; then
# real	10m40.282s
# user	8m57.655s
# sys	0m38.096s
		echo "1260" # 21 min
	elif [[ "${trainer}" == "jemalloc_trainers_stress_test" ]] ; then
# real	16m35.275s
# user	14m33.077s
# sys	0m17.290s
		echo "1620" # 27 min
	else
		echo "1800" # 30 min
	fi
}

multilib_src_test() {
	if [[ -n "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" ]] ; then
		addwrite "/dev/"
		rm -f "/dev/null."*
	fi
	emake check
	emake stress
	if [[ -n "${CFLAGS_HARDENED_SANITIZERS_COMPAT}" ]] ; then
		rm -f "/dev/null."*
		grep -e "^ERROR:" "${T}/build.log" && die "Detected error"
	fi
}

multilib_src_install() {
	# Copy man file which the Makefile looks for
	cp "${S}/doc/jemalloc.3" "${BUILD_DIR}/doc" || die
	emake DESTDIR="${D}" install
	uopts_src_install
}

multilib_src_install_all() {
	if [[ "${CHOST}" == *"-darwin"* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}/usr/$(get_libdir)/libjemalloc.2.dylib" \
			"${ED}/usr/$(get_libdir)/libjemalloc.2.dylib" || die
	fi
	use static-libs || find "${ED}" -name '*.a' -delete
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-TAGS: PGO
# OILEDMACHINE-OVERLAY-TEST:  PASSED (5.3.0, 20250501)
