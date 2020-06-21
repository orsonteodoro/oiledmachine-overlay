# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI=7
DESCRIPTION="CoreFX is the foundational class libraries for .NET Core. It \
includes types for collections, file systems, console, JSON, XML, async and \
many others."
HOMEPAGE="https://github.com/dotnet/corefx"
LICENSE="all-rights-reserved
	Apache-2.0
	MIT
	BSD
	BSD-2
	unicode
	W3C
	ZLIB" # The vanilla MIT license does not have all rights reserved
KEYWORDS="~amd64 ~arm"
CORE_V="${PV}"
SDK_V="2.1.300-rc1-008673" # found in DotnetCLIVersion.txt
SDK_V_FALLBACK=2.1.302 # Using earliest 2.1 with arm/arm64 support
# Need to use fallback version to avoid
# The specified framework 'Microsoft.NETCore.App', version '1.1.0' was not found.
# For 1.1.x runtimes
# https://github.com/dotnet/core/tree/master/release-notes/download-archives
# For 1.1.0 runtime see
# https://github.com/dotnet/core/blob/master/release-notes/1.1/releases.json
IUSE="debug doc heimdal test"
REQUIRED_USE="!debug"  # To prevent xunit download failure
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we
# have to keep downloading it everytime the sandbox is wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
SDK_BASEURI_FALLBACK="\
https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/"
RT_V_1_1_BASEURI=\
"https://download.microsoft.com/download/A/F/6/AF610E6A-1D2D-47D8-80B8-F178951A0C72/Binaries"
# No 1.1.0 dotnet-runtime for arm/arm64
FX_V_FALLBACK="servicing-28928-01"
FX_V="servicing-28619-01"
CLR_V_2_1_FALLBACK="2.1.19-${FX_V_FALLBACK}" # See CoreCLR 2.1 branch
CLR_V_2_1="2.1.17-${FX_V}" # From MicrosoftNETCoreRuntimeCoreCLRPackageVersion in dependencies.props
CLR_V_2_1_HASH_FALLBACK="aaadde716917918910882bc57a91157f74898897"
CLR_V_2_1_HASH="bdc9476e343d89127d7f8ac4b939b5d9c5316245"
SRC_URI="\
https://github.com/dotnet/${PN}/archive/v${CORE_V}.tar.gz \
  -> ${PN}-${CORE_V}.tar.gz
  amd64? ( ${SDK_BASEURI_FALLBACK}/dotnet-sdk-${SDK_V_FALLBACK}-linux-x64.tar.gz
	${RT_V_1_1_BASEURI}/dotnet-ubuntu.16.04-x64.1.1.0.tar.gz )
  arm? ( ${SDK_BASEURI_FALLBACK}/dotnet-sdk-${SDK_V_FALLBACK}-linux-arm.tar.gz )
  arm64? ( ${SDK_BASEURI_FALLBACK}/dotnet-sdk-${SDK_V_FALLBACK}-linux-arm64.tar.gz )
https://github.com/dotnet/corefx/commit/84fd7608e9b0a2974ccd9a5c4e51dc2b86cc40d9.patch -> ${PN}-2.1.19-no-download-symbols.patch
"
SLOT="${PV}"
# Requirements based on Ubuntu 16.04 minimum requirements.
# Library requirements based on:
# init-tools.sh
# Documentation/building/unix-instructions.md
# cross/build-rootfs.sh
# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore21
RDEPEND=">=dev-libs/icu-55.1
	 >=dev-libs/openssl-1.0.2o
	 >=dev-libs/openssl-compat-1.0.2o:1.0.0
	 >=dev-dotnet/libgdiplus-6.0.1
	 >=dev-util/lldb-4.0
	 >=dev-util/lttng-ust-2.7.1
	 >=net-misc/curl-7.47
	 heimdal? ( >=app-crypt/heimdal-1.7 )
	!heimdal? ( >=app-crypt/mit-krb5-1.13.2 )
	 >=sys-devel/llvm-3.9:*
	 >=sys-libs/libunwind-1.1
	 >=sys-libs/zlib-1.2.8"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.5.1
	  dev-vcs/git
	>=sys-devel/clang-3.9
	>=sys-devel/gettext-0.19.7
	>=sys-devel/make-4.1
	 !dev-dotnet/dotnetcore-aspnet-bin
	 !dev-dotnet/dotnetcore-runtime-bin
	 !dev-dotnet/dotnetcore-sdk-bin"
