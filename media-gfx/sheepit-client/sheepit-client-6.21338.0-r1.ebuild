# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2 linux-info

DESCRIPTION='Client for the free and distributed render farm "SheepIt Render Farm"'
HOMEPAGE="https://github.com/laurent-clouet/sheepit-client"
LICENSE="GPL-2 Apache-2.0 LGPL-2.1+
MIT
|| ( CDDL GPL-2-with-classpath-exception )
!system-blender? (
	blender? (
		Apache-2.0
		BitstreamVera
		Boost-1.0
		BSD
		BSD-2
		CC0-1.0
		GPL-2
		GPL-2-with-font-exception
		LGPL-2.1+
		GPL-3
		GPL-3-with-font-exception
		MIT
		MIT all-rights-reserved
		PSF-2
		PSF-2.4
		SGI-B-1.1
		SGI-B-2.0
	)
)"

#
# About the sheepit-client licenses
#
#   The licenses in the first line of the LICENSE field are those that were
#   found in sheepit-client sources.
#
#
# Third Party Licenses
#
#   The licenses in the blender section of the LICENSE variable
#   are licenses files and references in readmes in Blender 2.79b, 2.82, 2.83.
#
#   The GLU library references strings covered under under either
#     SGI Free Software License B, Version 1.1
#   or
#     SGI FREE SOFTWARE LICENSE B (Version 2.0, Sept. 18, 2008).
#
#   The Mesa library has MIT license with all rights reserved as default.
#   There is no all rights reserved in the vanilla MIT license.  Parts of it
#   contains strings sourced from SGI-B-2.0 licensed files.
#
#   The libglapi is under SGI-B-2.0.  It was bundled in precompiled Blender
#   2.80+.
#
# Additional Third Party Licenses (in SheepIt's Blender 2.82)
#
#   The libcaca library is under WTFPL-2.
#
#   The libfusion-1.2.so.9 library contains LGPL-2.1+ strings.
#
#   The libSDL [1.2.14_pre20091018] library was made
#   available under LGPL-2.1+ in Jan 30, 2006.
#
#   The libXxf86vm is under MIT.
#
#   The tslib is under LGPL-2.1.
#
# Build time licenses:
#
#   gradle is Apache-2.0
#   The various third-party jars are either MIT, Apache-2.0, \
#     or || ( CDDL GPL-2-with-classpath-exception )
#
# Uncaught license corrections:
#
#   In LICENSE-droidsans.ttf.txt at line 49 in Blender 2.82, it mentions
#   GPL-2.1+.  It should be LGPL-2.1+.
#
KEYWORDS="~amd64"
SLOT="0"

BLENDER_VERSIONS=(
	2_83_18
	2_90_1
	2_91_2
	2_92_0
	2_93_6
	3_0_0
)

