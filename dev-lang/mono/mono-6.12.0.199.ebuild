# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Too slow to instrument some bins or libs.
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_EBOLT=0

TRAIN_TEST_DURATION=1800 # 30 min
CHECKREQS_DISK_BUILD="4500M"
inherit autotools check-reqs linux-info mono-env pax-utils multilib-minimal
inherit lcnr toolchain-funcs uopts
# inherit git-r3

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="https://mono-project.com"

# Extra licenses because it is in source code form and third party external
# modules.  Also, additional licenses for additional files through git not
# found in the tarball.
LICENSE="
	MIT
	( MIT UoI-NCSA )
	Apache-1.1
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	APSL-2
	BoringSSL-ECC
	BoringSSL-PSK
	BSD
	BSD-2
	BSD-4
	CC-BY-2.5
	CC-BY-4.0
	DOTNET-libraries-and-runtime-components-patents
	gcc-runtime-library-exception-3.1
	GPL-2+
	GPL-2-with-linking-exception
	GPL-2+-with-libtool-exception
	GPL-3+
	GPL-3+-with-autoconf-exception
	GPL-3+-with-libtool-exception
	IDPL
	Info-ZIP
	ISC
	LGPL-2.1
	LGPL-2.1-with-linking-exception
	Mono-gc_allocator.h
	Mono-patents
	MPL-1.1
	Ms-PL
	openssl
	OSL-3.0
	SunPro
	ZLIB
	acceptance-tests-coreclr-trainer? (
		( MIT all-rights-reserved )
		DOTNET-libraries-and-runtime-components-patents
		MIT
	)
	acceptance-tests-microbench-trainer? (
		( all-rights-reserved CDDL-1.1 )
		all-rights-reserved
		Apache-2.0
		BSD
		BSD-2
		CDDL-1.1
		MIT
		GPL-2+
	)
	jemalloc? (
		BSD-2
		BSD
		custom
		GPL-3+
		HPND
	)
"
# The GPL-2, GPL-2+*, GPL-3* apply to build files and not for binary only
# distribution after install.

# The GPL-2-with-linking-exception is actually GPL-2+-with-linking-exception"
# since "or later" is present which makes it Apache-2.0 compatible, so the"
# distro license file name is a misnomer.  A GPL-2 only usually will have
# something like "version 2." or "version 2 of the license." without the word
# "later".

# all-rights-reserved - acceptance-tests/DebianShootoutMono/external/FlameGraph/stackcollapse-java-exceptions.pl
# all-rights-reserved, CDDL-1.1 - acceptance-tests/DebianShootoutMono/FlameGraph/flamegraph.pl
# Apache-1.1 - external/ikvm/THIRD_PARTY_README
# Apache-2.0-with-LLVM-exceptions - mono/tools/offsets-tool/clang/enumerations.py
# Apache-2.0 - acceptance-tests/DebianShootoutMono/external/FlameGraph/files.pl
# APSL-2 BSD-4 - support/ios/net/route.h
# BSD - mono/utils/bsearch.c
# BSD ISC openssl custom -- boringssl
#   custom - ssl/ssl_lib.c
# BSD-2 - jemalloc
# BSD-2 - mono/utils/freebsd-elf64.h
# BSD-2 SunPro - support/libm/complex.c
# BSD-2 - mono/utils/jemalloc/jemalloc/COPYING
# CDDL-1.1 - acceptance-tests/DebianShootoutMono/external/FlameGraph/dev/hotcoldgraph.pl
# gcc-runtime-library-exception-3.1
#   https://github.com/mono/mono/blob/mono-6.12.0.122/mono/mini/decompose.c#L966
#   https://github.com/mono/mono/blob/mono-6.12.0.122/THIRD-PARTY-NOTICES.TXT#L69
# custom - mono/utils/jemalloc/Makefile.in
# custom - mono/utils/jemalloc/jemalloc/m4/ax_cxx_compile_stdcxx.m4
# GPL-2+ - acceptance-tests/DebianShootoutMono/external/FlameGraph/stackcollapse-bpftrace.pl
# GPL-3+ - mono/utils/jemalloc/jemalloc/build-aux/config.guess
# GPL-2+ GPL-3+ GPL-3+-with-libtool-exception external/bdwgc/libtool
# GPL-2+ mono/benchmark/logic.cs
# GPL-3+-with-autoconf-exception - external/bdwgc/libatomic_ops/config.guess
# GPL-2+-with-libtool-exception external/bdwgc/libtool
# GPL-2+-with-linking-exception - mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs
# HPND - mono/utils/jemalloc/jemalloc/build-aux/install-sh
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# MIT UoI-NCSA - external/llvm-project/libunwind/src/EHHeaderParser.hpp
# MIT all-rights-reserved - acceptance-tests/coreclr/THIRD-PARTY-NOTICES
#   The distro license template does not have all rights reserved for the MIT license.
# openssl - external/boringssl/crypto/ecdh/ecdh.c
# OSL-3.0 - external/nunit-lite/NUnitLite-1.0.0/src/framework/Internal/StackFilter.cs
# ZLIB - external/ikvm ; lists paths/names with different licenses but these files are removed or not present (option disabled by godot-mono-builds)
# ZLIB - ikvm-native/jni.h

# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.


SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 -riscv x86 ~amd64-linux"
PGO_TRAINERS="
	acceptance-tests-coreclr-trainer
	acceptance-tests-microbench-trainer
	mono-benchmark-trainer
	mono-managed-trainer
	mono-native-trainer
	mcs-trainer
"
IUSE+=" ${PGO_TRAINERS[@]}"
IUSE+=" doc jemalloc jemalloc-assert jemalloc-custom-cflags jemalloc-default minimal nls pax-kernel xen"
gen_pgo_trainers_required_use() {
	local u
	for u in ${PGO_TRAINERS[@]} ; do
		echo "${u}? ( pgo )"
	done
}
REQUIRED_USE+="
	jemalloc-assert? (
		jemalloc
	)
	jemalloc-custom-cflags? (
		jemalloc
	)
	jemalloc-default? (
		jemalloc
	)
	pgo? (
		|| (
			${PGO_TRAINERS[@]}
		)
	)
"
REQUIRED_USE+=" "$(gen_pgo_trainers_required_use)

# Note: mono works incorrect with older versions of libgdiplus
# Details on dotnet overlay issue: https://github.com/gentoo/dotnet/issues/429

# Internal is required because of function prefix to allow both system alloc and
# Jemalloc to coexist.
JEMALLOC_PV="5.3.0" # 5.0.1 (circa 2018) was the upstream selected.
# SECURITY:  Bump every time a vulnerability fix is announced.
# See https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=jemalloc&search_type=all

DEPEND+="
	!minimal? (
		>=dev-dotnet/libgdiplus-6.0.2
	)
	app-crypt/mit-krb5[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	ia64? (
		sys-libs/libunwind
	)
	nls? (
		sys-devel/gettext
	)
"
RDEPEND+="
	${DEPEND}
	app-misc/ca-certificates
"
BDEPEND+="
	dev-util/yacc
	sys-devel/bc
	pax-kernel? (
		sys-apps/elfix
	)
	mono-benchmark-trainer? (
		sys-process/time
	)
"

MONO_CORECLR_COMMIT="90f7060935732bb624e1f325d23f63072433725f"
XMRNBENCHMARKER_COMMIT="97f618cd585af549dd861b7c142656c496f6a89b"
DEBIANSHOOTOUTMONO_COMMIT="3fde2ced806c1fe7eed81120a40d99474fa009f0"
BENCHMARKDOTNET_COMMIT="96ed005c57605cb8f005b6941c4d83453912eb75"
FLAMEGRAPH_COMMIT="f857ebc94bfe2a9bfdc4f1536ebacfb7466f69ba"
SRC_URI="
https://download.mono-project.com/sources/mono/${P}.tar.xz
jemalloc? (
	https://github.com/jemalloc/jemalloc/archive/refs/tags/${JEMALLOC_PV}.tar.gz
		-> jemalloc-${JEMALLOC_PV}.tar.gz
)
acceptance-tests-coreclr-trainer? (
	https://github.com/mono/coreclr/archive/${MONO_CORECLR_COMMIT}.tar.gz
		-> mono-coreclr-${MONO_CORECLR_COMMIT:0:7}.tar.gz
)
acceptance-tests-microbench-trainer? (
	https://github.com/alexanderkyte/DebianShootoutMono/archive/${DEBIANSHOOTOUTMONO_COMMIT}.tar.gz
		-> DebianShootoutMono-${DEBIANSHOOTOUTMONO_COMMIT:0:7}.tar.gz
	https://github.com/alexanderkyte/BenchmarkDotNet/archive/${BENCHMARKDOTNET_COMMIT}.tar.gz
		-> BenchmarkDotNet-${BENCHMARKDOTNET_COMMIT:0:7}.tar.gz
	https://github.com/brendangregg/FlameGraph/archive/${FLAMEGRAPH_COMMIT}.tar.gz
		-> FlameGraph-${FLAMEGRAPH_COMMIT:0:7}.tar.gz

)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.12-try-catch.patch"
	"${FILESDIR}/${PN}-6.12.0.122-disable-automagic-ccache.patch"
	"${FILESDIR}/${PN}-6.12.0.182-disable-test-mono-callspec.patch"
	"${FILESDIR}/${PN}-6.12.0.182-mono-benchmark-missing-main.patch"
	"${FILESDIR}/${PN}-6.12.0.122-acceptance-tests-disable-reset.patch"
)

