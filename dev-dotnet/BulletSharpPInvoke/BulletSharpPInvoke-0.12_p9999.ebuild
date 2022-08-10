# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eutils gac git-r3 multilib-minimal

FRAMEWORK="6.0"
DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
LICENSE="MIT zlib"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
USE_DOTNET="net60"
IUSE="${USE_DOTNET} debug test"
REQUIRED_USE="|| ( ${USE_DOTNET} ) net60"
LIBBULLETC_PV="2.88_p20190814"
RDEPEND="
	>=sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-6
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-6
"
BULLET_COMMIT="cb654ddc803a56567fdc8f6dcc4eb3e8291b3e98"
EGIT_COMMIT="498e8b8d0f57d43b55ad9179e3daf416eae33dcb"
SRC_URI=""
SLOT="0/${PV}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

strong_sign() {
	local assembly="${1}"
	local keyfile="${2}"
	if use gac; then
		einfo "Strong signing ${assembly}"
		if ! sn -R "${assembly}" "${keyfile}" ; then
eerror
eerror "Failed to strong sign"
eerror
eerror "Assembly/DLL:  ${assembly}"
eerror "Keyfile:  ${keyfile}"
eerror
			die
		fi
	fi
}

# Copy and sanitize permissions
copy_next_to_file() {
	local source="${1}"
	local attachment="${2}"
	local bn_attachment=$(basename "${attachment}")
	local permissions="${3}"
	local owner="${4}"
	local fingerprint=$(sha256sum "${source}" | cut -f 1 -d " ")
	for x in $(find "${ED}" -type f) ; do
		[[ -L "${x}" ]] && continue
		x_fingerprint=$(sha256sum "${x}" | cut -f 1 -d " ")
		if [[ "${fingerprint}" == "${x_fingerprint}" ]] ; then
			local destdir=$(dirname "${x}")
			cp -a "${attachment}" "${destdir}" || die
			chmod "${permissions}" "${destdir}/${bn_attachment}" || die
			chown "${owner}" "${destdir}/${bn_attachment}" || die
einfo
einfo "Copied ${attachment} -> ${destdir}"
einfo
		fi
	done
}

src_unpack() {
ewarn
ewarn "This ebuild is WIP (Work In Progress)"
ewarn
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/AndresTraks/BulletSharpPInvoke.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	git-r3_fetch
	git-r3_checkout

#	EGIT_BRANCH="master"
#	EGIT_REPO_URI="https://github.com/bulletphysics/bullet3.git"
#	EGIT_CHECKOUT_DIR="${WORKDIR}/bullet"
#	git-r3_fetch
#	git-r3_checkout

	mv bullet3-${BULLET_COMMIT} bullet || die
}

src_prepare() {
	default
	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" \
		BulletSharp/Native.cs || die
	if ! use test ; then
		sed -i -e 's|ADD_SUBDIRECTORY\(test\)||g' \
			libbulletc/CMakeLists.txt || die
	fi
	estrong_assembly_info "using System.Runtime.InteropServices;" \
		"${DISTDIR}/mono.snk" "BulletSharp/Properties/AssemblyInfo.cs"

	prepare_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${CMAKE_USE_DIR}_build"
		cp -a "${S}" "${CMAKE_USE_DIR}" || die
		cd "${CMAKE_USE_DIR}" || die
		cmake_src_prepare
	}
	multilib_foreach_abi prepare_abi
}


DOTNET_SUPPORTED_VERSION=(6.0)
src_configure() {
	local found=0
	for pv in ${DOTNET_SUPPORTED_VERSION[@]} ; do
		if [[ -e "${EPREFIX}/opt/dotnet-sdk-bin-${pv}/dotnet" ]] ; then
			export "${EPREFIX}/opt/dotnet-sdk-bin-${pv}:${PATH}"
			found=1
		fi
	done
	if (( ${found} == 0)) ; then
eerror
eerror "The dotnet sdk has not been found.  Emerge dev-dotnet/dotnet-sdk-bin"
eerror "Supported versions ${DOTNET_SUPPORTED_VERSION[@]}"
eerror
		die
	fi
	configure_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${CMAKE_USE_DIR}_build"
		cd "${CMAKE_USE_DIR}/libbulletc" || die
	        local mycmakeargs=( -DBUILD_BULLET3=1 )
		cmake_src_configure
	}
	multilib_foreach_abi configure_abi
}

get_dotnet_arch() {
	if [[ "${ABI}" == "amd64" ]] ; then
		echo "linux-x64"
	elif [[ "${ABI}" == "arm64" ]] ; then
		echo "linux-arm64"
	fi
}

src_compile() {
	local configuration=$(usex debug "Debug" "Release")
	compile_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${CMAKE_USE_DIR}_build"
		cd "${BUILD_DIR}/libbulletc" || die
		# Build native shared library wrapper
		cmake_src_compile
	}
	multilib_foreach_abi compile_abi

	# Build C# wrapper
	cd BulletSharp || die
	dotnet build -c ${configuration} -r $(get_dotnet_arch) --sc -o "${ED}" || die
}

_mydoins() {
	local dll_path="$1"
	egacinstall "${dll_path}"
	copy_next_to_file \
		"${dll_path}" \
		"${FILESDIR}/BulletSharp.dll.config" \
		0644 \
		root:root
	use developer && \
		copy_next_to_file \
		"${dll_path}" \
		"${dll_path}.mdb" \
		0644 \
		root:root
	doins "${dll_path}"
	doins "BulletSharp.dll.config"
	use developer && doins "${dll_path}.mdb"
}

src_install() {
	install_abi() {
		export CMAKE_USE_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}"
		export BUILD_DIR="${CMAKE_USE_DIR}_build"
		cd "${BUILD_DIR}" || die
		exeinto /usr/$(get_libdir)
		doexe "libbulletc.so"
	}
	multilib_foreach_abi install_abi

	insinto "/usr/lib/mono/${FRAMEWORK}"
	local configuration=$(usex debug "Debug" "Release")
	_mydoins "BulletSharp/bin/${configuration}/BulletSharp.dll"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
