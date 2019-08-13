# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~x86 ~amd64"

USE_DOTNET="net45"
EBUILD_FRAMEWORK="4.5"
IUSE="${USE_DOTNET} +gac debug developer system-libgit2 test"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

inherit dotnet eutils

DESCRIPTION="A C# PInvoke wrapper library for LibGit2 C library"

COMMIT="a709ab84d4b3c14e7aa9038c2c6b05c57a6b007f"
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

SNK_FILENAME="${S}/libgit2sharp.snk"

LIBGIT2_NATIVE_BINARIES_V="2.0.267"
LIBGIT2_COMMIT="572e4d8c1f1d42feac1c770f0cddf6fda6c4eca0" # v0.28.1
LIBGIT2_SHORT_HASH="572e4d8" # short hash of commit
NATIVE_LIBGIT2_SHORT_HASH="572e4d8" # pretend

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

pkg_pretend() {
	# the sandbox won't allow us to use dotnet restore properly so sandbox restrictions must be dropped
	if has sandbox $FEATURES || has usersandbox $FEATURES || has network-sandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox and network-sandbox to be disabled in FEATURES."
	fi
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

	addpredict /etc/mono/registry/last-btime
	epatch "${FILESDIR}/libgit2sharp-0.26-sln.patch"
	#epatch "${FILESDIR}/packages-config-remove-xunit.patch"

	if use debug; then
		export Configuration=debug
	else
		export Configuration=release
	fi

	# explained in buildandtest.sh
	export LD_LIBRARY_PATH=.

	dotnet restore --verbosity normal || die

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
	export EXTRADEFINE='LEAKS_IDENTIFYING'
	dotnet build LibGit2Sharp.Tests -f netcoreapp2.0 -property:ExtraDefine="$EXTRADEFINE" -fl -flp:verbosity=detailed || die
}

genlibdir() {
	prefix=${PREFIX}/usr
	exec_prefix=${prefix}
	libdir=${exec_prefix}/$(get_libdir)/mono/${EBUILD_FRAMEWORK}
}

src_install() {
	genlibdir
	insinto "${libdir}"
	if use debug; then
		DIR="debug"
	else
		DIR="release"
	fi
	doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.dll"

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins libgit2sharp.snk

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.pdb"
		doins "bin/LibGit2Sharp/${DIR}/netstandard2.0/LibGit2Sharp.xml"
	fi

	dotnet_multilib_comply
}

src_test() {
	if use test ; then
		dotnet test LibGit2Sharp.Tests/LibGit2Sharp.Tests.csproj -f netcoreapp2.0 --no-restore --no-build || die
	fi
}

pkg_postinst() {
	genlibdir

	if use gac; then
		for x in ${USE_DOTNET} ; do
			FW_UPPER=${x:3:1}
			FW_LOWER=${x:4:1}
			einfo "strong signing"
			sn -R /usr/$(get_libdir)/mono/${FW_UPPER}.${FW_LOWER}/LibGit2Sharp.dll "/usr/$(get_libdir)/mono/${PN}/libgit2sharp.snk" || die
			einfo "adding to GAC"
			gacutil -i "/usr/$(get_libdir)/mono/${FW_UPPER}.${FW_LOWER}/LibGit2Sharp.dll" || die
		done
	fi
}

pkg_postrm() {
	genlibdir

	if use gac; then
		einfo "removing from GAC"
		gacutil -u LibGit2Sharp
		# don't die, it there is no such assembly in GAC
	fi
}
