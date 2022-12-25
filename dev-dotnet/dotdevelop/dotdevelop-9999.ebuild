# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PV="6.0"
inherit git-r3 lcnr

DESCRIPTION="DotDevelop will hopefully be a full-featured integrated development
environment (IDE) for .NET using GTK."
HOMEPAGE="https://github.com/dotdevelop/dotdevelop"
LICENSE="
	LGPL-2.1
	MIT
	all-rights-reserved
	Apache-2.0
	GPL-2
	LGPL-2.1
	Ms-PL
	ZLIB
"
#
# sharpsvn-binary - Apache-2.0
# fsharpbinding - Apache-2.0
# libgit-binary - GPL-2-with-linking-exception, Apache-2.0, MIT, LGPL-2.1, ZLIB
# macdoc (from monomac) - MIT Apache-2.0
#   lib/AgilityPack.dll [Html Agility Pack] - MIT
#   lib/Ionic.Zip.dll - Ms-PL
# mdtestharness - all-rights-reserved (no explicit license and sources)
# monotools - GPL-2, LGPL-2, MIT
# nuget-binary - Apache-2.0
#
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
debugger developer test

+fallback-commit
"
REQUIRED_USE="
	!debugger
"
CDEPEND="
	>=dev-lang/mono-5.10
	>=dev-dotnet/gtk-sharp-2.12.8:2
"
RDEPEND="
	${CDEPEND}
"
DEPEND="${RDEPEND}"
BDEPEND="
	${CDEPEND}
	  app-shells/bash
	>=dev-dotnet/dotnet-sdk-bin-3.1:3.1
	>=dev-dotnet/dotnet-sdk-bin-6.0:6.0
	>=dev-dotnet/msbuild-bin-16:16
	>=dev-util/cmake-2.8.12.2
	  dev-util/intltool
	  dev-vcs/git
	>=sys-devel/autoconf-2.53
	>=sys-devel/automake-1.10
	  sys-devel/gettext
	  sys-devel/make
	  virtual/pkgconfig
	  x11-misc/shared-mime-info
	debugger? ( dev-lang/python )
	kernel_Darwin? (
		dev-lang/ruby
	)
"
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-9999-use-monolauncher.patch"
#	"${FILESDIR}/${PN}-9999-buildvariables-references.patch"
	"${FILESDIR}/${PN}-9999-AsyncQuickInfoDemo-references.patch"
)
EGIT_REPO_URI="https://github.com/dotdevelop/dotdevelop.git"
EGIT_BRANCH="main"
EGIT_COMMIT="HEAD"
MY_PV="${PV}"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

EXPECTED_BUILD_FILES="\
95dbea87f666876c2fa0263a83291644e3c8cd521c961155f7073550701569ff\
f1e851c34cbbbddf6c78522c59bc9d24f60a63e90e29e6e98505b4130d20ae0c\
"

pkg_setup() {
ewarn
ewarn "This ebuild is unbuildable and incomplete."
ewarn
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
	use fallback-commit && EGIT_COMMIT="5819e6e7ef5747ba6375cb9dfad0a75b6127d562"
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die

	local actual_pv=$(grep -e "^Version=" "version.config" | cut -f 2 -d "=")
	local expected_pv="8.6"
	if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
eerror
eerror "Version mismatch"
eerror
eerror "Actual PV:  ${actual_pv}"
eerror "Expected PV:  ${expected_pv}"
eerror
eerror
		die
	fi

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
eerror "Actual PV:  ${actual_build_files}"
eerror "Expected PV:  ${EXPECTED_BUILD_FILES}"
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
#	_attach_reference_assemblies_pack
	_drop_projects
}

# Upstream uses the mono version but it doesn't work
_use_msbuild_mono() {
	mkdir -p "${WORKDIR}/bin" || die
cat <<EOF > "${WORKDIR}/bin/msbuild" || die
#!${EPREFIX}/bin/bash
"${EPREFIX}/usr/bin/mono" \
	$(realpath "${EPREFIX}/usr/share/msbuild/16/MSBuild.dll") \
	-p:UseMonoLauncher=1 \
	-p:ReferencePath="${HOME}/.nuget/packages" \
	"\${@}"
EOF
#	-p:FrameworkPathOverride="${HOME}/.nuget/packages/microsoft.netframework.referenceassemblies.net472/1.0.3/build/.NETFramework/v4.7.2" \
	chmod +x "${WORKDIR}/bin/msbuild" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

_use_msbuild_dotnet() {
	mkdir -p "${WORKDIR}/bin" || die
cat <<EOF > "${WORKDIR}/bin/msbuild" || die
#!${EPREFIX}/bin/bash
"${EPREFIX}/opt/${SDK}/dotnet" \
	$(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll") \
	-tv:Current \
	-p:UseMonoLauncher=1 \
	-p:ReferencePath="${HOME}/.nuget/packages" \
	"\${@}"
EOF
#	-p:FrameworkPathOverride="${HOME}/.nuget/packages/microsoft.netframework.referenceassemblies.net472/1.0.3/build/.NETFramework/v4.7.2" \
	chmod +x "${WORKDIR}/bin/msbuild" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

_check_msbuild() {
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
	msbuild -version | grep -q -e "for .NET" || die
	msbuild -version | grep -q -e "for Mono" && die
}

src_configure() {
	local f
	for f in $(grep -r -l "${EPREFIX}/usr/local/share/dotnet") ; do
		einfo "Edited ${f}:  ${EPREFIX}/usr/local/share/dotnet -> ${EPREFIX}/opt/${SDK}"
		sed -i -e "s|/usr/local/share/dotnet|${EPREFIX}/opt/${SDK}|g" "${f}" || die
	done
	_use_msbuild_dotnet
	#_check_msbuild
	local msbuild_path=$(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll")
	sed -i -e "s|XBUILD=msbuild|XBUILD=\"${WORKDIR}/bin/msbuild\"|g" \
		main/xbuild.include || die
}

_restore_all() {
	IFS=$'\n'
	local f
	for f in $(find "${S}" -name "*.csproj") ; do
		if ! use test && [[ "${f,,}" =~ ("test") ]] ; then
			continue
		fi
		if ! use kernel_Darwin && [[ "${f,,}" =~ ("mac"|"cocoa") ]] ; then
			continue
		fi
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
		--profile=gnome
		--prefix="${EPREFIX}/usr"
		--enable-release
	)

	./configure \
		${myconf[@]}

	export PATH="${EPREFIX}/opt/dotnet-sdk-bin-6.0:${PATH}"

einfo "Called print_config"
	emake print_config

einfo "Called all-recursive"
	emake all-recursive
}

_build_debugger() {
	cd main/external/Samsung.Netcoredbg || die
	./build.sh
}

src_compile() {
	local configuration="Release"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
	_build_all
	use debugger && _build_debugger
}

src_install() {
	local configuration="Release"

	die "src_install is unfinished"
cat <<EOF > "${ED}/usr/bin/dotdevelop"
#!/bin/bash
PATH="/usr/lib/dotdevelop:\${PATH}"
mono main/build/bin/MonoDevelop.exe "\${@}"
EOF

	dodoc README.md
	lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
