# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Version details:  7.6 branch at tip ; ebuild maybe to check if it works

DOTNET_PV="3.0"

inherit git-r3 lcnr

SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="MonoDevelop is a cross platform .NET IDE"
HOMEPAGE="
https://www.monodevelop.com/
https://github.com/mono/monodevelop
"
LICENSE="
	LGPL-2.1
	MIT
	all-rights-reserved
	Apache-2.0
	BSD
	GPL-2
	GPL-2-with-linking-exception
	LGPL-2.1
	Ms-PL
	ZLIB
"
#
# sharpsvn-binary - Apache-2.0
# fsharpbinding - Apache-2.0
# libgit-binary - GPL-2-with-linking-exception, Apache-2.0, MIT, LGPL-2.1, ZLIB
# libgit2 - GPL-2-with-linking-exception
# libssh2 - BSD
# macdoc (from monomac) - MIT Apache-2.0
#   lib/AgilityPack.dll [Html Agility Pack] - MIT
#   lib/Ionic.Zip.dll - Ms-PL
# mdtestharness - all-rights-reserved (no explicit license and sources)
# monotools - GPL-2, LGPL-2, MIT
# nuget-binary - Apache-2.0
#
#KEYWORDS="~amd64 ~x86" # Ebuild not finished
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE=" developer git monoextentions subversion test"
REQUIRED_USE=" "
CDEPEND="
	>=dev-dotnet/gtk-sharp-2.12.8:2
	>=dev-dotnet/fsharp-mono-bin-5.0.0.0_p15
	>=dev-lang/mono-4
	git? (
		net-libs/libssh2
	)
"
RDEPEND="
	${CDEPEND}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}
	>=dev-dotnet/dotnet-sdk-bin-3.1:3.1
	>=dev-dotnet/mono-msbuild-bin-16.10.1
	>=dev-util/cmake-2.8.12.2
	>=sys-devel/autoconf-2.53
	>=sys-devel/automake-1.10
	app-shells/bash
	dev-util/intltool
	dev-vcs/git
	sys-devel/gettext
	sys-devel/make
	virtual/pkgconfig
	x11-misc/shared-mime-info
	git? (
		dev-util/cmake
	)
	kernel_Darwin? (
		dev-lang/ruby
	)
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-7.6.11_p9999-use-monolauncher.patch"
	"${FILESDIR}/${PN}-8.4.3_p9999-buildvariables-references.patch"
	"${FILESDIR}/${PN}-7.6.11_p9999-configure-args.patch"
	"${FILESDIR}/${PN}-7.6.11_p9999-csc-path.patch"
	"${FILESDIR}/${PN}-7.6.11_p9999-TextEditor-target-framework.patch"
)
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_BRANCH="release-$(ver_cut 1-2 ${PV})"
#EGIT_COMMIT="HEAD"
EGIT_SUBMODULES=( '*' )
MY_PV="${PV}"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

EXPECTED_BUILD_FILES="\
7635b36f3de3e146116ab748431a1f01fe61d3ab753c541dcc0608308fb87e58\
4c7072c3c3f215b9f7b54cec80f8101811110bafb02c8b14c905f69f74c0c746\
"

pkg_setup() {
ewarn
ewarn "This ebuild is unbuildable and incomplete."
ewarn
	use kernel_Darwin && die "This ebuild does not support this Prefix or CHOST currently."
	use elibc_mingw && die "This ebuild does not support this Prefix or CHOST currently."
eerror
eerror "This product is no longer maintained upstream."
eerror
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local found=0
	for sdk in ${DOTNET_SUPPORTED_SDKS[@]} ; do
		if [[ -e "${EPREFIX}/opt/${sdk}" ]] ; then
			export SDK="${sdk}"
			export PATH="${EPREFIX}/opt/${sdk}:${PATH}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "You need a dotnet SDK."
eerror
eerror "Supported SDK versions: ${DOTNET_SUPPORTED_SDKS[@]}"
eerror
		die
	fi
}

