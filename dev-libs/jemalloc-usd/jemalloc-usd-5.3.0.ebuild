# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild exists to prevent:
# ImportError: /usr/lib64/libjemalloc.so.2: cannot allocate memory in static TLS block
# for openusd ebuild-package.

# Same as jemalloc ebuild from gentoo-overlay but with the mtls-dialect-gnu
# patch.

# PGOing this library is justified because the size of the library is over a
# 1000 4k pages in size.

MY_PN="jemalloc"

# asan breaks test suite.  ubsan works with test suite.
# ubsan breaks dev-util/ruff
#CFLAGS_HARDENED_SANITIZERS="undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO"
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX14[@]}
)
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/jemalloc/jemalloc.h"
)
TRAINERS=(
	"jemalloc_usd_trainers_test_suite"
	"jemalloc_usd_trainers_stress_test"
)
TRAIN_TEST_DURATION=1800 # 30 min
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=0 # bolt and asan/ubsan are mutually exclusive
UOPTS_SUPPORT_TPGO=1

inherit autotools cflags-hardened check-compiler-switch flag-o-matic libstdcxx-slot multilib-minimal uopts

KEYWORDS+=" ~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${MY_PN}-${PV}.tar.bz2"

DESCRIPTION="USD support for Jemalloc, a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"
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
ebuild_revision_40
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
	jemalloc_usd_trainers_test_suite? (
		pgo
	)
	jemalloc_usd_trainers_stress_test? (
		pgo
	)
"
HTML_DOCS=(
	"doc/jemalloc.html"
)
PATCHES=(
	"${FILESDIR}/${MY_PN}-5.2.1-mtls-dialect-gnu2-7036e64.patch"
)

_add_lib() {
	local lib="${1}"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	local f
	for f in Makefile Makefile.in ; do
einfo "Editing ${f}:  Adding ${lib}"
		sed -i \
			-e "s|EXTRA_LDFLAGS :=|EXTRA_LDFLAGS := ${lib}|g" \
			"${d}/${f}" \
			|| die
	done
}

_remove_lib() {
	local lib="${1}"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	local f
	for f in Makefile Makefile.in ; do
einfo "Editing ${f}:  Removing ${lib}"
		sed -i \
			-e "s|EXTRA_LDFLAGS := ${lib}|EXTRA_LDFLAGS :=|g" \
			"${d}/${f}" \
			|| die
	done
}

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
		eapply "${FILESDIR}/${MY_PN}-5.3.0-gentoo-fixups.patch"
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
		--prefix="/usr/$(get_libdir)/openusd"
		$(use_enable debug)
		$(use_enable lazy-lock)
		$(use_enable prof)
		$(use_enable stats)
		$(use_enable xmalloc)
	)
	ECONF_SOURCE="${S}-${MULTILIB_ABI_FLAG}.${ABI}" econf "${myconf[@]}"
	[[ "${PGO_PHASE}" == "PGI" ]] && _add_lib "-lgcov"
	[[ "${PGO_PHASE}" == "PGO" ]] && _remove_lib "-gcov"
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
	local use_id="jemalloc_usd_trainers_test_suite"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}"
make check || true
EOF
chmod +x "${d}/${use_id}" || die
}

_stress_test_trainer_wrapper() {
	local use_id="jemalloc_usd_trainers_stress_test"
	local d="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}"
make stress || true
EOF
chmod +x "${d}/${use_id}" || die
}

_src_pre_train() {
	use jemalloc_usd_trainers_test_suite && _test_trainer_wrapper
	use jemalloc_usd_trainers_stress_test && _stress_test_trainer_wrapper
}

train_trainer_list() {
	use jemalloc_usd_trainers_test_suite && echo "jemalloc_usd_trainers_test_suite"
	use jemalloc_usd_trainers_stress_test && echo "jemalloc_usd_trainers_stress_test"
}

train_get_trainer_exe() {
	local trainer="${1}"
	local s="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	echo "${s}/${trainer}"
}

train_override_duration() {
	local trainer="${1}"
	# 10 min slack is added for older computers.
	if [[ "${trainer}" == "jemalloc_usd_trainers_test_suite" ]] ; then
# real	10m40.282s
# user	8m57.655s
# sys	0m38.096s
		echo "1260" # 21 min
	elif [[ "${trainer}" == "jemalloc_usd_trainers_stress_test" ]] ; then
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
	rm -rf "${ED}/usr/share/man" || die
}

pkg_postinst() {
	uopts_pkg_postinst
}

# OILEDMACHINE-OVERLAY-META-TAGS: PGO
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  install-location
