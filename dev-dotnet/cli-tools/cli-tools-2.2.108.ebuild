# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

VERSION_SUFFIX=''
DropSuffix="true" # true=official latest release, false=dev for live ebuilds

DESCRIPTION="This repo contains the .NET Core command-line (CLI) tools, used for building .NET Core apps and libraries through your development flow (compiling, NuGet package management, running, testing, ...)."
HOMEPAGE="https://github.com/dotnet/cli"
LICENSE="MIT"

IUSE="tests debug"
SDK_V="2.1.403"
FXR_V="2.2.5"

DOTNET_CLI_COMMIT="33ed5b90ce6385c4bc6ee5ae4f79e4e62ac51c79" # exactly ${PV}
SRC_URI="https://github.com/dotnet/cli/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
	 amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz )"
#	 arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz )
#	 arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz )"

SLOT="0"
KEYWORDS="~amd64"

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

S="${WORKDIR}"
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

_unpack_cli() {
	unpack ${PN}-${PV}.tar.gz
	mv "${WORKDIR}/cli-${PV}" "${S}/dotnet-cli-${PV}"
	export CLI_S="${S}/dotnet-cli-${PV}"
}

_fetch_cli() {
	# git is used because we need the git metadata because the scripts rely on it to pull versioning info for VERSION_SUFFIX iif DropSuffix=false

	einfo "Fetching dotnet-cli"
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	b="${distdir}/dotnet-sdk"
	d="${b}/dotnet-cli"
	addwrite "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning project"
		git clone ${DOTNET_CLI_REPO_URL} "${d}"
		cd "${d}"
		git checkout master
		git checkout tags/v${PV} -b v${PV} || die
	else
		einfo "Updating project"
		cd "${d}"
		git clean -fdx
		git reset --hard master
		git checkout master
		git pull
		git branch -D v${PV}
		git checkout tags/v${PV} -b v${PV} || die
	fi
	cd "${d}"
	#git checkout ${DOTNET_CLI_COMMIT} # uncomment for forced deterministic build.  comment to follow head of tag.
	[ ! -e "README.md" ] && die "found nothing"
	cp -a "${d}" "${CLI_S}"
	mv "${S}/dotnetcli-${DOTNET_CLI_COMMIT}/" "${S}/dotnet-cli-${PV}" || die
	export CLI_S="${S}/dotnet-cli-${PV}"
	cd "${CLI_S}"
	local rev=$(printf "%06d" $(git rev-list --count v${PV}))
	einfo "rev=${rev}"
	if [[ "${DropSuffix}" != "true" ]] ; then
		export VERSION_SUFFIX="-preview-${rev}"
	fi
}

src_unpack() {
	if [[ "${DropSuffix}" == "false" ]] ; then
		_fetch_cli # for dev
	else
		_unpack_cli # for official latest release (i.e. tarball)
	fi

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
	if [[ ${ARCH} =~ (amd64) ]]; then
		myarch="x64"
	elif [[ ${ARCH} =~ (x86) ]] ; then
		myarch="x32"
	elif [[ ${ARCH} =~ (arm64) ]] ; then
		myarch="arm64"
	elif [[ ${ARCH} =~ (arm) ]] ; then
		myarch="arm"
	fi

#	default_src_prepare
	cd "${CLI_S}"
	eapply -p2 ${_PATCHES[@]}

	# allow verbose output
	local F=$(grep -l -r -e "__init_tools_log" $(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|>> "$__init_tools_log" 2>&1|\|\& tee -a "$__init_tools_log"|g' -e 's|>> "$__init_tools_log"|\| tee -a "$__init_tools_log"|g' -e 's| > "$__init_tools_log"| \| tee "$__init_tools_log"|g' "$f" || die
	done

	# allow wget curl output
	local F=$(grep -l -r -e "-sSL" $(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|-sSL|-L|g' -e 's|wget -q |wget |g' "$f" || die
	done

	local p
	p="${CLI_S}/.dotnet_stage0/${myarch}"
	mkdir -p "${p}" || die
	pushd "${p}" || die
	tar -xvf "${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd
	[ ! -f "${CLI_S}/.dotnet_stage0/${myarch}/dotnet" ] && die "dotnet not found"

	# It has to be done manually if you don't let the installer get the tarballs.
	export PATH="${p}:${PATH}"
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

	buildargs_corecli+=" /property:DropSuffix=${DropSuffix}"

	if [[ "${DropSuffix}" == "true" ]] ; then
		# workaround for not requiring git with tarball builds.
		buildargs_corecli+=" /property:GitInfoCommitCount=0 /property:GitInfoCommitHash=${DOTNET_CLI_COMMIT}"
	fi

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
	local dest="/opt/dotnet"
	local ddest="${D}/${dest}"
	local dest_sdk="${dest}/sdk/${PV}/"
	local ddest_sdk="${ddest}/sdk/${PV}/"
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

	# partly based on:
	# https://www.archlinux.org/packages/community/x86_64/dotnet-host/files/ for dotnet binary and fxr
	# https://www.archlinux.org/packages/community/x86_64/dotnet-runtime/files/ for shared dlls
	# using the unpacked binary distribution

	dodir "${dest_sdk}"
	cp -a "${CLI_S}/bin/2/linux-${myarch}/dotnet/sdk/${PV}${VERSION_SUFFIX}"/* "${ddest_sdk}/" || die
	cp -a "${CLI_S}/bin/2/linux-${myarch}/dotnet/dotnet" "${ddest}/" || die
	cp -a "${CLI_S}/bin/2/linux-x64/dotnet/host/" "${ddest}/" || die
	cp -a "${CLI_S}/bin/2/linux-x64/dotnet/shared/" "${ddest}/" || die

	# prevent collision with coreclr ebuild
	rm -rf "${ddest}"/shared/Microsoft.NETCore.App/${FXR_V} || die

	dosym "${dest}/dotnet" "/usr/bin/dotnet"

	dodir /usr/share/licenses/cli-tools
	cp -a "${CLI_S}/bin/2/linux-${myarch}/dotnet"/{LICENSE.txt,ThirdPartyNotices.txt} "${D}/usr/share/licenses/cli-tools" || die
}
