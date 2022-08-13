# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

MY_PV=$(ver_cut 1-2 "${PV}")
FRAMEWORK="6.0"
DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
LICENSE="MIT ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE+=" ${USE_DOTNET} debug test"

# For dotnet runtimes, see https://github.com/dotnet/runtime/blob/main/src/libraries/Microsoft.NETCore.Platforms/src/runtime.json
# For CI and supported platforms, see https://github.com/MonoGame/MonoGame/blob/v3.8.1_HOTFIX/build.cake
#arm here is armv7
ANDROID_MARCH=( arm arm64 x64 x86 ) # dotnet runtimes available
#   arm=armv7
ANDROID_ERIDS="${ANDROID_MARCH[@]/#/dotnet_android_}"

IOS_MARCH=( arm arm64 x64 x86 ) # dotnet runtimes available
IOS_ERIDS="${IOS_MARCH[@]/#/dotnet_ios_}"
# OS >= 11.2

IOSSIMULATOR_MARCH=( arm64 x64 x86 ) # dotnet runtimes available
IOSSIMULATOR_ERIDS="${IOSSIMULATOR_MARCH[@]/#/dotnet_iossimulator_}"

# arm here is armv7*hf only; armel is armv7*s*
LINUX_MARCH=( arm arm64 armel armv6 loongarch64 ppc64le mips64 s390x x64 x86 ) # dotnet runtimes available
LINUX_ERIDS="${LINUX_MARCH[@]/#/dotnet_linux_}"

# arm here is armv7 or armv6; armel is armv7*s*
LINUX_MUSL_MARCH=( arm arm64 armel ppc64le s390x x64 x86 ) # dotnet runtimes available
LINUX_MUSL_ERIDS="${LINUX_MUSL_MARCH[@]/#/dotnet_linux_musl_}"

OSX_MARCH=( arm64 x64 ) # dotnet runtimes available
OSX_ERIDS="${OSX_MARCH[@]/#/dotnet_osx_}"

# Based on Wikipedia
UWP_MARCH=( arm arm64 x64 x86)
UWP_ERIDS="${UWP_MARCH[@]/#/dotnet_uap_}"

WIN_MARCH=( arm arm64 x64 x86 ) # dotnet runtimes available
WIN_ERIDS="${WIN_MARCH[@]/#/dotnet_win_}"

# emerge RIDs
ERIDS=(
	${ANDROID_ERIDS[@]}
	${IOS_ERIDS[@]}
	${IOSSIMULATOR_ERIDS[@]}
	${LINUX_ERIDS[@]}
	${LINUX_MUSL_ERIDS[@]}
	${OSX_ERIDS[@]}
	${UWP_ERIDS[@]}
	${WIN_ERIDS[@]}
)

IUSE+=" ${RIDS[@]} "
REQUIRED_USE+="
	|| (
		${ERIDS[@]}
	)
	elibc_Cygwin? (
		|| (
			${UWP_ERIDS[@]}
			${WIN_ERIDS[@]}
		)
	)
	elibc_glibc? (
		|| (
			${LINUX_ERIDS[@]}
		)
	)
	elibc_musl? (
		|| (
			${LINUX_MUSL_ERIDS[@]}
		)
	)
"

