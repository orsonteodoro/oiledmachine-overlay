# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PV="6.0"

inherit git-r3 lcnr xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dotdevelop/dotdevelop.git"
	EGIT_BRANCH="main"
	EGIT_COMMIT="HEAD"
	MY_PV="${PV}"
	SRC_URI=""
	S="${WORKDIR}/${PN}-${PV}"
fi

DESCRIPTION="DotDevelop will hopefully be a full-featured integrated development \
environment (IDE) for .NET using GTK."
HOMEPAGE="https://github.com/dotdevelop/dotdevelop"
LICENSE="
	LGPL-2.1
	MIT
	all-rights-reserved
	Apache-2.0
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
# macdoc (from monomac) - MIT Apache-2.0
#   lib/AgilityPack.dll [Html Agility Pack] - MIT
#   lib/Ionic.Zip.dll - Ms-PL
# mdtestharness - all-rights-reserved (no explicit license and sources)
# monotools - GPL-2, LGPL-2, MIT
# nuget-binary - Apache-2.0
#
#KEYWORDS="~amd64 ~x86" # Ebuild not finished
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="
debug debugger developer test

+fallback-commit
r1
"
REQUIRED_USE="
	!debugger
"
CDEPEND="
	!dev-dotnet/monodevelop
	>=dev-lang/mono-6.12
	>=dev-dotnet/fsharp-mono-bin-5.0.0.0_p15
	>=dev-dotnet/gtk-sharp-2.12.8:2
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
	>=dev-dotnet/dotnet-sdk-bin-6.0.416:6.0
	>=dev-dotnet/mono-msbuild-bin-16.10.1
	>=dev-util/cmake-2.8.12.2
	>=dev-vcs/git-2.25.1
	>=sys-devel/autoconf-2.53
	>=sys-devel/automake-1.10
	>=sys-devel/make-4.2.1
	app-shells/bash
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-misc/shared-mime-info
	debugger? (
		dev-lang/python
	)
	kernel_Darwin? (
		dev-lang/ruby
	)
"
RESTRICT="mirror"
PATCHES=(
)

# The dotnet-sdk-bin supports only 1 ABI at a time.
DOTNET_SUPPORTED_SDKS=( "dotnet-sdk-bin-${DOTNET_PV}" )

EXPECTED_BUILD_FILES="\
70f568daad6bc575e4c623312ec493836c02d0a72a6e116956bacc11640ecd9b\
434efbe8222f89b8baf3f710aee37b8803264adee9faca34b98046cbc81e4a38\
"

pkg_setup() {
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
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="ce0af42429434e9a0701b8af15bc7d26f6dd424b" # Sep 10, 2023
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
	fi
	cd "${S}" || die

einfo "Importing GPG key into sandboxed keychain"
	# See also
	# https://keyserver.ubuntu.com/pks/lookup?search=3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF&fingerprint=on&op=index
	local KEY_ID="3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
	local pub_keyserver=${GPG_PUBLIC_KEYSERVER:-"hkp://keyserver.ubuntu.com:80"}
	_run gpg \
		--batch \
		--keyserver "${pub_keyserver}" \
		--recv-keys "${KEY_ID}"
}

src_prepare() {
	default
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
"${EPREFIX}/opt/${SDK}/dotnet" \
	$(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll") \
	-tv:Current \
	-p:ReferencePath="${HOME}/.nuget/packages" \
	-p:UseMonoLauncher=1 \
	"\${@}"
EOF
	chmod +x "${WORKDIR}/bin/msbuild" || die
	export PATH="${WORKDIR}/bin:${PATH}"
}

src_configure() {
	local f
	for f in $(grep -r -l "${EPREFIX}/usr/local/share/dotnet") ; do
		einfo "Edited ${f}:  ${EPREFIX}/usr/local/share/dotnet -> ${EPREFIX}/opt/${SDK}"
		sed -i \
			-e "s|/usr/local/share/dotnet|${EPREFIX}/opt/${SDK}|g" \
			"${f}" \
			|| die
	done
	_use_msbuild_mono
	#_use_msbuild_dotnet
	local msbuild_path=$(realpath "${EPREFIX}/opt/${SDK}/sdk/"*"/MSBuild.dll")
	sed -i -e "s|XBUILD=msbuild|XBUILD=\"${WORKDIR}/bin/msbuild\"|g" \
		main/xbuild.include \
		|| die
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
	)
	if ! use debug ; then
		myconf+=(
			--enable-release
		)
	fi

	./configure \
		${myconf[@]}

	pushd "${S}/main" || die
		emake
	popd
}

_build_debugger() {
	cd main/external/Samsung.Netcoredbg || die
	./build.sh
}

_run() {
einfo "Running:  ${@}"
	"${@}" || die
}

_verify_toolchain() {
	_run uname -a
	_run git --version
	_run make --version
	_run mono -V
	_run msbuild -version
	_run dotnet --info
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
	export PATH="${EPREFIX}/opt/dotnet-sdk-bin-6.0:${PATH}"
	export MAKEOPTS="-j1"
	addpredict /etc/mono/registry/last-btime
	_verify_toolchain
	_build_all
	use debugger && _build_debugger
}

_make_wrapper() {
cat <<EOF > "${ED}/usr/bin/dotdevelop"
#!/bin/bash
PATH="/usr/lib/dotdevelop:\${PATH}"
cd "/usr/lib/dotdevelop"
mono bin/MonoDevelop.exe "\${@}"
EOF
}

_install_files() {
einfo "Copying files..."
	dodir /usr/lib/monodevelop
	cp -aT \
		"${S}/main/build" \
		"${ED}/usr/lib/monodevelop" \
		|| die
}

sanitize_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		realpath "${path}" 2>/dev/null 1>/dev/null || continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
		elif file "${path}" | grep -q -e "POSIX shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL) (console)" ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	emake DESTDIR="${D}" install
	_install_files
	_make_wrapper
	dodoc README.md
	lcnr_install_files
	sanitize_permissions
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