_get_s() {
	if (( ${NABIS} == 1 )) ; then
		echo "${S}"
	else
		echo "${S}-${MULTILIB_ABI_FLAG}.${ABI}"
	fi
}

_get_build_dir() {
	_get_s
}

pkg_pretend() {
	linux-info_pkg_setup

	if use kernel_linux ; then
		if linux_config_exists ; then
			linux_chkconfig_builtin SYSVIPC || die "SYSVIPC not enabled in the kernel"
		else
			# https://github.com/gentoo/gentoo/blob/f200e625bda8de696a28338318c9005b69e34710/eclass/linux-info.eclass#L686
			ewarn "kernel config not found"
			ewarn "If CONFIG_SYSVIPC is not set in your kernel .config, mono will hang while compiling."
			ewarn "See https://bugs.gentoo.org/261869 for more info."
		fi
	fi

	# bug #687892
	check-reqs_pkg_pretend
}

NABIS=0
pkg_setup() {
	mono-env_pkg_setup
	check-reqs_pkg_setup
	uopts_setup

	if \
	( \
		   use acceptance-tests-coreclr-trainer \
		|| use acceptance-tests-microbench-trainer \
	) && \
	has network-sandbox ${FEATURES} ; then
eerror
eerror "Building with acceptance-tests requires network-sandbox to be disabled"
eerror "in FEATURES on a per-package level."
eerror
		die
	fi

	if use acceptance-tests-coreclr-trainer ; then
ewarn
ewarn "Time to build acceptance-tests-coreclr-trainer test may take hours."
ewarn
	fi

	local a
	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
}

src_unpack() {
	unpack ${P}.tar.xz
	if use jemalloc ; then
		unpack jemalloc-${JEMALLOC_PV}.tar.gz
		mv "${WORKDIR}/jemalloc-${JEMALLOC_PV}" \
			"${S}/mono/utils/jemalloc/jemalloc" || die
	fi

	mkdir -p "${S}/acceptance-tests/external"
	if use acceptance-tests-coreclr-trainer ; then
		unpack mono-coreclr-${MONO_CORECLR_COMMIT:0:7}.tar.gz
		mv "${WORKDIR}/coreclr-${MONO_CORECLR_COMMIT}" "${S}/acceptance-tests/external/coreclr" || die

#		EGIT_REPO_URI="https://github.com/mono/coreclr.git"
#		EGIT_BRANCH="mono"
#		EGIT_COMMIT="90f7060935732bb624e1f325d23f63072433725f"
#		EGIT_CHECKOUT_DIR="${S}/acceptance-tests/external/coreclr"
#		git-r3_fetch
#		git-r3_checkout
	fi
	if use acceptance-tests-microbench-trainer ; then
		unpack DebianShootoutMono-${DEBIANSHOOTOUTMONO_COMMIT:0:7}.tar.gz
		unpack BenchmarkDotNet-${BENCHMARKDOTNET_COMMIT:0:7}.tar.gz
		unpack FlameGraph-${FLAMEGRAPH_COMMIT:0:7}.tar.gz
		mv "${WORKDIR}/DebianShootoutMono-${DEBIANSHOOTOUTMONO_COMMIT}" "${S}/acceptance-tests/external/DebianShootoutMono" || die
		mkdir -p "${S}/acceptance-tests/external/DebianShootoutMono/external" || die
		mv "${WORKDIR}/BenchmarkDotNet-${BENCHMARKDOTNET_COMMIT}" "${S}/acceptance-tests/external/DebianShootoutMono/external/BenchmarkDotNet" || die
		mv "${WORKDIR}/FlameGraph-${FLAMEGRAPH_COMMIT}" "${S}/acceptance-tests/external/DebianShootoutMono/external/FlameGraph" || die

#		EGIT_REPO_URI="https://github.com/alexanderkyte/DebianShootoutMono.git"
#		EGIT_BRANCH="release_11_15_2018"
#		EGIT_COMMIT="3fde2ced806c1fe7eed81120a40d99474fa009f0"
#		EGIT_CHECKOUT_DIR="${S}/acceptance-tests/external/DebianShootoutMono"
#		git-r3_fetch
#		git-r3_checkout
	fi
}

