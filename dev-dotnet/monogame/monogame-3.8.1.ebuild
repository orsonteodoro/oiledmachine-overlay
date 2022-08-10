# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

FRAMEWORK="6.0"
UAP_VERSION_MIN="10.0"

DESCRIPTION="One framework for creating powerful cross-platform games."
HOMEPAGE="http://www.monogame.net"
LICENSE="
	Ms-PL
	MIT
	GamepadConfig
	FIPL-1.0
	BSD MIT
	GPL-2
	LGPL-3
	ZLIB
"
# Many licenses because of the ThirdParty folder.
# Ms-PL*, MIT - LICENSE.txt
# BSD, MIT - ThirdParty/Dependencies/assimp/Assimp_License.txt
# custom (for commerical & noncommerial using MonoGame) - ThirdParty/GamepadConfig/License.txt
# Ms-PL - ThirdParty/Dependencies/NVorbis/COPYING, ThirdParty/NVorbis/LICENSE
# FIPL-1.0 - ThirdParty/Dependencies/FreeImage.NET/license-fi.txt
# MIT - ThirdParty/Dependencies/Tests/NDesk_LICENSE.txt, ThirdParty/Dependencies/SharpDX/License.txt
# MIT - ThirdParty/Dependencies/SharpDoc/Styles/Standard/syntaxhighlighter/MIT-LICENSE
# GPL-2 - ThirdParty/Dependencies/makeself/COPYING
# LGPL-3 - ThirdParty/Dependencies/SharpDoc/Styles/Standard/syntaxhighlighter/LGPL-LICENSE
# ZLIB - ThirdParty/SDL_GameControllerDB/LICENSE
# ZLIB - ThirdParty/Dependencies/Tests/nunit_LICENSE.txt

# KEYWORDS="~amd64 ~x86" # disabled because ebuild is in development
RDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}
	linux? (
		media-libs/libpng
		sys-devel/gcc[openmp]
		sys-libs/zlib[minizip]
		virtual/libc
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}
"
USE_DOTNET="net60"
PLATFORMS=(android ios linux macos uwp windowsdx)
IUSE+="
	${PLATFORMS[@]}
	${USE_DOTNET}
	debug
	+linux
"
REQUIRED_USE+=" || ( ${PLATFORMS[@]} )"
SRC_URI="https://github.com/MonoGame/MonoGame/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0/${PV}"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

SUPPORTED_SDKS=(6.0)

pkg_setup() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi

	local found=0
	for pv in ${SUPPORTED_SDKS} ; do
		if [[ -e "${EPREFIX}/opt/dotnet-sdk-bin-${pv}" ]] ; then
			export PATH="/opt/dotnet-sdk-bin-${pv}:${PATH}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "You need dev-dotnet/dotnet-sdk-bin."
eerror
eerror "Supported SDK versions: ${SUPPORTED_SDKS}"
eerror
		die
	fi
}

src_unpack() {
	# For .gitmodules
	EGIT_COMMIT="v${PV}"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/MonoGame/MonoGame.git"
	git-r3_fetch
	git-r3_checkout
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	declare -A platforms=(
		[android]="MonoGame.Framework.Android.sln"
		[linux]="MonoGame.Tools.Linux.sln"
		[ios]="MonoGame.Framework.iOS.sln"
		[macos]="MonoGame.Tools.Mac.sln"
		[uwp]="MonoGame.Framework.WindowsUniversal.sln"
		[windowsdx]="MonoGame.Framework.WindowsDX.sln"
	)

	if use android ; then
		dotnet build "${platforms[android]}" ${args[@]} -c ${configuration} -o "${S}_android_${configuration}_build" || die
	fi
	if use ios ; then
		dotnet build "${platforms[ios]}" ${args[@]} -c ${configuration} -o "${S}_ios_${configuration}_build" || die
	fi
	if use linux ; then
		dotnet build "${platforms[linux]}" ${args[@]} -c ${configuration} -o "${S}_linux_${configuration}_build" || die
	fi
	if use macos ; then
		dotnet build "${platforms[macos]}" ${args[@]} -c ${configuration} -o "${S}_macos_${configuration}_build" || die
	fi
	if use uwp ; then
		dotnet build "${platforms[uwp]}" ${args[@]} -c ${configuration} -o "${S}_uwp_${configuration}_build" || die
	fi
	if use windowsdx ; then
		dotnet build "${platforms[windowsdx]}" ${args[@]} -c ${configuration} -o "${S}_windowsdx_${configuration}_build" || die
	fi
}

src_install() {
	if use android ; then
		insinto /opt/${monogame}/export/android
		doins -r "${S}_android_${configuration}_build"
	fi
	if use ios ; then
		insinto /opt/${monogame}/export/ios
		doins -r "${S}_ios_${configuration}_build"
	fi
	if use linux ; then
		insinto /opt/${monogame}
		doins -r "${S}_linux_${configuration}_build"
	fi
	if use macos ; then
		insinto /opt/${monogame}/export/macos
		doins -r "${S}_macos_${configuration}_build"
	fi
	if use uwp ; then
		insinto /opt/${monogame}/export/uwp
		doins -r "${S}_uwp_${configuration}_build"
	fi
	if use windowsdx ; then
		insinto /opt/${monogame}/export/windowsdx
		doins -r "${S}_windowsdx_${configuration}_build"
	fi

einfo
einfo "Restoring file permissions"
einfo
	local x
	for x in $(find "${ED}") ; do
		local path=$(echo "${x}" | sed -e "s|${ED}||g")
		if file "${x}" | grep -q "executable" ; then
			fperms 0775 "${path}"
		elif file "${x}" | grep -q "shared object" ; then
			fperms 0775 "${path}"
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-QUALITY:  BUILDS
# OILEDMACHINE-OVERLAY-META-TAGS:  work-in-progress untested
# OILEDMACHINE-OVERLAY-META-DETAILED-NOTES:
