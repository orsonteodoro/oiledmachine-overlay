# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI=7
DESCRIPTION="CoreCLR is the runtime for .NET Core. It includes the garbage \
collector, JIT compiler, primitive data types and low-level classes."
HOMEPAGE="https://github.com/dotnet/coreclr"
LICENSE="all-rights-reserved
	Apache-2.0
	BSD
	BSD-2
	ISOC-rfc
	MIT
	unicode
	ZLIB
" # The vanilla MIT license doesn't come with all rights reserved
KEYWORDS="~amd64 ~arm ~arm64"
CORE_V=${PV}
SDK_V=3.1.100 # from global.json
SDK_V_FALLBACK=3.1.200-preview-014946 # from dev-dotnet/cli-3.1*
# From the commit history, they say they keep DotnetCLIVersion.txt in sync with
# other dotnet projects
DropSuffix="false" # true=official latest release, false=dev for live ebuilds
IUSE="debug doc numa test"
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we have
# to keep downloading it everytime the sandbox is wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
SDK_BASEURI_FALLBACK_ARM="https://download.visualstudio.microsoft.com/download/pr/67766a96-eb8c-4cd2-bca4-ea63d2cc115c/7bf13840aa2ed88793b7315d5e0d74e6"
SDK_BASEURI_FALLBACK_ARM64="https://download.visualstudio.microsoft.com/download/pr/5a4c8f96-1c73-401c-a6de-8e100403188a/0ce6ab39747e2508366d498f9c0a0669"
if [[ "${DropSuffix}" == "true" ]] ; then
SRC_URI="\
https://github.com/dotnet/${PN}/archive/v${CORE_V}.tar.gz \
	-> ${PN}-${CORE_V}.tar.gz
"
fi
SRC_URI+="\
  amd64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz )
  arm? ( ${SDK_BASEURI_FALLBACK_ARM}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz )
  arm64? ( ${SDK_BASEURI_FALLBACK_ARM64}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz )"
SLOT="${PV}"
# Dependencies based on init-tools.sh
# For more dependencies see
# https://github.com/dotnet/coreclr/blob/v3.1.4/Documentation/building/linux-instructions.md
# Library requirements assumes Ubuntu 16.04 minimum.
RDEPEND=">=app-crypt/mit-krb5-1.13.2
	 >=dev-libs/icu-55.1
	 >=dev-libs/openssl-compat-1.0.2o:1.0.0
	 >=dev-util/lldb-3.9
	 >=dev-util/lttng-ust-2.7.1
	 >=net-misc/curl-7.47
	 >=sys-devel/llvm-3.9:*
	 >=sys-libs/libunwind-1.1
	 numa? ( >=sys-process/numactl-2.0.11 )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.5.1
	  dev-vcs/git
	>=sys-devel/clang-3.9
	>=sys-devel/gettext-0.19.7
	>=sys-devel/make-4.1"
RESTRICT="mirror"
inherit git-r3
S="${WORKDIR}/${PN}-${CORE_V}"
_PATCHES=(
	"${FILESDIR}/${PN}-3.1.5-limit-maxHttpRequestsPerSource-to-1.patch"
	"${FILESDIR}/${PN}-3.1.5-msbuild-RestoreDisableParallel-true.patch"
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
}

_fetch_coreclr() {
	EGIT_REPO_URI="https://github.com/dotnet/${PN}.git"
	EGIT_COMMIT="v${PV}"
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
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
	if [[ "${DropSuffix}" == "true" ]] ; then
		unpack "${PN}-${CORE_V}.tar.gz"
	else
		_fetch_coreclr
	fi

	cd "${S}" || die
	X_SDK_V=$(grep "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ${ARCH} =~ (arm64|arm) ]] ; then
		:;
	elif [[ ! -f global.json ]] ; then
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
}

_src_prepare() {
	cd "${S}" || die
	eapply ${_PATCHES[@]}

	sed -i -e "s|--no-cache --packages|--disable-parallel --no-cache --packages|g" \
		init-tools.sh || die
	sed -i -e "s|\$dotnet restore|\$dotnet restore --disable-parallel|" \
		tests/setup-stress-dependencies.sh
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
	local buildargs_coreclr=""
	local mydebug=$(usex debug "debug" "release")
	local myarch=$(_getarch)

	# prevent: InvalidOperationException: The terminfo database is invalid
	# dotnet.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	buildargs_coreclr+=" -numproc ${numproc}"

# https://github.com/dotnet/runtime/blob/595a95c05bc1c636f73be61cc5aa7807ca54cc75/docs/workflow/building/libraries/freebsd-instructions.md
	mkdir -p "${S}/.dotnet"
	pushd "${S}/.dotnet" || die
	# Pre unpack to set SourceRevisionId
	unpack "dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz"
	if ! ls "${S}"/.dotnet/shared/Microsoft.NETCore.App/*/libcoreclr.so ; then
		die "Cannot find libcoreclr.so"
	fi
	local coreclr_revid=$(strings "${S}"/.dotnet/shared/Microsoft.NETCore.App/*/libcoreclr.so \
		| grep -F -e "@Commit:" | cut -f 4 -d " ")
	popd || die

	buildargs_coreclr+=" /p:SourceRevisionId=${coreclr_revid}"

	if ! use test ; then
		buildargs_coreclr+=" -skiptests"
	fi

	einfo "Building CoreCLR"
	cd "${S}" || die

	# Required by Microsoft.Build.Tasks.Git
	# See
	# https://github.com/dotnet/sourcelink/pull/438/files
	# https://github.com/dotnet/sourcelink/blob/master/src/Microsoft.Build.Tasks.Git.UnitTests/GitOperationsTests.cs#L207
	git remote add origin https://github.com/dotnet/${PN}.git

	# Temporarily comment out the codeblock below and re-emerge to update
	# ${SDK_V}

	local fn="dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz"
	export DotNetBootstrapCliTarPath="${DISTDIR}/${fn}"
	mkdir -p "${S}/.dotnet" || die
	pushd "${S}/.dotnet" || die
		unpack "dotnet-sdk-${SDK_V}-linux-x64.tar.gz"
	popd
	./build.sh -${myarch} -${mydebug} -verbose ${buildargs_coreclr} \
		-ignorewarnings || die
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
	local mydebug=$(usex debug "Debug" "Release")
	local myarch=$(_getarch)

	insinto "${dest_core}"

	# Based on
	# https://www.archlinux.org/packages/community/x86_64/dotnet-runtime/files/
	# AspNetCore requires libhostpolicy.so

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	doins -r "${S}/bin/Product/Linux.${myarch}.${mydebug}"/*
	chmod 0755 \
		"${ddest_core}"/*.so \
		"${ddest_core}"/\
{coreconsole,corerun,createdump,crossgen,ilasm,ildasm,mcs,superpmi}

	docinto licenses
	dodoc PATENTS.TXT LICENSE.TXT THIRD-PARTY-NOTICES.TXT

	if use doc ; then
		docinto docs
		dodoc -r CONTRIBUTING.md Documentation README.md
	fi

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}
