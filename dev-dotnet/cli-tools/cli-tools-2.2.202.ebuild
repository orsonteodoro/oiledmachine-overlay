# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

VERSION_SUFFIX=''

DESCRIPTION="This repo contains the .NET Core command-line (CLI) tools, used for building .NET Core apps and libraries through your development flow (compiling, NuGet package management, running, testing, ...)."
HOMEPAGE="https://github.com/dotnet/cli"
LICENSE="MIT"

IUSE="tests debug"

DOTNET_CLI_COMMIT="8a7ff6789d66a487bffc35aebb136621f5a1b3ee" # exactly ${PV}
SRC_URI=""
RESTRICT="fetch"

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
	"${FILESDIR}/dotnet-cli-2.1.505-null-LastWriteTimeUtc-minval.patch"
)

S=${WORKDIR}
CLI_S="${S}/dotnetcli-${DOTNET_CLI_COMMIT}"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

DOTNET_CLI_REPO_URL="https://github.com/dotnet/cli.git"

_fetch_cli() {
	einfo "Fetching dotnet-cli"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	b="${distdir}/dotnet-sdk"
	d="${b}/dotnet-cli"
	addwrite "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning project"
		git clone -b v${PV} ${DOTNET_CLI_REPO_URL} "${d}" || die
	else
		einfo "Updating project"
		cd "${d}"
		git checkout v${PV}
		git reset --hard
		git pull origin v${PV}|| die
	fi
	cd "${d}"
	git checkout ${DOTNET_CLI_COMMIT} . || die
	[ ! -e "README.md" ] && die "found nothing"
	cp -a "${d}" "${CLI_S}"
	mv "${S}/dotnetcli-${DOTNET_CLI_COMMIT}/" "${S}/dotnet-cli-${PV}" || die
	export CLI_S="${S}/dotnet-cli-${PV}"
	export VERSION="-preview-$(git rev-list --count v${PV})"
}

src_unpack() {
	# need the .git folder
	_fetch_cli

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${CLI_S}"
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
	local buildargs_corecli=""
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
	#buildargs_corecli+=" "

	if ! use tests ; then
		buildargs_corecli+=" /t:Compile"
	#else
		#buildargs_corecli+=" "
	fi

	einfo "Building CLI"
	cd "${CLI_S}"
	./build.sh --configuration ${mydebug^} --architecture ${myarch} ${buildargs_corecli} || die
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_sdk="${D}/opt/dotnet_core/sdk/${PV}/"
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

	dodir "${ddest_sdk}"
	cp -a "${CLI_S}/bin/2/linux-${myarch}/dotnet/sdk/${PV}${VERSION_SUFFIX}"/* "${ddest_sdk}/" || die

	dosym "../../opt/dotnet_cli/dotnet" "/usr/bin/dotnet"
}
