# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~x86 ~amd64"

USE_DOTNET="net46"
EBUILD_FRAMEWORK="4.5"
IUSE="${USE_DOTNET} +gac debug test"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

inherit eutils

DESCRIPTION="A C# PInvoke wrapper library for LibGit2 C library"

COMMIT="a709ab84d4b3c14e7aa9038c2c6b05c57a6b007f"
REPO_URL="https://github.com/libgit2/libgit2sharp.git"
HOMEPAGE="https://github.com/libgit2/libgit2sharp"
SRC_URI="
	https://github.com/mono/mono/raw/master/mcs/class/mono.snk"
#${HOMEPAGE}/archive/v0.26.tar.gz -> ${P}.tar.gz
#RESTRICT="mirror"

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

SNK_FILENAME="${S}/mono.snk"

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
	echo "/usr/lib64/libgit2.so" >"LibGit2Sharp/libgit2_filename.txt" || die

	cp "${DISTDIR}/mono.snk" "${S}"
	if use debug; then
		export Configuration=debug
	else
		export Configuration=release
	fi

	# explained in buildandtest.sh
	export LD_LIBRARY_PATH=.

	dotnet restore --verbosity normal || die

	eapply "${FILESDIR}/libgit2sharp-0.26-remove-native-binaries-1.patch"
	eapply "${FILESDIR}/libgit2sharp-0.26-remove-native-binaries-2.patch"

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

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins mono.snk
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
		einfo "adding to GAC"
		gacutil -i "${libdir}/LibGit2Sharp.dll" || die
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
