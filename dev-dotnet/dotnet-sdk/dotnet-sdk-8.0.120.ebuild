# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# Build ("src_compile")
# To learn about arguments that are passed to the "build.sh" script see:
# https://github.com/dotnet/source-build/discussions/4082
# User variable: DOTNET_VERBOSITY - set other verbosity log level.

CHECKREQS_DISK_BUILD="20G"
CHECKREQS_DISK_USR="650M"
COMMIT="6825a8d5c72c1893049c2c5ffa491b65cbcea7e0"
GCC_SLOT="11" # Same as U22 default
SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.20"
LLVM_COMPAT=( 18 ) # U22 defauls to  14
PYTHON_COMPAT=( "python3_11" ) # U22 uses 3.10.6
# Created by dotnet itself:
QA_PREBUILT="
.*/dotnet
.*/ilc
"
# .NET runtime, better to not touch it if they want some specific flags.
QA_FLAGS_IGNORED="
.*/apphost
.*/createdump
.*/libSystem.Globalization.Native.so
.*/libSystem.IO.Compression.Native.so
.*/libSystem.Native.so
.*/libSystem.Net.Security.Native.so
.*/libSystem.Security.Cryptography.Native.OpenSsl.so
.*/libclrgc.so
.*/libclrjit.so
.*/libcoreclr.so
.*/libcoreclrtraceptprovider.so
.*/libhostfxr.so
.*/libhostpolicy.so
.*/libmscordaccore.so
.*/libmscordbi.so
.*/libnethost.so
.*/singlefilehost
"

KEYWORDS="amd64"
S="${WORKDIR}/${PN}-${RUNTIME_SLOT}"
EGIT_COMMIT="dotnet-sdk-${PV}"
EGIT_MIN_CLONE_TYPE="shallow"
EGIT_REPO_URI="https://github.com/dotnet/dotnet.git"

inherit check-reqs flag-o-matic llvm-r1 multiprocessing python-any-r1 sandbox-changes

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="
	https://dotnet.microsoft.com/
	https://github.com/dotnet/dotnet/
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	CC-BY-3.0
	CC-BY-SA-3.0
	CC0-1.0
	custom
	DOTNET-libraries-and-runtime-components-patents
	GPL-2-with-linking-exception
	HPND
	LGPL-2.1+
	MIT
	Ms-PL
	public-domain
	Unicode-DFS-2016
	UoI-NCSA
	W3C-Software-and-Document-Notice-and-License
	ZLIB
"
# See https://github.com/dotnet/dotnet/blob/v8.0.120/THIRD-PARTY-NOTICES.txt
# The distro's Apache-2.0 license template doesn't contain the all rights reserved clause.
# The distro's MIT license template doesn't contain the all rights reserved clause.
# Apache-2.0 Boost-1.0 BSD-2 HPND MIT public-domain UoI-NCSA ZLIB - src/diagnostics/THIRD-PARTY-NOTICES.TXT
# Apache-2.0 BSD custom CC-BY-3.0 MIT Ms-PL - src/source-build-externals/src/application-insights/WEB/ThirdPartyNotices.txt
# CC-BY-SA-3.0 - src/runtime/src/tests/sizeondisk/sodbench/THIRD-PARTY-NOTICES.TXT
# custom - Search "The limited permissions granted above"
# custom - Search "To anyone who acknowledges that this file is"
# custom - See src/roslyn/src/Setup/Roslyn.VsixLicense/EULA.rtf
# custom - See src/roslyn-analyzers/assets/EULA.txt
# ( all-rights-reserved Apache-2.0 ) src/msbuild/THIRDPARTYNOTICES.txt
# GPL-2-with-linking-exception LGPL-2.1+ MIT ZLIB - src/sourcelink/src/SourceLink.Git.IntegrationTests/THIRD-PARTY-NOTICES.txt
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"

# STRIP="llvm-strip" corrupts some executables when using the patchelf hack.
# Be safe and restrict it for source-built too, bug https://bugs.gentoo.org/923430
RESTRICT="splitdebug strip"

CURRENT_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
"
EXTRA_NUGETS_DEPEND="
	~dev-dotnet/dotnet-runtime-nugets-6.0.36
	~dev-dotnet/dotnet-runtime-nugets-7.0.20
"
NUGETS_DEPEND="
	${CURRENT_NUGETS_DEPEND}
	${EXTRA_NUGETS_DEPEND}
"
PDEPEND="
	${NUGETS_DEPEND}
"
RDEPEND="
	(
		>=dev-libs/openssl-3.0.2:0/3
		dev-libs/openssl:=
	)
	(
		>=dev-util/lttng-ust-2.13.1
		dev-util/lttng-ust:=
	)
	>=app-arch/brotli-1.0.9
	>=app-crypt/mit-krb5-1.19.2:0/0
	>=dev-libs/icu-70.1
	>=dev-libs/rapidjson-1.1.0
	>=sys-libs/libunwind-1.3.2
	>=sys-libs/zlib-1.2.11:0/1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
	')
	>=dev-build/cmake-3.22.1
	>=dev-vcs/git-2.34.1
	sys-devel/gcc:${GCC_SLOT}