src_prepare() {
	#
	# We need to sed in the paxctl-ng -mr in the runtime/mono-wrapper.in so
	# it don't get killed in the build proces when MPROTECT is enabled,
	# bug #286280.
	#
	# RANDMMAP kills the build process too, bug #347365
	#
	# We use paxmark.sh to get PT/XT logic, bug #532244
	#
	if use pax-kernel ; then
		ewarn "We are disabling MPROTECT on the mono binary."

		# issue 9 : https://github.com/Heather/gentoo-dotnet/issues/9
		sed '/exec "/ i\paxmark.sh -mr "$r/@mono_runtime@"' \
			-i "${S}"/runtime/mono-wrapper.in \
			|| die "Failed to sed mono-wrapper.in"
	fi

	default

	if use jemalloc ; then
		if use jemalloc-custom-cflags ; then
			pushd "${S}/mono/utils/jemalloc/jemalloc" || die
				eapply "${FILESDIR}/jemalloc-5.3.0-gentoo-fixups.patch"
			popd
			if ! use jemalloc-assert ; then
				sed -i -e "/-g3/d" \
					"${S}/mono/utils/jemalloc/jemalloc/configure.ac" || die
			fi
		fi
	fi

	# PATCHES contains configure.ac patch
	eautoreconf

	# The time cost is heavy to duplicate sources for only building 1 ABI.
	(( ${NABIS} > 1 )) && multilib_copy_sources

	prepare_abi() {
		uopts_src_prepare
	}
	multilib_foreach_abi prepare_abi
}

src_configure() { :; }

_src_configure() {
	uopts_src_configure

	if tc-is-gcc && [[ "${PGO_PHASE}" == "PGO" ]] ; then
		append-flags -Wno-error=coverage-mismatch
	fi

	local myeconfargs=(
		--disable-dtrace
		--enable-system-aot
		--without-ikvm-native
		$(use_enable nls)
		$(use_with doc mcs-docs)
		$(use_with jemalloc)
		$(use_with jemalloc-assert jemalloc_assert)
		$(use_with jemalloc-default jemalloc_always)
		$(use_with xen xen_opt)
	)

	# Workaround(?) for bug #779025
	# May be able to do a real fix by adjusting path used?
	if multilib_is_native_abi ; then
		myeconfargs+=( --enable-system-aot )
	else
		myeconfargs+=( --disable-system-aot )
	fi

	econf "${myeconfargs[@]}"
}

_src_compile() {
	emake
}