S="${WORKDIR}/${PN}-${CORE_V}"
RESTRICT="mirror"
_PATCHES=(
	"${FILESDIR}/${PN}-2.1.18-found-clang-on-gentoo-for-build-native.patch"
	"${FILESDIR}/${PN}-2.1.18-no-werror.patch"
	"${FILESDIR}/${PN}-2.1.19-pull-request-31457-backport.patch"
	"${FILESDIR}/${PN}-2.1.19-disable-parallel-in-init-tools.patch"
	"${FILESDIR}/${PN}-2.1.19-disable-parallel-in-SharedFrameworkValidation_proj.patch"
	"${DISTDIR}/${PN}-2.1.19-no-download-symbols.patch"
)

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_setup() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while
	# compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die \
"${PN} requires sandbox and usersandbox to be disabled in FEATURES."
	fi

	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES."
	fi

	einfo "CPU Architecture:"
	case ${CHOST} in
		aarch64*) einfo "  aarch64";;
		armv7a*h*) einfo "  armv7a-hf";;
		x86_64*)  einfo "  x86_64";;
		*) die "Unsupported CPU architecture";;
	esac

	if [[ "${ARCH}" =~ (arm) ]] ; then
		ewarn "arm is untested.  It may not build at all due to missing dotnet-runtime 1.1.0 for arm."
	elif [[ "${ARCH}" =~ (arm64) ]] ; then
		ewarn "arm64 is unsupported upstream.  Building anyway"
	fi
}

_set_download_cache_folder() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local dlbasedir="${distdir}/oiledmachine-overlay-dev_dotnet"
	addwrite "${dlbasedir}"
	local global_packages="${dlbasedir}/.nuget/packages"
	local http_cache="${dlbasedir}/NuGet/v3-cache"
	mkdir -p "${http_cache}" || die
	export NUGET_HTTP_CACHE_PATH="${http_cache}"
	einfo \
"Using ${dlbasedir} to store cached downloads for \`dotnet restore\` \
or NuGet downloads"
	einfo "Remove the folder it if it is problematic."
}

src_unpack() {
	_set_download_cache_folder

	einfo \
"If you emerged this first, please use the meta package dotnetcore-sdk instead\
 as the starting point."
	unpack "${PN}-${CORE_V}.tar.gz"

	cd "${S}" || die

	X_SDK_V=$(cat DotnetCLIVersion.txt)
	if [[ ${ARCH} =~ (arm64|arm|amd64) ]] ; then
		echo "${SDK_V_FALLBACK}" > DotnetCLIVersion.txt || die
	elif [[ ! -f DotnetCLIVersion.txt ]] ; then
		die "Cannot find DotnetCLIVersion.txt"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
SDK_V to ${X_SDK_V}"
	fi

	local d="Tools/dotnetcli"
	mkdir -p "${d}" || die
	pushd "${d}" || die
		unpack "dotnet-ubuntu.16.04-x64.1.1.0.tar.gz"
	popd || die

	# gentoo or the sandbox doesn't allow downloads in compile phase
	# so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${S}" || die

	eapply ${_PATCHES[@]}

	sed -i -e "s|${CLR_V_2_1}|${CLR_V_2_1_FALLBACK}|g" \
		"dependencies.props" || die
	sed -i -e "s|${CLR_V_2_1_HASH}|${CLR_V_2_1_HASH_FALLBACK}|g" \
		"dependencies.props" || die
	sed -i -e "s|${FX_V}|${FX_V_FALLBACK}|g" \
		"dependencies.props" || die
	sed -i -e "s|${CLR_V_2_1}|${CLR_V_2_1_FALLBACK}|g" \
		"tools-local/ILAsmVersion.txt" || die

#	# Tools/Build.Common.props appears later
#	sed -i -e "s|--packages|--packages --disable-parallel|g" \
#		Tools/Build.Common.props || die
}

_getarch() {
	if [[ ${ARCH} =~ (amd64) ]]; then
		myarch="x64"
	elif [[ ${ARCH} =~ (x86) ]] ; then
		myarch="x32"
	elif [[ ${ARCH} =~ (arm64) ]] ; then
		myarch="arm64"
	elif [[ ${ARCH} =~ (arm) ]] ; then
		myarch="arm"
	fi
	echo "${myarch}"
}