gen_linux_required_use() {
	local erid
	for erid in ${LINUX_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_glibc
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_linux_required_use)

gen_linux_musl_required_use() {
	local erid
	for erid in ${LINUX_MUSL_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_musl
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_linux_musl_required_use)

gen_win_required_use() {
	local erid
	for erid in ${WIN_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_Cygwin
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_win_required_use)

gen_uwp_required_use() {
	local erid
	for erid in ${UWP_ERIDS[@]} ; do
		echo "
			${erid}? (
				elibc_Cygwin
			)
		"
	done
}
REQUIRED_USE+=" "$(gen_uwp_required_use)

RDEPEND="
	~sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	~sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-${FRAMEWORK}:${FRAMEWORK}
"

# Only tested versions allowed because the wrapper is version sensitive.
BULLET_VERSIONS=(2.89)
# Requires:
# setCachedSeperatingAxis in src/BulletCollision/NarrowPhaseCollision/btGjkPairDetector.h
# getAngularMomentum in src/BulletDynamics/Featherstone/btMultiBody.h
# getNonStaticRigidBodies in src/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h
# getConstraintType in src/BulletDynamics/Featherstone/btMultiBodyConstraint.h

gen_iuse() {
	local pv
	for pv in ${BULLET_VERSIONS[@]} ; do
		echo " bullet_${pv/./_}"
	done
}

BULLET_IUSE=($(gen_iuse))
IUSE+="
	${BULLET_IUSE[@]}
"
REQUIRED_USE="
	^^ ( ${BULLET_IUSE[@]} )
"

gen_src_uris() {
	local pv
	for pv in ${BULLET_VERSIONS[@]} ; do
		echo "
			bullet_${pv/./_}? (
https://github.com/bulletphysics/bullet3/archive/refs/tags/${pv}.tar.gz
	-> bullet-${pv}.tar.gz
			)
		"
	done
}

SRC_URI+=" "$(gen_src_uris)
SLOT="0/${PV}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"
DOTNET_SUPPORTED_SDKS=("dotnet-sdk-bin-6.0")

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

get_crid_platform() {
	local erid="${1}"
	local cplatform="${erid%-*}"
	cplatform="${cplatform/uwp/win}"
	echo "${cplatform}"
}

get_hrid_platform() {
	local erid="${1}"
	echo "${erid%-*}"
}

get_hrid_arch() {
	local erid="${1}"
	echo "${erid##*-}"
}

# erid_arch -> Gentoo arch
get_garch() {
	local erid="${1}"
	local garch="${erid/dotnet_}"
	garch="${garch##*_}"
	garch="${garch/x64/amd64}"
	garch="${garch/armel/arm}"
	echo "${garch}"
}

# Canonical rid (uwp is win)
get_crid() {
	local erid="${1}"
	local crid="${erid/dotnet_}"
	crid="${crid//_/-}"
	crid="${crid/uwp/win}"
	echo "${crid}"
}

# Hypothetical rid (uwp is uwp)
get_hrid() {
	local erid="${1}"
	local hrid="${erid/dotnet_}"
	hrid="${hrid//_/-}"
	echo "${hrid}"
}

pkg_setup() {
	local found=0
	for sdk in ${DOTNET_SUPPORTED_SDKS[@]} ; do
		if [[ -e "${EPREFIX}/opt/${sdk}/dotnet" ]] ; then
			export SDK="${sdk}"
			export PATH="${EPREFIX}/opt/${sdk}:${PATH}"
			found=1
		fi
	done
	if (( ${found} == 0)) ; then
eerror
eerror "You need a dotnet SDK."
eerror
eerror "Supported SDK versions: ${DOTNET_SUPPORTED_SDKS[@]}"
eerror
		die
	fi
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

	local flag
	for flag in ${BULLET_IUSE[@]} ; do
		if use "${flag}" ; then
			local pv="${flag/bullet_}"
			pv="${pv/_/.}"
			unpack "bullet-${pv}.tar.gz"
			mv bullet3-${pv} bullet || die
			break
		fi
	done
}

src_prepare() {
	# https://github.com/AndresTraks/BulletSharpPInvoke/issues/65
	sed -i -e "s|setCachedSeperatingAxis|setCachedSeparatingAxis|g" \
		"${S}/libbulletc/src/btGjkPairDetector_wrap.cpp" || die

	sed -i -e "s|\"libbulletc\"|\"libbulletc.dll\"|g" \
		BulletSharp/Native.cs || die
	if ! use test ; then
		sed -i -e 's|ADD_SUBDIRECTORY\(test\)||g' \
			libbulletc/CMakeLists.txt || die
	fi
#	estrong_assembly_info "using System.Runtime.InteropServices;" \
#		"${DISTDIR}/mono.snk" "BulletSharp/Properties/AssemblyInfo.cs"

	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}_build"
			cp -a "${S}" "${S}-${hrid}" || die
			cd "${CMAKE_USE_DIR}" || die
			cmake_src_prepare
		fi
	done
}

src_configure() {
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local hplatform=$(get_hrid_platform "${erid}")

			# Only allow for native for now
			[[ "${hplatform}" != "linux" ]] || continue
			local garch=$(get_garch "${rid}")
			export CHOST=$(get_abi_CHOST "${garch}")
			if [[ "${hplatform}" == "linux" ]] ; then
				export CC="${CHOST}-gcc"
				export CXX="${CHOST}-g++"
			fi

			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}_build"
			cd "${CMAKE_USE_DIR}" || die
		        local mycmakeargs=( -DBUILD_BULLET3=1 )
			cmake_src_configure
		fi
	done
}

src_compile() {
	local configuration=$(usex debug "Debug" "Release")
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local crid=$(get_crid "${erid}")
			local hrid=$(get_hrid "${erid}")
			local hplatform=$(get_hrid_platform "${erid}")

			# Only allow for native for now
			[[ "${hplatform}" != "linux" ]] || continue
			local garch=$(get_garch "${rid}")
			export CHOST=$(get_abi_CHOST "${garch}")
			if [[ "${hplatform}" == "linux" ]] ; then
				export CC="${CHOST}-gcc"
				export CXX="${CHOST}-g++"
			fi

			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}_build"
			cd "${BUILD_DIR}" || die
			# Build native shared library wrapper
			cmake_src_compile

			# Cross build requires Gentoo Prefix.
			# Build C# wrapper
			cd "${CMAKE_USE_DIR}/BulletSharp" || die
			dotnet publich -c ${configuration} -r ${crid} --sc -o "${BUILD_DIR}" || die
		fi
	done
}

_mydoins() {
	local dll_path="$1"
#	egacinstall "${dll_path}"
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
	local configuration=$(usex debug "Debug" "Release")
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}_build"
			cd "${BUILD_DIR}" || die

			local d="/opt/${SDK}/shared/${PN}.Host.${platform}-${arch}/${MY_PV}"
			insinto "${d}"
			exeinto "${d}"
			_mydoins "BulletSharp/bin/${configuration}/BulletSharp.dll"
			doexe "libbulletc.so"
		fi
	done

}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
