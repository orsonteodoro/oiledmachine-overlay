# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI=7
DESCRIPTION="ASP.NET Core is a cross-platform .NET framework for building \
modern cloud-based web applications on Windows, Mac, or Linux."
HOMEPAGE="https://github.com/aspnet/AspNetCore/"
LICENSE="all-rights-reserved
	 Apache-2.0
	 BSD
	 BSD-2
	 ISC
	 MIT
	 SIL-1.1
	 ZLIB
" # The vanilla MIT license does not have all rights reserved
KEYWORDS="~amd64 ~arm ~arm64"
DropSuffix="false" # true=official latest release, false=dev for live ebuilds
# DO NOT SET DropSuffix=true for 3.1.  \
# Tarball builds not supported.  Only git (Required by Microsoft.DotNet.Arcade.Sdk).
MY_PN="AspNetCore"
IUSE="debug doc test"
REQUIRED_USE="!test" # broken
NETFX_V="4.7.2" # max .NETFramework requested
SDK_V="3.1.103" # from global.json
ASPNETCORE_COMMIT="844a82e37cae48af2ab2ee4f39b41283e6bb4f0e" # exactly ${PV}
GOOGLETEST_COMMIT="4e4df226fc197c0dda6e37f5c8c3845ca1e73a49" # see src/submodules
MESSAGEPACK_CSHARP_COMMIT="8861abdde93a3b97180ac3b2eafa33459ad52392" # see src/submodules
SLOT="${PV}"
# For dependencies, see...
# eng/common/cross/build-rootfs.sh
# src/Installers/Debian/tools/setup/build_setup.sh
# src/submodules/googletest/ci/install-linux.sh
# src/submodules/googletest/README.md
# src/submodules/googletest/CONTRIBUTING.md
# docs/BuildFromSource.md
# eng/common/cross/armel/tizen-fetch.sh
# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore31
# (R)DEPENDs assumes Ubuntu 16.04 lib versions minimal.
RDEPEND=">=app-crypt/mit-krb5-1.13.2
	 >=dev-libs/icu-55.1
	 >=dev-libs/openssl-compat-1.0.2o:1.0.0
	 >=dev-util/lldb-3.9.1
	 >=dev-util/lttng-ust-2.7.1
	 >=net-libs/nodejs-10.14.2
	 >=net-misc/curl-7.47
	 >=sys-libs/libunwind-1.1
	 >=sys-libs/zlib-1.2.8"
DEPEND="${RDEPEND}
	  dev-dotnet/cli-tools
	 !dev-dotnet/dotnetcore-aspnet-bin
	 !dev-dotnet/dotnetcore-runtime-bin
	 !dev-dotnet/dotnetcore-sdk-bin
	  dev-util/bazel
	>=dev-util/cmake-2.5.1
	  dev-vcs/git
	  net-misc/wget
	  sys-devel/automake
	  sys-devel/autoconf
	>=sys-devel/clang-3.9.1
	>=sys-devel/gcc-4.9
	  sys-devel/libtool
	>=virtual/jdk-11"
# currently using only tarballs to avoid git is a problem at build time
ASPNET_GITHUB_BASEURI="https://github.com/aspnet"
if [[ "${DropSuffix}" == "true" ]] ; then
SRC_URI_TGZ="\
${ASPNET_GITHUB_BASEURI}/${MY_PN}/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz \
	-> googletest-${GOOGLETEST_COMMIT}.tar.gz
${ASPNET_GITHUB_BASEURI}/MessagePack-CSharp/archive/${MESSAGEPACK_CSHARP_COMMIT}.tar.gz \
	-> messagepack-csharp-${MESSAGEPACK_CSHARP_COMMIT}.tar.gz"
fi
# We need to cache the dotnet-sdk and dotnet-runtime tarballs outside the
# sandbox otherwise we have to keep downloading it everytime the sandbox is
# wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
CORE_V="3.1.5-servicing.20270.5" # found eng/Versions.props \
CORE_V_BASEURI="https://dotnetcli.azureedge.net/dotnet/Runtime/${CORE_V}"
			# under MicrosoftNETCoreAppInternalPackageVersion tag
