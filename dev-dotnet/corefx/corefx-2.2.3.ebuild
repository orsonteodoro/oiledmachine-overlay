# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

CORE_V=${PV}

DESCRIPTION="CoreFX is the foundational class libraries for .NET Core. It includes types for collections, file systems, console, JSON, XML, async and many others."
HOMEPAGE="https://github.com/dotnet/corefx"
LICENSE="MIT"

IUSE="heimdal tests debug"

SRC_URI="https://github.com/dotnet/corefx/archive/v${CORE_V}.tar.gz -> corefx-${CORE_V}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"

RDEPEND="
	>=sys-devel/llvm-4.0:*
	>=dev-util/lldb-4.0
	>=sys-libs/libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	heimdal? (
		>=app-crypt/heimdal-1.5.3-r2
	)
	!heimdal? (
		>=app-crypt/mit-krb5-1.14.2
	)
	>=sys-libs/zlib-1.2.8-r1"
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
	"${FILESDIR}/corefx-2.2.3-werror.patch"
)

S=${WORKDIR}
COREFX_S="${S}/corefx-${CORE_V}"

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
	unpack "corefx-${CORE_V}.tar.gz"

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${WORKDIR}"
	eapply ${_PATCHES[@]}

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
	local buildargs_corefx=""
	local mydebug="release"
	local myarch=""

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=1

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


	# prevent: InvalidOperationException: The terminfo database is invalid dotnet
	# cannot be xterm-256color
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	export ProcessorCount=${numproc}
	#buildargs_corefx+=" --numproc ${numproc}"

	if ! use tests ; then
		buildargs_corefx+=" -SkipTests=true -BuildTests=false"
	else
		buildargs_corefx+=" -SkipTests=false -BuildTests=true"
	fi

	einfo "Building CoreFX"
	cd "${COREFX_S}" || die
	./build.sh -buildArch -ArchGroup=${myarch} -${mydebug} ${buildargs_corefx} || die
	if use tests ; then
		einfo "Building CoreFX tests"
		cd "${COREFX_S}"
		./build-tests.sh -buildArch -ArchGroup=${myarch} -${mydebug} || die
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

	cp -a "${COREFX_S}/bin/Linux.${myarch}.Release/native"/* "${ddest_core}"/ || die
}
