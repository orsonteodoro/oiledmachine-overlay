# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# For downloads, see ESRs in https://ftp.mozilla.org/pub/firefox/releases/

# See also
# /var/tmp/portage/dev-lang/spidermonkey-140.12.0/work/firefox-140.12.0/taskcluster/kinds/fetch/toolchains.yml
# /var/tmp/portage/dev-lang/spidermonkey-140.12.0/work/firefox-140.12.0/taskcluster/kinds/toolchain/node.yml
# /var/tmp/portage/dev-lang/spidermonkey-140.12.0/work/firefox-140.12.0/taskcluster/kinds/toolchain/rust.yml

CFLAGS_HARDENED_USE_CASES="jit language-runtime scripting security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"
RUSTFLAGS_HARDENED_USE_CASES="jit language-runtime scripting sensitive-data untrusted-data"
RUSTFLAGS_HARDENED_VULNERABILITY_HISTORY="IO TC"

MITIGATION_DATE="Jun 16, 2026" # Advisory date
MITIGATION_LAST_UPDATE=1781557080 # From `date +%s -d "2026-06-15 13:58"` from ftp date matching version in report
MITIGATION_URI="https://www.mozilla.org/en-US/security/advisories/mfsa2026-58/"
SEVERITY_LABEL="Severity:"
VULNERABILITIES_FIXED=(
)

FIREFOX_PATCHSET="firefox-140esr-patches-12.tar.xz"
SPIDERMONKEY_PATCHSET="spidermonkey-140-patches-02.tar.xz"

LLVM_COMPAT=( 19 20 22 )
RUST_LIVE_TIMESTAMP="Jul 5, 2026 8:11 AM PDT"
RUST_MAX_VER="9999"
RUST_MIN_VER="1.86.0"
RUST_NEEDS_LLVM=1 # Prune rustc for unused LLVM slots
RUST_NIGHTLY_PV="1.99.0"

PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="ncurses,ssl,xml(+)"

WANT_AUTOCONF="2.1"

CHKL_TIMESTAMPS=(
	"dev-libs/icu-79.0.9999"
)

inherit cflags-hardened check-compiler-switch check-reqs chkl dhms flag-o-matic llvm-r1 multiprocessing python-any-r1 rust secure-version toolchain-funcs

MY_PN="mozjs"
MY_PV="${PV/_pre*}"

MY_MAJOR=$(ver_cut 1)

MOZ_ESR=yes

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_PN="firefox"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