SRC_URI+="${SRC_URI_TGZ}
	 amd64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz
		${CORE_V_BASEURI}/dotnet-runtime-${CORE_V}-linux-x64.tar.gz
	 )
	 arm? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz
		${CORE_V_BASEURI}/dotnet-runtime-${CORE_V}-linux-arm.tar.gz
	 )
	 arm64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz
		${CORE_V_BASEURI}/dotnet-runtime-${CORE_V}-linux-arm64.tar.gz
	 )"
S=${WORKDIR}
RESTRICT="mirror"
inherit git-r3
_PATCHES=(
	"${FILESDIR}/${PN}-3.1.5-limit-maxHttpRequestsPerSource-to-1.patch"
	"${FILESDIR}/${PN}-3.1.5-msbuild-RestoreDisableParallel-true.patch"
)

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

if [[ "${DropSuffix}" == "true" ]] ; then
S="${WORKDIR}/${MY_PN}-${PV}"
else
S="${WORKDIR}/${PN}-${PV}"
fi

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
}

_unpack_asp() {
	cd "${WORKDIR}" || die
	unpack ${A}

	cd ${MY_PN}-${PV} || die

	mkdir -p modules || die
	mkdir -p src/submodules || die

	# See .gitmodules

	pushd src/submodules || die
	mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}"/ \
		"${WORKDIR}/googletest" || die
	mv "${WORKDIR}/googletest" . || die
	popd || die

	pushd src/submodules || die
	mv "${WORKDIR}/MessagePack-CSharp-${MESSAGEPACK_CSHARP_COMMIT}"/ \
		"${WORKDIR}/MessagePack-CSharp" || die
	mv "${WORKDIR}/MessagePack-CSharp" . || die
	popd || die
}

