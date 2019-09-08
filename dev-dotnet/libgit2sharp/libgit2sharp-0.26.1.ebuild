# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~x86 ~amd64"

# test do not work for netstandard20
#USE_DOTNET="netcoreapp20"
USE_DOTNET="netstandard20 net46"
TOOLS_VERSION="15.0"

IUSE="${USE_DOTNET} debug developer gac system-libgit2 test"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

inherit dotnet eutils

DESCRIPTION="A C# PInvoke wrapper library for LibGit2 C library"

COMMIT="8950f498511d9e4cc1756193682ac3bb08581166"
REPO_URL="https://github.com/libgit2/libgit2sharp.git"
HOMEPAGE="https://github.com/libgit2/libgit2sharp"
SRC_URI=""
#${HOMEPAGE}/archive/v0.26.tar.gz -> ${P}.tar.gz

S="${WORKDIR}/${PN}-${PV}"

LICENSE="MIT"
SLOT="0"

CDEPEND="
	dev-libs/libgit2
"

DEPEND="${CDEPEND}
	>=dev-dotnet/nuget-2.7
	>=dev-lang/mono-5.4
	|| ( dev-dotnet/dotnetcore-sdk dev-dotnet/dotnetcore-sdk-bin )
"
RDEPEND="${CDEPEND}
	 dev-vcs/git"

LIBGIT2_NATIVE_BINARIES_V="2.0.289"
LIBGIT2_COMMIT="7ce88e66a19e3b48340abcdd86aeaae1882e63cc" # v0.28.3
LIBGIT2_SHORT_HASH="7ce88e6" # short hash of commit
NATIVE_LIBGIT2_SHORT_HASH="7ce88e6" # pretend

_fetch_project() {
	# using git is required.

	einfo "Fetching ${PN}"
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	b="${distdir}/oiledmachine-overlay-git"
	d="${b}/${PN}"
	addwrite "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning project"
		git clone ${REPO_URL} "${d}"
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
	#git checkout ${COMMIT} # uncomment for forced deterministic build.  comment to follow head of tag.
	[ ! -e "README.md" ] && die "found nothing"
	cp -a "${d}" "${S}" || die
}

src_unpack() {
	_fetch_project

	default

	# remove rogue binaries
	rm -rf "${S}/Lib/NuGet/" || die
	rm -rf "${S}/Lib/CustomBuildTasks/CustomBuildTasks.dll" || die
}

src_prepare() {
	cd "${S}"

	if use net46 ; then
		eapply "${FILESDIR}/libgit2sharp-0.26-net46-references.patch"

		L=$(find "${S}" -name "*.csproj")
		for f in $L ; do
			cp "${FILESDIR}"/netfx.props "$(dirname $f)" || die
			einfo "Editing $f"
			sed -i -e "s|<Project Sdk=\"Microsoft.NET.Sdk\">|<Project Sdk=\"Microsoft.NET.Sdk\">\n  <Import Project=\"netfx.props\" />\n|" "$f" || die
		done

	fi

	epatch "${FILESDIR}/libgit2sharp-0.26.1-sln.patch"
	#epatch "${FILESDIR}/packages-config-remove-xunit.patch"

	if use debug; then
		export Configuration=debug
	else
		export Configuration=release
	fi

	# explained in buildandtest.sh
	export LD_LIBRARY_PATH=.

	erestore

	if use system-libgit2 ; then
		# native lib
		sed -i -e "s|lib/linux-x64/libgit2-${LIBGIT2_SHORT_HASH}.so|/usr/lib64/libgit2.so|g" "${HOME}/.nuget/packages/libgit2sharp.nativebinaries/${LIBGIT2_NATIVE_BINARIES_V}/libgit2/LibGit2Sharp.dll.config" || die

		# native lib name
		sed -i -e "s|git2-${LIBGIT2_SHORT_HASH}|git2-${NATIVE_LIBGIT2_SHORT_HASH}|g" "${HOME}/.nuget/packages/libgit2sharp.nativebinaries/${LIBGIT2_NATIVE_BINARIES_V}/libgit2/LibGit2Sharp.dll.config" || die

		sed -i -e "s|\$(MSBuildThisFileDirectory)\..\..\runtimes\linux-x64\native\libgit2-${LIBGIT2_SHORT_HASH}.so|/usr/lib64/libgit2.so|g" "${HOME}/.nuget/packages/libgit2sharp.nativebinaries/${LIBGIT2_NATIVE_BINARIES_V}/build/net46/LibGit2Sharp.NativeBinaries.props" || die
	fi

	default
}

src_compile() {
	# build #1 using this way linux-x64 dlls?
	if use net46 ; then
		export FrameworkPathOverride=/usr/lib/mono/4.6-api/
		_exbuild_netcore_raw build -f net46 --verbosity detailed
	fi

	# build #2 using this way results in gentoo-x64 dlls?
	export EXTRADEFINE='LEAKS_IDENTIFYING'
	exbuild LibGit2Sharp.Tests -property:ExtraDefine="$EXTRADEFINE" -fl -flp:verbosity=detailed
}

src_install() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	local _dotnet
	if [ -d /opt/dotnet ] ; then
		_dotnet="dotnet"
	elif [ -d /opt/dotnet_core ] ; then
		_dotnet="dotnet_core"
	fi

	if use net46 ; then
		insinto "/usr/lib/mono/4.6-api"
		estrong_resign "bin/LibGit2Sharp/${DIR}/net46/LibGit2Sharp.dll" "${S}/libgit2sharp.snk"
		doins "bin/LibGit2Sharp/${DIR}/net46/LibGit2Sharp.dll"

		if [ -n "${_dotnet}" ] ; then
			insinto "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/net46/"
			dosym "/usr/lib/mono/4.6-api/LibGit2Sharp.dll" "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/net46/LibGit2Sharp.dll"
		fi
	elif use netstandard20 ; then
		insinto "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/netstandard2.0"
		estrong_resign "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.dll" "${S}/libgit2sharp.snk"
		doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.dll"
	fi

	if use developer ; then
		if use net46 ; then
			insinto "/usr/lib/mono/4.6-api"
			doins "bin/LibGit2Sharp/${DIR}/net46/LibGit2Sharp.pdb"
			doins "bin/LibGit2Sharp/${DIR}/net46/LibGit2Sharp.xml"
			if [ -n "${_dotnet}" ] ; then
				dosym "/usr/lib/mono/4.6-api/LibGit2Sharp.pdb" "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/net46/LibGit2Sharp.pdb"
				dosym "/usr/lib/mono/4.6-api/LibGit2Sharp.xml" "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/net46/LibGit2Sharp.xml"
			fi
		elif use netstandard20 ; then
			insinto "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN}/${PV}/lib/netstandard2.0"
			doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.pdb"
			doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.xml"
		fi

	fi

	dotnet_multilib_comply
}

src_test() {
	if use test ; then
		exbuild_raw test LibGit2Sharp.Tests/LibGit2Sharp.Tests.csproj -f netcoreapp2.0 --no-restore --no-build || die
	fi
}

pkg_postinst() {
	if use net46 && use gac; then
		einfo "Adding to GAC"
		gacutil -i "/usr/lib/mono/4.6-api/LibGit2Sharp.dll" || die
	fi
}

pkg_postrm() {
	if use net46 && use gac; then
		einfo "Removing from GAC"
		gacutil -u LibGit2Sharp
		# don't die, it there is no such assembly in GAC
	fi
}
