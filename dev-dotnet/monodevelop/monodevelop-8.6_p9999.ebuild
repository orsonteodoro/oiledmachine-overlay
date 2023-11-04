# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# FIXME:
# Errors in /var/tmp/portage/dev-dotnet/monodevelop-8.6_p9999/work/monodevelop-8.6_p9999/main/external/Xamarin.PropertyEditing/Xamarin.PropertyEditing/Xamarin.PropertyEditing.csproj
#     > 65536
#     Parameter name: length


# Version details:  main branch at HEAD ; develop/experimental

DOTNET_PV="6.0"

inherit git-r3 lcnr xdg

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
IUSE=" developer test"
REQUIRED_USE=" "
CDEPEND="
	!dev-dotnet/dotdevelop
	>=dev-dotnet/gtk-sharp-2.12.8:2
	>=dev-dotnet/fsharp-mono-bin-5.0.0.0_p15
	>=dev-lang/mono-5.10
"
RDEPEND="
	${CDEPEND}
"
DEPEND="
	${RDEPEND}
"
#	>=dev-dotnet/dotnet-sdk-bin-3.1:3.1
BDEPEND="
	${CDEPEND}
	>=dev-dotnet/dotnet-sdk-bin-6.0:6.0
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
	kernel_Darwin? (
		dev-lang/ruby
	)
"
RESTRICT="mirror"
PATCHES=(
##	"${FILESDIR}/${PN}-8.4.3_p9999-use-monolauncher.patch"
##	"${FILESDIR}/${PN}-8.4.3_p9999-buildvariables-references.patch"
###	"${FILESDIR}/${PN}-8.4.3_p9999-reference-assemblies.patch"
##	"${FILESDIR}/${PN}-8.4.3_p9999-AsyncQuickInfoDemo-references.patch"
)
EGIT_REPO_URI="https://github.com/mono/monodevelop.git"
EGIT_BRANCH="main"
EGIT_COMMIT="HEAD"
EGIT_SUBMODULES=( '*' )
MY_PV="${PV}"

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

EXPECTED_BUILD_FILES="\
ea69fec9392ef2dcff34dc288887a73766c04956dae952778de7e70fdbdb68fc\
74241c6401c7d57ef16f5878c458f459f97d4275513e0aed4de116a4c4fa6a0f\
"