IUSE=" blender disable-hard-version-blocks cuda doc firejail gentoo-blender
intel-ocl lts no-repacks +opencl opencl_rocr opencl_orca opencl_pal opengl_mesa
pro-drivers split-drivers system-blender system-gradle vanilla
video_cards_amdgpu video_cards_i965 video_cards_iris video_cards_nvidia
video_cards_radeonsi"
IUSE_BLENDER_VERSIONS=( ${BLENDER_VERSIONS[@]/#/sheepit_client_blender_} )
BENCHMARK_V="2.93.6"
BENCHMARK_VERSION="sheepit_client_blender_${BENCHMARK_V//./_}"
IUSE+=" ${IUSE_BLENDER_VERSIONS[@]} +${BENCHMARK_VERSION}"
#GEN_DL_DETAILS="1" # Uncomment to generate download details for GRADLE_PKGS_URIS and GRADLE_PKGS_UNPACK
#EBUILD_MAINTENANCE_MODE=""

gen_required_use_blender()
{
	local version="${1}"
	local o=""
	for x in ${IUSE_BLENDER_VERSIONS[@]} ; do
		o+=" ${x}? ( blender )"
	done
	echo "${o}"
}

REQUIRED_USE+=" "$(gen_required_use_blender)
REQUIRED_USE+="
	blender? ( || ( ${IUSE_BLENDER_VERSIONS[@]} ) )
	|| ( cuda opencl )
	no-repacks? ( !system-blender )
	pro-drivers? ( || ( opencl_orca opencl_pal opencl_rocr ) )
	opencl_orca? (
		|| ( split-drivers pro-drivers )
		video_cards_amdgpu
	)
	opencl_pal? (
		pro-drivers
		video_cards_amdgpu
	)
	opencl_rocr? (
		split-drivers
		video_cards_amdgpu
	)
	split-drivers? ( || ( opencl_orca opencl_rocr ) )
	system-blender? ( !no-repacks )
	vanilla? (
		!firejail
		!gentoo-blender
		!no-repacks
		!system-blender
		!system-gradle
	)
	video_cards_amdgpu? (
		|| ( pro-drivers split-drivers )
	)
"

# About the lib folder
# 2.79, 2.80 contains glu libglapi, mesa
# 2.82, 2.81a contains DirectFB, libcaca, libglapi, glu, mesa, slang, SDL:1.2, \
#   tslib, libXxf86vm

# For vanilla Blender 2.79-2.83.1
RDEPEND_BLENDER="
	dev-libs/expat
	sys-libs/glibc
	dev-libs/libbsd
	media-libs/mesa
	sys-devel/gcc[cxx]
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libxshmfence"

# Due to the many different Blender project requirements, the release config
# flags will be used to match especially those that affect the rendering.
#
# If you use the gentoo-overlay blender ebuilds, you must match exactly the
# benchmark version of Blender in order to progress to render other projects.
# This will require to maintain your own version on your local repository since
# the distro deviates from the release builds when it considers what options
# are toggleable.

JAVA_V="11"
JDK_DEPEND="
|| (
	dev-java/openjdk-bin:${JAVA_V}
	dev-java/openjdk:${JAVA_V}
)"
JRE_DEPEND="
|| (
	${JDK_DEPEND}
	dev-java/openjdk-jre-bin:${JAVA_V}
)"
#JDK_DEPEND=" virtual/jdk:${JAVA_V}"
#JRE_DEPEND=" virtual/jre:${JAVA_V}"

RDEPEND="
	blender? (
		firejail? ( sys-apps/firejail )
		!system-blender? (
			${RDEPEND_BLENDER}
		)
		system-blender? (
			gentoo-blender? (
				sheepit_client_blender_2_93_6? (
~media-gfx/blender-2.93.6\
[alembic,bullet,collada,color-management,cycles,dds,-debug,embree,fluid,fftw,\
gmp,-headless,jpeg2k,nls,openexr,oidn,openimageio,opensubdiv,openvdb,\
openxr,osl,potrace,pugixml,tiff,usd]
					media-libs/embree[raymask]
					sci-physics/bullet
				)
				sheepit_client_blender_3_0_0? (
~media-gfx/blender-3.0.0\
[alembic,bullet,collada,color-management,cycles,dds,-debug,embree,fluid,fftw,\
gmp,-headless,jpeg2k,nls,openexr,oidn,openimageio,opensubdiv,openvdb,\
openxr,osl,potrace,pugixml,tiff,usd]
					media-libs/embree[raymask]
					sci-physics/bullet
				)
			)
			!gentoo-blender? (
sheepit_client_blender_2_83_18? (
	~media-gfx/blender-2.83.18[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_90_1? (
	~media-gfx/blender-2.90.1[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_91_2? (
	~media-gfx/blender-2.91.2[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_92_0? (
	~media-gfx/blender-2.92.0[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_2_93_6? (
	~media-gfx/blender-2.93.6[cycles,build_creator(+),release(+)]
)
sheepit_client_blender_3_0_0? (
	~media-gfx/blender-3.0.0[cycles,build_creator(+),release(+)]
)
			)
		)
	)
	opencl? (
	intel-ocl? ( dev-util/intel-ocl-sdk )
	|| (
		video_cards_amdgpu? (
			|| (
				pro-drivers? (
					opengl_mesa? (
						!lts? (
							|| (
<x11-drivers/amdgpu-pro-20.45\
[X,developer,open-stack,opengl_mesa,opencl,opencl_orca?,opencl_pal?]
>=x11-drivers/amdgpu-pro-20.45\
[X,developer,open-stack,opengl_mesa,opencl,opencl_orca?,opencl_rocr?]
							)
						)
						lts? (
							|| (
<x11-drivers/amdgpu-pro-lts-20.45\
[X,developer,open-stack,opengl_mesa,opencl,opencl_orca?,opencl_pal?]
>=x11-drivers/amdgpu-pro-lts-20.45\
[X,developer,open-stack,opengl_mesa,opencl,opencl_orca?,opencl_rocr?]
							)
						)
					)
					!opengl_mesa? (
						!lts? (
							|| (
<x11-drivers/amdgpu-pro-20.45\
[opencl,opencl_orca?,opencl_pal?]
>=x11-drivers/amdgpu-pro-20.45\
[opencl,opencl_orca?,opencl_rocr?]
							)
						)
						lts? (
							|| (
<x11-drivers/amdgpu-pro-lts-20.45\
[opencl,opencl_orca?,opencl_pal?]
>=x11-drivers/amdgpu-pro-lts-20.45\
[opencl,opencl_orca?,opencl_rocr?]
							)
						)
					)
				)
				split-drivers? (
					opencl_orca? ( dev-libs/amdgpu-pro-opencl )
					opencl_rocr? ( dev-libs/rocm-opencl-runtime )
				)
			)
		)
		video_cards_i965? (
			dev-libs/intel-neo
		)
		video_cards_iris? (
			dev-libs/intel-neo
		)
		video_cards_nvidia? (
			x11-drivers/nvidia-drivers
		)
		video_cards_radeonsi? (
			dev-libs/amdgpu-pro-opencl
		)
	)
	)
	cuda? ( x11-drivers/nvidia-drivers )
	no-repacks? (
		app-arch/bzip2
		app-arch/gzip
		app-arch/tar
		app-arch/xz-utils
	)
	${JRE_DEPEND}"
GRADLE_V="7.0" # See gradle/wrapper/gradle-wrapper.properties
BDEPEND="${RDEPEND}
	app-arch/bzip2
	app-arch/tar
	app-arch/unzip
	app-arch/xz-utils
	${JDK_DEPEND}
	system-gradle? ( >=dev-java/gradle-bin-${GRADLE_V} )"

GRADLE_PKGS_UNPACK=(
	"args4j/args4j-site/2.33/9ba12fde00306694af3ce9f5ff302c858345edf/args4j-site-2.33.pom"
	"args4j/args4j/2.33/168b592340292d4410a1d000bb7fa7144967fc12/args4j-2.33.pom"
	"args4j/args4j/2.33/bd87a75374a6d6523de82fef51fc3cfe9baf9fc9/args4j-2.33.jar"
	"com.formdev/flatlaf/1.1.2/1a74ac44b5caf8e6feaa381efc24799a4f51d98/flatlaf-1.1.2.pom"
	"com.formdev/flatlaf/1.1.2/46519a67f34483185b799dc330d4abe45cceab8a/flatlaf-1.1.2.module"
	"com.formdev/flatlaf/1.1.2/9ed8cdea9aa43429ea26702f806d69d51655b0ef/flatlaf-1.1.2.jar"
	"com.github.johnrengelman.shadow/com.github.johnrengelman.shadow.gradle.plugin/7.0.0/86f5449c9c91ddd5ef9406682031048a93337909/com.github.johnrengelman.shadow.gradle.plugin-7.0.0.pom"
	"com.github.oshi/oshi-core/5.8.2/3a4c610d5991654009653e55b3204065441e2f0d/oshi-core-5.8.2.jar"
	"com.github.oshi/oshi-core/5.8.2/43a62713d5e72d3eb177e66da10d9e4ef6820081/oshi-core-5.8.2.pom"
	"com.github.oshi/oshi-parent/5.8.2/65daf409ea8ae40ed502da4730683830608c1233/oshi-parent-5.8.2.pom"
	"com.gradle.publish/plugin-publish-plugin/0.14.0/418f03257810c52a803f4a7d58d7762a16183216/plugin-publish-plugin-0.14.0.pom"
	"com.gradle.publish/plugin-publish-plugin/0.14.0/8b7f6814383f13927d9d33f78e61b07dceadb0dc/plugin-publish-plugin-0.14.0.jar"
	"com.squareup.okhttp3/okhttp-urlconnection/4.7.2/4a5ae1f42907834190ca464b5e606d69e2b8feec/okhttp-urlconnection-4.7.2.module"
	"com.squareup.okhttp3/okhttp-urlconnection/4.7.2/7e1421fe4d6d63b4d2a4afcc89ae88090cafd74d/okhttp-urlconnection-4.7.2.pom"
	"com.squareup.okhttp3/okhttp-urlconnection/4.7.2/812effc52e6988e36b5868c153276ab581af8394/okhttp-urlconnection-4.7.2.jar"
	"com.squareup.okhttp3/okhttp/4.7.2/2ba1a84ac0f93be2de3b8a49f65a44b60f8f8d38/okhttp-4.7.2.module"
	"com.squareup.okhttp3/okhttp/4.7.2/c9acfd63537db1d7d21d98a7405e22449bb881d6/okhttp-4.7.2.jar"
	"com.squareup.okhttp3/okhttp/4.7.2/db4f01eaabed8c683fee36b4f5fa9af6cc0e6190/okhttp-4.7.2.pom"
	"com.squareup.okio/okio/2.6.0/14f5f240bc9aeb745421df725606c5723d72fc6a/okio-2.6.0.module"
	"com.squareup.okio/okio/2.6.0/c099e0689dcc10dd26a653ac0587c036d42b704c/okio-2.6.0.pom"
	"com.squareup.okio/okio/2.6.0/f06923d428f3c8e6f571043ec29a45d0cd9d2bf/okio-2.6.0.jar"
	"com.sun.activation/all/1.2.0/9b1023e38195ea19d1a0ac79192d486da1904f97/all-1.2.0.pom"
	"commons-io/commons-io/2.8.0/92999e26e6534606b5678014e66948286298a35c/commons-io-2.8.0.jar"
	"commons-io/commons-io/2.8.0/9bde4473ef8c6f2e5aef5bc5fbf357663a90834e/commons-io-2.8.0.pom"
	"gradle.plugin.com.github.jengelman.gradle.plugins/shadow/7.0.0/20ffdb9932ed8c8ad21e547c19508374a92ebc81/shadow-7.0.0.pom"
	"gradle.plugin.com.github.jengelman.gradle.plugins/shadow/7.0.0/71a6f66a467097a1aa213b73b1f0d2b8e002b3b7/shadow-7.0.0.jar"
	"javax.activation/javax.activation-api/1.2.0/1aa9ef58e50ba6868b2e955d61fcd73be5b4cea5/javax.activation-api-1.2.0.pom"
	"javax.activation/javax.activation-api/1.2.0/85262acf3ca9816f9537ca47d5adeabaead7cb16/javax.activation-api-1.2.0.jar"
	"javax.xml.bind/jaxb-api-parent/2.3.1/26101e8a1a09e16cdf277a4591f6d29917b2e06e/jaxb-api-parent-2.3.1.pom"
	"javax.xml.bind/jaxb-api/2.3.1/8531ad5ac454cc2deb9d4d32c40c4d7451939b5d/jaxb-api-2.3.1.jar"
	"javax.xml.bind/jaxb-api/2.3.1/c42c51ae84892b73ef7de5351188908e673f5c69/jaxb-api-2.3.1.pom"
	"net.java.dev.jna/jna-platform/5.9.0/64c85bba135aec10935c5237c98fef40827fa55b/jna-platform-5.9.0.pom"
	"net.java.dev.jna/jna-platform/5.9.0/c535a5bda553d7d7690356c825010da74b2671b5/jna-platform-5.9.0.jar"
	"net.java.dev.jna/jna/5.9.0/8f503e6d9b500ceff299052d6be75b38c7257758/jna-5.9.0.jar"
	"net.java.dev.jna/jna/5.9.0/b33141d591221ada1ad5fcdd22bc35de6646166d/jna-5.9.0.pom"
	"net.java/jvnet-parent/1/b55a1b046dbe82acdee8edde7476eebcba1e57d8/jvnet-parent-1.pom"
	"net.java/jvnet-parent/5/5343c954d21549d039feebe5fadef023cdfc1388/jvnet-parent-5.pom"
	"net.lingala.zip4j/zip4j/2.7.0/8b5899a09b398148b361aa4f980882bb566c6491/zip4j-2.7.0.pom"
	"net.lingala.zip4j/zip4j/2.7.0/cfaa04aab342a807656ecfc513116f8751b33f68/zip4j-2.7.0.jar"
	"org.apache.ant/ant-launcher/1.10.9/19fc4af88aaf7a7910a94871ca75e5afe6ed3d85/ant-launcher-1.10.9.pom"
	"org.apache.ant/ant-launcher/1.10.9/bcc582424a533933d9960b7a4ccde12c6f257245/ant-launcher-1.10.9.jar"
	"org.apache.ant/ant-parent/1.10.9/fc88b05848614d3f954d18b31ba306207586bd78/ant-parent-1.10.9.pom"
	"org.apache.ant/ant/1.10.9/1b7290dfbc114e4f5cc6a6199e77d575324c413c/ant-1.10.9.pom"
	"org.apache.ant/ant/1.10.9/a8a0c9bc4473acdac25832d0a9da2ca9fd9cd35f/ant-1.10.9.jar"
	"org.apache.commons/commons-parent/52/4ee86dedc66d0010ccdc29e5a4ce014c057854/commons-parent-52.pom"
	"org.apache.logging.log4j/log4j-api/2.14.1/9199a73770616b1ca0b00f576db3231aaab4876a/log4j-api-2.14.1.pom"
	"org.apache.logging.log4j/log4j-api/2.14.1/cd8858fbbde69f46bce8db1152c18a43328aae78/log4j-api-2.14.1.jar"
	"org.apache.logging.log4j/log4j-core/2.14.1/9141212b8507ab50a45525b545b39d224614528b/log4j-core-2.14.1.jar"
	"org.apache.logging.log4j/log4j-core/2.14.1/f66708526155233e7351a79358a2942090b8736f/log4j-core-2.14.1.pom"
	"org.apache.logging.log4j/log4j/2.14.1/501880bb5ba829046840c5789b19b7199e8a3a77/log4j-2.14.1.pom"
	"org.apache.logging/logging-parent/3/5aacbd3590605400bd3b29892751c6d70d810a75/logging-parent-3.pom"
	"org.apache.maven/maven-model/3.0.4/5e149cfe15daedebbb1e8970d6a5ff1bea61b94c/maven-model-3.0.4.jar"
	"org.apache.maven/maven-model/3.0.4/60d040156ffd0590a0cfd74e517b34ea9dfb1784/maven-model-3.0.4.pom"
	"org.apache.maven/maven-parent/21/ecebf1043d9c7bdd3d32a4184ad4ef9ad3ea744/maven-parent-21.pom"
	"org.apache.maven/maven/3.0.4/84e07094d0da2867c8463ee5206cafecb308036d/maven-3.0.4.pom"
	"org.apache/apache/10/48296e511366fa13aad48c58d8e09721774abec6/apache-10.pom"
	"org.apache/apache/23/404949e96725e63a10a6d8f9d9b521948d170d5/apache-23.pom"
	"org.codehaus.plexus/plexus-utils/3.3.0/cf43b5391de623b36fe066a21127baef82c64022/plexus-utils-3.3.0.jar"
	"org.codehaus.plexus/plexus-utils/3.3.0/de5faec837d872a1712aa89242845216118a9405/plexus-utils-3.3.0.pom"
	"org.codehaus.plexus/plexus/5.1/2fca82e2eb5172f6a2909bea7accc733581a8c71/plexus-5.1.pom"
	"org.jdom/jdom2/2.0.6/11e250d112bc9f2a0e1a595a5f6ecd2802af2691/jdom2-2.0.6.pom"
	"org.jdom/jdom2/2.0.6/6f14738ec2e9dd0011e343717fa624a10f8aab64/jdom2-2.0.6.jar"
	"org.jetbrains.kotlin/kotlin-stdlib-common/1.3.70/bd1d0642aedfd3780a730235af7499706225ccb3/kotlin-stdlib-common-1.3.70.pom"
	"org.jetbrains.kotlin/kotlin-stdlib-common/1.3.71/dc5b708b195cb44fcb098c96c5ed4774a53d5c93/kotlin-stdlib-common-1.3.71.pom"
	"org.jetbrains.kotlin/kotlin-stdlib-common/1.3.71/e71c3fef58e26affeb03d675e91fd8abdd44aa7b/kotlin-stdlib-common-1.3.71.jar"
	"org.jetbrains.kotlin/kotlin-stdlib/1.3.71/47da9a84ba07a4de17cddff5e139f8d120627c62/kotlin-stdlib-1.3.71.pom"
	"org.jetbrains.kotlin/kotlin-stdlib/1.3.71/898273189ad22779da6bed88ded39b14cb5fd432/kotlin-stdlib-1.3.71.jar"
	"org.jetbrains/annotations/13.0/919f0dfe192fb4e063e7dacadee7f8bb9a2672a9/annotations-13.0.jar"
	"org.jetbrains/annotations/13.0/fa7d3d07cc80547e2d15bf4839d3267c637c642f/annotations-13.0.pom"
	"org.kohsuke/pom/14/7e52f77bc3cd74f323816fadbcb9303df219b1ea/pom-14.pom"
	"org.ow2.asm/asm-analysis/9.1/4f61b83b81d8b659958f4bcc48907e93ecea55a0/asm-analysis-9.1.jar"
	"org.ow2.asm/asm-analysis/9.1/e30004dc53274dc96d0b9c6a3ac06bdcf6d23d86/asm-analysis-9.1.pom"
	"org.ow2.asm/asm-commons/9.1/5914a98fed0e76a0ce92a75704cacaf2454ae90a/asm-commons-9.1.pom"
	"org.ow2.asm/asm-commons/9.1/8b971b182eb5cf100b9e8d4119152d83e00e0fdd/asm-commons-9.1.jar"
	"org.ow2.asm/asm-tree/9.1/aeef4f505fe557517394dc29e404fba6ba98c428/asm-tree-9.1.pom"
	"org.ow2.asm/asm-tree/9.1/c333f2a855069cb8eb17a40a3eb8b1b67755d0eb/asm-tree-9.1.jar"
	"org.ow2.asm/asm/9.1/927153d04a920d5f06a9a4aefd5f6be60726117d/asm-9.1.pom"
	"org.ow2.asm/asm/9.1/a99500cf6eea30535eeac6be73899d048f8d12a8/asm-9.1.jar"
	"org.ow2/ow2/1.5/d8edc69335f4d9f95f511716fb689c86fb0ebaae/ow2-1.5.pom"
	"org.projectlombok/lombok/1.18.20/18bcea7d5df4d49227b4a0743a536208ce4825bb/lombok-1.18.20.jar"
	"org.projectlombok/lombok/1.18.20/616bd84e8cd034042459c7105f34003dc6786e9b/lombok-1.18.20.pom"
	"org.simpleframework/simple-xml/2.7.1/dd91fb744c2ff921407475cb29a1e3fee397d411/simple-xml-2.7.1.jar"
	"org.simpleframework/simple-xml/2.7.1/e5272a3c03686ecb3e1adf929681fca23215f52b/simple-xml-2.7.1.pom"
	"org.slf4j/slf4j-api/1.7.32/cdcff33940d9f2de763bc41ea05a0be5941176c3/slf4j-api-1.7.32.jar"
	"org.slf4j/slf4j-api/1.7.32/dd71cee8b1ef6f54fa6e60f3814fa748f03642e2/slf4j-api-1.7.32.pom"
	"org.slf4j/slf4j-nop/1.7.32/6bc3ba3dd52f71133df66ad07fb2dabcdc6dd2fe/slf4j-nop-1.7.32.pom"
	"org.slf4j/slf4j-nop/1.7.32/e5349fc363dbc19c60cb12b10120b4c4f9e4aca8/slf4j-nop-1.7.32.jar"
	"org.slf4j/slf4j-parent/1.7.32/a3cb6b2b36f7d228af85043d7b31393c6c16a4d6/slf4j-parent-1.7.32.pom"
	"org.vafer/jdependency/2.6.0/4e54c26b0b504c88e8c1a2fa909f9719a6f57d4f/jdependency-2.6.0.jar"
	"org.vafer/jdependency/2.6.0/c1cfed83aaa1c68527a209bda8255c174998bc16/jdependency-2.6.0.pom"
	"stax/stax-api/1.0.1/49c100caf72d658aca8e58bd74a4ba90fa2b0d70/stax-api-1.0.1.jar"
	"stax/stax-api/1.0.1/e3a933099229a34b22e9e78b2b999e1eb03b3e4e/stax-api-1.0.1.pom"
	"stax/stax/1.2.0/25c804f06fe1d144906fb812b88e60711cc2b3fd/stax-1.2.0.pom"
	"stax/stax/1.2.0/c434800de5e4bbe1822805be5fb1c32d6834f830/stax-1.2.0.jar"
	"xpp3/xpp3/1.1.3.3/2bd55af9b5089d6a7aae908fc2a155a19ee88cba/xpp3-1.1.3.3.pom"
	"xpp3/xpp3/1.1.3.3/64f9d2bb88f58ad2a15a4301487d977ee9b4294/xpp3-1.1.3.3.jar"
)

# Perform downloads outside of the sandbox to decrease the amount of redownloads
# caused by bad recompiles or repatches.

GRADLE_PKGS_URIS="
https://plugins.gradle.org/m2/com/github/johnrengelman/shadow/com.github.johnrengelman.shadow.gradle.plugin/7.0.0/com.github.johnrengelman.shadow.gradle.plugin-7.0.0.pom
https://plugins.gradle.org/m2/com/gradle/publish/plugin-publish-plugin/0.14.0/plugin-publish-plugin-0.14.0.jar
https://plugins.gradle.org/m2/com/gradle/publish/plugin-publish-plugin/0.14.0/plugin-publish-plugin-0.14.0.pom
https://plugins.gradle.org/m2/commons-io/commons-io/2.8.0/commons-io-2.8.0.jar
https://plugins.gradle.org/m2/commons-io/commons-io/2.8.0/commons-io-2.8.0.pom
https://plugins.gradle.org/m2/gradle/plugin/com/github/jengelman/gradle/plugins/shadow/7.0.0/shadow-7.0.0.jar
https://plugins.gradle.org/m2/gradle/plugin/com/github/jengelman/gradle/plugins/shadow/7.0.0/shadow-7.0.0.pom
https://plugins.gradle.org/m2/org/apache/ant/ant-launcher/1.10.9/ant-launcher-1.10.9.jar
https://plugins.gradle.org/m2/org/apache/ant/ant-launcher/1.10.9/ant-launcher-1.10.9.pom
https://plugins.gradle.org/m2/org/apache/ant/ant-parent/1.10.9/ant-parent-1.10.9.pom
https://plugins.gradle.org/m2/org/apache/ant/ant/1.10.9/ant-1.10.9.jar
https://plugins.gradle.org/m2/org/apache/ant/ant/1.10.9/ant-1.10.9.pom
https://plugins.gradle.org/m2/org/apache/apache/10/apache-10.pom
https://plugins.gradle.org/m2/org/apache/apache/23/apache-23.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/52/commons-parent-52.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.jar
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j/2.14.1/log4j-2.14.1.pom
https://plugins.gradle.org/m2/org/apache/logging/logging-parent/3/logging-parent-3.pom
https://plugins.gradle.org/m2/org/apache/maven/maven-model/3.0.4/maven-model-3.0.4.jar
https://plugins.gradle.org/m2/org/apache/maven/maven-model/3.0.4/maven-model-3.0.4.pom
https://plugins.gradle.org/m2/org/apache/maven/maven-parent/21/maven-parent-21.pom
https://plugins.gradle.org/m2/org/apache/maven/maven/3.0.4/maven-3.0.4.pom
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus-utils/3.3.0/plexus-utils-3.3.0.jar
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus-utils/3.3.0/plexus-utils-3.3.0.pom
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus/5.1/plexus-5.1.pom
https://plugins.gradle.org/m2/org/jdom/jdom2/2.0.6/jdom2-2.0.6.jar
https://plugins.gradle.org/m2/org/jdom/jdom2/2.0.6/jdom2-2.0.6.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/9.1/asm-analysis-9.1.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/9.1/asm-analysis-9.1.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/9.1/asm-commons-9.1.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/9.1/asm-commons-9.1.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/9.1/asm-tree-9.1.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/9.1/asm-tree-9.1.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.1/asm-9.1.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.1/asm-9.1.pom
https://plugins.gradle.org/m2/org/ow2/ow2/1.5/ow2-1.5.pom
https://plugins.gradle.org/m2/org/vafer/jdependency/2.6.0/jdependency-2.6.0.jar
https://plugins.gradle.org/m2/org/vafer/jdependency/2.6.0/jdependency-2.6.0.pom
https://repo.maven.apache.org/maven2/args4j/args4j-site/2.33/args4j-site-2.33.pom
https://repo.maven.apache.org/maven2/args4j/args4j/2.33/args4j-2.33.jar
https://repo.maven.apache.org/maven2/args4j/args4j/2.33/args4j-2.33.pom
https://repo.maven.apache.org/maven2/com/formdev/flatlaf/1.1.2/flatlaf-1.1.2.jar
https://repo.maven.apache.org/maven2/com/formdev/flatlaf/1.1.2/flatlaf-1.1.2.module
https://repo.maven.apache.org/maven2/com/formdev/flatlaf/1.1.2/flatlaf-1.1.2.pom
https://repo.maven.apache.org/maven2/com/github/oshi/oshi-core/5.8.2/oshi-core-5.8.2.jar
https://repo.maven.apache.org/maven2/com/github/oshi/oshi-core/5.8.2/oshi-core-5.8.2.pom
https://repo.maven.apache.org/maven2/com/github/oshi/oshi-parent/5.8.2/oshi-parent-5.8.2.pom
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp-urlconnection/4.7.2/okhttp-urlconnection-4.7.2.jar
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp-urlconnection/4.7.2/okhttp-urlconnection-4.7.2.module
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp-urlconnection/4.7.2/okhttp-urlconnection-4.7.2.pom
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp/4.7.2/okhttp-4.7.2.jar
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp/4.7.2/okhttp-4.7.2.module
https://repo.maven.apache.org/maven2/com/squareup/okhttp3/okhttp/4.7.2/okhttp-4.7.2.pom
https://repo.maven.apache.org/maven2/com/squareup/okio/okio/2.6.0/okio-2.6.0.jar
https://repo.maven.apache.org/maven2/com/squareup/okio/okio/2.6.0/okio-2.6.0.module
https://repo.maven.apache.org/maven2/com/squareup/okio/okio/2.6.0/okio-2.6.0.pom
https://repo.maven.apache.org/maven2/com/sun/activation/all/1.2.0/all-1.2.0.pom
https://repo.maven.apache.org/maven2/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar
https://repo.maven.apache.org/maven2/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.pom
https://repo.maven.apache.org/maven2/javax/xml/bind/jaxb-api-parent/2.3.1/jaxb-api-parent-2.3.1.pom
https://repo.maven.apache.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar
https://repo.maven.apache.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.pom
https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.9.0/jna-platform-5.9.0.jar
https://repo.maven.apache.org/maven2/net/java/dev/jna/jna-platform/5.9.0/jna-platform-5.9.0.pom
https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.9.0/jna-5.9.0.jar
https://repo.maven.apache.org/maven2/net/java/dev/jna/jna/5.9.0/jna-5.9.0.pom
https://repo.maven.apache.org/maven2/net/java/jvnet-parent/1/jvnet-parent-1.pom
https://repo.maven.apache.org/maven2/net/java/jvnet-parent/5/jvnet-parent-5.pom
https://repo.maven.apache.org/maven2/net/lingala/zip4j/zip4j/2.7.0/zip4j-2.7.0.jar
https://repo.maven.apache.org/maven2/net/lingala/zip4j/zip4j/2.7.0/zip4j-2.7.0.pom
https://repo.maven.apache.org/maven2/org/jetbrains/annotations/13.0/annotations-13.0.jar
https://repo.maven.apache.org/maven2/org/jetbrains/annotations/13.0/annotations-13.0.pom
https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.70/kotlin-stdlib-common-1.3.70.pom
https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.71/kotlin-stdlib-common-1.3.71.jar
https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.71/kotlin-stdlib-common-1.3.71.pom
https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/1.3.71/kotlin-stdlib-1.3.71.jar
https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/1.3.71/kotlin-stdlib-1.3.71.pom
https://repo.maven.apache.org/maven2/org/kohsuke/pom/14/pom-14.pom
https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar
https://repo.maven.apache.org/maven2/org/projectlombok/lombok/1.18.20/lombok-1.18.20.pom
https://repo.maven.apache.org/maven2/org/simpleframework/simple-xml/2.7.1/simple-xml-2.7.1.jar
https://repo.maven.apache.org/maven2/org/simpleframework/simple-xml/2.7.1/simple-xml-2.7.1.pom
https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.jar
https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.pom
https://repo.maven.apache.org/maven2/org/slf4j/slf4j-nop/1.7.32/slf4j-nop-1.7.32.jar
https://repo.maven.apache.org/maven2/org/slf4j/slf4j-nop/1.7.32/slf4j-nop-1.7.32.pom
https://repo.maven.apache.org/maven2/org/slf4j/slf4j-parent/1.7.32/slf4j-parent-1.7.32.pom
https://repo.maven.apache.org/maven2/stax/stax-api/1.0.1/stax-api-1.0.1.jar
https://repo.maven.apache.org/maven2/stax/stax-api/1.0.1/stax-api-1.0.1.pom
https://repo.maven.apache.org/maven2/stax/stax/1.2.0/stax-1.2.0.jar
https://repo.maven.apache.org/maven2/stax/stax/1.2.0/stax-1.2.0.pom
https://repo.maven.apache.org/maven2/xpp3/xpp3/1.1.3.3/xpp3-1.1.3.3.jar
https://repo.maven.apache.org/maven2/xpp3/xpp3/1.1.3.3/xpp3-1.1.3.3.pom
"

# Sorted output from gradlew
GRADLE_HASH="9m115ut5nwvtxli7nys8pggfr"
GRADLE_DOWNLOAD="
https://services.gradle.org/distributions/gradle-${GRADLE_V}-all.zip
"

# See https://www.sheepit-renderfarm.com/servers.php under the "binary mirrors" section.
# See profiles/thirdpartymirrors in this repo.
SI_RENDERER_MIRROR="mirror://sheepit-blender-binaries/"

# See https://www.blender.org/about/website/
# See profiles/thirdpartymirrors in this repo.
VANILLA_RENDERER_MIRROR="mirror://vanilla-blender-binaries/"

# The renders are fetched at the ebuild level instead of runtime.

# For allowed renderers, see https://www.sheepit-renderfarm.com/index.php?show=binaries
# For renderer archives, see https://static-binary-gra-fr.sheepit-renderfarm.com/
SI_RENDERERS_X86_64=(
	"sheepit_client_blender_3_0_0;blender300_linux_64bit.zip"
	"sheepit_client_blender_2_93_6;blender293.6_linux_64bit.zip"
	"sheepit_client_blender_2_92_0;blender292.0_linux_64bit.zip"
	"sheepit_client_blender_2_91_2;blender291.2_linux_64bit.zip"
	"sheepit_client_blender_2_90_1;blender290.1_linux_64bit.zip"
	"sheepit_client_blender_2_83_18;blender283.18_linux_64bit.zip"
)

VANILLA_RENDERERS_X86_64=(
	"sheepit_client_blender_3_0_0;Blender3.0/blender-3.0.0-linux-x64.tar.xz"
	"sheepit_client_blender_2_93_6;Blender2.93/blender-2.93.6-linux-x64.tar.xz"
	"sheepit_client_blender_2_92_0;Blender2.92/blender-2.92.0-linux64.tar.xz"
	"sheepit_client_blender_2_91_2;Blender2.91/blender-2.91.2-linux64.tar.xz"
	"sheepit_client_blender_2_90_1;Blender2.90/blender-2.90.1-linux64.tar.xz"
	"sheepit_client_blender_2_83_18;Blender2.83/blender-2.83.18-linux-x64.tar.xz"
)

gen_renderer_repack_urls()
{
	local arch="${1}"
	local mirror_host="${2}"
	unset filelist
	local -n filelist=$3
	local o=""
	for x in ${filelist[@]} ; do
		local r="${x%;*}"
		local fn="${x#*;}"
		if [[ -n "${EBUILD_MAINTENANCE_MODE}" && "${EBUILD_MAINTENANCE_MODE}" == "1" ]] ; then
			o+=" ${mirror_host}${fn} "
		else
			o+=" !no-repacks? ( ${arch}? ( ${r}? ( ${mirror_host}${fn} ) ) )"
		fi
	done
	echo "${o}"
}

gen_renderer_vanilla_urls()
{
	local arch="${1}"
	local mirror_host="${2}"
	unset filelist
	local -n filelist=$3
	local o=""
	for x in ${filelist[@]} ; do
		local r="${x%;*}"
		local p="${x#*;}"
		if [[ -n "${EBUILD_MAINTENANCE_MODE}" && "${EBUILD_MAINTENANCE_MODE}" == "1" ]] ; then
			o+=" ${mirror_host}${p} "
		else
			o+=" no-repacks? ( ${arch}? ( ${r}? ( ${mirror_host}/${p} ) ) )"
		fi
	done
	echo "${o}"
}

RENDERER_DOWNLOADS+=" "$(gen_renderer_repack_urls "amd64" "${SI_RENDERER_MIRROR}" SI_RENDERERS_X86_64)
RENDERER_DOWNLOADS+=" "$(gen_renderer_vanilla_urls "amd64" "${VANILLA_RENDERER_MIRROR}" VANILLA_RENDERERS_X86_64)

SRC_URI="https://gitlab.com/sheepitrenderfarm/client/-/archive/v${PV}/client-v${PV}.tar.bz2
	-> ${PN}-${PV}.tar.bz2
	!vanilla? (
		${GRADLE_PKGS_URIS}
		${RENDERER_DOWNLOADS}
		!system-gradle? ( ${GRADLE_DOWNLOAD} )
	)"
S="${WORKDIR}/client-v${PV}"
RESTRICT="mirror strip"
WRAPPER_VERSION="3.2.0" # .sh launcher file not the gradlew wrapper
EXPECTED_GRADLE_WRAPPER_JAR_SHA256=\
"e996d452d2645e70c01c11143ca2d3742734a28da2bf61f25c82bdc288c9e637"
# For the Wrapper JAR Checksum, see also
# https://gradle.org/release-checksums/

show_codename_docs() {
	einfo
	einfo "Details about codenames can be found at"
	einfo
	einfo "Radeon Pro:  https://en.wikipedia.org/wiki/Radeon_Pro"
	einfo "Radeon RX Vega:  https://en.wikipedia.org/wiki/Radeon_RX_Vega_series"
	einfo "Radeon RX 5xx:  https://en.wikipedia.org/wiki/Radeon_RX_500_series"
	einfo "Radeon RX 4xx:  https://en.wikipedia.org/wiki/Radeon_RX_400_series"
	einfo "Radeon R5/R7/R9:  https://en.wikipedia.org/wiki/Radeon_Rx_300_series"
	einfo "APU: https://en.wikipedia.org/wiki/AMD_Accelerated_Processing_Unit"
	einfo "Device IDs <-> codename: \
https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L777"
	einfo
}

show_notice_pcie3_atomics_required() {
	# See \
# https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver/blob/roc-3.3.0/drivers/gpu/drm/amd/amdkfd/kfd_device.c
# https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/blob/master/runtime/device/rocm/rocdevice.cpp
# Device should be supported end-to-end from kfd to runtime.
	ewarn
	ewarn "Detected no PCIe atomics."
	ewarn
	ewarn "ROCm OpenCL requires PCIe atomics for the following:"
	ewarn "raven"
	ewarn "fiji"
	ewarn "polaris10"
	ewarn "polaris11"
	ewarn "polaris12"
	einfo
	einfo "If your device matches one of the codenames above, use the"
	einfo "opencl_orca (for polaris 10, polaris 11, polaris 12, fiji) or"
	einfo "opencl_pal (for raven) USE flag instead or upgrade CPU and"
	einfo "Mobo combo with both PCIe 3.0 support, or upgrade to one of"
	einfo "the GPUs in the list following immediately."
	einfo
	einfo "In addition, your kernel config must have CONFIG_HSA_AMD=y."
	einfo
	einfo
	einfo "You may ignore if your device is the following:"
	einfo "kaveri"
	einfo "carrizo"
	einfo "hawaii"
	einfo "vega10"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "navi12"
	einfo "navi14"
	einfo
	einfo "Not supported for ROCm:"
	ewarn "tonga (PCIe atomics required, don't work on ROCm)"
	ewarn "vegam (PCIe atomics required, may work on ROCm)"
	ewarn "iceland"
	ewarn "vega12 (no PCIE atomics required)"
	einfo
	einfo "Try opencl_orca for tonga, vegam, iceland."
	einfo "Try opencl_pal for vega12."
	einfo
	einfo "If ROCm OpenCL doesn't work, stick to either opencl_pal"
	einfo "opencl_orca."
	einfo
	show_codename_docs
}

show_notice_pal_support() {
	# Vega 10 is in the GFX_v9 set
	# Navi 10 is GFX_v10
	einfo
	einfo "opencl_pal is only supported for GFX_v9 and the following:"
	einfo "vega10"
	einfo "vega12"
	einfo "vega20"
	einfo "renoir"
	einfo "navi10"
	einfo "raven"
	einfo
	einfo "If your device does not match one of the codenames above, use"
	einfo "the opencl_rocr if CPU and Mobo both have PCIe 3.0 support;"
	einfo "otherwise, try opencl_orca."
	einfo
	show_codename_docs
}

check_embree() {
	# For the configuration, see
# https://github.com/blender/blender/blob/v2.90.1/build_files/build_environment/cmake/embree.cmake

	# There is no standard embree ebuild.  Assume other repo or local copy.

	# This check is ensure that the rendering quality is the same and the output
	# is the same especially if the animated movies are split.

	if has embree ${IUSE_EFFECTIVE} && use embree ; then
		# The default for EMBREE_FILTER_FUNCTION is ON in embree.
		if grep -q -F -e "EMBREE_FILTER_FUNCTION=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_FILTER_FUNCTION should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-filter_function]' || \
				has_version 'media-libs/embree[-filter-function]' || \
				has_version 'media-libs/embree[-filterfunction]' ; then
				die "EMBREE_FILTER_FUNCTION should be set to ON for embree."
			fi
		fi

		# The default for EMBREE_BACKFACE_CULLING is OFF in embree.
		if grep -q -F -e "EMBREE_BACKFACE_CULLING=ON" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
		else
			if has_version 'media-libs/embree[backface_culling]' || \
				has_version 'media-libs/embree[backface-culling]' || \
				has_version 'media-libs/embree[backfaceculling]' ; then
				die "EMBREE_BACKFACE_CULLING should be set to OFF for embree."
			fi
		fi

		# The default for EMBREE_RAY_MASK is OFF in embree.
		if grep -q -F -e "EMBREE_RAY_MASK=OFF" \
			"${EROOT}/var/db/pkg/media-libs/embree-"*/*.ebuild ; then
			die "EMBREE_RAY_MASK should be set to ON for embree."
		else
			if has_version 'media-libs/embree[-ray_mask]' || \
				has_version 'media-libs/embree[-ray-mask]' || \
				has_version 'media-libs/embree[-raymask]' ; then
				die "EMBREE_RAY_MASK should be set to ON for embree."
			elif has_version 'media-libs/embree[ray_mask]' || \
				has_version 'media-libs/embree[ray-mask]' || \
				has_version 'media-libs/embree[raymask]' ; then
				:;
			elif has_version 'media-libs/embree' ; then
				die "EMBREE_RAY_MASK should be set to ON for embree."
			fi
		fi
	fi
}

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /usr/$(get_libdir)/openjdk-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d 2>/dev/null 1>/dev/null ; then
		export JAVA_HOME=$(find /opt/openjdk-bin-${JAVA_V}*/ -maxdepth 1 -type d | sort -V | head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
		die "dev-java/openjdk:${JDK_V} or dev-java/openjdk-bin:${JDK_V} must be installed"
	fi
}

pkg_setup() {
	ewarn
	ewarn "New ebuild maintainer needed.  See metadata.xml for details."
	ewarn "Must have recent hardware described here: https://gitlab.com/sheepitrenderfarm/client/-/issues/21"
	ewarn
	ewarn "This ebuild package will be deleted due to newer hardware requirements."
	ewarn

	if use vanilla ; then
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES."
		fi
	fi

	if use opencl_rocr ; then
		# No die checks for this kernel config in
		# dev-libs/rocm-opencl-runtime.
		CONFIG_CHECK="HSA_AMD"
		ERROR_HSA_AMD=\
"Change CONFIG_HSA_AMD=y in kernel config.  It's required for opencl_rocr support."
		linux-info_pkg_setup
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
				2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
			show_notice_pcie3_atomics_required
		fi
	fi

	if use opencl_pal ; then
		CONFIG_CHECK="HSA_AMD"
		WARNING_HSA_AMD=\
"Change CONFIG_HSA_AMD=y kernel config.  It may be required for opencl_pal support for pre-Vega 10."
		linux-info_pkg_setup
		if dmesg \
			| grep kfd \
			| grep "PCI rejects atomics" \
				2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		elif dmesg \
			| grep -e '\[drm\] PCIE atomic ops is not supported' \
			2>/dev/null 1>/dev/null ; then
			show_notice_pal_support
		fi
	fi

	if use blender ; then
		grep -q -i -E -e 'sse2( |$)' /proc/cpuinfo # 2000
		local has_sse2="$?"

		if [[ "${has_sse2}" != "0" ]] ; then
			die "Blender requires sse2 on your CPU."
		fi

		if (( $(nproc) < 2 )) ; then
			ewarn "Blender requires a dual core CPU."
		fi

		if use system-blender ; then
			check_embree
		fi
	fi

	setup_openjdk

	einfo "JAVA_HOME=${JAVA_HOME}"
	einfo "PATH=${PATH}"

	# Not fixed for several months
	# java-pkg_init # unsets JAVA_HOME
	# java-pkg_ensure-vm-version-ge ${JAVA_V}

	if use system-gradle ; then
		export GRADLE_BIN="gradle"
	else
		export GRADLE_BIN="gradlew"
	fi
}

enable_hardblock() {
	sed -i -e "s|\
public static final boolean ${1} = false;|\
public static final boolean ${1} = true;|g" \
		src/com/sheepit/client/Configuration.java || die
}

disable_hardblock() {
	sed -i -e "s|\
public static final boolean ${1} = true;|\
public static final boolean ${1} = false;|g" \
		src/com/sheepit/client/Configuration.java || die
}

unpack_gradle()
{
	for x in ${GRADLE_PKGS_UNPACK[@]} ; do
		local d_rel=$(dirname "${x}" \
			| sed -r -e "s|/[0-9a-z]{38,40}||g" \
			| tr "/" "\n" \
			| sed -e "1s|[.]|/|g" \
			| tr "\n" "/" \
			| sed -e "s|/$||g")
		#local d_base="${HOME}/.gradle/caches/modules-2/files-2.1"
		local d_base="${HOME}/.m2/repository"
		local d="${d_base}/${d_rel}"
		mkdir -p "${d}" || die
		local s=$(realpath "${DISTDIR}/"$(basename ${x}))
		einfo "Copying ${s} to ${d}"
		cp -a "${s}" "${d}" || die
	done
}

unpack_blender() {
	if use amd64 ; then
		if use no-repacks ; then
			for x in ${VANILLA_RENDERERS_X86_64[@]} ; do
				local useflag="${x%;*}"
				local fn="${x#*;}"
				if use ${useflag} ; then
					md5_hash=$(md5sum $(realpath ${DISTDIR}/${fn}) \
                                                | cut -f 1 -d " ")
					d="${WORKDIR}/blender/opt/sheepit-client/renderers/${md5_hash}"
					mkdir -p "${d}" || die
					local arg=""
					if [[ "${fn}" =~ ".tar.bz2" ]] ; then
						arg="j"
					elif [[ "${fn}" =~ ".tar.xz" ]] ; then
						arg="J"
					fi
					tar --strip-components=1 \
						-${arg}xvf \
						"${DISTDIR}/${fn}" \
						-C "${d}" \
						|| die
				fi
			done
		elif ! use system-blender ; then
			for x in ${SI_RENDERERS_X86_64[@]} ; do
				local useflag="${x%;*}"
				local uri="${x#*;}"
				local fn=$(basename ${uri})
				if use ${useflag} ; then
					md5_hash=$(md5sum $(realpath ${DISTDIR}/${fn}) \
                                                | cut -f 1 -d " ")
					d="${WORKDIR}/blender/opt/sheepit-client/renderers/${md5_hash}"
					mkdir -p "${d}" || die
					unzip "${DISTDIR}/${fn}" \
						-d "${d}" \
						|| die
				fi
			done
		fi
	fi
}

src_unpack() {
	unpack ${PN}-${PV}.tar.bz2

	if ! use vanilla \
	&& ! use system-blender \
	&& [[ -z "${GEN_DL_DETAILS}" \
		|| ( -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "0" ) ]] ; then
		unpack_blender
	fi
}

apply_client_patches()
{
	if use opencl ; then
		sed -i -e "s|os instanceof Windows|true|" \
			src/com/sheepit/client/hardware/gpu/GPU.java || die
	fi

	eapply "${FILESDIR}/sheepit-client-6.21338.0-renderer-version-picker.patch"
	if [[ -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "1" ]] ; then
		:;
	else
		eapply "${FILESDIR}/sheepit-client-6.21292.0-use-maven-local.patch"
	fi

	sed -i -e "s|__MAVEN_PATH__|${HOME}/.m2/repository|g" build.gradle || die

	if use system-blender ; then
		if use gentoo-blender ; then
			sed -i -e "s|oiledmachine-overlay|gentoo-overlay|g" \
				src/com/sheepit/client/Configuration.java || die
		elif bzcat /var/db/pkg/media-gfx/blender-*/environment.bz2 \
			| grep -q -F -e "parent-datafiles-dir-change" ; then
			:;
		else
			eerror
			eerror "Use either gentoo-blender or the blender ebuilds from the"
			eerror "oiledmachine-overlay"
			eerror
			die
		fi
	fi

	if ! use system-blender ; then
		sed -i -e "s|\
USE_SYSTEM_RENDERERS = true|\
USE_SYSTEM_RENDERERS = false|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

	if use no-repacks ; then
		sed -i -e "s|\
USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = false|\
USE_ONLY_DOWNLOAD_DOT_BLENDER_DOT_ORG = true|g" \
			src/com/sheepit/client/Configuration.java || die
	fi

	for x in ${IUSE_BLENDER_VERSIONS[@]} ; do
		[[ "${x}" == "" ]] && continue
		if ! use ${x} ; then
			local v=${x//sheepit_client_blender_}
			v=${v^^}
			enable_hardblock "HARDBLOCK_BLENDER_${v}"
		fi
	done
}

src_prepare() {
	X_GRADLE_WRAPPER_JAR_SHA256=$(sha256sum \
		"${S}/gradle/wrapper/gradle-wrapper.jar" \
		| cut -f 1 -d " ")
	if [[ "${X_GRADLE_WRAPPER_JAR_SHA256}" \
		!= "${EXPECTED_GRADLE_WRAPPER_JAR_SHA256}" ]] ; then
		eerror "X_GRADLE_WRAPPER_JAR_SHA256=${X_GRADLE_WRAPPER_JAR_SHA256}"
		eerror "EXPECTED_GRADLE_WRAPPER_JAR_SHA256=${EXPECTED_GRADLE_WRAPPER_JAR_SHA256}"
		eerror "Wrong checksum.  Ebuild maintainer note:  Update the jars also."
		die
	fi

	if ! use system-blender ; then
		ewarn
		ewarn "Security notices:"
		ewarn
		ewarn "${PN} downloads Blender 2.83.18 with Python 3.7.4 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.90.1 with Python 3.7.7 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.91.2 with Python 3.7.7 having high security CVE advisory"
		ewarn "${PN} downloads Blender 2.92.0 with Python 3.7.7 having high security CVE advisory"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=python%203.7&search_type=all"
		ewarn "https://security.gentoo.org/glsa/202104-04"
		ewarn "https://security.gentoo.org/glsa/202101-18"
		ewarn
		ewarn "${PN} downloads Blender 2.93.6 with statically linked libsdl 2.0.12 having high and medium CVE advisories"
		ewarn "${PN} downloads Blender 2.92.0 with statically linked libsdl 2.0.12 having high and medium CVE advisories"
		ewarn "${PN} downloads Blender 2.91.2 with statically linked libsdl 2.0.12 having high and medium CVE advisories"
		ewarn "${PN} downloads Blender 2.83.18 with statically linked libsdl 2.0.8 having multiple high and medium CVE advisories"
		ewarn "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=libsdl&search_type=all&isCpeNameSearch=false"
		ewarn "https://security.gentoo.org/glsa/202107-55"
		ewarn
	fi

	default

	if ! use vanilla ; then
		apply_client_patches
	fi
}

compile_with_gradlew_prefetched()
{
	einfo "Called compile_with_gradlew_prefetched"
	# Prevents: Could not open terminal for stdout: could not get termcap
	# entry
	export TERM=linux # pretend to be outside of X

	export GRADLE_USER_HOME="${HOME}/.gradle"
	local d="${GRADLE_USER_HOME}/wrapper/dists/gradle-${GRADLE_V}-all/${GRADLE_HASH}"
	export PATH="${d}/gradle-${GRADLE_V}/bin:${PATH}"
	mkdir -p "${d}" || die
	cd "${d}" || die
	touch "${d}/gradle-7.0-all.zip.ok" || die
	cp -a $(realpath "${DISTDIR}/gradle-7.0-all.zip") "${d}" || die
	unpack gradle-${GRADLE_V}-all.zip

	if [[ -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "1" ]] ; then
		:;
	else
		unpack_gradle
	fi

	cd "${S}" || die
	chmod +x gradlew || die
	einfo "GRADLE_USER_HOME=${GRADLE_USER_HOME}"
	einfo "PATH=${PATH}"
	gradle --version || die
	X_GRADLE_V=$(gradle --version | grep -e "Gradle " | cut -f 2 -d " ")
	if [[ "${X_GRADLE_V}" != "${GRADLE_V}" ]] ; then
		die "Running X_GRADLE_V=${X_GRADLE_V} which should be GRADLE_V=${GRADLE_V}"
	fi
	if [[ -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "1" ]] ; then
		einfo
		einfo "Generating prefix gradle download details..."
		gradle -d shadowJar || die
		einfo
		einfo "Download URIs:"
		einfo
		grep -r -e "Performing HTTP GET" "${T}/build.log" \
			| cut -f 7- -d " " | sort | grep -e "^http"

		einfo
		einfo "Updated GRADLE_PKGS_UNPACK:"
		einfo
		for f in $(find "${HOME}/.gradle/caches/modules-2/files-2.1" \
			-name "*.jar" -o -name "*.pom" -o -name "*.module" \
			| cut -f 12- -d "/") ; do \
			echo -e "\t\"${f}\"" \
			| sed -e "s|okio-jvm|okio|g" ; \
		done | sort > "${T}/t2"
		cat "${T}/t2"

		die "Please update the ebuild details."
	else
		gradle shadowJar || die
	fi
}

compile_with_gradlew()
{
	einfo "Called compile_with_gradlew"
	# Prevents: Could not open terminal for stdout: could not get termcap
	# entry
	export TERM=linux # pretend to be outside of X

	export GRADLE_USER_HOME="${HOME}/.gradle"
	cd "${S}" || die
	chmod +x gradlew || die
	if [[ -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "1" ]] ; then
		einfo
		einfo "Generating prefix gradle download details..."
		./gradlew -d shadowJar || die
		einfo
		einfo "Download URIs:"
		einfo
		grep -r -e "Performing HTTP GET" "${T}/build.log" \
			| cut -f 7- -d " " | sort | grep -e "^http"

		einfo
		einfo "Updated GRADLE_PKGS_UNPACK:"
		einfo
		for f in $(find "${HOME}/.gradle/caches/modules-2/files-2.1" \
			-name "*.jar" -o -name "*.pom" -o -name "*.module" \
			| cut -f 12- -d "/") ; do \
			echo -e "\t\"${f}\"" \
			| sed -e "s|okio-jvm|okio|g" ; \
		done | sort > "${T}/t2"
		cat "${T}/t2"

		die "Please update the ebuild details."
	else
		./gradlew shadowJar || die
	fi
}

# For use in sandboxed build, normal use case.
compile_with_gradle()
{
	# Prevents: Could not open terminal for stdout: could not get termcap
	# entry
	export TERM=linux # pretend to be outside of X

	# This has to be placed here because something is up with the sandbox.
	if [[ -n "${GEN_DL_DETAILS}" && "${GEN_DL_DETAILS}" == "1" ]] ; then
		:;
	else
		unpack_gradle
	fi

	export GRADLE_USER_HOME="${HOME}/.gradle"
	export PATH="/usr/share/gradle-bin-${GRADLE_V}/bin:${PATH}"
	einfo "GRADLE_USER_HOME=${GRADLE_USER_HOME}"
	einfo "PATH=${PATH}"
	gradle shadowJar || die
}

src_compile() {
	if use vanilla ; then
		compile_with_gradlew
	else
		if [[ "${GRADLE_BIN}" == "gradle" ]] ; then
			compile_with_gradle
		else
			compile_with_gradlew_prefetched
		fi
	fi
}

src_install() {
	insinto /usr/share/${PN}
	local ext=""
	if [[ "${GRADLE_BIN}" == "gradlew" ]] ; then
		ext="-all"
	fi
	doins build/libs/sheepit-client${ext}.jar
	exeinto /usr/bin
	cat "${FILESDIR}/sheepit-client-v${WRAPPER_VERSION}" \
		> "${T}/sheepit-client" || die
	sed -i -e "s|__JAVA_V__|${JAVA_V}|g" "${T}/sheepit-client" || die
	docinto licenses
	dodoc LICENSE

	if use doc ; then
		docinto docs
		dodoc protocol.txt README.md
	fi

	if use system-blender ; then
		sed -i -e "s|^#USE_SYSTEM_BLENDER|USE_SYSTEM_BLENDER|g" \
		"${T}/sheepit-client" || die
	fi

	# Work In Progress (WIP)
	if use firejail ; then
		sed -i -e "s|^#USE_FIREJAIL|USE_FIREJAIL|g" \
		"${T}/sheepit-client" || die

		insinto /etc/firejail
		if use system-blender ; then
			newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-system-blender.profile" \
	"sheepit-client.profile"
		else
			if use no-repacks ; then
				newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-no-repacks.profile" \
	"sheepit-client.profile"
			else
				newins \
	"${FILESDIR}/firejail-profiles/sheepit-client-default.profile" \
	"sheepit-client.profile"

			fi
		fi
	fi

	insinto /

	# sanitize
	if ! use vanilla && ! use system-blender ; then
		doins -r "${WORKDIR}/blender/"*
		fperms 0755 $(find "${WORKDIR}/blender" \
			-path "*/rend.exe" \
			-o -path "*/blender" \
			-o -path "*/bin/python*" \
			-o -path "*/lib/*.so" \
			-o -path "*/lib/*.so.*" \
			-o -path "*-linux-gnu.so" \
			| sed -e "s|${WORKDIR}/blender||g")
	fi

	exeinto /usr/bin
	doexe "${T}/sheepit-client"
}

pkg_postinst() {
	einfo
	einfo "You need an account from https://www.sheepit-renderfarm.com/ to"
	einfo "use this product."
	einfo
	# This applies to the GUI part.
	ewarn
        ewarn "If you are using dwm or non-parenting window manager and see"
	ewarn "no buttons or input boxes, you need to:"
	ewarn "  emerge wmname"
	ewarn "  wmname LG3D"
	ewarn "Run 'wmname LG3D' before you run '${PN}'"
	ewarn
	if use opencl ; then
		ewarn
		ewarn "OpenCL support is not officially supported for Linux."
		ewarn "For details see, https://github.com/laurent-clouet/sheepit-client/issues/165"
		ewarn
	fi
	einfo
	einfo "Don't forget to add your user account to the video group."
	einfo "This can be done with: \`gpasswd -a USERNAME video\`"
	einfo

	if use firejail ; then
		ewarn
		ewarn "The Firejail profile is experimental.  Several updates"
		ewarn "may occur to improve the privacy within the sandboxed"
		ewarn "image and reduce the attack surface.  Also, updates may"
		ewarn "occur to fix errors between different configurations."
		ewarn
		ewarn "The Firejail profile requires additional rules for your"
		ewarn "JRE and video card drivers.  Add them to"
		ewarn "/etc/firejail/sheepit-client.local.  Use ldd on the"
		ewarn "shared libraries and drivers to add more private-lib or"
		ewarn "whitelist rules."
		ewarn
	fi

	if ! use vanilla ; then
		einfo
		einfo "Since this ebuild automatically uses an unpacked shared folder"
		einfo "of renderers, the per user /usr/<user>/.sheepit-client/sheepit_binary_cache"
		einfo "is no longer required and can be deleted."
		einfo
	fi
	if ! use ${BENCHMARK_VERSION} ; then
		ewarn
		ewarn "${PN} may use the ${BENCHMARK_VERSION} for benchmarks"
		ewarn "when using the service.  If it fails, try the latest"
		ewarn "stable or LTS version.  It may also help to pass"
		ewarn "--verbose to see what the first project requires."
		ewarn
	fi
	if use firejail ; then
		ewarn
		ewarn "The firejail profile has not been tested with the new"
		ewarn "changes and may require editing."
		ewarn
	fi
}
