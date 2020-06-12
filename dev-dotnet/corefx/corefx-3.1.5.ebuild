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
KEYWORDS="~amd64 ~arm ~arm64"
CORE_V="${PV}"
SDK_V="3.1.100" # found in global.json
IUSE="debug doc test"
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we
# have to keep downloading it everytime the sandbox is wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
SDK_BASEURI_FALLBACK="\
https://download.visualstudio.microsoft.com\
/download/pr/67766a96-eb8c-4cd2-bca4-ea63d2cc115c/7bf13840aa2ed88793b7315d5e0d74e6"
# Fallback URI obtained from
# https://github.com/dotnet/core/blob/master/release-notes/3.1/releases.json
SRC_URI="\
https://github.com/dotnet/${PN}/archive/v${CORE_V}.tar.gz \
  -> ${PN}-${CORE_V}.tar.gz
  amd64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz )
  arm? ( ${SDK_BASEURI_FALLBACK}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz )
  arm64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz )"
SLOT="${PV}"
# Requirements based on Ubuntu 16.04 minimum requirements.
# Library requirements based on:
# init-tools.sh
# Documentation/building/unix-instructions.md
# cross/build-rootfs.sh
# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore31
RDEPEND=">=app-crypt/mit-krb5-1.13.2
	 >=dev-libs/icu-55.1
	 >=dev-libs/openssl-1.0.2o
	 >=dev-libs/openssl-compat-1.0.2o:1.0.0
	 >=dev-dotnet/libgdiplus-6.0.1
	 >=dev-util/lldb-4.0
	 >=dev-util/lttng-ust-2.7.1
	 >=net-misc/curl-7.47
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
PATCHES=(
	"${FILESDIR}/${PN}-3.1.5-limit-maxHttpRequestsPerSource-to-1.patch"
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
	X_SDK_V=$(grep "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ${ARCH} =~ (arm) ]] ; then
		:;
	elif [[ ! -f global.json ]] ; then
		die "Cannot find global.json"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
SDK_V to ${X_SDK_V}"
	fi

	# gentoo or the sandbox doesn't allow downloads in compile phase
	# so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${S}" || die

	# allow verbose output
	local F=\
$(grep -l -r -e "__init_tools_log" $(find "${WORKDIR}" -name "*.sh"))
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
	local buildargs_corefx=""
	local mydebug=$(usex debug "Debug" "Release")
	local myarch=$(_getarch)

	# prevent: InvalidOperationException: The terminfo database is invalid
	# dotnet.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	export ProcessorCount=${numproc}

	# comment out code block temporary and re-emerge to update ${SDK_V}
	local fn=\
"dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz"
	export DotNetBootstrapCliTarPath="${DISTDIR}/${fn}"
	local p
	p="${S}/.dotnet"
	mkdir -p "${p}" || die
	pushd "${p}" || die
		tar -xvf \
"${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd || die
	[ ! -f "${S}/.dotnet/dotnet" ] && die "dotnet not found"

	# It has to be done manually if you don't let the installer get the
	# tarballs.
	export PATH="${p}:${PATH}"

	if use test ; then
		buildargs_corefx+=" --buildtests"
	fi

	einfo "Building CoreFX"
	ewarn \
"Restoration (i.e. downloading) may randomly fail for bad local routers, \
firewalls, or network cards.  Emerge and try again."
	cd "${S}" || die
	./build.sh --restore --build --arch ${myarch} \
		--configuration ${mydebug} \
		${buildargs_corefx} || die
}

src_test() {
	if use test ; then
		./build.sh --test || die
	fi
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
	local myarch=$(_getarch)
	local mydebug=$(usex debug "Debug" "Release")

	dodir "${dest_core}"
	cp -a "${S}/artifacts/bin/native/netcoreapp-Linux-${mydebug}-${myarch}"/* \
		"${ddest_core}"/ || die

	cd "${S}" || die
	docinto licenses
	dodoc LICENSE.TXT PATENTS.TXT THIRD-PARTY-NOTICES.TXT

	if use doc ; then
		docinto docs
		dodoc -r CODE_OF_CONDUCT.md CONTRIBUTING.md Documentation \
			README.md
	fi
}
