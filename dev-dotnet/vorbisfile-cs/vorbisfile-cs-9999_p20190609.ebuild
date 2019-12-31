# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Vorbisfile# is a C# wrapper for Vorbisfile"
HOMEPAGE="https://github.com/flibitijibibo/Vorbisfile-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
RDEPEND="media-libs/libvorbis"
DEPEND="${RDEPEND}"
inherit dotnet eutils
PROJECT_NAME="Vorbisfile-CS"
EGIT_COMMIT="b929dedf3dab9ef85a3e6080f44227643f970710"
SRC_URI=\
"https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
SLOT="0/${PV}"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")

	compile_impl() {
	        einfo "Building solution"
		exbuild /p:Configuration=${mydebug} \
			${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln || die
		dotnet_copy_dllmap_config \
			"${FILESDIR}/${PROJECT_NAME}.dll.config"
	}

	dotnet_foreach_impl compile_impl
}

# @FUNCTION: _mydoins
# @DESCRIPTION: combines gac install, regular install, .config install
_mydoins() {
	local path="$1"
	if dotnet_is_netfx ; then
		estrong_resign "${path}" "${DISTDIR}/mono.snk"
		egacinstall "${path}"
		dotnet_distribute_file_matching_dll_in_gac "${path}" \
			"${PROJECT_NAME}.dll.config"
	fi
	doins "${path}"
	doins "${PROJECT_NAME}.dll.config"
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

	install_impl() {
		dotnet_install_loc
		_mydoins bin/${mydebug}/${PROJECT_NAME}.dll
	}

	dotnet_foreach_impl install_impl
}
