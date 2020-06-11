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
KEYWORDS="~amd64 ~arm"
DropSuffix="false" # true=official latest release, false=dev for live ebuilds
MY_PN="AspNetCore"
IUSE="debug doc signalr test"
REQUIRED_USE="!test" # broken
NETFX_V="4.7.2" # from $HOME/.dotnet/buildtools/korebuild/*/KoreBuild.sh
SDK_V="2.1.512" # from $HOME/.dotnet/buildtools/korebuild/*/config/sdk.version
ASPNETCORE_COMMIT="9e38dcf1fc0335862e1ba6f19fc6a1f30e82ebb0" # exactly ${PV}
ENTITYFRAMEWORKCORE_COMMIT="e7a4277846e720fb8a5729c2a3de98c4c2ff67e5" # see modules
SLOT="${PV}"
# For dependencies, see...
# build/tools/docker/ubuntu.14.04/Dockerfile
# src/Installers/Debian/setup/build_setup.sh
# docs/BuildFromSource.md
# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore21
# (R)DEPENDs assumes Ubuntu 16.04 lib versions minimal.
RDEPEND=">=app-crypt/mit-krb5-1.13.2
	 >=dev-libs/icu-55.1
	 >=dev-libs/openssl-compat-1.0.2o:1.0.0
	 >=dev-util/lldb-3.9.1
	 >=dev-util/lttng-ust-2.7.1
	 signalr? ( net-libs/nodejs )
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
	signalr? ( >=net-libs/nodejs-5.6.0 )
	  sys-devel/automake
	  sys-devel/autoconf
	>=sys-devel/clang-3.9.1
	>=sys-devel/gcc-4.9
	  sys-devel/libtool"
# currently using only tarballs to avoid git is a problem at build time
ASPNET_GITHUB_BASEURI="https://github.com/aspnet"
if [[ "${DropSuffix}" == "true" ]] ; then
SRC_URI_TGZ="\
${ASPNET_GITHUB_BASEURI}/${MY_PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
${ASPNET_GITHUB_BASEURI}/EntityFrameworkCore/archive/${ENTITYFRAMEWORKCORE_COMMIT}.zip \
	-> entityframeworkcore-${ENTITYFRAMEWORKCORE_COMMIT}.zip"