"
IDEPEND="
	app-eselect/eselect-dotnet
"

check_requirements_locale() {
	if [[ "${MERGE_TYPE}" != "binary" ]] ; then
		if use elibc_glibc ; then
			local locales
			locales="$(locale -a)"

			if has en_US.utf8 ${locales} ; then
				LC_ALL="en_US.utf8"
			elif has en_US.UTF-8 ${locales} ; then
				LC_ALL="en_US.UTF-8"
			else
eerror "The locale en_US.utf8 or en_US.UTF-8 is not available."
eerror "Please generate en_US.UTF-8 before building ${CATEGORY}/${P}."

eerror "Could not switch to the en_US.UTF-8 locale."
				die
			fi
		else
			LC_ALL="en_US.UTF-8"
		fi

		export LC_ALL
einfo "Successfully switched to the ${LC_ALL} locale."
	fi
}

pkg_pretend() {
	check-reqs_pkg_pretend

	check_requirements_locale
}

pkg_setup() {
einfo "Build:  Long Term Support (LTS)"
	sandbox-changes_no_network_sandbox "To download project and submodules"
	check-reqs_pkg_setup
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup

	check_requirements_locale
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	cd "${S}" || die
	git rev-parse HEAD || die
	"./prep.sh" || die
	rm -f -r ".git"
}

src_prepare() {
	default

	# We need to ensure that we avoid this error:
	# error: "Assumed value of MB_LEN_MAX wrong"
	# To fix this, we usually use an earlier GCC slot.
	local gcc_slot=$(gcc-config -l | grep "*" | cut -f 3 -d " ")
	gcc_slot=${row##*-}
	if (( ${gcc_slot} != ${GCC_SLOT} )) ; then
eerror
eerror "Switch to GCC ${GCC_SLOT}.  Do the following"
eerror
eerror "eselect gcc set ${CHOST}-${GCC_SLOT}"
eerror "source /etc/profile"
eerror
		die
	fi

	strip-flags
	# Not implemented by Clang, bug 946334 \
	filter-flags -Werror=lto-type-mismatch
	filter-flags -Wlto-type-mismatch
	filter-lto

	unset DOTNET_ROOT
	unset NUGET_PACKAGES

	unset CLR_ICU_VERSION_OVERRIDE
	unset USER_CLR_ICU_VERSION_OVERRIDE

	export DOTNET_CLI_TELEMETRY_OPTOUT="1"
	export DOTNET_NUGET_SIGNATURE_VERIFICATION="false"
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE="1"
	export MSBUILDDISABLENODEREUSE="1"
	export MSBUILDTERMINALLOGGER="off"
	export UseSharedCompilation="false"

	local dotnet_sdk_tmp_directory="${WORKDIR}/dotnet-sdk-tmp"
	mkdir -p "${dotnet_sdk_tmp_directory}" || die

	# This should fix the "PackageVersions.props" problem,
	# see below, in src_compile.
	sed -e "s|/tmp|${dotnet_sdk_tmp_directory}|g" -i build.sh || die
}

src_compile() {
	# Remove .NET leftover files that can be blocking the build.
	# Keep this nonfatal!
	local package_versions_path="/tmp/PackageVersions.props"
	if [[ -f "${package_versions_path}" ]] ; then
		rm "${package_versions_path}" ||
			ewarn "Failed to remove ${package_versions_path}, build may fail!"
	fi

	# The "source_repository" should always be the same.
	local source_repository="https://github.com/dotnet/dotnet"
	local verbosity="${DOTNET_VERBOSITY:-minimal}"

	ebegin "Building the .NET SDK ${SDK_SLOT}"
	local -a buildopts=(
	# URLs, version specification, etc. ...
		--source-repository "${source_repository}"
		--source-version "${COMMIT}"

	# How it should be built.
		--clean-while-building

	# Auxiliary options.
		--
		-maxCpuCount:"$(makeopts_jobs)"
		-p:MaxCpuCount="$(makeopts_jobs)"
		-p:ContinueOnPrebuiltBaselineError="true"

	# Verbosity settings.
		-verbosity:"${verbosity}"
		-p:LogVerbosity="${verbosity}"
		-p:verbosity="${verbosity}"
		-p:MinimalConsoleLogOutput="false"
	)
	bash "./build.sh" "${buildopts[@]}"
	eend ${?} || die "build failed"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SDK_SLOT}"
	dodir "${dest}"

	ebegin "Extracting the .NET SDK archive"
	tar xzf "artifacts/"*"/Release/${PN}-${SDK_SLOT}."*".tar.gz" -C "${ED}/${dest}"
	eend ${?} || die "extraction failed"

	fperms 0755 "${dest}"
	dosym -r "${dest}/dotnet" "/usr/bin/dotnet-${SDK_SLOT}"

	# Fix permissions again for what is already marked as executable.
	find "${ED}" -type f -executable -exec chmod +x {} + || die
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