_run() {
einfo "Running:  ${@}"
	"${@}" || die
}

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
	EGIT_OVERRIDE_REPO_LIBSSH2_LIBSSH2="${EGIT_OVERRIDE_REPO_LIBSSH2_LIBSSH2:-https://github.com/libssh2/libssh2.git}"
	EGIT_OVERRIDE_REPO_MONO_DEBUGGER_LIBS="${EGIT_OVERRIDE_REPO_MONO_DEBUGGER_LIBS:-https://github.com/mono/debugger-libs.git}"
	EGIT_OVERRIDE_REPO_MONO_GUIUNIT="${EGIT_OVERRIDE_REPO_MONO_GUIUNIT:-https://github.com/mono/guiunit.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT_BINARY="${EGIT_OVERRIDE_REPO_MONO_LIBGIT_BINARY:-https://github.com/mono/libgit-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT2="${EGIT_OVERRIDE_REPO_MONO_LIBGIT2:-https://github.com/mono/libgit2.git}"
	EGIT_OVERRIDE_REPO_MONO_LIBGIT2SHARP="${EGIT_OVERRIDE_REPO_MONO_LIBGIT2SHARP:-https://github.com/mono/libgit2sharp.git}"
	EGIT_OVERRIDE_REPO_MONO_MDTESTHARNESS="${EGIT_OVERRIDE_REPO_MONO_MDTESTHARNESS:-https://github.com/mono/mdtestharness.git}"
	EGIT_OVERRIDE_REPO_MONO_MONO_ADDINS="${EGIT_OVERRIDE_REPO_MONO_MONO_ADDINS:-https://github.com/mono/mono-addins.git}"
	EGIT_OVERRIDE_REPO_MONO_MONO_TOOLS="${EGIT_OVERRIDE_REPO_MONO_MONO_TOOLS:-https://github.com/mono/mono-tools.git}"
	EGIT_OVERRIDE_REPO_MONO_NUGET_BINARY="${EGIT_OVERRIDE_REPO_MONO_NUGET_BINARY:-https://github.com/mono/nuget-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_REFACTORINGESSENTIALS="${EGIT_OVERRIDE_REPO_MONO_REFACTORINGESSENTIALS:-https://github.com/mono/RefactoringEssentials.git}"
	EGIT_OVERRIDE_REPO_MONO_SHARPSVN_BINARY="${EGIT_OVERRIDE_REPO_MONO_SHARPSVN_BINARY:-https://github.com/mono/sharpsvn-binary.git}"
	EGIT_OVERRIDE_REPO_MONO_XWT="${EGIT_OVERRIDE_REPO_MONO_XWT:-https://github.com/mono/xwt.git}"
	EGIT_OVERRIDE_REPO_XAMARIN_MACDOC="${EGIT_OVERRIDE_REPO_XAMARIN_MACDOC:-https://github.com/xamarin/macdoc.git}"
	EGIT_OVERRIDE_REPO_XAMARIN_NREFACTORY="${EGIT_OVERRIDE_REPO_XAMARIN_NREFACTORY:-https://github.com/xamarin/NRefactory.git}"

	git-r3_fetch
	git-r3_checkout

	cd "${S}" || die

	local actual_pv=$(grep -e "^Version=" "version.config" | cut -f 2 -d "=")
	local expected_pv=$(ver_cut 1-2 ${PV})
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
eerror "Actual build files:  ${actual_build_files}"
eerror "Expected build files:  ${EXPECTED_BUILD_FILES}"
eerror
		die
	fi

einfo "Importing GPG key into sandboxed keychain"
	# See also
	# https://keyserver.ubuntu.com/pks/lookup?search=3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF&fingerprint=on&op=index
	local KEY_ID="3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
	local pub_keyserver=${GPG_PUBLIC_KEYSERVER:-"hkp://keyserver.ubuntu.com:80"}
	_run gpg \
		--batch \
		--keyserver "${pub_keyserver}" \
		--recv-keys "${KEY_ID}"

	# Fixes CERTIFICATE_VERIFY_FAILED
	# See https://github.com/mono/monodevelop/issues/9675
	sed -i -e 's|dotnet.myget.org|www.myget.org|g' NuGet.config || die
}

_fix_nuget_feeds() {
	# Breaks restore
	local BANNED_FEEDS=(
		# Avoids:  "Please provide credentials for: https://www.myget.org/F/vstest/"
		# See also:  https://github.com/mono/monodevelop/issues/9675
		"vstest"

		# Dropped in dotdevelop
		"Roslyn Nightlies"
		"roslyn-analyzers"
		"VS Editor Legacy"
		"VSTest"
		"Templating"
		"Azure AppService"
		"MSBuild"
		"nuget-build"

		# Found in
		# main/NuGet.config
		# main/external/Xamarin.PropertyEditing/Xamarin.PropertyEditing/Xamarin.PropertyEditing.csproj
#		"myget.org/F/"

		# Found in
		# main/external/Xamarin.PropertyEditing/Xamarin.PropertyEditing/Xamarin.PropertyEditing.csproj
#		"devdiv.pkgs.visualstudio.com"
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

src_prepare() {
	default
	_fix_nuget_feeds
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
"${EPREFIX}/opt/${SDK}/dotnet" $(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll") -tv:Current -p:UseMonoLauncher=1 -p:ReferencePath="${HOME}/.nuget/packages" "\${@}"
EOF
	chmod +x "${WORKDIR}/bin/msbuild" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

src_configure() {
	local f
	for f in $(grep -r -l "${EPREFIX}/usr/local/share/dotnet") ; do
		einfo "Edited ${f}:  ${EPREFIX}/usr/local/share/dotnet -> ${EPREFIX}/opt/${SDK}"
		sed -i -e "s|/usr/local/share/dotnet|${EPREFIX}/opt/${SDK}|g" "${f}" || die
	done
	_use_msbuild_mono
	#_use_msbuild_dotnet
}

_build_all() {
	local myconf=(
		--profile=gnome
		--prefix="${EPREFIX}/usr"
#		--enable-release
	)

	./configure \
		${myconf[@]} || die

	export PATH="${EPREFIX}/opt/dotnet-sdk-bin-6.0:${PATH}"

	pushd "${S}/main" || die
		emake
	popd
}

src_compile() {
	local configuration="Release"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
	export MAKEOPTS="-j1"
	addpredict /etc/mono/registry/last-btime
	_build_all
}

gen_wrapper() {
cat <<EOF > "${ED}/usr/bin/monodevelop"
#!/bin/bash
PATH="/usr/lib/monodevelop:\${PATH}"
mono main/build/bin/MonoDevelop.exe "\${@}"
EOF
}

sanitize_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		if file "${path}" | grep -q -e "symbolic link" ; then
			continue
		fi
		realpath "${path}" 2>/dev/null 1>/dev/null || continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "POSIX shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL) (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (GUI)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32+ executable (DLL) (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32+ executable (DLL) (GUI)" ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README.md

	LCNR_SOURCE="${HOME}/.nuget"
	LCNR_TAG="third_party"
	lcnr_install_files

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
	sanitize_permissions
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
