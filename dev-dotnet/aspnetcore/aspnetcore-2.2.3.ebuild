# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

CORE_V=${PV}

DESCRIPTION="ASP.NET Core is a cross-platform .NET framework for building modern cloud-based web applications on Windows, Mac, or Linux."
HOMEPAGE="https://github.com/aspnet/AspNetCore/"
LICENSE="MIT"

IUSE="tests debug"

ASPNETCORE_COMMIT="fbe49b396bf8ece2998791dedca487e581e2619c" # exactly ${PV}
SRC_URI=""
RESTRICT="fetch"
REQUIRED_USE="!tests" # broken

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

S=${WORKDIR}
ASPNETCORE_S="${S}/AspNetCore-${ASPNETCORE_COMMIT}"
#ASPNETCORE_S="${S}/AspNetCore-${CORE_V}"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_setup() {
	ewarn "This ebuild is still under development"
	local free_vmem=$(free -th | tail -n1 | grep Total | tr -s ' ' | cut -f2 -d" " | sed -e "s|Gi||")
	if (( $free_vmem < 11 )) ; then
		# fix for: dotnet failed with exit code 134
		die "You need 11 GiB total virtual memory to compile asp support."
	fi
}

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

ASPNETCORE_REPO_URL="https://github.com/aspnet/AspNetCore.git"

_fetch_asp() {
	einfo "Fetching AspNetCore"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	b="${distdir}/dotnet-sdk"
	d="${b}/aspnetcore"
	addwrite "${b}"
	local update=0
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning project"
		git clone --recursive -b v${CORE_V} ${ASPNETCORE_REPO_URL} "${d}" || die
	else
		einfo "Updating project"
		cd "${d}"
		git checkout v${CORE_V}
		git reset --hard
		git pull origin v${CORE_V} || die
		local update=1
	fi
	cd "${d}"
	git checkout ${ASPNETCORE_COMMIT} . || die
	if [[ "$update" == "1" ]] ; then
		git submodule update --recursive || die
	else
		git submodule update --init --recursive || die
	fi
	[ ! -e "README.md" ] && die "found nothing"
	cp -a "${d}" "${ASPNETCORE_S}"
	mv "${S}/AspNetCore-${ASPNETCORE_COMMIT}/" "${S}/AspNetCore-${CORE_V}" || die
	export ASPNETCORE_S="${S}/AspNetCore-${CORE_V}"
}

src_unpack() {
	# need repo references
	_fetch_asp

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${WORKDIR}"

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

	if ! use tests ; then
		sed -i -e "s|-Werror||g" "${ASPNETCORE_S}"/src/SignalR/clients/cpp/test/gtest-1.8.0/xcode/Config/General.xcconfig
	fi

	cd "${ASPNETCORE_S}"
	patch -p1 -i "${FILESDIR}/aspnetcore-pull-request-6950-strict-mode-in-roslyn-compiler-1.patch" || die
	patch -p1 -i "${FILESDIR}/aspnetcore-pull-request-6950-strict-mode-in-roslyn-compiler-2.patch" || die
	patch -p1 -i "${FILESDIR}/aspnetcore-2.1.9-skip-tests-1.patch" || die
	rm src/Razor/CodeAnalysis.Razor/src/TextChangeExtensions.cs || die # Missing TextChange

	mv src/SignalR "${T}" || die
	mv src/Servers/Kestrel/shared/test "${T}"/test.1 || die
	mv src/DataProtection/shared/test "${T}"/test.2 || die
	mv src/Identity "${T}" || die
	mv modules/EntityFrameworkCore "${T}" || die
	mv src/Templating/test "${T}"/test.3 || die
	rm -rf $(find . -iname "test" -o -iname "tests" -o -iname "testassets" -o -iname "*.Tests" -o -iname "sample" -o -iname "samples" -type d)
	mv "${T}"/SignalR src || die
	mv "${T}"/test.1 src/Servers/Kestrel/shared/test || die
	mv "${T}"/test.2 src/DataProtection/shared/test || die
	mv "${T}"/Identity src || die
	mv "${T}"/EntityFrameworkCore modules || die
	mv "${T}"/test.3 src/Templating/test || die
}

_src_compile() {
	local buildargs_coreasp=""
	local mydebug="release"
	local myarch=""

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=1

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
	#buildargs_coreasp+=" "

	if ! use tests ; then
#		buildargs_coreasp+=" /p:SkipTests=true /p:_ProjectsOnly=true"
		buildargs_coreasp+=" /p:SkipTests=true /p:CompileOnly=true"
	else
		buildargs_coreasp+=" /p:SkipTests=false /p:CompileOnly=false"
	fi

	if [[ ${ARCH} =~ (amd64) ]]; then
		einfo "Building AspNetCore"
		cd "${ASPNETCORE_S}"
		#-arch ${myarch} # in master
		./build.sh /p:Configuration=${mydebug^} --verbose ${buildargs_coreasp} || die
	fi
}

# See https://docs.microsoft.com/en-us/dotnet/core/build/distribution-packaging
src_install() {
	local dest="/opt/dotnet"
	local ddest="${D}/${dest}"
	local ddest_aspnetcoreall="${ddest}/shared/Microsoft.AspNetCore.All/${PV}/"
	local ddest_aspnetcoreapp="${ddest}/shared/Microsoft.AspNetCore.App/${PV}/"

	dodir "${ddest_aspnetcoreall}"
	cp -a "${ASPNETCORE_S}/build/tasks/bin/publish"/* "${ddest_aspnetcoreall}"

	# todo
	dodir "${ddest_aspnetcoreapp}"
	cp -a "${ASPNETCORE_S}/bin"/* "${ddest_aspnetcoreapp}/" || die
}
