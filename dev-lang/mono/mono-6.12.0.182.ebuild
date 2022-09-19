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

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="https://mono-project.com"

# Extra licenses because it is in source code form and third party external
# modules.  Also, additional licenses for additional files through git not
# found in the tarball.
LICENSE="
	MIT
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
	( MIT UoI-NCSA )
	Mono-gc_allocator.h
	Mono-patents
	MPL-1.1
	Ms-PL
	openssl
	OSL-3.0
	SunPro
	ZLIB
"
# The GPL-2, GPL-2+*, GPL-3* apply to build files and not for binary only
# distribution after install.

# The GPL-2-with-linking-exception is actually GPL-2+-with-linking-exception"
# since "or later" is present which makes it Apache-2.0 compatible, so the"
# distro license file name is a misnomer.  A GPL-2 only usually will have
# something like "version 2." or "version 2 of the license." without the word
# "later".

# Apache-1.1 - external/ikvm/THIRD_PARTY_README
# Apache-2.0-with-LLVM-exceptions - mono/tools/offsets-tool/clang/enumerations.py
# APSL-2 BSD-4 - support/ios/net/route.h
# BSD - mono/utils/bsearch.c
# BSD ISC openssl custom -- boringssl
#   custom - ssl/ssl_lib.c
# BSD-2 - mono/utils/freebsd-elf64.h
# BSD-2 SunPro - support/libm/complex.c
# gcc-runtime-library-exception-3.1
#   https://github.com/mono/mono/blob/mono-6.12.0.122/mono/mini/decompose.c#L966
#   https://github.com/mono/mono/blob/mono-6.12.0.122/THIRD-PARTY-NOTICES.TXT#L69
# GPL-2+ mono/benchmark/logic.cs
# GPL-2+-with-libtool-exception external/bdwgc/libtool
# GPL-2+ GPL-3+ GPL-3+-with-libtool-exception external/bdwgc/libtool
# GPL-2+-with-linking-exception mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs
# GPL-3+-with-autoconf-exception - external/bdwgc/libatomic_ops/config.guess
# LGPL-2.1 LGPL-2.1-with-linking-exception -- mcs/class/ICSharpCode.SharpZipLib/ICSharpCode.SharpZipLib/BZip2/BZip2.cs (ICSharpCode.SharpZipLib.dll)
# MIT UoI-NCSA - external/llvm-project/libunwind/src/EHHeaderParser.hpp
# openssl - external/boringssl/crypto/ecdh/ecdh.c
# OSL-3.0 - external/nunit-lite/NUnitLite-1.0.0/src/framework/Internal/StackFilter.cs
# ZLIB - external/ikvm ; lists paths/names with different licenses but these files are removed or not present (option disabled by godot-mono-builds)
# ZLIB - ikvm-native/jni.h

# See https://github.com/mono/mono/blob/main/LICENSE to resolve license compatibilities.


SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 -riscv x86 ~amd64-linux"
PGO_TRAINERS="
	mono-benchmark-trainer
	mono-managed-trainer
	mono-native-trainer
	mcs-trainer
"
IUSE+=" ${PGO_TRAINERS[@]}"
IUSE+=" doc minimal nls pax-kernel xen"
REQUIRED_USE+="
	pgo? (
		|| ( ${PGO_TRAINERS[@]} )
	)
"

# Note: mono works incorrect with older versions of libgdiplus
# Details on dotnet overlay issue: https://github.com/gentoo/dotnet/issues/429
DEPEND+="
	app-crypt/mit-krb5[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	ia64? ( sys-libs/libunwind )
	!minimal? ( >=dev-dotnet/libgdiplus-6.0.2 )
	nls? ( sys-devel/gettext )
"
RDEPEND+="
	${DEPEND}
	app-misc/ca-certificates
"
BDEPEND+="
	sys-devel/bc
	virtual/yacc
	pax-kernel? ( sys-apps/elfix )
"

SRC_URI="https://download.mono-project.com/sources/mono/${P}.tar.xz"

PATCHES=(
	"${FILESDIR}/${PN}-5.12-try-catch.patch"
	"${FILESDIR}/${PN}-6.12.0.122-disable-automagic-ccache.patch"
	"${FILESDIR}/${PN}-6.12.0.182-disable-test-mono-callspec.patch"
)

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

	local a
	for a in $(multilib_get_enabled_abis) ; do
		NABIS=$((${NABIS} + 1))
	done
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
		if (( ${NABIS} == 1 )) ; then
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
		fi
		uopts_src_compile
	}
	multilib_foreach_abi compile_abi
}

train_trainer_list() {
	use mono-benchmark-trainer && echo "mono-benchmark-trainer"
	use mono-managed-trainer && echo "mono-managed-trainer"
	use mono-native-trainer && echo "mono-native-trainer"
	use mcs-trainer && echo "mcs-trainer"
}

_pre_trainer_mono_benchmark() {
cat <<EOF > "${S}/mono-benchmark-trainer" || die
#!${EPREFIX}/bin/bash
cd "${S}/mono/benchmark"
make run-test || true
EOF
chmod +x "${S}/mono-benchmark-trainer" || die
}

_pre_trainer_mono_managed() {
cat <<EOF > "${S}/mono-managed-trainer" || die
#!${EPREFIX}/bin/bash
cd "${S}/mono/tests"
make check || true
EOF
chmod +x "${S}/mono-managed-trainer" || die
}

_pre_trainer_mono_native() {
cat <<EOF > "${S}/mono-native-trainer" || die
#!${EPREFIX}/bin/bash
cd "${S}/mono/unit-tests"
make check || true
EOF
chmod +x "${S}/mono-native-trainer" || die
}

_pre_trainer_mcs() {
cat <<EOF > "${S}/mcs-trainer" || die
#!${EPREFIX}/bin/bash
cd "${S}/mcs/tests"
make run-test || true
EOF
chmod +x "${S}/mcs-trainer" || die
}

_src_pre_train() {
	use mono-benchmark-trainer && _pre_trainer_mono_benchmark
	use mono-managed-trainer && _pre_trainer_mono_managed
	use mono-native-trainer && _pre_trainer_mono_native
	use mcs-trainer && _pre_trainer_mcs
}

train_get_trainer_exe() {
	local trainer="${1}"
	echo "${S}/${trainer}"
}

multilib_src_test() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi
	cd mcs/tests || die
	emake check
}

src_install() {
	if (( ${NABIS} == 1 )) ; then
		export BUILD_DIR="${S}"
		cd "${BUILD_DIR}" || die
	fi
	install_abi() {
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