fi
KOREBUILD_V="2.1.7-build-20200221.1" # stored in korebuild-lock.txt
FN_KOREBUILD="korebuild.${KOREBUILD_V}.zip"
# We need to cache the dotnet-sdk/dotnet-runtime tarball outside the sandbox otherwise we have
# to keep downloading it everytime the sandbox is wiped.
# We need to pre fetch the korebuild tarball to obtain SDK_V.  It is not easily
# accessible without first going though build.sh.
# No dotnet runtime 2.0.9 for arm64
# Runtime urls generated from dotnet-install.sh
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
ASPNETCORE_HOST="https://aspnetcore.blob.core.windows.net"
NETFX_BASEURI="${ASPNETCORE_HOST}/buildtools/netfx/${NETFX_V}"
KOREBUILD_BASEURI=\
"${ASPNETCORE_HOST}/buildtools/korebuild/artifacts/${KOREBUILD_V}"
RT_V_2_0="2.0.9"
RT_V_2_1="2.1.12"
RUNTIME_BASEURI="https://dotnetcli.azureedge.net/dotnet/Runtime"
SRC_URI+="${SRC_URI_TGZ}
	 ${KOREBUILD_BASEURI}/${FN_KOREBUILD}
	 ${NETFX_BASEURI}/netfx.${NETFX_V}.tar.gz
	 amd64? (
		${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz
${RUNTIME_BASEURI}/${RT_V_2_0}/dotnet-runtime-${RT_V_2_0}-linux-x64.tar.gz
${RUNTIME_BASEURI}/${RT_V_2_1}/dotnet-runtime-${RT_V_2_1}-linux-x64.tar.gz
	 )
	 arm? (
		${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz
${RUNTIME_BASEURI}/${RT_V_2_0}/dotnet-runtime-${RT_V_2_0}-linux-arm.tar.gz
${RUNTIME_BASEURI}/${RT_V_2_1}/dotnet-runtime-${RT_V_2_1}-linux-arm.tar.gz
	 )
	 arm64? (
		${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz
${RUNTIME_BASEURI}/${RT_V_2_1}/dotnet-runtime-${RT_V_2_1}-linux-arm64.tar.gz
	 )"
RESTRICT="mirror"
inherit git-r3

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

if [[ "${DropSuffix}" == "true" ]] ; then
S="${WORKDIR}/${MY_PN}-${PV}"
else
S="${WORKDIR}/${MY_PN,,}-${PV}"
fi

pkg_setup() {
	ewarn "This ebuild is a Work In Progress (WIP) and will not compile"
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

	pushd modules || die
	mv "${WORKDIR}/EntityFrameworkCore-${ENTITYFRAMEWORKCORE_COMMIT}"/ \
		"${WORKDIR}/EntityFrameworkCore" || die
	mv "${WORKDIR}/EntityFrameworkCore" . || die
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
#	mkdir -p "${global_packages}" || die
	mkdir -p "${http_cache}" || die
#	export NUGET_PACKAGES="${global_packages}"
	export NUGET_HTTP_CACHE_PATH="${http_cache}"
	einfo "Using ${dlbasedir} to store cached downloads for \`dotnet restore\` or NuGet downloads"
	einfo "Remove the folder it if it is problematic."
}

src_unpack() {
	_set_download_cache_folder

	einfo \
"If you emerged this first, please use the meta package dotnetcore-sdk instead\
 as the starting point."

	mkdir -p "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}" || die
	pushd "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}" || die
		unpack "${FN_KOREBUILD}"
	popd || die

	# need repo references
	if [[ "${DropSuffix}" == "true" ]] ; then
		_unpack_asp
	else
		_fetch_asp
	fi

	cd "${S}" || die

	X_KOREBUILD_V=$(cat korebuild-lock.txt | head -n 1 | cut -f 2 -d ":")
	if [[ ! -f korebuild-lock.txt ]] ; then
		die "Cannot find korebuild-lock.txt"
	elif [[ "${X_KOREBUILD_V}" != "${KOREBUILD_V}" ]] ; then
		die \
"Cached korebuild in distfiles is not the same as requested.  Update \
ebuild's KOREBUILD_V to ${X_KOREBUILD_V}"
	fi

	X_RT_V_2_0=$(grep -r -e "<MicrosoftNETCoreApp20PackageVersion" build/dependencies.props \
 | cut -f 2 -d ">" | cut -f 1 -d "<")
	if [[ ! -f build/dependencies.props ]] ; then
		die "Cannot find build/dependencies.props"
	elif [[ "${X_RT_V_2_0}" != "${RT_V_2_0}" ]] ; then
		die \
"Cached dotnet-runtime in distfiles is not the same as requested.  Update \
ebuild's RT_V_2_0 to ${X_RT_V_2_0}"
	fi

	# MicrosoftNETCoreAppPackageVersion is ambiguous or same with
	# MicrosoftNETCoreDotNetAppHostPackageVersion
	X_RT_V_2_1=$(grep -r -e "<MicrosoftNETCoreAppPackageVersion" build/dependencies.props \
 | cut -f 2 -d ">" | cut -f 1 -d "<")
	if [[ ! -f build/dependencies.props ]] ; then
		die "Cannot find build/dependencies.props"
	elif [[ "${X_RT_V_2_1}" != "${RT_V_2_1}" ]] ; then
		die \
"Cached dotnet-runtime in distfiles is not the same as requested.  Update \
ebuild's RT_V_2_1 to ${X_RT_V_2_1}"
	fi

	X_NETFX_V=$(grep -r -e "local netfx_version" "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}/KoreBuild.sh" \
		| cut -f 2 -d "'")
	if [[ ! -f "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}/KoreBuild.sh" ]] ; then
		die "Cannot find KoreBuild.sh"
	elif [[ "${X_NETFX_V}" != "${NETFX_V}" ]] ; then
		die \
"Cached dotnet-runtime in distfiles is not the same as requested.  Update \
ebuild's NETFX_V to ${X_NETFX_V}"
	fi

	X_SDK_V=$(cat "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}/config/sdk.version" | sed -r -e 's|\r||g')
	if [[ ! -f "${HOME}/.dotnet/buildtools/korebuild/${KOREBUILD_V}/config/sdk.version" ]] ; then
		die "Cannot find sdk.version"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
SDK_V to ${X_SDK_V}"
	fi

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_use_native_netfx() {
	# Use mono dlls instead of prebuilt targeting pack dlls
	# Fix for:
	# error MSB3644: The reference assemblies for framework
	# ".NETFramework,Version=v4.6.1" were not found.

	# Comment code block below to see the expected version.
	# Trick the scripts by creating the dummy dir to skip downloading.
	local p
	p="${S}/.dotnet/buildtools/netfx/${NETFX_V}/"
	mkdir -p "${p}" || die

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
_use_ms_netfx() {
	# corefx (netcore) not the same as netfx (found in mono)
	local p
	p="${HOME}/.dotnet/buildtools/netfx/4.7.2" # for Microsoft tarball
	mkdir -p "${p}" || die
	pushd "${p}" || die
	tar -xvf "${DISTDIR}/netfx.${NETFX_V}.tar.gz" || die
	popd || die
}

_use_native_sdk() {
	local p
	p="${S}/.dotnet/sdk/${SDK_V}"
	mkdir -p "${p}" || die

	# This is a Workaround for /opt/dotnet/dotnetinstall.lock: Permission denied
	# We cannot use addwrite/addread with /opt/dotnetinstall.lock.
	#
	# It would be better just to modify korebuild's dotnet-install.sh's \
	# dotnetinstall.lock location but can't do that because the file is \
	# not located in the tarballs before the build process but later in \
	# the middle of the build process of fetching dependency packages.
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
	p="${HOME}/.dotnet"
	mkdir -p "${p}" || die
	pushd "${p}" || die
		local myarch=$(_getarch)
		tar -xvf "${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd || die
	export PATH="${p}:${PATH}"
}

_unpack_dotnet_runtime() {
	local myarch=$(_getarch)
	pushd "${HOME}/.dotnet" || die
	if [[ "${ARCH}" =~ (amd64|arm) ]] ; then
		unpack "dotnet-runtime-${RT_V_2_0}-linux-${myarch}.tar.gz"
	fi
	unpack "dotnet-runtime-${RT_V_2_1}-linux-${myarch}.tar.gz"
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
		_D="${S}/src/SignalR/clients/cpp/test/gtest-1.8.0/xcode/Config"
		sed -i -e "s|-Werror||g" "${_D}/General.xcconfig" || die
	fi

	cd "${S}" || die
	eapply \
 "${FILESDIR}/${MY_PN,,}-pull-request-6950-strict-mode-in-roslyn-compiler-1-2.1.18.patch" \
 || die
	eapply \
 "${FILESDIR}/${MY_PN,,}-pull-request-6950-strict-mode-in-roslyn-compiler-2.patch" \
 || die

	if ! use signalr ; then
		rm -rf src/SignalR || die
		eapply \
 "${FILESDIR}/${MY_PN,,}-2.1.18-remove-signalr.patch"
	fi

	#_use_native_netfx
	_use_ms_netfx

	#_use_native_sdk
	_use_ms_sdk

	_unpack_dotnet_runtime
}

_src_compile() {
	local buildargs_coreasp=""
	local mydebug="release"
	local myarch=$(_getarch)

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=1

	if use debug ; then
		mydebug="debug"
	fi

	# prevent: InvalidOperationException: The terminfo database is invalid dotnet
	# cannot be xterm-256color
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"

	if ! use test ; then
		buildargs_coreasp+=" /p:SkipTests=true /p:CompileOnly=true"
	else
		buildargs_coreasp+=" /p:SkipTests=false /p:CompileOnly=false"
	fi

	[[ "${DropSuffix}" == "true" ]] \
	&& ewarn "Building with DropSuffix=true (with tarballs, no git) is broken"

	export DropSuffix="true" # to avoid problems for now as in directory
				# name changes... kinda like a work around

	einfo "Building ${MY_PN}"
	ewarn \
"Restoration (i.e. downloading) may randomly fail for bad local routers, \
firewalls, or network cards.  Emerge and try again."
	cd "${S}" || die
	#-arch ${myarch} # in master
	./build.sh /p:Configuration=${mydebug^} \
		--verbose ${buildargs_coreasp} \
		|| die
}

# See https://docs.microsoft.com/en-us/dotnet/core/build/distribution-packaging
src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_aspnetcoreall="${dest}/shared/Microsoft.${MY_PN}.All/${PV}/"
	local ddest_aspnetcoreall="${ddest}/shared/Microsoft.${MY_PN}.All/${PV}/"
	local dest_aspnetcoreapp="${dest}/shared/Microsoft.${MY_PN}.App/${PV}/"
	local ddest_aspnetcoreapp="${ddest}/shared/Microsoft.${MY_PN}.App/${PV}/"
	local myarch=$(_getarch)

	# Based on https://www.archlinux.org/packages/community/x86_64/aspnet-runtime/
	# i.e. unpacked binary distribution

	dodir "${dest_aspnetcoreall}"
	local d1=\
"${S}/bin/fx/linux-${myarch}/Microsoft.${MY_PN}.All/lib"
	cp -a "${d1}/netcoreapp"$(ver_cut 1-2 ${PV})/* \
		"${ddest_aspnetcoreall}" || die

	dodir "${dest_aspnetcoreapp}"
	local d2=\
"${S}/bin/fx/linux-${myarch}/Microsoft.${MY_PN}.App/lib"
	cp -a "${d2}/netcoreapp"$(ver_cut 1-2 ${PV})/* \
		"${ddest_aspnetcoreapp}" || die


	cd "${S}" || die

	docinto licenses
	dodoc LICENSE.txt THIRD-PARTY-NOTICES.txt
	cp -a src/Identity/UI/src/{,Identity-UI-}THIRD-PARTY-NOTICES || die
	dodoc src/Identity/UI/src/Identity-UI-THIRD-PARTY-NOTICES
	cp -a src/SignalR/{,SignalR-}THIRD-PARTY-NOTICES || die
	dodoc src/SignalR/SignalR-THIRD-PARTY-NOTICES
	cp -a src/Templating/src/{,Templating-}THIRD-PARTY-NOTICES || die
	dodoc src/Templating/src/Templating-THIRD-PARTY-NOTICES

	if use doc ; then
		docinto docs
		dodoc -r CONTRIBUTING.md docs README.md SECURITY.md
	fi
}