_src_compile() {
	cd "${S}" || die
	local buildargs_corefx=""
	local buildargs_corefx_native=""
	local buildargs_corefx_managed=""
	local mydebug=$(usex debug "debug" "release")
	local myarch=$(_getarch)

	if use heimdal; then
		# build uses mit-krb5 by default but lets override to heimdal
		buildargs_corefx_alt+=" -cmakeargs -DHeimdalGssApi=ON"
	fi

	# prevent: InvalidOperationException: The terminfo database is invalid
	# dotnet.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	export ProcessorCount=${numproc}
	#buildargs_corefx+=" --numproc ${numproc}"

	if ! use test ; then
		buildargs_corefx+=" -SkipTests=true -BuildTests=false"
	else
		buildargs_corefx+=" -SkipTests=false -BuildTests=true"
	fi

	CLANG_MAJOR=$(ver_cut 1 $(clang --version | head -n 1 | cut -f 3 -d " "))
	CLANG_MINOR=$(ver_cut 2 $(clang --version | head -n 1 | cut -f 3 -d " "))
	einfo "Clang detected as ${CLANG_MAJOR}.${CLANG_MINOR}"

	export OPENSSL_CRYPTO_LIBRARY="/usr/$(get_libdir)/libssl.so.1.0.0"
	export OPENSSL_INCLUDE_DIR="/usr/include/openssl"

	buildargs_corefx_native+=" -cmakeargs -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_CRYPTO_LIBRARY}"
	buildargs_corefx_native+=" -cmakeargs -DOPENSSL_INCLUDE_DIR=${OPENSSL_INCLUDE_DIR}"

	buildargs_corefx_managed+=" /p:DotNetBuildFromSource=true"

	sed -i -e "s|unset ILASMCOMPILER_VERSION|:;#unset ILASMCOMPILER_VERSION|g" \
		init-tools.sh || die

	local fn
	if [[ ${ARCH} =~ (arm64|arm|amd64) ]] ; then
		fn="dotnet-sdk-${SDK_V_FALLBACK}-linux-${myarch}.tar.gz"
	else
		fn="dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz"
	fi
	export DotNetBootstrapCliTarPath="${DISTDIR}/${fn}"

	ewarn \
"Restoration (i.e. downloading) may randomly fail for bad local routers, \
firewalls, or network cards.  Emerge and try again."
	einfo "Building native CoreFX"
	./run.sh build-native -ArchGroup=${myarch} -${mydebug} \
		${buildargs_corefx} -- --clang${CLANG_MAJOR}.${CLANG_MINOR} \
		--numproc ${numproc} \
		${buildargs_corefx_native} || die

	einfo "Building managed CoreFX"
	./run.sh build-managed -ArchGroup=${myarch} -${mydebug} \
		${buildargs_corefx} \
		-- ${buildargs_corefx_managed} || die

	if use test ; then
		einfo "Building CoreFX tests"
		cd "${S}" || die
		./build-tests.sh -ArchGroup=${myarch} \
			-${mydebug} || die
	fi
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
	local myarch=$(_getarch)
	local mydebug=$(usex debug "Debug" "Release")

	insinto "${dest_core}"
	doins "${S}/bin/runtime/netcoreapp-Linux-${mydebug}-${myarch}"/*
	chmod 0755 "${ddest_core}"/*.so
	if use debug ; then
		chmod 0755 "${ddest_core}"/*.dbg || die
	fi
	fperms 0755 "${dest_core}"/{dotnet,apphost}

	exeinto "${dest}/host/fxr/${PV}"
	doexe "${S}/bin/runtime/netcoreapp-Linux-${mydebug}-${myarch}"/{libhostfxr.so,apphost}

	cd "${S}" || die
	docinto licenses
	dodoc LICENSE.TXT PATENTS.TXT THIRD-PARTY-NOTICES.TXT

	if use doc ; then
		docinto docs
		dodoc -r CODE_OF_CONDUCT.md CONTRIBUTING.md Documentation \
			README.md
	fi

	# Dedupe for CoreCLR
	pushd "${ddest_core}" || die
	rm \
		SOS.NETCore.dll \
		System.Globalization.Native.so \
		System.Private.CoreLib.dll \
		corerun \
		createdump \
		libclrjit.so \
		libcoreclr.so \
		libcoreclrtraceptprovider.so \
		libdbgshim.so \
		libmscordaccore.so \
		libmscordbi.so \
		libsos.so \
		libsosplugin.so \
		sosdocsunix.txt
	popd || die
}
