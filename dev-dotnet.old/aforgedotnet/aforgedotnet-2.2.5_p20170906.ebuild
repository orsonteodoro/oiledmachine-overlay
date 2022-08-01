# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="AForge.NET Framework is a C# framework designed for developers and"
DESCRIPTION+=" researchers in the fields of Computer Vision and Artificial"
DESCRIPTION+=" Intelligence - image processing, neural networks, genetic"
DESCRIPTION+=" algorithms, machine learning, robotics, etc."
HOMEPAGE="http://www.aforgenet.com/"
LICENSE="LGPL-3 GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
USE_DOTNET="net20 net40"
RDEPEND="media-video/ffmpeg
         kinect? ( dev-libs/libfreenect )"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug gac kinect ximea"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
SLOT="0/${PV}"
inherit dotnet eutils mono
PROJECT_NAME="AForge.NET"
EGIT_COMMIT="a9453dad025d1fbffab165293cedc976187da535"
SRC_URI="https://github.com/andrewkirillov/AForge.NET/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" \
		Sources/Video.Kinect/KinectNative.cs || die
	sed -i -e "s|\"m3api.dll\"|\"libm3api.dll\"|g" \
		Sources/Video.Ximea/Internal/XimeaAPI.cs || die
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		if use kinect ; then
			dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Kinect.dll.config"
		fi

		if use ximea ; then
			dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Ximea.dll.config"
		fi
		cd "Sources"
		einfo "Building solution"
	        exbuild "Build All.sln" || die
	}
	dotnet_foreach_impl compile_impl
}

_mydoins() {
	local name="$1"
	if ver_test $(dotnet_use_moniker_to_dotted_ver "${EDOTNET}") -ge 4.0 ; then
		if [[ -z "${name}" ]] ; then
			estrong_resign ${mydebug}/AForge.dll \
			Sources/Core/AForge.${name}.snk
		else
			estrong_resign ${mydebug}/AForge.${name}.dll \
			Sources/${name}/AForge.${name}.snk
		fi
	fi
	if [[ -z "${name}" ]] ; then
		doins ${mydebug}/AForge.dll
	else
		doins ${mydebug}/AForge.${name}.dll
	fi
	if dotnet_is_netfx ; then
		egacinstall ${mydebug}/AForge.${name}.dll
		if use kinect ; then
			dotnet_distribute_file_matching_dll_in_gac \
			  "${mydebug}/AForge.Video.Kinect.dll" \
			  "AForge.Video.Kinect.dll.config"
			doins AForge.Video.Kinect.dll.config
		fi
		if use ximea ; then
			dotnet_distribute_file_matching_dll_in_gac \
			  "${mydebug}/AForge.Video.Ximea.dll" \
			  "AForge.Video.Ximea.dll.config"
			doins AForge.Video.Ximea.dll.config
		fi
	fi
	if use developer ; then
		if [[ "${EDOTNET}" == "net40" ]] ; then
			if [[ -z "${name}" ]] ; then
				doins Sources/Core/AForge.xml
				dotnet_distribute_file_matching_dll_in_gac \
					"${mydebug}/AForge.dll" \
					"Sources/Core/AForge.xml"
			else
				doins Sources/${name}/AForge.${name}.xml
				dotnet_distribute_file_matching_dll_in_gac \
					"${mydebug}/AForge.${name}.dll" \
					"Sources/${name}/AForge.${name}.xml"
			fi
		fi
		if [[ "${EDOTNET}" == "net20" ]] ; then
			if [[ -z "${name}" ]] ; then
				doins ${mydebug}/AForge.pdb
				#dotnet_distribute_file_matching_dll_in_gac \
				#	"${mydebug}/AForge.dll" \
				#	"${mydebug}/AForge.pdb"
			else
				doins ${mydebug}/AForge.${name}.pdb
				#dotnet_distribute_file_matching_dll_in_gac \
				#	"${mydebug}/AForge.${name}.dll" \
				#	"${mydebug}/AForge.${name}.pdb"
			fi
		fi
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
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
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	if use ximea ; then
		einfo "This package does not pull the XIMEA xiAPI package."
		einfo "You must manually create it yourself or install the"
		einfo "library yourself."
	fi
	einfo "This package doesn't support:"
	einfo "  AForge.Controls.dll,"
	einfo "  AForge.Robotics.Lego.dll,"
	einfo "  AForge.Robotics.Surveyor.dll,"
	einfo "  AForge.Video.DirectShow.dll,"
	einfo "  AForge.Video.VFW.dll."
}
