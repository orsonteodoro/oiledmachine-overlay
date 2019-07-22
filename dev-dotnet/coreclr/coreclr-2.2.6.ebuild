# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

CORE_V=${PV}
DOTNETCLI_V=2.2.108

DESCRIPTION="CoreCLR is the runtime for .NET Core. It includes the garbage collector, JIT compiler, primitive data types and low-level classes."
HOMEPAGE="https://github.com/dotnet/coreclr"
LICENSE="MIT"

IUSE="numa tests debug"

SRC_URI="https://github.com/dotnet/coreclr/archive/v${CORE_V}.tar.gz -> coreclr-${CORE_V}.tar.gz
	 amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNETCLI_V}/dotnet-sdk-${DOTNETCLI_V}-linux-x64.tar.gz )"
#	 x86? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNETCLI_V}/dotnet-sdk-${DOTNETCLI_V}-linux-x86.tar.gz )
#	 arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNETCLI_V}/dotnet-sdk-${DOTNETCLI_V}-linux-arm64.tar.gz )
#	 arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNETCLI_V}/dotnet-sdk-${DOTNETCLI_V}-linux-arm.tar.gz )

SLOT="0"
KEYWORDS="~amd64"
# based on init-tools.sh and dotnet-sdk-${DOTNETCLI_V}-linux-${myarch}.tar.gz
# ~x86 ~arm64 ~arm

RDEPEND="
	>=sys-devel/llvm-4.0:*
	>=dev-util/lldb-4.0
	>=sys-libs/libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	>=sys-libs/zlib-1.2.8-r1
	numa? ( sys-process/numactl )"
DEPEND="${RDEPEND}
	dev-vcs/git
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7
	!dev-dotnet/dotnetcore-runtime-bin
	!dev-dotnet/dotnetcore-sdk-bin
	!dev-dotnet/dotnetcore-aspnet-bin"

_PATCHES=(
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-1.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-2.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-3.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-4.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-5.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-6.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-7.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-8.patch"
	"${FILESDIR}/coreclr-2.1.9-jit-hex-format-change-9.patch"
)

S=${WORKDIR}
CORECLR_S="${S}/coreclr-${CORE_V}"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

src_unpack() {
	unpack "coreclr-${CORE_V}.tar.gz"

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
	cd "${CORECLR_S}"
	eapply -p2 ${_PATCHES[@]}

	# allow verbose output
	local F=$(grep -l -r -e "__init_tools_log" $(find ${WORKDIR} -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|>> "$__init_tools_log" 2>&1|\|\& tee -a "$__init_tools_log"|g' -e 's|>> "$__init_tools_log"|\| tee -a "$__init_tools_log"|g' -e 's| > "$__init_tools_log"| \| tee "$__init_tools_log"|g' "$f" || die
	done

	# allow wget curl output
	local F=$(grep -l -r -e "-sSL" $(find ${WORKDIR} -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|-sSL|-L|g' -e 's|wget -q |wget |g' "$f" || die
	done
}

_src_compile() {
	local buildargs_coreclr=""
	local mydebug="release"
	local myarch=""

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=5

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


	# prevent: InvalidOperationException: The terminfo database is invalid dotnet
	# cannot be xterm-256color
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	buildargs_coreclr+=" -numproc ${numproc}"

	if ! use tests ; then
		buildargs_coreclr+=" -skiptests"
	#else
		#buildargs_coreclr+=" "
	fi


	einfo "Building CoreCLR"
	cd "${CORECLR_S}" || die

	DotNetBootstrapCliTarPath="${DISTDIR}/dotnet-sdk-${DOTNETCLI_V}-linux-${myarch}.tar.gz" \
	./build.sh -${myarch} -${mydebug} -verbose ${buildargs_coreclr} || die
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${D}/${dest}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${PV}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${PV}"
	local mydebug="release"
	local myarch=""

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

	dodir "${dest_core}"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	cp -a "${CORECLR_S}/bin/Product/Linux.${myarch}.${mydebug^}"/* "${ddest_core}"/ || die
	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}
