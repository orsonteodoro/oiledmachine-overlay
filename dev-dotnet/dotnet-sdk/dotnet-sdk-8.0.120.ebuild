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
SRC_URI=""

inherit check-reqs flag-o-matic llvm-r1 multiprocessing python-any-r1 sandbox-changes

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="
	https://dotnet.microsoft.com/
	https://github.com/dotnet/dotnet/
"
LICENSE="MIT"
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
	>=app-arch/brotli-1.0.9
	>=app-crypt/mit-krb5-1.19.2:0/0
	>=dev-libs/icu-70.1
	>=dev-libs/openssl-3.0.2
	dev-libs/openssl:=
	>=dev-libs/rapidjson-1.1.0
	>=dev-util/lttng-ust-2.13.1
	dev-util/lttng-ust:=
	>=sys-libs/libunwind-1.3.2
	>=sys-libs/zlib-1.2.11:0/1
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.22.1
	>=dev-vcs/git-2.34.1
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
	')
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
	sandbox-changes_no_network_sandbox "To download tarball with submodules"
	check-reqs_pkg_setup
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup

	check_requirements_locale
}

build_tarball() {
	# Typically, a GH tarball doesn't package submodules.  A clone will download the submodules.
	git clone --depth 1 -b "v${RUNTIME_SLOT}" "https://github.com/dotnet/dotnet" "dotnet-sdk-${RUNTIME_SLOT}" || die
	cd "dotnet-sdk-${RUNTIME_SLOT}" || die
	git rev-parse HEAD || die
	"./prep.sh" || die
	rm -fr .git
	cd .. || die
	tar -acf "dotnet-sdk-${PV}-prepared-gentoo-amd64.tar.xz" "dotnet-sdk-${RUNTIME_SLOT}" || die
}

src_unpack() {
	build_tarball
	unpack "dotnet-sdk-${PV}-prepared-gentoo-amd64.tar.xz"
}

src_prepare() {
	default

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
