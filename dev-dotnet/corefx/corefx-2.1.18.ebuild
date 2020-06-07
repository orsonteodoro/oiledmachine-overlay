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
SDK_V="2.1.300-rc1-008673" # defined in DotnetCLIVersion.txt
IUSE="debug doc heimdal test"
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we
# have to keep downloading it everytime the sandbox is wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
SRC_URI="\
https://github.com/dotnet/${PN}/archive/v${CORE_V}.tar.gz \
  -> ${PN}-${CORE_V}.tar.gz
  amd64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz )
  arm64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz )
  arm? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz )"
SLOT="${PV}"
# Requirements based on Ubuntu 16.04 minimum requirements.
# Library requirements based on:
# init-tools.sh
# Documentation/building/unix-instructions.md
# cross/build-rootfs.sh
# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore21
RDEPEND=">=dev-libs/icu-55.1
	 >=dev-libs/openssl-compat-1.0.2o:1.0
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

src_unpack() {
	einfo \
"If you emerged this first, please use the meta package dotnetcore-sdk instead\
 as the starting point."
	ewarn "This ebuild is a Work in Progress (WIP) and may likely not work."
	unpack "${PN}-${CORE_V}.tar.gz"

	cd "${S}" || die
	X_SDK_V=$(cat DotnetCLIVersion.txt)
	if [[ ! -f DotnetCLIVersion.txt ]] ; then
		die "Cannot find DotnetCLIVersion.txt"
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

_src_compile() {
	local buildargs_corefx=""
	local mydebug="release"
	local myarch=""

	if use heimdal; then
		# build uses mit-krb5 by default but lets override to heimdal
		buildargs_corefx+=" -cmakeargs -DHeimdalGssApi=ON"
	fi

	if use debug ; then
		mydebug="debug"
	fi

	if [[ ${ARCH} =~ (amd64) ]]; then
		myarch="x64"
	elif [[ ${ARCH} =~ (x86) ]] ; then
		myarch="x32"
	elif [[ ${ARCH} =~ (arm64) ]] ; then
		myarch="arm64"
	elif [[ ${ARCH} =~ (arm) ]] ; then
		myarch="arm"
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

	einfo "Building CoreFX"
	cd "${S}" || die

	DotNetBootstrapCliTarPath=\
"${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" \
	./build.sh -buildArch -ArchGroup=${myarch} -${mydebug} \
		${buildargs_corefx} || die

	if use test ; then
		einfo "Building CoreFX tests"
		cd "${S}" || die
		./build-tests.sh -buildArch -ArchGroup=${myarch} \
			-${mydebug} || die
	fi
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${D}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
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

	dodir "${dest_core}"

	cp -a "${S}/bin/Linux.${myarch}.Release/native"/* \
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