src_unpack() {
	# Override because the git-r3 eclass is not security smart.
	# The server will reject if using git://
	EGIT_OVERRIDE_REPO_ICSHARPCODE_NREFACTORY="${EGIT_OVERRIDE_REPO_ICSHARPCODE_NREFACTORY:-https://github.com/icsharpcode/NRefactory.git}"
	EGIT_OVERRIDE_REPO_LIBSSH2_LIBSSH2="${EGIT_OVERRIDE_REPO_LIBSSH2_LIBSSH2:-https://github.com/libssh2/libssh2.git}"
	EGIT_OVERRIDE_REPO_MONO_DEBUGGER_LIBS="${EGIT_OVERRIDE_REPO_MONO_DEBUGGER_LIBS:-https://github.com/mono/debugger-libs.git}"
	EGIT_OVERRIDE_REPO_MONO_GUIUNIT="${EGIT_OVERRIDE_REPO_MONO_GUIUNIT:-https://github.com/mono/guiunit.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT_BINARY="${EGIT_OVERRIDE_REPO_MONO_LIBGIT_BINARY:-https://github.com/mono/libgit-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT2="${EGIT_OVERRIDE_REPO_MONO_LIBGIT2:-https://github.com/mono/libgit2.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT2SHARP="${EGIT_OVERRIDE_REPO_MONO_LIBGIT2SHARP:-https://github.com/mono/libgit2sharp.git}"
	EGIT_OVERRIDE_REPO_MONO_MACCORE="${EGIT_OVERRIDE_REPO_MONO_MACCORE:-https://github.com/mono/maccore.git}"
	EGIT_OVERRIDE_REPO_MONO_MDTESTHARNESS="${EGIT_OVERRIDE_REPO_MONO_MDTESTHARNESS:-https://github.com/mono/mdtestharness.git}"
	EGIT_OVERRIDE_REPO_MONO_MONO_ADDINS="${EGIT_OVERRIDE_REPO_MONO_MONO_ADDINS:-https://github.com/mono/mono-addins.git}"
	EGIT_OVERRIDE_REPO_MONO_MONO_TOOLS="${EGIT_OVERRIDE_REPO_MONO_MONO_TOOLS:-https://github.com/mono/mono-tools.git}"
	EGIT_OVERRIDE_REPO_MONO_MONOMAC="${EGIT_OVERRIDE_REPO_MONO_MONOMAC:-https://github.com/mono/monomac.git}"
	EGIT_OVERRIDE_REPO_MONO_NUGET_BINARY="${EGIT_OVERRIDE_REPO_MONO_NUGET_BINARY:-https://github.com/mono/nuget-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_REFACTORINGESSENTIALS="${EGIT_OVERRIDE_REPO_MONO_REFACTORINGESSENTIALS:-https://github.com/mono/RefactoringEssentials.git}"
	EGIT_OVERRIDE_REPO_MONO_SHARPSVN_BINARY="${EGIT_OVERRIDE_REPO_MONO_SHARPSVN_BINARY:-https://github.com/mono/sharpsvn-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_XWT="${EGIT_OVERRIDE_REPO_MONO_XWT:-https://github.com/mono/xwt.git}"
	EGIT_OVERRIDE_REPO_XAMARIN_MACDOC="${EGIT_OVERRIDE_REPO_XAMARIN_MACDOC:-https://github.com/xamarin/macdoc.git}"
	EGIT_OVERRIDE_REPO_XAMARIN_NREFACTORY="${EGIT_OVERRIDE_REPO_XAMARIN_NREFACTORY:-https://github.com/xamarin/NRefactory.git}"

	git-r3_fetch
	git-r3_checkout

	cd "${S}" || die

	IFS=$'\n'
	for f in $(find "${S}" -name "*.csproj" | sort) ; do
		cat "${f}"
	done | sha512sum | cut -f 1 -d " " > "${T}/h"
	IFS=$' \t\n'
	local actual_build_files=$(cat "${T}/h")

	if [[ "${actual_build_files}" != "${EXPECTED_BUILD_FILES}" ]] ; then
eerror
eerror "Build files change detected for dependencies"
eerror
eerror "Actual build files:  ${actual_build_files}"
eerror "Expected build files:  ${EXPECTED_BUILD_FILES}"
eerror
		die
	fi
}

_fix_nuget_feeds() {
	# Breaks restore
	local BANNED_FEEDS=(
		"myget.org/F/"
		"devdiv.pkgs.visualstudio.com"
	)
	local f
	local feed
	for f in $(find "${S}" -iname "NuGet.config") ; do
		for feed in ${BANNED_FEEDS[@]} ; do
			if grep -q -e "${feed}" "${f}" ; then
einfo "Editing ${f} to remove ${feed}"
				sed -i \
					-e "\|${feed}|d" \
					"${f}" || die
			fi
		done
	done
}

_attach_reference_assemblies_pack() {
	IFS=$'\n'
	local f
	for f in $(find "${S}" -name "*.csproj") ; do
		local loc=$(grep -n "<Reference Include=\"System" "${f}" | cut -f 1 -d ":" | head -n 1)
		[[ -z "${loc}" ]] && continue
einfo "Editing ${f}:  Attaching PackageReference to Microsoft.NETFramework.ReferenceAssemblies"
		sed -i -e "${loc}i<PackageReference Include=\"Microsoft.NETFramework.ReferenceAssemblies\" Version=\"1.0.3\" />" "${f}" || die
	done
	IFS=$' \t\n'
}

_set_target_platform() {
	IFS=$'\n'
	for f in $(find "${S}" -name "*.csproj") ; do
		if ! grep -q -e "<TargetFrameworkVersion" "${f}" \
			&& grep -E -q -e "<ProjectReference.*(MonoDevelop.Ide|MonoDevelop.Core|Mono.TextEditor|MonoDevelop.DesignerSupport)" "${f}" ; then
			local loc=$(grep -n "<AssemblyName>" "${f}" | cut -f 1 -d ":" | head -n 1)
			[[ -z "${loc}" ]] && continue
			local framework_version="4.6.1"
einfo "Editing ${f}:  Attaching TargetFrameworkVersion v${framework_version}"
			sed -i -e "${loc}a<TargetFrameworkVersion>v${framework_version}</TargetFrameworkVersion>" "${f}" || die
		fi
	done
	IFS=$' \t\n'
}

_drop_projects() {
	IFS=$'\n'
	local f
	for f in $(find "${S}" -name "*.sln") ; do
		if ! use test ; then
			sed -i -e '/^Project.*Test/i,/^EndProject/d' "${f}" || die
		fi
	done
	IFS=$' \t\n'
}

src_prepare() {
	default
	_fix_nuget_feeds
	_attach_reference_assemblies_pack
	_set_target_platform
#	_drop_projects
}

_use_msbuild_mono() {
	mkdir -p "${WORKDIR}/bin" || die
	ln -s \
		"/usr/bin/msbuild" \
		"${WORKDIR}/bin/msbuild"
	export PATH="${WORKDIR}/bin:${PATH}"
}

_use_msbuild_dotnet() {
	mkdir -p "${WORKDIR}/bin" || die
cat <<EOF > "${WORKDIR}/bin/msbuild" || die
#!${EPREFIX}/bin/bash
"${EPREFIX}/opt/${SDK}/dotnet" $(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll") -tv:14.0 -p:UseMonoLauncher=1 -p:ReferencePath="${HOME}/.nuget/packages" "\${@}"
EOF
	chmod +x "${WORKDIR}/bin/msbuild" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

_make_fsharpc() {
	mkdir -p "${WORKDIR}/bin" || die
cat <<EOF > "${WORKDIR}/bin/fsharpc" || die
#!${EPREFIX}/bin/bash
"${EPREFIX}/opt/${SDK}/dotnet" $(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/FSharp/fsc.dll") "\${@}"
EOF
	chmod +x "${WORKDIR}/bin/fsharpc" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

_set_csc() {
	mkdir -p "${WORKDIR}/bin" || die
cat <<EOF > "${WORKDIR}/bin/csc.exe" || die
#!${EPREFIX}/bin/bash
"${EPREFIX}/opt/${SDK}/dotnet" $(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/Roslyn/bincore/csc.dll") "\${@}"
EOF
	chmod +x "${WORKDIR}/bin/csc.exe" || die
	sed -i -e "s|__CSC_TOOL_EXE__|csc.exe|g" \
		main/msbuild/MonoDevelop.BeforeCommon.targets || die
	sed -i -e "s|__CSC_TOOL_PATH__|${WORKDIR}/bin|g" \
		main/msbuild/MonoDevelop.BeforeCommon.targets || die
}

src_configure() {
	local f
	for f in $(grep -r -l "${EPREFIX}/usr/local/share/dotnet") ; do
		einfo "Edited ${f}:  ${EPREFIX}/usr/local/share/dotnet -> ${EPREFIX}/opt/${SDK}"
		sed -i -e "s|/usr/local/share/dotnet|${EPREFIX}/opt/${SDK}|g" "${f}" || die
	done
	_set_csc
	_use_msbuild_mono
	#_use_msbuild_dotnet
	#_make_fsharpc
}

_restore_all() {
	IFS=$'\n'
	local f
	for f in $(find "${S}" -name "*.csproj") ; do
#		if ! use test && [[ "${f,,}" =~ ("test") ]] ; then
#			continue
#		fi
#		if ! use kernel_Darwin && [[ "${f,,}" =~ ("mac"|"cocoa") ]] ; then
#			continue
#		fi
		if grep -q -e "PackageReference" "${f}" ; then

einfo "Restoring missing assemblies for ${f}"
		"${EPREFIX}/opt/${SDK}/dotnet" msbuild \
			-p:RestorePackagesConfig=true \
			-t:restore \
			"${f}" || die
		fi
	done
	IFS=$' \t\n'
}

_build_all() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--enable-release
		$(use_enable git)
		$(use_enable test tests)
		$(use_enable monoextentions)
		$(use_enable subversion)
	)

	if use kernel_Darwin && [[ ${CHOST} =~ "x86_64" ]] ; then
		myconf+=( --with-macarch x86_64 )
	elif use kernel_Darwin && [[ ${CHOST} =~ i[3456]86 ]] ; then
		myconf+=( --with-macarch i386 )
	fi

	./configure \
		${myconf[@]} || die

	export PATH="${EPREFIX}/opt/dotnet-sdk-bin-3.0:${PATH}"

einfo "Called all-recursive"
	emake all-recursive
}

src_compile() {
	local configuration="Release"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
	export MAKEOPTS="-j1"
	addpredict /etc/mono/registry/last-btime
	_build_all
}

src_install() {
	local configuration="Release"

	die "src_install is not finished"
cat <<EOF > "${ED}/usr/bin/monodevelop"
#!/bin/bash
PATH="/usr/lib/monodevelop:\${PATH}"
mono main/build/bin/MonoDevelop.exe "\${@}"
EOF

	dodoc README.md

	LCNR_SOURCE="${HOME}/.nuget"
	LCNR_TAG="third_party"
	lcnr_install_files

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
