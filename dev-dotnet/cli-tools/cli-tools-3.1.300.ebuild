# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI=7
DESCRIPTION="This repo contains the .NET Core command-line (CLI) tools, used for building .NET Core apps and libraries through your development flow (compiling, NuGet package management, running, testing, ...)."
HOMEPAGE="https://github.com/dotnet/cli"
LICENSE="all-rights-reserved MIT
	Apache-2.0
	ISOC-rfc"
KEYWORDS="~amd64" # also arm32, arm64 https://github.com/dotnet/core/blob/master/release-notes/3.1/3.1-supported-os.md
VERSION_SUFFIX=''
DropSuffix="true" # true=official latest release, false=dev for live ebuilds
IUSE="debug doc tests"
SDK_V="3.1.200-preview-014946" # from global.json ; it must match or it will redownload
# urls constructed from: https://dot.net/v1/dotnet-install.sh
DOTNET_CLI_COMMIT="f6250b79a00848f18e6e7b076b561d0a794983d3" # exactly ${PV}
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we have to keep downloading it everytime the sandbox is wiped.
SRC_URI="https://github.com/dotnet/cli/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
	 amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz )"
#	 arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz )
#	 arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz )"
SLOT="${PV}"
# see scripts/docker/ubuntu.16.04/Dockerfile for dependencies
# todo check if it requires <openssl-1.1 only
RDEPEND="
	>=dev-libs/icu-55.1
	>=dev-libs/openssl-compat-1.0.2o:1.0
	>=dev-util/lttng-ust-2.7.1
	>=app-crypt/mit-krb5-1.13.2
	>=sys-apps/util-linux-2.27.1
	>=sys-devel/llvm-3.5
	>=sys-libs/libunwind-1.1
	>=sys-libs/zlib-1.2.8"
DEPEND="${RDEPEND}
	!dev-dotnet/dotnetcore-aspnet-bin
	!dev-dotnet/dotnetcore-runtime-bin
	!dev-dotnet/dotnetcore-sdk-bin
	app-arch/unzip
	>=dev-util/cmake-3.5.1
	>=dev-util/lldb-3.6.2
	dev-vcs/git
	>=net-misc/curl-7.47
	>=sys-devel/clang-3.5
	>=sys-devel/make-4.1"
_PATCHES=( "${FILESDIR}/dotnet-cli-2.1.505-null-LastWriteTimeUtc-minval.patch" )
RESTRICT="mirror"
S="${WORKDIR}"
CLI_S="${S}/dotnetcli-${DOTNET_CLI_COMMIT}"
DOTNET_CLI_REPO_URL="https://github.com/dotnet/cli.git"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die "${PN} require sandbox and usersandbox to be disabled in FEATURES."
	fi

	if has network-sandbox $FEATURES ; then
		die "${PN} require network-sandbox to be disabled in FEATURES."
	fi
}

_unpack_cli() {
	ewarn "This ebuild is a Work In Progress (WIP) and may likely not work."
	unpack ${PN}-${PV}.tar.gz
	mv "${WORKDIR}/cli-${PV}" "${S}/dotnet-cli-${PV}"
	export CLI_S="${S}/dotnet-cli-${PV}"

	cd "${CLI_S}" || die

	X_SDK_V=$(grep -e "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ! -f global.json ]] ; then
		die "Cannot find global.json"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die "Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's SDK_V to ${X_SDK_V}"
	fi
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
	cd "${CLI_S}" || die
	local rev=$(printf "%06d" $(git rev-list --count v${PV}))
	einfo "rev=${rev}"
	if [[ "${DropSuffix}" != "true" ]] ; then
		export VERSION_SUFFIX="-preview-${rev}"
	fi
}

src_unpack() {
	ewarn "This ebuild is a WIP does not work."
	ewarn "https://github.com/dotnet/sdk/issues/11795"
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
	cd "${CLI_S}" || die
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

	# comment out code block temporary and re-emerge to update ${SDK_V}
	local p
	p="${CLI_S}/.dotnet"
	mkdir -p "${p}" || die
	pushd "${p}" || die
	tar -xvf "${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd
	[ ! -f "${CLI_S}/.dotnet/dotnet" ] && die "dotnet not found"

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

#	if ! use tests ; then
#		buildargs_corecli+=" /t:Compile"
	#else
		#buildargs_corecli+=" "
#	fi

	einfo "Building CLI"
	cd "${CLI_S}" || die
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
	local d_dotnet="${CLI_S}/bin/2/linux-${myarch}/dotnet"
	cp -a "${d_dotnet}/sdk/${PV}${VERSION_SUFFIX}"/* "${ddest_sdk}/" || die
	cp -a "${d_dotnet}/dotnet" "${ddest}/" || die
	cp -a "${d_dotnet}/host/" "${ddest}/" || die
	cp -a "${d_dotnet}/shared/" "${ddest}/" || die

	# prevent collision with coreclr ebuild
	FXR_V=$(grep -r -e "MicrosoftNETCoreAppInternalPackageVersion" "${CLI_S}/Versions.props" | head -n 1 | cut -f 2 -d ">" | cut -f 1 -d "<")
	rm -rf "${ddest}"/shared/Microsoft.NETCore.App/${FXR_V} || die

	dodir /usr/share/licenses/cli-tools-${PV}
	cp -a "${d_dotnet}"/{LICENSE.txt,ThirdPartyNotices.txt} "${D}/usr/share/licenses/cli-tools-${PV}" || die

	# for monodevelop.  15.0 is toolsversion.
	cd "${ddest_sdk}" || die
	ln -s Current 15.0 || die

	mv "${D}"/opt/dotnet/dotnet "${D}"/opt/dotnet/dotnet-${PV}

	cd "${CLI_S}" || die
	docinto licenses
	dodoc LICENSE THIRD-PARTY-NOTICES

	if use doc ; then
		docinto docs
		dodoc -r CONTRIBUTING.md Documentation ISSUE_TEMPLATE PULL_REQUEST_TEMPLATE
	fi
}

pkg_postinst() {
	einfo "You may need to symlink from /opt/dotnet/dotnet-${PV} to /usr/bin/dotnet"
	# clobbler the symlink anyway
	ln -s /opt/dotnet/dotnet-${PV} /usr/bin/dotnet
}
