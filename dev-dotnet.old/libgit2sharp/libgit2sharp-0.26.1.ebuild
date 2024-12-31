# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A C# PInvoke wrapper library for LibGit2 C library"
HOMEPAGE="https://github.com/libgit2/libgit2sharp"
LICENSE="MIT"
KEYWORDS="~arm ~arm64 ~x86 ~amd64"
SLOT="0"
IUSE="${USE_DOTNET} debug developer gac system-libgit2 test"
REQUIRED_USE="|| ( ${USE_DOTNET} )
	      test? ( || ( netcoreapp21 net46 ) )
	      gac? ( net46 )"
CDEPEND="dev-libs/libgit2"
DEPEND="${CDEPEND}
	>=dev-dotnet/nuget-2.7
	 !system-libgit2? ( dev-libs/libgit2 )"
RDEPEND="${CDEPEND}
	 dev-vcs/git"
SRC_URI=""
#${HOMEPAGE}/archive/v0.26.tar.gz -> ${P}.tar.gz
USE_DOTNET="netstandard20 net46 netcoreapp21"
TOOLS_VERSION="Current"
inherit dotnet eutils
S="${WORKDIR}/${PN}-${PV}"
EGIT_COMMIT="8950f498511d9e4cc1756193682ac3bb08581166"
REPO_URL="https://github.com/libgit2/libgit2sharp.git"
LIBGIT2_HASH="7ce88e66a19e3b48340abcdd86aeaae1882e63cc"
LIBGIT2_SHORT_HASH="7ce88e6" # short hash of commit ; v0.28.3

_fetch_project() {
	# Using git is required.  The install scripts
	# may extract statistics
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
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D v${PV}
		git checkout tags/v${PV} -b v${PV} || die
	fi
	cd "${d}"
	#git checkout ${EGIT_COMMIT} # uncomment for forced deterministic build.
					# comment to follow head of tag.
	[ ! -e "README.md" ] && die "found nothing"
	cp -a "${d}" "${S}" || die
}

src_unpack() {
	_fetch_project
	default
	rm -rf "${S}/Lib/NuGet/" || die
	rm -rf "${S}/Lib/CustomBuildTasks/CustomBuildTasks.dll" || die
}

src_prepare() {
	default
	# check if platform has libgit2.so
	if ! use system-libgit2 ; then
		if ! use amd64 ; then
			die "Recompile with system-libgit2 USE flag enabled."
		fi
	fi
	eapply "${FILESDIR}/libgit2sharp-0.26.1-sln.patch"
	#eapply "${FILESDIR}/packages-config-remove-xunit.patch"
	dotnet_copy_sources
	export Configuration=$(usex debug "debug" "release")
	patch_impl() {
		if dotnet_is_netfx "${EDOTNET}" ; then
			eapply "${FILESDIR}/libgit2sharp-0.26-net46-references.patch"
			L=$(find . -name "*.csproj")
			for f in $L ; do
				cp "${FILESDIR}"/netfx.props "$(dirname $f)" || die
				einfo "Editing $f"
				sed -i -e "s|<Project Sdk=\"Microsoft.NET.Sdk\">|<Project Sdk=\"Microsoft.NET.Sdk\">\n  <Import Project=\"netfx.props\" />\n|" "$f" || die
			done
		fi
		# explained in buildandtest.sh
		export LD_LIBRARY_PATH=.
		erestore
		if use system-libgit2 ; then
			L=$(grep -l -r -e "${LIBGIT2_SHORT_HASH}" \
				$(find "${HOME}" \
					-name "LibGit2Sharp.dll.config"))
			for f in ${L} ; do
				einfo "Editing ${f}"
				sed -i -e "s|lib/linux-x64/libgit2-${LIBGIT2_SHORT_HASH}.so|/usr/$(get_libdir)/libgit2.so|g" "${f}" || die

				local wordsize
				wordsize="$(get_libdir)"
				wordsize="${wordsize//lib/}"
				wordsize="${wordsize//[on]/}"

				# this may mess up the unit testing
				sed -i -e "s|wordsize=\"[0-9]+\"|wordsize=\"${wordsize}\"|g" "${f}" || die
				sed -i -e "s|cpu=\"[,a-z0-9-]+\"||g" "${f}" || die
			done
		fi
	}
	dotnet_foreach_impl patch_impl
}

