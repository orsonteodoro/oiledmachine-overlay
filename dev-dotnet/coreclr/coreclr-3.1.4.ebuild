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
KEYWORDS="~amd64"
CORE_V=${PV}
DOTNETCLI_V=3.1.100 # from global.json
IUSE="debug doc numa tests"
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we have
# to keep downloading it everytime the sandbox is wiped.
DOTNETCLI_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNETCLI_V}"
SRC_URI="\
https://github.com/dotnet/coreclr/archive/v${CORE_V}.tar.gz \
	-> coreclr-${CORE_V}.tar.gz
  amd64? ( ${DOTNETCLI_BASEURI}/dotnet-sdk-${DOTNETCLI_V}-linux-x64.tar.gz )"
# x86? ( ${DOTNETCLI_BASEURI}/dotnet-sdk-${DOTNETCLI_V}-linux-x86.tar.gz )
# arm64? ( ${DOTNETCLI_BASEURI}/dotnet-sdk-${DOTNETCLI_V}-linux-arm64.tar.gz )
# arm? ( ${DOTNETCLI_BASEURI}/dotnet-sdk-${DOTNETCLI_V}-linux-arm.tar.gz )
SLOT="${PV}"
# based on init-tools.sh and dotnet-sdk-${DOTNETCLI_V}-linux-${myarch}.tar.gz
# ~x86 ~arm64 ~arm
# For dependencies see
# https://github.com/dotnet/coreclr/blob/v3.1.4/Documentation/building/linux-instructions.md
# Library requirements assumes Ubuntu 16.04 minimum.
RDEPEND=">=app-crypt/mit-krb5-1.13.2
	 >=dev-libs/icu-55.1
	 >=dev-libs/openssl-compat-1.0.2o:1.0
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
	>=sys-devel/make-4.1
	 !dev-dotnet/dotnetcore-aspnet-bin
	 !dev-dotnet/dotnetcore-runtime-bin
	 !dev-dotnet/dotnetcore-sdk-bin"
RESTRICT="mirror"
S="${WORKDIR}"
CORECLR_S="${S}/coreclr-${CORE_V}"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while
	# compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die \
"${PN} require sandbox and usersandbox to be disabled in FEATURES."
	fi

	if has network-sandbox $FEATURES ; then
		die "${PN} require network-sandbox to be disabled in FEATURES."
	fi
}

src_unpack() {
	einfo \
"If you emerged this first, please use the meta package dotnetcore-sdk instead\
 as the starting point."
	ewarn "This ebuild is a Work In Progress (WIP) and may not likely work"
	unpack "coreclr-${CORE_V}.tar.gz"

	cd "${CORECLR_S}" || die
	X_DOTNETCLI_V=$(grep "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ! -f global.json ]] ; then
		die "Cannot find global.json"
	elif [[ "${X_DOTNETCLI_V}" != "${DOTNETCLI_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
DOTNETCLI_V to ${X_DOTNETCLI_V}"
	fi

	# Gentoo or the sandbox doesn't allow downloads in compile phase so move
	# here
	_src_prepare
	_src_compile
}

_src_prepare() {
	cd "${CORECLR_S}" || die

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
	local buildargs_coreclr=""
	local mydebug=$(usex debug "debug" "release")
	local myarch=$(_getarch)

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=5

	# prevent: InvalidOperationException: The terminfo database is invalid
	# dotnet.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	buildargs_coreclr+=" -numproc ${numproc}"

	if ! use tests ; then
		buildargs_coreclr+=" -skiptests"
	fi

	einfo "Building CoreCLR"
	cd "${CORECLR_S}" || die

	# Temporarily comment out the codeblock below and re-emerge to update
	# ${DOTNETCLI_V}
	export DotNetBootstrapCliTarPath=\
"${DISTDIR}/dotnet-sdk-${DOTNETCLI_V}-linux-${myarch}.tar.gz"
	mkdir -p "${CORECLR_S}/.dotnet" || die
	pushd "${CORECLR_S}/.dotnet" || die
		unpack "dotnet-sdk-${DOTNETCLI_V}-linux-x64.tar.gz"
	popd

	./build.sh -${myarch} -${mydebug} -verbose ${buildargs_coreclr} \
		-ignorewarnings || die
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${D}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
	local mydebug=$(usex debug "debug" "release")
	local myarch=$(_getarch)

	dodir "${dest_core}"

	# Based on
	# https://www.archlinux.org/packages/community/x86_64/dotnet-runtime/files/
	# AspNetCore requires libhostpolicy.so

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	# copies coreclr but not runtime
	cp -a "${CORECLR_S}/bin/Product/Linux.${myarch}.Release"/* \
		"${ddest_core}"/ || die
	#cp -a "${CORECLR_S}/Tools/dotnetcli/shared/Microsoft.NETCore.App/${PV}"/* \
	#	"${ddest_core}"/ || die

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
