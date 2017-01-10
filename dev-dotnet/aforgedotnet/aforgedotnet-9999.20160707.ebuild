# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="AForge.NET Framework is a C# framework designed for developers and researchers in the fields of Computer Vision and Artificial Intelligence - image processing, neural networks, genetic algorithms, machine learning, robotics, etc."
HOMEPAGE=""
PROJECT_NAME="AForge.NET"
COMMIT="d70730b24aace6f3e108916dbfef60331b320b2c"
SRC_URI="https://github.com/andrewkirillov/AForge.NET/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac kinect ximea"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         media-libs/ffmpeg
         kinect? ( dev-libs/libfreenect )"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/Sources"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} "Build All.sln" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
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
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"

		doins Release/AForge.Vision.dll.mdb
		doins Release/AForge.MachineLearning.dll.mdb
		doins Release/AForge.Imaging.Formats.dll.mdb
		doins Release/AForge.Fuzzy.dll.mdb
		#doins Release/AForge.Controls.dll.mdb
		#doins Release/AForge.Robotics.Surveyor.dll.mdb
		#doins Release/AForge.Video.VFW.dll.mdb
		doins Release/AForge.Video.dll.mdb
		doins Release/AForge.Neuro.dll.mdb
		doins Release/AForge.Genetic.dll.mdb
		doins Release/AForge.Imaging.dll.mdb
		#doins Release/AForge.Robotics.Lego.dll.mdb
		use ximea && doins Release/AForge.Video.Ximea.dll.mdb
		doins Release/AForge.dll.mdb
		use kinect && doins Release/AForge.Video.Kinect.dll.mdb
		#doins Release/AForge.Video.DirectShow.dll.mdb
		doins Release/AForge.Math.dll.mdb


		#doins Sources/Controls/AForge.Controls.snk
		#doins Sources/Robotics.Lego/AForge.Robotics.Lego.snk
		doins Sources/MachineLearning/AForge.MachineLearning.snk
		doins Sources/Core/AForge.snk
		doins Sources/Video.Kinect/AForge.Video.Kinect.snk
		#doins Sources/Robotics.TeRK/AForge.Robotics.TeRK.snk
		doins Sources/Video.FFMPEG/AForge.Video.FFMPEG.snk
		doins Sources/Neuro/AForge.Neuro.snk
		doins Sources/Video.Ximea/AForge.Video.Ximea.snk
		doins Sources/Fuzzy/AForge.Fuzzy.snk
		doins Sources/Imaging/AForge.Imaging.snk
		doins Sources/Vision/AForge.Vision.snk
		#doins Sources/Video.VFW/AForge.Video.VFW.snk
		doins Sources/Video/AForge.Video.snk
		doins Sources/Imaging.Formats/AForge.Imaging.Formats.snk
		#doins Sources/Robotics.Surveyor/AForge.Robotics.Surveyor.snk
		doins Sources/Math/AForge.Math.snk
		#doins Sources/Video.DirectShow/AForge.Video.DirectShow.snk
		doins Sources/Genetic/AForge.Genetic.snk
		doins Tools/DebuggerVisualizers/AForge.DebuggerVisualizers.snk
		doins Tools/IPPrototyper/Interfaces/AForge.Imaging.IPPrototyper.snk
		doins Tools/IPPrototyper/AForge.IPPrototyper.snk
	fi

	dotnet_multilib_comply
}