src_compile() {
	build_impl() {
		if [[ "${EDOTNET}" =~ "netcoreapp" ]] ; then
			einfo "The netcoreapp USE flag is only for testing the"
			einfo "package.  No .NET Core ${PN} library will be"
			einfo "produced but only a .NET Standard version."
		fi

		# explained in buildandtest.sh
		export LD_LIBRARY_PATH=.
		# build #1 using this way linux-x64 dlls?

		if dotnet_is_netfx "${EDOTNET}" ; then
			export FrameworkPathOverride="$(dotnet_netfx_install_loc ${EDOTNET})/"
		else
			unset FrameworkPathOverride
		fi

		if [[ "${EDOTNET}" =~ "netstandard" \
			|| "${EDOTNET}" =~ net[0-9][0-9][0-9]? ]] ; then
			exbuild LibGit2Sharp/LibGit2Sharp.csproj
		fi

		if [[ "${EDOTNET}" =~ "netcoreapp" \
			|| "${EDOTNET}" =~ net[0-9][0-9][0-9]? ]] ; then
			if use test ; then
				export EXTRADEFINE='LEAKS_IDENTIFYING'
				exbuild LibGit2Sharp.Tests \
					-property:ExtraDefine="$EXTRADEFINE" \
					-fl -flp:verbosity=detailed
			fi
		fi
	}
	dotnet_foreach_impl build_impl
}

src_install() {
	install_impl() {
		DIR=$(usex debug "debug" "release")
		if [[ "${EDOTNET}" =~ "netstandard" ]] \
			|| dotnet_is_netfx ; then
			DIR="${DIR^}"
		fi

		local _dotnet
		if [ -d /opt/dotnet ] ; then
			_dotnet="dotnet"
		elif [ -d /opt/dotnet_core ] ; then
			_dotnet="dotnet_core"
		fi

		dotnet_install_loc
		local s_base
		s_base="bin/LibGit2Sharp/${DIR}/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})"
		if dotnet_is_netfx ; then
			estrong_resign "${s_base}/LibGit2Sharp.dll" \
				"${S}/libgit2sharp.snk"
			egacinstall "${s_base}/LibGit2Sharp.dll"
			dotnet_distribute_file_matching_dll_in_gac \
				"${s_base}/LibGit2Sharp.dll" \
				"${s_base}/LibGit2Sharp.dll.config"
		fi

		# netcore doesn't produce these dlls
		if [[ "${EDOTNET}" =~ "netstandard" ]] || dotnet_is_netfx ; then
			doins "${s_base}/LibGit2Sharp.dll"
			doins "${s_base}/LibGit2Sharp.dll.config"
		fi

		if ! use system-libgit2 ; then
			if use amd64 ; then
				insinto "${d}/lib/linux-x64"
				doins "${s_base}"/lib/linux-x64/libgit2-${LIBGIT2_SHORT_HASH}.so
			else
				die "Missing support for ${ARCH}"
			fi
		fi

		if dotnet_is_netfx && [[ -n "${_dotnet}" ]] ; then
			insinto "$(dotnet_netcore_install_loc ${EDOTNET})"
			dosym "$(dotnet_netfx_install_loc ${EDOTNET})/LibGit2Sharp.dll" \
				"$(dotnet_netcore_install_loc ${EDOTNET})/LibGit2Sharp.dll"
		fi

		if [[ "${EDOTNET}" =~ "netstandard" ]] || dotnet_is_netfx ; then
			if use developer ; then
				insinto "${d}"
				doins "bin/LibGit2Sharp/${DIR}/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/LibGit2Sharp.pdb"
				doins "bin/LibGit2Sharp/${DIR}/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/LibGit2Sharp.xml"
				if [[ "${EDOTNET}" == "net46" && -n "${_dotnet}" ]] ; then
					dosym "$(dotnet_netfx_install_loc ${EDOTNET})/LibGit2Sharp.pdb" \
						"$(dotnet_netcore_install_loc ${EDOTNET})/LibGit2Sharp.pdb"
					dosym "$(dotnet_netfx_install_loc ${EDOTNET})/LibGit2Sharp.xml" \
						"$(dotnet_netcore_install_loc ${EDOTNET})/LibGit2Sharp.xml"
				fi
			fi
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

src_test() {
	test_impl() {
		# explained in buildandtest.sh
		export LD_LIBRARY_PATH=.
#		if [[ "${EDOTNET}" =~ "netcoreapp" ]] || dotnet_is_netfx ; then
		if [[ "${EDOTNET}" =~ "netcoreapp" ]] ; then
			if use test ; then
				pushd "bin/LibGit2Sharp.Tests" || die
					[ -d release ] || ln -s "Release" "release" || die
				popd
				exbuild_raw test LibGit2Sharp.Tests/LibGit2Sharp.Tests.csproj \
					-f $(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET}) \
					--no-restore --no-build || die
			fi
		fi
	}
	dotnet_foreach_impl test_impl
}
