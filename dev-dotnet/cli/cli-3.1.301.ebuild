# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI=7
DESCRIPTION="The .NET Core command-line (CLI) tools, used for building .NET \
Core apps and libraries through your development flow (compiling, NuGet \
package management, running, testing, ...)."
HOMEPAGE="https://github.com/dotnet/cli"
LICENSE="all-rights-reserved
	Apache-2.0
	ISOC-rfc
	MIT"
KEYWORDS="~amd64 ~arm ~arm64"
# https://github.com/dotnet/core/blob/master/release-notes/3.1/3.1-supported-os.md
VERSION_SUFFIX=''
DropSuffix="true" # true=official latest release, false=dev for live ebuilds
IUSE="debug doc test"
SDK_V="3.1.200-preview-014946" # from global.json
# The URIs are constructed from: https://dot.net/v1/dotnet-install.sh
DOTNET_CLI_COMMIT="367c515ce40a394f53f00597cacc884a25cce495" # exactly ${PV}
# We need to cache the dotnet-sdk tarball outside the sandbox otherwise we have
# to keep downloading it everytime the sandbox is wiped.
SDK_BASEURI="https://dotnetcli.azureedge.net/dotnet/Sdk/${SDK_V}"
RUNTIME_BASEURI="https://dotnetcli.azureedge.net/dotnet/Runtime"
# Missing 1.1.2 of dotnet-runtime is EOL as well as all 1.1.x
#    ${RUNTIME_BASEURI}/1.1.2/dotnet-runtime-1.1.2-linux-x64.tar.gz
#    ${RUNTIME_BASEURI}/1.1.2/dotnet-runtime-1.1.2-linux-arm.tar.gz
#    ${RUNTIME_BASEURI}/1.1.2/dotnet-runtime-1.1.2-linux-arm64.tar.gz
# Missing:
#    ${RUNTIME_BASEURI}/2.0.0/dotnet-runtime-2.0.0-linux-arm64.tar.gz
# 3.1.4 based on MicrosoftNETCoreAppRuntimePackageVersion in eng/Versions.props
# 2.0.0, 2.2.0, 1.1.2 referenced in eng/restore-toolset.sh
if [[ "${DropSuffix}" == "true" ]] ; then
SRC_URI="\
https://github.com/dotnet/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz
"
fi
SRC_URI+="\
  amd64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-x64.tar.gz
    ${RUNTIME_BASEURI}/2.0.0/dotnet-runtime-2.0.0-linux-x64.tar.gz
    ${RUNTIME_BASEURI}/2.2.0/dotnet-runtime-2.2.0-linux-x64.tar.gz
    ${RUNTIME_BASEURI}/3.1.4/dotnet-runtime-3.1.4-linux-x64.tar.gz
  )
  arm? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm.tar.gz
    ${RUNTIME_BASEURI}/2.0.0/dotnet-runtime-2.0.0-linux-arm.tar.gz
    ${RUNTIME_BASEURI}/2.2.0/dotnet-runtime-2.2.0-linux-arm.tar.gz
    ${RUNTIME_BASEURI}/3.1.4/dotnet-runtime-3.1.4-linux-arm.tar.gz
  )
  arm64? ( ${SDK_BASEURI}/dotnet-sdk-${SDK_V}-linux-arm64.tar.gz
    ${RUNTIME_BASEURI}/2.2.0/dotnet-runtime-2.2.0-linux-arm64.tar.gz
    ${RUNTIME_BASEURI}/3.1.4/dotnet-runtime-3.1.4-linux-arm64.tar.gz
  )"
SLOT="${PV}"
# see scripts/docker/ubuntu.16.04/Dockerfile for dependencies
RDEPEND="
	>=app-crypt/mit-krb5-1.13.2
	>=dev-libs/icu-55.1
	>=dev-libs/openssl-compat-1.0.2o:1.0.0
	>=dev-util/lttng-ust-2.7.1
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
inherit git-r3
S="${WORKDIR}/${PN}-${PV}"

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

