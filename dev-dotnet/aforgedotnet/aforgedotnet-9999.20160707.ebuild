# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net20 net40"
RDEPEND="media-video/ffmpeg
         kinect? ( dev-libs/libfreenect )"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug gac kinect ximea"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"

inherit dotnet eutils mono

DESCRIPTION="AForge.NET Framework is a C# framework designed for developers and researchers in the fields of Computer Vision and Artificial Intelligence - image processing, neural networks, genetic algorithms, machine learning, robotics, etc."
HOMEPAGE="http://www.aforgenet.com/"
PROJECT_NAME="AForge.NET"
COMMIT="d70730b24aace6f3e108916dbfef60331b320b2c"
SRC_URI="https://github.com/andrewkirillov/AForge.NET/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

inherit gac

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
	default
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" ./Sources/Video.Kinect/KinectNative.cs || die
	sed -i -e "s|\"m3api.dll\"|\"libm3api.dll\"|g" ./Sources/Video.Ximea/Internal/XimeaAPI.cs || die

	dotnet_copy_sources
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	compile_impl() {
		if use kinect ; then
			dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Kinect.dll.config"
		fi

		if use ximea ; then
			dotnet_copy_dllmap_config "${FILESDIR}/AForge.Video.Ximea.dll.config"
		fi

		cd "Sources"

	        einfo "Building solution"
	        exbuild /p:Configuration=${mydebug} "Build All.sln" || die
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	#_src_preinstall
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	install_impl() {
		dotnet_install_loc

		if ver_test $(dotnet_use_moniker_to_dotted_ver "${EDOTNET}") -ge 4.0 ; then
			estrong_resign ${mydebug}/AForge.Vision.dll               Sources/Vision/AForge.Vision.snk
			estrong_resign ${mydebug}/AForge.MachineLearning.dll      Sources/MachineLearning/AForge.MachineLearning.snk
			estrong_resign ${mydebug}/AForge.Imaging.Formats.dll      Sources/Imaging.Formats/AForge.Imaging.Formats.snk
			estrong_resign ${mydebug}/AForge.Fuzzy.dll                Sources/Fuzzy/AForge.Fuzzy.snk
			#estrong_resign ${mydebug}/AForge.Controls.dll            Sources/Controls/AForge.Controls.snk
			#estrong_resign ${mydebug}/AForge.Robotics.Surveyor.dll   Sources/Robotics.Surveyor/AForge.Robotics.Surveyor.snk
			#estrong_resign ${mydebug}/AForge.Video.VFW.dll           Sources/Video.VFW/AForge.Video.VFW.snk
			estrong_resign ${mydebug}/AForge.Video.dll                Sources/Video/AForge.Video.snk
			estrong_resign ${mydebug}/AForge.Neuro.dll                Sources/Neuro/AForge.Neuro.snk
			estrong_resign ${mydebug}/AForge.Genetic.dll              Sources/Genetic/AForge.Genetic.snk
			estrong_resign ${mydebug}/AForge.Imaging.dll              Sources/Imaging/AForge.Imaging.snk
			#estrong_resign ${mydebug}/AForge.Robotics.Lego.dll       Sources/Robotics.Lego/AForge.Robotics.Lego.snk
			estrong_resign ${mydebug}/AForge.Video.Ximea.dll          Sources/Video.Ximea/AForge.Video.Ximea.snk
			estrong_resign ${mydebug}/AForge.dll                      Sources/Core/AForge.snk
			estrong_resign ${mydebug}/AForge.Video.Kinect.dll         Sources/Video.Kinect/AForge.Video.Kinect.snk
			#estrong_resign ${mydebug}/AForge.Video.DirectShow.dll    Sources/Video.DirectShow/AForge.Video.DirectShow.snk
			estrong_resign ${mydebug}/AForge.Math.dll                 Sources/Math/AForge.Math.snk

			# has key but missing in dlls/gac
#			#estrong_resign ${mydebug}/AForge.Robotics.TeRK.dll       Sources/Robotics.TeRK/AForge.Robotics.TeRK.snk
#			estrong_resign ${mydebug}/AForge.Video.FFMPEG.dll         Sources/Video.FFMPEG/AForge.Video.FFMPEG.snk
#			estrong_resign ${mydebug}/AForge.DebuggerVisualizers.dll  Tools/DebuggerVisualizers/AForge.DebuggerVisualizers.snk
#			estrong_resign ${mydebug}/AForge.Imaging.IPPrototyper.dll Tools/IPPrototyper/Interfaces/AForge.Imaging.IPPrototyper.snk
#			estrong_resign ${mydebug}/AForge.IPPrototyper.dll         Tools/IPPrototyper/AForge.IPPrototyper.snk

			egacinstall ${mydebug}/AForge.Vision.dll
			egacinstall ${mydebug}/AForge.MachineLearning.dll
			egacinstall ${mydebug}/AForge.Imaging.Formats.dll
			egacinstall ${mydebug}/AForge.Fuzzy.dll
			#egacinstall ${mydebug}/AForge.Controls.dll
			#egacinstall ${mydebug}/AForge.Robotics.Surveyor.dll
			#egacinstall ${mydebug}/AForge.Video.VFW.dll
			egacinstall ${mydebug}/AForge.Video.dll
			egacinstall ${mydebug}/AForge.Neuro.dll
			egacinstall ${mydebug}/AForge.Genetic.dll
			egacinstall ${mydebug}/AForge.Imaging.dll
			#egacinstall ${mydebug}/AForge.Robotics.Lego.dll
			use ximea && egacinstall ${mydebug}/AForge.Video.Ximea.dll
			egacinstall ${mydebug}/AForge.dll
			use kinect && egacinstall ${mydebug}/AForge.Video.Kinect.dll
			#egacinstall ${mydebug}/AForge.Video.DirectShow.dll
			egacinstall ${mydebug}/AForge.Math.dll
		fi

		doins ${mydebug}/AForge.Vision.dll
		doins ${mydebug}/AForge.MachineLearning.dll
		doins ${mydebug}/AForge.Imaging.Formats.dll
		doins ${mydebug}/AForge.Fuzzy.dll
		#doins ${mydebug}/AForge.Controls.dll
		#doins ${mydebug}/AForge.Robotics.Surveyor.dll
		#doins ${mydebug}/AForge.Video.VFW.dll
		doins ${mydebug}/AForge.Video.dll
		doins ${mydebug}/AForge.Neuro.dll
		doins ${mydebug}/AForge.Genetic.dll
		doins ${mydebug}/AForge.Imaging.dll
		#doins ${mydebug}/AForge.Robotics.Lego.dll
		use ximea && doins ${mydebug}/AForge.Video.Ximea.dll
		doins ${mydebug}/AForge.dll
		use kinect && doins ${mydebug}/AForge.Video.Kinect.dll
		#doins ${mydebug}/AForge.Video.DirectShow.dll
		doins ${mydebug}/AForge.Math.dll

		if use kinect ; then
			doins "AForge.Video.Kinect.dll.config"
			dotnet_distribute_dllmap_config "AForge.Video.Kinect.dll"
		fi

		if use ximea ; then
			doins "AForge.Video.Ximea.dll.config"
			dotnet_distribute_dllmap_config "AForge.Video.Ximea.dll"
		fi

		if use developer ; then
			if [[ "${EDOTNET}" == "net40" ]] ; then
				doins Sources/Vision/AForge.Vision.xml
				doins Sources/MachineLearning/AForge.MachineLearning.xml
				doins Sources/Imaging.Formats/AForge.Imaging.Formats.xml
				doins Sources/Fuzzy/AForge.Fuzzy.xml
				#doins Sources/Controls/AForge.Controls.xml
				#doins Sources/Robotics.Surveyor/AForge.Robotics.Surveyor.xml
				#doins Sources/Video.VFW/AForge.Video.VFW.xml
				doins Sources/Video/AForge.Video.xml
				doins Sources/Neuro/AForge.Neuro.xml
				doins Sources/Genetic/AForge.Genetic.xml
				doins Sources/Imaging/AForge.Imaging.xml
				#doins Sources/Robotics.Lego/AForge.Robotics.Lego.xml
				use ximea && doins Sources/Video.Ximea/AForge.Video.Ximea.xml
				doins Sources/Core/AForge.xml
				use kinect && doins Sources/Video.Kinect/AForge.Video.Kinect.xml
				#doins Sources/Video.DirectShow/AForge.Video.DirectShow.xml
				doins Sources/Math/AForge.Math.xml
			fi
			if [[ "${EDOTNET}" == "net20" ]] ; then
				doins ${mydebug}/AForge.Vision.pdb
				doins ${mydebug}/AForge.MachineLearning.pdb
				doins ${mydebug}/AForge.Imaging.Formats.pdb
				doins ${mydebug}/AForge.Fuzzy.pdb
				#doins ${mydebug}/AForge.Controls.pdb
				#doins ${mydebug}/AForge.Robotics.Surveyor.pdb
				#doins ${mydebug}/AForge.Video.VFW.pdb
				doins ${mydebug}/AForge.Video.pdb
				doins ${mydebug}/AForge.Neuro.pdb
				doins ${mydebug}/AForge.Genetic.pdb
				doins ${mydebug}/AForge.Imaging.pdb
				#doins ${mydebug}/AForge.Robotics.Lego.pdb
				use ximea && doins ${mydebug}/AForge.Video.Ximea.pdb
				doins ${mydebug}/AForge.pdb
				use kinect && doins ${mydebug}/AForge.Video.Kinect.pdb
				#doins ${mydebug}/AForge.Video.DirectShow.pdb
				doins ${mydebug}/AForge.Math.pdb
			fi
		fi
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}

pkg_postinst() {
	use ximea && einfo "This package does not pull the XIMEA xiAPI package.  You must manually create it yourself or install the library yourself."
	einfo "This package doesn't support: AForge.Controls.dll, AForge.Robotics.Surveyor.dll, AForge.Video.VFW.dll, AForge.Robotics.Lego.dll, AForge.Video.DirectShow.dll."
}
