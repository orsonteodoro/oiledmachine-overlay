# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic git-r3 lcnr

MY_PV="$(ver_cut 1-4 ${PV})"

TARGET_FRAMEWORK="netstandard2.1"
DOTNET_V="6.0"
DESCRIPTION=".NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE="http://andrestraks.github.io/BulletSharp/"
LICENSE="MIT ZLIB"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE+=" developer nupkg test"

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

# Not supported by ebuild because of dotnet workload install uwp missing
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

IUSE+=" ${ERIDS[@]} mono"
REQUIRED_USE+="
	^^ (
		${ERIDS[@]}
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

RDEPEND="
	mono? ( >=dev-lang/mono-6.4 )
	~sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_V}:${DOTNET_V}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	~sci-physics/bullet-3.24
	>=dev-dotnet/dotnet-sdk-bin-${DOTNET_V}:${DOTNET_V}
	dev-util/patchelf
"

# Only tested versions allowed because the wrapper is version sensitive.
BULLET_VERSIONS=(2.89)
# Finding the correct commit or version is like finding a needle in a haystack
# Must be commits between 2.89 and 3.05

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

# The dotnet-sdk-bin ebuild only supports one host
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

PATCHES=(
)

SRC_URI+=" "$(gen_src_uris)
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

# The dotnet-sdk-bin supports only one ABI at a time?
DOTNET_SUPPORTED_SDKS=("dotnet-sdk-bin-${DOTNET_V}")

get_crid_platform() {
	local hrid="${1}"
	local cplatform="${hrid%-*}"
	cplatform="${cplatform/uwp/win}"
	echo "${cplatform}"
}

get_hrid_platform() {
	local hrid="${1}"
	echo "${hrid%-*}"
}

get_hrid_arch() {
	local hrid="${1}"
	echo "${hrid##*-}"
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
	einfo " -- USING ${TARGET_FRAMEWORK} FRAMEWORK -- "
	[[ "${USE}" =~ ("android"|"ios"|"macos"|"uap"|"win") ]] && die "Linux only supported for now.  Disable all other platforms."
}

src_unpack() {
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/AndresTraks/BulletSharpPInvoke.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	git-r3_fetch
	git-r3_checkout

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

	local actual_version=$(cat "${S}/BulletSharp/BulletSharp.csproj" \
		| grep "Version" \
		| cut -f 2 -d ">" \
		| cut -f 1 -d "<")
	local expected_version=$(ver_cut 1-4 "${PV}")
	if [[ "${actual_version}" != "${expected_version}" ]] ; then
eerror
eerror "Version bump required"
eerror
eerror "Actual version:  ${actual_version}"
eerror "Expected version:  ${expected_version}"
eerror
eerror "QA:  Bump and review IUSE, DEPENDs, patches"
eerror

		die
	fi
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

	cd "${S}" || die
	eapply "${FILESDIR}/BulletSharpPInvoke-0.12_p9999-bullet-versioning.patch"

	export CMAKE_USE_DIR="${S}/libbulletc"
	cd "${CMAKE_USE_DIR}" || die
	cmake_src_prepare

	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			cp -a "${S}" "${S}-${hrid}" || die
		fi
	done
}

src_configure() {
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local crid=$(get_crid "${erid}")
			local hplatform=$(get_hrid_platform "${hrid}")

			# Only allow for native for now
			[[ "${hplatform}" == "linux" ]] || continue
			local garch=$(get_garch "${erid}")
			if [[ "${hplatform}" == "linux" ]] ; then
				export CC="${CHOST}-gcc"
				export CXX="${CHOST}-g++"
				strip-unsupported-flags
			fi

		        local mycmakeargs=( -DBUILD_BULLET3=1 -DBUILD_EXTRAS=1 )
			filter-flags -DBULLET_VER=*
			if use bullet_2_89 ; then
				# 02.89.000 ${major}${minor}${patch}${letter}
				append-cppflags -DBULLET_VER=0289000
			elif has bullet_3_05 ${IUSE} && use bullet_3_05 ; then
				# 03.05.000 ${major}${minor}${patch}${letter}
				append-cppflags -DBULLET_VER=0305000
			else
				append-cppflags -DBULLET_VER=9999999
			fi

einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo "CHOST:\t${CHOST}"
einfo

			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}/libbulletc"
			cd "${CMAKE_USE_DIR}" || die
			cmake_src_configure
		fi
	done
}

_init_workloads() {
	unset workloads
	declare -A workloads=(
		[android]="0"
		[ios]="0"
		[macos]="0"
	)
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local cplatform=$(get_crid_platform "${hrid}")
			[[ "${cplatform}" == "android" ]] && workloads[android]=1
			[[ "${cplatform}" == "ios" && "${native_hrid}" =~ "win" ]] && workloads[ios]=1 # Not available from Linux
			[[ "${cplatform}" == "osx" ]] && workloads[macos]=1
		fi
	done

	# Only download once per platform
	for k in ${!workloads[@]} ; do
		if [[ "${workloads[${k}]}" == "1" ]] ; then
			dotnet workload install "${k}" || die
		fi
	done
}