_unpack_cli() {
	ewarn "This ebuild is a Work In Progress (WIP) and may likely not work."
	cd "${WORKDIR}" || die
	unpack ${PN}-${PV}.tar.gz

	cd "${S}" || die

	X_SDK_V=$(grep -e "dotnet" global.json | head -n 1 | cut -f 4 -d "\"")
	if [[ ! -f global.json ]] ; then
		die "Cannot find global.json"
	elif [[ "${X_SDK_V}" != "${SDK_V}" ]] ; then
		die \
"Cached dotnet-sdk in distfiles is not the same as requested.  Update ebuild's \
SDK_V to ${X_SDK_V}"
	fi
}

_unpack_runtime() {
	local myarch=$(_getarch)
	mkdir -p "${S}/.dotnet" || die
	pushd "${S}/.dotnet" || die
	# See eng/restore-toolset.sh for expected versions
	if [[ ${ARCH} =~ (arm|amd64) ]] ; then
		unpack "dotnet-runtime-2.0.0-linux-${myarch}.tar.gz"
	fi
	unpack "dotnet-runtime-2.2.0-linux-${myarch}.tar.gz"
	unpack "dotnet-runtime-3.1.4-linux-${myarch}.tar.gz"
	popd || die
}

_fetch_cli() {
	EGIT_REPO_URI="https://github.com/dotnet/${PN}.git"
	EGIT_COMMIT="v${PV}"
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	local rev=$(printf "%06d" $(git rev-list --count v${PV}))
	einfo "rev=${rev}"
	if [[ "${DropSuffix}" != "true" ]] ; then
		export VERSION_SUFFIX="-preview-${rev}"
	fi
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
	ewarn "This ebuild is a WIP does not work."
	ewarn "https://github.com/dotnet/sdk/issues/11795"
	if [[ "${DropSuffix}" == "false" ]] ; then
		_fetch_cli # for dev
	else
		_unpack_cli # for official latest release (i.e. tarball)
	fi

	_unpack_runtime

	# Gentoo or the sandbox doesn't allow downloads in compile phase so move
	# here
	_src_prepare
	_src_compile
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

_src_prepare() {
	local myarch=$(_getarch)

#	default_src_prepare
	cd "${S}" || die
	eapply ${_PATCHES[@]}

	# Allows verbose output
	local F=$(grep -l -r -e "__init_tools_log" \
			$(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i \
	-e 's|>> "$__init_tools_log" 2>&1|\|\& tee -a "$__init_tools_log"|g' \
	-e 's|>> "$__init_tools_log"|\| tee -a "$__init_tools_log"|g' \
	-e 's| > "$__init_tools_log"| \| tee "$__init_tools_log"|g' "$f" || die
	done

	# Allows wget curl output
	local F=$(grep -l -r -e "-sSL" $(find "${WORKDIR}" -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|-sSL|-L|g' -e 's|wget -q |wget |g' "$f" || die
	done

	# Comment out code block temporary and re-emerge to update ${SDK_V}
	local p
	p="${S}/.dotnet"
	mkdir -p "${p}" || die
	pushd "${p}" || die
	tar -xvf "${DISTDIR}/dotnet-sdk-${SDK_V}-linux-${myarch}.tar.gz" || die
	popd
	[ ! -f "${S}/.dotnet/dotnet" ] && die "dotnet not found"

	# Common problem in 3.1.x.  darc-int is a private package but it's not
	# supposed to be there.
	sed -i -e '/.*darc-int-.*/d' NuGet.config || die
	# Should be public packages not internal
	sed -i -e "s|\
MicrosoftNETCoreAppInternalPackageVersion|\
MicrosoftNETCoreAppRuntimePackageVersion|g" \
		global.json || die

	# Prevent from stalling
	sed -i -e "s|\
InstallDotNetSharedFramework \"1.1.2\"|\
#InstallDotNetSharedFramework \"1.1.2\"|" \
		eng/restore-toolset.sh || die

	# It has to be done manually if you don't let the installer get the
	# tarballs.
	export PATH="${p}:${PATH}"
}

_src_compile() {
	local buildargs_corecli=""
	local mydebug=$(usex debug "debug" "release")
	local myarch=$(_getarch)

	# Prevent InvalidOperationException: The terminfo database is invalid
	# dotnet.  It cannot be xterm-256color.
	export TERM=linux # pretend to be outside of X

	buildargs_corecli+=" /property:DropSuffix=${DropSuffix}"

	if [[ "${DropSuffix}" == "true" ]] ; then
		# workaround for not requiring git with tarball builds.
		buildargs_corecli+=\
" /property:GitInfoCommitCount=0 /property:GitInfoCommitHash=${DOTNET_CLI_COMMIT}"
	fi

#	if ! use test ; then
#		buildargs_corecli+=" /t:Compile"
#	else
#		buildargs_corecli+=" "
#	fi

	einfo "Building ${PN^^}"
	ewarn \
"Restoration (i.e. downloading) may randomly fail for bad local routers, \
firewalls, or network cards.  Emerge and try again."
	cd "${S}" || die
	./build.sh --configuration ${mydebug^} --architecture ${myarch} \
		${buildargs_corecli} || die
}

src_install() {
	local dest="/opt/dotnet"
	local ddest="${ED}/${dest}"
	local dest_sdk="${dest}/sdk/${PV}/"
	local ddest_sdk="${ddest}/sdk/${PV}/"
	local myarch=$(_getarch)

	# Installed files partly based on
# https://www.archlinux.org/packages/community/x86_64/dotnet-host/files/
	# For dotnet runtime libraries and FXR file list see
# https://www.archlinux.org/packages/community/x86_64/dotnet-runtime/files/

	dodir "${dest_sdk}"
	local d_dotnet="${S}/bin/2/linux-${myarch}/dotnet"
	cp -a "${d_dotnet}/sdk/${PV}${VERSION_SUFFIX}"/* "${ddest_sdk}/" || die
	cp -a "${d_dotnet}/dotnet" "${ddest}/" || die
	cp -a "${d_dotnet}/shared/" "${ddest}/" || die

	# Prevents collision with dotnetcore-runtime ebuild
	FXR_V=$(grep -r -e "MicrosoftNETCoreAppInternalPackageVersion" \
		"${S}/Versions.props" \
		| head -n 1 | cut -f 2 -d ">" | cut -f 1 -d "<")
	rm -rf "${ddest}"/shared/Microsoft.NETCore.App/${FXR_V} || die

	dodir /usr/share/licenses/${PN}-${PV}
	cp -a "${d_dotnet}"/{LICENSE.txt,ThirdPartyNotices.txt} \
		"${ED}/usr/share/licenses/${PN}-${PV}" || die

	# Symlink for MonoDevelop.  15.0 is the toolsversion.
	cd "${ddest_sdk}" || die
	ln -s Current 15.0 || die

	mv "${ED}"/opt/dotnet/dotnet "${ED}"/opt/dotnet/dotnet-${PV} || die

	cd "${S}" || die
	docinto licenses
	dodoc LICENSE THIRD-PARTY-NOTICES

	if use doc ; then
		docinto docs
		dodoc -r CONTRIBUTING.md Documentation ISSUE_TEMPLATE \
			PULL_REQUEST_TEMPLATE
	fi

	# Fix security permissions.
	find "${ED}/opt/dotnet/sdk/${PV}" -perm -o=w -type f -exec chmod o-w {} \;
}

pkg_postinst() {
	einfo \
"You may need to symlink from /opt/dotnet/dotnet-${PV} to /usr/bin/dotnet"
	# Clobbler the symlink anyway
	ln -s /opt/dotnet/dotnet-${PV} /usr/bin/dotnet
}
