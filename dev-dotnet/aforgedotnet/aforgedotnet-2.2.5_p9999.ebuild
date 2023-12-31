# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="AForge.NET"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/andrewkirillov/AForge.NET.git"
USE_DOTNET="net40"

inherit dotnet gac mono git-r3

DESCRIPTION="AForge.NET Framework is a C# framework designed for developers and \
researchers in the fields of Computer Vision and Artificial Intelligence - \
image processing, neural networks, genetic algorithms, machine learning, \
robotics, etc."
HOMEPAGE="http://www.aforgenet.com/"
LICENSE="LGPL-3 GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
RDEPEND+="
	media-video/ffmpeg
	kinect? ( dev-libs/libfreenect )
"
DEPEND+=" ${RDEPEND}"
IUSE="${USE_DOTNET} developer gac kinect ximea"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
SLOT="0/$(ver_cut 1-2 ${PV})"
RESTRICT="mirror"
SRC_URI=""
S="${WORKDIR}/${P}"

src_prepare() {
	default
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" \
		Sources/Video.Kinect/KinectNative.cs || die
	sed -i -e "s|\"m3api.dll\"|\"libm3api.dll\"|g" \
		Sources/Video.Ximea/Internal/XimeaAPI.cs || die

	local actual_version=$(grep "AppVerName" "${S}/Setup/Installer/aforge.iss" \
		| grep -o -E "[0-9]+\.[0-9]+\.[0-9]+")
	local expected_version=$(ver_cut 1-3 "${PV}")
	if ver_test ${expected_version} -ne ${actual_version} ; then
eerror
eerror "Version inconsistency"
eerror
eerror "Expected version:  ${expected_version}"
eerror "Actual version:  ${actual_version}"
eerror
eerror "DEV QA:  Bump ebuild version and dependencies."
eerror
		die
	fi
}

src_compile() {
	if use kinect ; then
		dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Kinect.dll.config"
	fi
	if use ximea ; then
		dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Ximea.dll.config"
	fi
	cd "Sources" || die
	einfo "Building solution"
	exbuild "Build All.sln" || die
}

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

_mydoins() {
	local name="${1}"
	if [[ -z "${name}" ]] ; then
		strong_sign "$(pwd)/${configuration}/AForge.dll" \
		"$(pwd)/Sources/Core/AForge.snk"
	else
		strong_sign "$(pwd)/${configuration}/AForge.${name}.dll" \
		"$(pwd)/Sources/${name}/AForge.${name}.snk"
	fi
	if [[ -z "${name}" ]] ; then
		doexe ${configuration}/AForge.dll
		egacinstall "${S}/${configuration}/AForge.dll"
	else
		doexe ${configuration}/AForge.${name}.dll
		egacinstall "${S}/${configuration}/AForge.${name}.dll"
	fi
	if use kinect ; then
		doins "AForge.Video.Kinect.dll.config"
		copy_next_to_file \
			"$(pwd)/${configuration}/AForge.Video.Kinect.dll" \
			"$(pwd)/AForge.Video.Kinect.dll.config" \
			0644 \
			root:root
	fi
	if use ximea ; then
		doins "AForge.Video.Ximea.dll.config"
		copy_next_to_file \
			"$(pwd)/${configuration}/AForge.Video.Ximea.dll" \
			"$(pwd)/AForge.Video.Ximea.dll.config" \
			0644 \
			root:root
	fi
	if use developer ; then
		if [[ "${FRAMEWORK}" == "4.0" ]] ; then
			if [[ -z "${name}" ]] ; then
				doins Sources/Core/AForge.xml
				copy_next_to_file \
					"$(pwd)/${configuration}/AForge.dll" \
					"$(pwd)/Sources/Core/AForge.xml" \
					0644 \
					root:root
			else
				doins Sources/${name}/AForge.${name}.xml
				copy_next_to_file \
					"$(pwd)/${configuration}/AForge.${name}.dll" \
					"$(pwd)/Sources/${name}/AForge.${name}.xml" \
					0644 \
					root:root
			fi
		fi
	fi
}

src_install() {
	local configuration="Release"
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	_mydoins Vision
	_mydoins MachineLearning
	_mydoins Imaging.Formats
	_mydoins Fuzzy
	#_mydoins Controls
	#_mydoins Robotics.Surveyor
	#_mydoins Video.VFW
	_mydoins Video
	_mydoins Neuro
	_mydoins Genetic
	_mydoins Imaging
	#_mydoins Robotics.Lego
	_mydoins Video.Ximea
	_mydoins ""
	_mydoins Video.Kinect
	#_mydoins Video.DirectShow
	_mydoins Math
	#_mydoins Robotics.TeRK
	#_mydoins Video.FFMPEG
	#_mydoins DebuggerVisualizers
	#_mydoins Imaging.IPPrototyper
	#_mydoins IPPrototype
}

pkg_postinst() {
	if use ximea ; then
einfo
einfo "This package does not pull the XIMEA xiAPI package.  You must manually"
einfo "create it yourself or install the library yourself."
einfo
	fi
einfo
einfo "This ebuild package doesn't support:"
einfo
einfo "  AForge.Controls.dll"
einfo "  AForge.Robotics.Lego.dll"
einfo "  AForge.Robotics.Surveyor.dll"
einfo "  AForge.Video.DirectShow.dll"
einfo "  AForge.Video.VFW.dll"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