src_compile() {
	local configuration="Release"

	# Disabled until restore is sorted out
	#_init_workloads

	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local crid=$(get_crid "${erid}")
			local hrid=$(get_hrid "${erid}")
			local hplatform=$(get_hrid_platform "${hrid}")

			# Only allow for native for now
			einfo "hplatform=${hplatform}"
			local garch=$(get_garch "${erid}")
			if [[ "${hplatform}" == "linux" ]] ; then
				export CC="${CHOST}-gcc"
				export CXX="${CHOST}-g++"
			else
eerror
eerror "Linux supported only for now"
eerror "You may fork ebuild and modify it for ${hrid}"
eerror
				die
			fi

			export CMAKE_USE_DIR="${S}-${hrid}/libbulletc"
			export BUILD_DIR="${S}-${hrid}/libbulletc"
			cd "${BUILD_DIR}" || die
			# Build native shared library wrapper
			cmake_src_compile

			# Cross build requires Gentoo Prefix.
			# Build C# wrapper
			export BUILD_DIR="${S}-${hrid}"
			cd "${BUILD_DIR}/BulletSharp" || die
			export DOTNET_CLI_TELEMETRY_OPTOUT=1
			dotnet publish "BulletSharp.sln" -c ${configuration} -r ${crid} --sc -o "${BUILD_DIR}/publish" || die
		fi
	done
}

_mydoins() {
	local dll_path="$1"
	doexe "${dll_path}"
	doins $(echo "${dll_path}" | sed -e "s|.dll|.deps.json|g")
	use developer && doins $(echo "${dll_path}" | sed -e "s|.dll|.pdb|g")
	if use mono ; then
#
# See https://www.mono-project.com/docs/about-mono/releases/4.4.0/
# for explanation why 4.5 is used as a folder for runtime assemblies including
# the latest 4.8.x.
#
# For reassurance for .NET Standard 2.1 support, see
# https://www.mono-project.com/docs/about-mono/releases/6.4.0/#net-standard-21-support
#
		local mtfm="4.5"
		dodir "/usr/lib/mono/${mtfm}"
		local bn=$(basename "${dll_path}")
		dosym "${d}/${bn}" "/usr/lib/mono/${mtfm}/${bn}"
	fi
}

_install_libbulletc() {
	local x
	cd "${BUILD_DIR}" || die
	einfo "lib suffix:  $(get_libname)"
	for x in $(find . -name "*$(get_libname)") ; do
		if [[ "${erid}" =~ "linux" ]] ; then
einfo "Changing rpath for ${x}"
			patchelf --set-rpath "${d}" "${x}" || die
		fi
		doexe "${x}"
	done
	if ! [[ "${erid}" =~ "linux" ]] ; then
ewarn
ewarn "Missing rpath change."
ewarn "${hrid} is untested or needs ebuild developer for this port"
ewarn
	fi
	local L=(
libBullet2FileLoader.so
libBullet3Collision.so
libBullet3Common.so
libBullet3Dynamics.so
libBullet3Geometry.so
libBullet3OpenCL_clew.so
libBulletCollision.so
libBulletDynamics.so
libBulletFileLoader.so
libBulletInverseDynamics.so
libBulletInverseDynamicsUtils.so
libBulletRobotics.so
libBulletSoftBody.so
libBulletWorldImporter.so
libBulletXmlWorldImporter.so
libConvexDecomposition.so
libGIMPACTUtils.so
libHACD.so
libLinearMath.so
	)
	for x in $(find . -name "*$(get_libname)") ; do
		doexe "${x}"
	done
	for l in ${L[@]} ; do
		for bullet_pv in ${BULLET_VERSIONS[@]} ; do
			if use bullet_${bullet_pv/./_} ; then
				mv "${ED}${d}/${l}"{,.${bullet_pv}} || die
				dosym "${l}.${bullet_pv}" "${d}/${l}"
			fi
		done
	done
}

_install_wrapper() {
	cd "${BUILD_DIR}/publish" || die
	_mydoins "$(pwd)/BulletSharp.dll"
}

_install_nupkg() {
	cd "${BUILD_DIR}" || die
	doins "BulletSharp/bin/Release/BulletSharp.$(ver_cut 1-3 ${MY_PV}).nupkg"
}

_LLP=()
src_install() {
	export STRIP="${EPREFIX}/usr/true" # Don't strip rpath
	local configuration="Release"
	local erid
	for erid in ${ERIDS[@]} ; do
		if use "${erid}" ; then
			local hrid=$(get_hrid "${erid}")
			local crid=$(get_crid "${erid}")
			local garch=$(get_garch "${erid}")
			export CHOST=$(get_abi_CHOST "${garch}")
			export BUILD_DIR="${S}-${hrid}"
			local d="/opt/${SDK}/shared/${PN}.${hrid}/${MY_PV}/${TARGET_FRAMEWORK}"
			_LLP+=( "${d}" )
			insinto "${d}"
			exeinto "${d}"
			_install_libbulletc
			_install_wrapper
			use nupkg && _install_nupkg
		fi
	done

	if ! use developer ; then
		find "${ED}" \( -name "*.pdb" -o -name "*.xml" \) -delete
	fi

	if [[ -e "${HOME}/.nuget" ]] ; then
		LCNR_SOURCE="${HOME}/.nuget"
		LCNR_TAG="third_party"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files

	LCNR_SOURCE="${WORKDIR}/bullet"
	LCNR_TAG="bullet"
	lcnr_install_files
}

pkg_postinst() {
	local d
	for d in ${_LLP[@]} ; do
#
# We don't do it systemwide via env.d because it may conflict with the system
# package.
#
einfo
einfo "You must manually set LD_LIBRARY_PATH=\"${d}:\${LD_LIBRARY_PATH}\""
einfo "in order for P/Invoke to work properly."
einfo
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