if [[ ${PV} == *_rc* ]] ; then
	MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/candidates/${MOZ_PV}-candidates/build${PV##*_rc}"
fi

PATCH_URIS=(
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${FIREFOX_PATCHSET}
	https://dev.gentoo.org/~juippis/mozilla/patchsets/${SPIDERMONKEY_PATCHSET}
)

DESCRIPTION="Mozilla's JavaScript engine written in C and C++"
HOMEPAGE="https://spidermonkey.dev https://firefox-source-docs.mozilla.org/js/index.html"
SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz
	${PATCH_URIS[@]}"
S="${WORKDIR}/firefox-${PV%_*}"
LICENSE="
	Firefox-ESR-$(ver_cut 1-2 ${PV}).x-Licenses.html
	MPL-2.0
"
SLOT="$(ver_cut 1)/140.11.0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="clang cpu_flags_arm_neon debug +jit test"

#RESTRICT="test"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	$(llvm_gen_dep '
		clang? (
			llvm-core/clang:${LLVM_SLOT}
			llvm-core/lld:${LLVM_SLOT}
			llvm-core/llvm:${LLVM_SLOT}
		)
	')
	>=dev-util/cbindgen-0.27.0
	virtual/pkgconfig
	llvm_slot_19? (
		|| (
			~dev-lang/rust-bin-1.86.0
			~dev-lang/rust-1.86.0
		)
	)
	llvm_slot_20? (
		|| (
			~dev-lang/rust-bin-1.90.0
			~dev-lang/rust-1.90.0
		)
	)
	llvm_slot_22? (
		|| (
			=dev-lang/rust-bin-9999
			=dev-lang/rust-9999
		)
	)
	test? (
		$(python_gen_any_dep 'dev-python/six[${PYTHON_USEDEP}]')
	)"
DEPEND=">=dev-libs/icu-${ICU_PV}:=
	>=dev-libs/nspr-${NSPR_PV}:=
	sys-libs/readline:=
	>=virtual/zlib-${ZLIB_PV}:="
RDEPEND="${DEPEND}"

llvm_check_deps() {
	if use clang ; then
		if ! has_version -b "llvm-core/clang:${LLVM_SLOT}" ; then
			einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! has_version -b "llvm-core/llvm:${LLVM_SLOT}" ; then
			einfo "llvm-core/llvm:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! tc-ld-is-mold ; then
			if ! has_version -b "llvm-core/lld:${LLVM_SLOT}" ; then
				einfo "llvm-core/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

python_check_deps() {
	if use test ; then
		python_has_version "dev-python/six[${PYTHON_USEDEP}]"
	fi
}

pkg_pretend() {
	if use test ; then
		CHECKREQS_DISK_BUILD="4400M"
	else
		CHECKREQS_DISK_BUILD="4300M"
	fi

	check-reqs_pkg_pretend
}

verify_rust_nightly() {
	local is_nightly=$("${RUSTC}" --version | grep -q "nightly")
	is_nightly=$(( "${?}" == 0 ? 1 : 0 ))

	if (( ${is_nightly} == 0 )) ; then
eerror "Only nightly Rust is currently supported."
eerror "Switch to live with \`eselect rust\`"
		die
	fi

	if "${RUSTC}" --version | grep -q -e "nightly" ; then
		local compatible_time=$(date --date="${RUST_LIVE_TIMESTAMP}" "+%s")

		local merge_time
		local pkg_name
		if [[ "${RUSTC}" =~ "rust-bin" ]] ; then
			pkg_name="rust-bin"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-bin-9999/BUILD_TIME")
		else
			pkg_name="rust"
			merge_time=$(cat "/var/db/pkg/dev-lang/rust-9999/BUILD_TIME")
		fi
		if (( ${merge_time} < ${compatible_time} )) ; then
eerror
eerror "Detected old live timestamp."
eerror "Re-emerge ${pkg_name} or switch to Rust ${RUST_NIGHTLY_PV} or later."
eerror
eerror "Current timestamp:  "$(date --date="@${merge_time}")
eerror "Expected timestamp:  >= "$(date --date="@${compatible_time}")
eerror
			die
		fi
	else
		local actual_pv=$("${RUSTC}" --version | cut -f 2 -d " ")
		if ver_test "${actual_pv}" "-lt" "${RUST_MIN_VER}" ; then
eerror "Switch Rust to >= ${RUST_MIN_VER}"
			die
		fi
	fi
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start

	# Get LTO from environment; export after this phase for use in src_configure (etc)
	use_lto=no

	if [[ ${MERGE_TYPE} != binary ]] ; then
		if tc-is-lto; then
			use_lto=yes
			# LTO is handled via configure
			filter-lto
		fi

		if [[ ${use_lto} = yes ]]; then
			# -Werror=lto-type-mismatch -Werror=odr are going to fail with GCC,
			# bmo#1516758, bgo#942288
			filter-flags -Werror=lto-type-mismatch -Werror=odr
		fi

		if use test ; then
			CHECKREQS_DISK_BUILD="4400M"
		else
			CHECKREQS_DISK_BUILD="4300M"
		fi

		check-reqs_pkg_setup
		llvm-r1_pkg_setup
		rust_pkg_setup
		python-any-r1_pkg_setup

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
			ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	export use_lto

	if use llvm_slot_22 ; then
		verify_rust_nightly
	fi
}

src_prepare() {
	if [[ ${use_lto} == "yes" ]]; then
		rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch || die
	fi

	# Workaround for bgo #915651,915651,929013 on musl
	if use elibc_glibc ; then
		rm -v "${WORKDIR}"/firefox-patches/*bgo-748849-RUST_TARGET_override.patch || die
	fi

	eapply "${WORKDIR}"/firefox-patches
	eapply "${WORKDIR}"/spidermonkey-patches

	default

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Workaround for bgo #915651,915651,929013 on musl
	if ! use elibc_glibc ; then
		if use amd64 ; then
			export RUST_TARGET="x86_64-unknown-linux-musl"
		elif use x86 ; then
			export RUST_TARGET="i686-unknown-linux-musl"
		elif use arm64 ; then
			export RUST_TARGET="aarch64-unknown-linux-musl"
		elif use ppc64 ; then
			export RUST_TARGET="powerpc64le-unknown-linux-musl"
		else
			die "Unknown musl chost, please post your rustc -vV along with emerge --info on Gentoo's bug #915651"
		fi
	fi

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		python/mozbuild/mozbuild/configure/check_debug_ranges.py ||
			die "sed failed to set toolchain prefix"

	einfo "Removing pre-built binaries ..."
	find third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	# Create build dir
	BUILD_DIR="${WORKDIR}/${PN}_build"
	mkdir -p "${BUILD_DIR}" || die
}

check_security_expire() {
	local safe_period
	local now=$(date +%s)
	local dhms_passed=$(dhms_get ${MITIGATION_LAST_UPDATE} ${now})

	local desc=""
# The ideal choice is actually mitigation_use_case=${MITIGATION_USE_CASE:-email}
# but the ESR releases tend to be less frequent compared to rapid.
	local mitigation_use_case="${MITIGATION_USE_CASE:-user-generated-content}"
	if [[ "${mitigation_use_case}" =~ ("email") ]] ; then
		safe_period=$((60*60*24*7))
		desc="1 week"
	elif [[ "${mitigation_use_case}" =~ ("socials"|"user-generated-content") ]] ; then
		safe_period=$((60*60*24*14))
		desc="2 weeks"
	else
		safe_period=$((60*60*24*30))
		desc="30 days"
	fi

	if (( ${now} > ${MITIGATION_LAST_UPDATE} + ${safe_period} )) ; then
eerror
eerror "This ebuild release period is past ${desc} since release."
eerror "It is considered insecure.  As a precaution, this particular point"
eerror "release will not (re-)install."
eerror
eerror "Time passed since the last security update:  ${dhms_passed}"
eerror "Mitigated use case(s):  ${mitigation_use_case}"
eerror
eerror "Solutions:"
eerror
eerror "1.  Use a newer release from the overlay."
eerror "2.  Use the latest distro release."
eerror
eerror "See metadata.xml for details to adjust MITIGATION_USE_CASE."
eerror
		die
	else
einfo "Time passed since the last security update:  ${dhms_passed}"
	fi
}

src_configure() {
	check_security_expire
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
	cflags-hardened_append
	rustflags-hardened_append

	# Show flags set at the beginning
	einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Current CFLAGS:    ${CFLAGS}"
	einfo "Current CXXFLAGS:  ${CXXFLAGS}"
	einfo "Current LDFLAGS:   ${LDFLAGS}"
	einfo "Current RUSTFLAGS: ${RUSTFLAGS}"

	local have_switched_compiler=
	if use clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."

		local version_clang=$(clang --version 2>/dev/null | grep -F -- 'clang version' | awk '{ print $3 }')
		[[ -n ${version_clang} ]] && version_clang=$(ver_cut 1 "${version_clang}")
		[[ -z ${version_clang} ]] && die "Failed to read clang version!"

		if tc-is-gcc; then
			have_switched_compiler=yes
		fi

		AR=llvm-ar
		CC=${CHOST}-clang-${version_clang}
		CXX=${CHOST}-clang++-${version_clang}
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		OBJDUMP=llvm-objdump

	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
		READELF=readelf
		OBJDUMP=objdump
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# Ensure we use correct toolchain,
	# AS is used in a non-standard way by upstream, #bmo1654031
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	export AS="$(tc-getCC) -c"

	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB READELF PKG_CONFIG

	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="${SYSROOT:+--sysroot=${ESYSROOT}} --target=${CHOST} ${BINDGEN_CFLAGS-}"
	fi

	# ../python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Set state path
	export MOZBUILD_STATE_PATH="${BUILD_DIR}"

	# Set MOZCONFIG
	export MOZCONFIG="${S}/.mozconfig"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-project=js

	mozconfig_add_options_ac 'Gentoo default' \
		--host="${CBUILD:-${CHOST}}" \
		--target="${CHOST}" \
		--disable-ctype \
		--disable-jemalloc \
		--disable-smoosh \
		--disable-strip \
		--enable-packed-relative-relocs \
		--enable-readline \
		--enable-release \
		--enable-shared-js \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--with-intl-api \
		--with-system-icu \
		--with-system-nspr \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-"

	mozconfig_use_enable debug
	mozconfig_use_enable jit
	mozconfig_use_enable test tests

	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
		mozconfig_add_options_ac '+debug' --enable-debug-symbols
		mozconfig_add_options_ac '+debug' --enable-real-time-tracing
	else
		mozconfig_add_options_ac '-debug' --enable-optimize
		mozconfig_add_options_ac '-debug' --disable-debug-symbols
		mozconfig_add_options_ac '-debug' --disable-real-time-tracing
	fi

	# We always end up disabling this at some point due to newer rust versions. bgo#933372
	mozconfig_add_options_ac '--disable-rust-simd' --disable-rust-simd

	# Modifications to better support ARM, bug 717344
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-thumb=yes
			mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-thumb-interwork=no
		fi
	fi

	# Tell build system that we want to use LTO
	if [[ ${use_lto} == "yes" ]] ; then
		if use clang ; then
			if tc-ld-is-mold ; then
				mozconfig_add_options_ac '+lto' --enable-linker=mold
			else
				mozconfig_add_options_ac '+lto' --enable-linker=lld
			fi
			mozconfig_add_options_ac '+lto' --enable-lto=cross

		else
			mozconfig_add_options_ac '+lto' --enable-linker=bfd
			mozconfig_add_options_ac '+lto' --enable-lto=full
		fi
	fi

	# LTO flag was handled via configure
	filter-lto

	# Pass MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_DIR}"

	# Show flags we will use
	einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Build CFLAGS:    ${CFLAGS}"
	einfo "Build CXXFLAGS:  ${CXXFLAGS}"
	einfo "Build LDFLAGS:   ${LDFLAGS}"
	einfo "Build RUSTFLAGS: ${RUSTFLAGS}"

	./mach configure || die
}

src_compile() {
	./mach build --verbose || die
}

src_test() {
	if "${BUILD_DIR}/js/src/js" -e 'print("Hello world!")'; then
		einfo "Smoke-test successful, continuing with full test suite"
	else
		die "Smoke-test failed: did interpreter initialization fail?"
	fi

	cp "${FILESDIR}"/spidermonkey-140-known-test-failures.txt "${T}"/known_test_failures.list || die
	./mach jstests --exclude-file="${T}"/known_test_failures.list || die
}

src_install() {
	cd "${BUILD_DIR}" || die
	default

	# fix soname links
	pushd "${ED}"/usr/$(get_libdir) &>/dev/null || die
	mv lib${MY_PN}-${MY_MAJOR}.so lib${MY_PN}-${MY_MAJOR}.so.0.0.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0.0.0 lib${MY_PN}-${MY_MAJOR}.so.0 || die
	ln -s lib${MY_PN}-${MY_MAJOR}.so.0 lib${MY_PN}-${MY_MAJOR}.so || die
	popd &>/dev/null || die

	# remove unneeded files
	rm \
		"${ED}"/usr/bin/js${MY_MAJOR}-config \
		"${ED}"/usr/$(get_libdir)/libjs_static.ajs || die

	# fix permissions
	chmod -x \
		"${ED}"/usr/$(get_libdir)/pkgconfig/*.pc \
		"${ED}"/usr/include/mozjs-${MY_MAJOR}/js-config.h || die
}