_fetch_asp() {
	EGIT_REPO_URI="${ASPNET_GITHUB_BASEURI}/${MY_PN}.git"
	EGIT_COMMIT="v${PV}"
	git-r3_fetch
	git-r3_checkout
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
	einfo \
"If you emerged this first, please use the meta package dotnetcore-sdk instead\
 as the starting point."

	_set_download_cache_folder

	# need repo references
	if [[ "${DropSuffix}" == "true" ]] ; then
		_unpack_asp
	else
		_fetch_asp
	fi

	cd "${S}" || die

	X_CORE_V=$(grep -r -e "MicrosoftNETCoreAppInternalPackageVersion" \
		eng/Versions.props \
 | cut -f 2 -d ">" | cut -f 1 -d "<")
	if [[ ! -f eng/Versions.props ]] ; then
		die "Cannot find eng/Versions.props"
	elif [[ "${X_CORE_V}" != "${CORE_V}" ]] ; then
		die \
 "Cached dotnet-runtime in distfiles is not the same as requested.  Update \
 ebuild's CORE_V to ${X_CORE_V}"
	fi

	X_SDK_V=$(grep "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ! -f global.json ]] ; then
		die "Cannot find global.json"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
SDK_V to ${X_SDK_V}"
	fi

	# Gentoo or the sandbox doesn't allow downloads in compile phase so move
	# here
	_src_prepare
	_src_compile

	if [[ "${DropSuffix}" == "true" ]] ; then
		die "Compiling with DropSuffix=${DropSuffix} is not supported."
	fi
}

_use_native_netcore() {
	# Use mono dlls instead of prebuilt targeting pack dlls
	# Fix for:
	# error MSB3644: The reference assemblies for framework
	# ".NETFramework,Version=v4.6.1" were not found.

	# Trick the scripts by creating the dummy dir to skip downloading.
#	local p
#	p="${S}/.dotnet/buildtools/netfx/${CORE_V}/"
#	mkdir -p "${p}" || die

	L=$(find "${S}"/modules/EntityFrameworkCore/ -name "*.csproj")
	for f in $L ; do
		cp "${FILESDIR}"/netfx.props "$(dirname $f)" || die
		einfo "Editing $f"
		sed -i -e "s|\
<Project>|\
<Project>\n\
  <Import Project=\"netfx.props\" />\n|g" \
			"$f" || die
		sed -i -e "s|\
<Project Sdk=\"Microsoft.NET.Sdk\">|\
<Project Sdk=\"Microsoft.NET.Sdk\">\n\
  <Import Project=\"netfx.props\" />\n|g" \
			"$f" || die
	done
}

# prebuilt (i.e. binary distributed) by Microsoft
# does not contain a license file in the archive
_use_ms_netcore() {
	local myarch=$(_getarch)
	# corefx (netcore) not the same as netfx (found in mono)
	local p
	p="${S}/.dotnet" # for Microsoft tarball
	mkdir -p "${p}" || die
	pushd "${p}" || die
		tar -xvf \
	"${DISTDIR}/dotnet-runtime-${CORE_V}-linux-${myarch}.tar.gz" || die
	popd || die
}

_use_native_sdk() {
	local p
	p="${S}/.dotnet/sdk/${SDK_V}"
	mkdir -p "${p}" || die

	# This is a workaround for /opt/dotnet/dotnetinstall.lock: Permission denied
	# We cannot use addwrite/addread with /opt/dotnetinstall.lock.
	#
	# It would be better just to modify korebuild's dotnet-install.sh's
	# dotnetinstall.lock location but can't do that because the file is not
	# located in the tarballs before the build process but later in the
	# middle of the build process of fetching dependency packages.
	cp -a /opt/dotnet/* "${p}" || die

	# It has to be done manually if you don't let the installer get the tarballs.
	export PATH="${p}:${PATH}"
}

_getarch() {
	local myarch=""
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

# prebuilt (i.e. binary distributed)
_use_ms_sdk() {
	local p
#	p="${S}/.dotnet/sdk/${SDK_V}"
	p="${S}/.dotnet"
	mkdir -p "${p}" || die
	pushd "${p}" || die
		local myarch=$(_getarch)
		unpack "dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd || die
	export PATH="${p}:${PATH}"
}

_unpack_dotnet_runtime() {
	local myarch=$(_getarch)
	mkdir -p "${HOME}/.dotnet" || die
	pushd "${HOME}/.dotnet" || die
	unpack "dotnet-runtime-${CORE_V}-linux-${myarch}.tar.gz"
	popd || die
}

_src_prepare() {
	cd "${WORKDIR}" || die

	# allow verbose output
	local F=$(grep -l -r -e "__init_tools_log" $(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i \
	-e 's|>> "$__init_tools_log" 2>&1|\|\& tee -a "$__init_tools_log"|g' \
	-e 's|>> "$__init_tools_log"|\| tee -a "$__init_tools_log"|g' \
	-e 's| > "$__init_tools_log"| \| tee "$__init_tools_log"|g' "$f" || die
	done

	# allow wget curl output
	local F=$(grep -l -r -e "-sSL" $(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|-sSL|-L|g' -e 's|wget -q |wget |g' "$f" || die
	done

	if ! use test ; then
		_D="${S}/src/submodules/googletest/googletest/xcode/Config"
		sed -i -e "s|-Werror||g" "${_D}/General.xcconfig" || die
	fi

	cd "${S}" || die
	eapply ${_PATCHES[@]}

	#_use_native_netcore
	_use_ms_netcore

	#_use_native_sdk
	_use_ms_sdk

	_unpack_dotnet_runtime

	# Common problem in 3.1.x.  darc-int is a private package but it's not
	# supposed to be there.
	sed -i -e '/.*darc-int-.*/d' NuGet.config || die
	# Should be public packages not internal
	sed -i -e "s|\
MicrosoftNETCoreAppInternalPackageVersion|\
MicrosoftNETCoreAppRuntimeVersion|g" \
		global.json || die
	sed -i -e "s|\
\$(DotNetAssetRootUrl)Runtime/\$(MicrosoftNETCoreAppInternalPackageVersion)|\
\$(DotNetAssetRootUrl)Runtime/\$(MicrosoftNETCoreAppRuntimeVersion)|g" \
		src/Framework/src/Microsoft.AspNetCore.App.Runtime.csproj || die
	# Replace with more reliable host.  Try to avoid:
	# Microsoft.AspNetCore.App.Runtime.csproj(388,5): error : Giving up downloading the file from 'https://dotnetcli.blob.core.windows.net/dotnet/Runtime/3.1.5-servicing.20270.5/dotnet-runtime-3.1.5-linux-x64.tar.gz' after 5 retries.
	# Host/dotnet-runtime same as in SRC_URI
	sed -i -e "s|dotnetcli.blob.core.windows.net|dotnetcli.azureedge.net|" \
		eng/Versions.props || die

	# todo: Needs (re-)testing
	#sed -i -e "s|dotnet restore|dotnet restore --disable-parallel|g" \
	#	eng/common/internal-feed-operations.sh || die

	if use debug ; then
		pushd src/Components/Web.JS/dist || die
		ln -s Release Debug || die
		popd || die
	fi
}

_src_compile() {
	local buildargs_coreasp=""
	local mydebug=$(usex debug "Debug" "Release")
	local myarch=$(_getarch)

	# For smoother network multitasking (default 50)
	export npm_config_maxsockets=1

	# This prevents InvalidOperationException: The terminfo database is
	# invalid.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	# Force it to be 1 since it slows down the PC.
	local numproc="1"

	# Required by Microsoft.Build.Tasks.Git
	# See
	# https://github.com/dotnet/sourcelink/pull/438/files
	# https://github.com/dotnet/sourcelink/blob/master/src/Microsoft.Build.Tasks.Git.UnitTests/GitOperationsTests.cs#L207
	git remote add origin https://github.com/dotnet/${PN}.git || die

	if [[ "${DropSuffix}" == "true" ]] ; then
		ewarn \
	"Building with DropSuffix=true (with tarballs, no git) is broken"
	fi

	cd "${S}" || die

	einfo "Building ${MY_PN}"
	ewarn \
"Restoration (i.e. downloading) may randomly fail for bad local routers, \
firewalls, or network cards.  Emerge and try again."
	./build.sh --arch ${myarch} \
		--configuration ${mydebug^} ${buildargs_coreasp} \
		|| die
}

src_test() {
	if use test ; then
		./build.sh --test || die
	fi
}

# See https://docs.microsoft.com/en-us/dotnet/core/build/distribution-packaging
src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_aspnetcoreapp="${dest}/shared/Microsoft.${MY_PN}.App/${PV}/"
	local ddest_aspnetcoreapp="${ddest}/shared/Microsoft.${MY_PN}.App/${PV}/"
	local mydebug=$(usex debug "Debug" "Release")
	local myarch=$(_getarch)

	# Based on https://www.archlinux.org/packages/community/x86_64/aspnet-runtime/
	# i.e. unpacked binary distribution

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	insinto "${dest_aspnetcoreapp}"
	local rid="linux-${myarch}"
	local module_name="Microsoft.${MY_PN}.App.Runtime"
	local netcore_moniker="netcoreapp"$(ver_cut 1-2 ${PV})
	local d=\
"${S}/artifacts/bin/${module_name}/${mydebug}/${netcore_moniker}/${rid}"
	doins "${d}"/*

	docinto licenses
	dodoc LICENSE.txt THIRD-PARTY-NOTICES.txt
	cp -a src/SignalR/{,SignalR-}THIRD-PARTY-NOTICES || die
	dodoc src/SignalR/SignalR-THIRD-PARTY-NOTICES
	cp -a src/SignalR/clients/ts/signalr/src/\
{,SignalR-clients-ts-}third-party-notices.txt || die
	dodoc src/SignalR/clients/ts/signalr/src/\
SignalR-clients-ts-third-party-notices.txt
	cp -a src/SignalR/clients/ts/signalr-protocol-msgpack/src/\
{,SignalR-clients-ts-signalr-protocol-msgpack-}third-party-notices.txt || die
	dodoc src/SignalR/clients/ts/signalr-protocol-msgpack/src/\
SignalR-clients-ts-signalr-protocol-msgpack-third-party-notices.txt
	cp -a src/ProjectTemplates/{,ProjectTemplates-}THIRD-PARTY-NOTICES || die
	dodoc src/ProjectTemplates/ProjectTemplates-THIRD-PARTY-NOTICES
	cp -a src/Identity/UI/src/{,Identity-UI-}THIRD-PARTY-NOTICES.txt || die
	dodoc src/Identity/UI/src/Identity-UI-THIRD-PARTY-NOTICES.txt
	cp -a src/Components/{,Components-}THIRD-PARTY-NOTICES.txt || die
	dodoc src/Components/Components-THIRD-PARTY-NOTICES.txt
	cp -a src/Components/benchmarkapps/BlazingPizza.Server/\
{,Components-benchmarkapps-BlazingPizza.Server-}THIRD-PARTY-NOTICES.md || die
	dodoc src/Components/benchmarkapps/BlazingPizza.Server/\
Components-benchmarkapps-BlazingPizza.Server-THIRD-PARTY-NOTICES.md

	if use doc ; then
		docinto docs
		dodoc -r CONTRIBUTING.md docs README.md SECURITY.md
	fi

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}