src_compile() {
	compile_abi() {
		cd $(_get_build_dir) || die
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

train_trainer_list() {
	use acceptance-tests-coreclr-trainer && echo "acceptance-tests-coreclr-trainer"
	use acceptance-tests-microbench-trainer && echo "acceptance-tests-microbench-trainer"
	use mono-benchmark-trainer && echo "mono-benchmark-trainer"
	use mono-managed-trainer && echo "mono-managed-trainer"
	use mono-native-trainer && echo "mono-native-trainer"
	use mcs-trainer && echo "mcs-trainer"
}

_pre_trainer_acceptance_tests_coreclr() {
	local use_id="acceptance-tests-coreclr-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/acceptance-tests"
make check-coreclr || true
EOF
chmod +x "${d}/${use_id}" || die
}

_pre_trainer_acceptance_tests_microbench() {
	local use_id="acceptance-tests-microbench-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/acceptance-tests"
make check-microbench || true
EOF
chmod +x "${d}/${use_id}" || die
}

_pre_trainer_mono_benchmark() {
	local use_id="mono-benchmark-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/mono/benchmark"
make run-test || true
EOF
chmod +x "${d}/${use_id}" || die
}

_pre_trainer_mono_managed() {
	local use_id="mono-managed-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/mono/tests"
make check || true
EOF
chmod +x "${d}/${use_id}" || die
}

_pre_trainer_mono_native() {
	local use_id="mono-native-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/mono/unit-tests"
make check || true
EOF
chmod +x "${d}/${use_id}" || die
}

_pre_trainer_mcs() {
	local use_id="mcs-trainer"
	local d=$(_get_s)
cat <<EOF > "${d}/${use_id}" || die
#!${EPREFIX}/bin/bash
cd "${d}/mcs/tests"
make run-test || true
EOF
chmod +x "${d}/${use_id}" || die
}

_src_pre_train() {
	use acceptance-tests-coreclr-trainer && _pre_trainer_acceptance_tests_coreclr
	use acceptance-tests-microbench-trainer && _pre_trainer_acceptance_tests_microbench
	use mono-benchmark-trainer && _pre_trainer_mono_benchmark
	use mono-managed-trainer && _pre_trainer_mono_managed
	use mono-native-trainer && _pre_trainer_mono_native
	use mcs-trainer && _pre_trainer_mcs
}

train_get_trainer_exe() {
	local trainer="${1}"
	echo "${S}/${trainer}"
}

train_override_duration() {
	local trainer="${1}"
	# 10 min slack is added for older computers.
	if [[ "${trainer}" == "acceptance-tests-coreclr-trainer" ]] ; then
# real	234m55.992s
# user	748m11.238s
# sys	14m25.457s
		echo "18000" # 4 hrs + 1 hr slack.
	elif [[ "${trainer}" == "acceptance-tests-microbench-trainer" ]] ; then
# real	9m35.200s
# user	15m54.854s
# sys	0m12.760s
		echo "1140" # 19 min
	elif [[ "${trainer}" == "mono-benchmark-trainer" ]] ; then
# real	2m44.450s
# user	2m39.598s
# sys	0m4.267s
		echo "780" # 13 min
	elif [[ "${trainer}" == "mono-managed-trainer" ]] ; then
# real	26m47.029s
# user	63m6.389s
# sys	3m57.119s
		echo "2160" # 36 min
	elif [[ "${trainer}" == "mono-native-trainer" ]] ; then
# real	1m37.212s
# user	3m30.138s
# sys	0m4.229s
		echo "720" # 12 min
	elif [[ "${trainer}" == "mcs-trainer" ]] ; then
# real	11m16.586s
# user	15m58.958s
# sys	0m23.959s
		echo "1320" # 22 min
	else
		echo "1800" # 30 min
	fi
}

multilib_src_test() {
	cd $(_get_build_dir) || die
	cd mcs/tests || die
	emake check
}

src_install() {
	install_abi() {
		cd $(_get_build_dir) || die
		emake install DESTDIR="${D}"
#
# Remove files not respecting LDFLAGS and that we are not supposed to
# provide, see Fedora mono.spec and
# http://www.mail-archive.com/mono-devel-list@lists.ximian.com/msg24870.html
# for reference.
#
		rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mscorlib.dll.so || die
		rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mcs.exe.so || die

		uopts_src_install
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	if [[ "${HOME}/.nuget" ]] ; then
		LCNR_SOURCE="${HOME}/.nuget"
		LCNR_TAG="third_party"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

pkg_postinst() {
	uopts_pkg_postinst
	# bug #762265
	cert-sync "${EROOT}"/etc/ssl/certs/ca-certificates.crt
}

# OILEDMACHINE-OVERLAY-META-TAGS:  PGO
