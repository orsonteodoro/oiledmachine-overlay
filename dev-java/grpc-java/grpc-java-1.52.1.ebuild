# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic java-pkg-2

# GEN_EBUILD=1 # For generating download links and unpacking lists.

DESCRIPTION="High-performance RPC framework (Java libraries)"
HOMEPAGE="https://grpc.io"
THIRD_PARTY_LICENSES="
	custom
	( Apache-2.0 all-rights-reserved )
	( Apache-2.0 || ( MIT GPL-2+ ) )
	( custom Apache-1.1 )
	Apache-1.0
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	CDDL
	CDDL-1.1
	EPL-1.0
	GPL-2-with-classpath-exception
	ISC
	LGPL-2.1+
	minpack
	MIT
	openssl
	W3C
	W3C-Document-License
	W3C-Software-Notice-and-License
	|| ( LGPL-2.1+ Apache-2.0 )
	|| ( Apache-2.0 Apache-1.1 BSD public-domain ( custom Apache-1.1 ) )
"
LICENSE="
	Apache-2.0
	${THIRD_PARTY_LICENSES}
"

# Apache-2.0, MIT, BSD - ./repository/com/android/tools/build/builder/4.2.0/builder-4.2.0/LICENSE
# Apache-2.0, W3C-Software-Notice-and-License - ./repository/com/google/appengine/appengine-api-1.0-sdk/1.9.59/appengine-api-1.0-sdk-1.9.59/org/apache/geronimo/mail/LICENSE
# Apache-2.0, LGPL-2.1+ - ./repository/net/java/dev/jna/jna-platform/5.6.0/jna-platform-5.6.0/META-INF/LICENSE
# Apache-2.0, openssl, ISC - ./repository/io/grpc/grpc-netty-shaded/1.43.2/grpc-netty-shaded-1.43.2/META-INF/NOTICE.txt
# Apache-2.0 all-rights-reserved - ./repository/org/apache/commons/commons-math3/3.2/commons-math3-3.2/META-INF/NOTICE.txt
# Apache-2.0, W3C, custom, Apache-1.1, EPL-1.0, SAX-PD, MIT - ./repository/org/jvnet/staxex/stax-ex/1.8.1/stax-ex-1.8.1/META-INF/NOTICE.md
# Apache-2.0, minpack, BSD, BSD-2 - ./repository/org/apache/commons/commons-math3/3.2/commons-math3-3.2/META-INF/LICENSE.txt
# Apache-2.0, W3C-Software-Notice-and-License, SAX2-PD - ./repository/org/apache/ant/ant-launcher/1.10.11/ant-launcher-1.10.11/META-INF/LICENSE.txt
# Apache-1.1 - ./repository/org/codehaus/plexus/plexus-utils/3.4.1/plexus-utils-3.4.1/licenses/extreme.indiana.edu.license.TXT
# BSD - ./repository/jakarta/xml/bind/jakarta.xml.bind-api/2.3.2/jakarta.xml.bind-api-2.3.2/META-INF/LICENSE.md
# BSD, (Apache-2.0 W3C-Software-Notice-and-License public-domain), MIT, (custom Apache-1.1), pending [Apache-2.0], (Apache-2.0 || (MIT GPL-1.0+)), SAX-PD, || ( Apache-2.0 Apache-1.1 BSD public-domain (custom Apache-1.1) ) - ./repository/com/sun/istack/istack-commons-runtime/3.0.8/istack-commons-runtime-3.0.8/META-INF/NOTICE.md
# BSD-2 - ./repository/org/codehaus/plexus/plexus-utils/3.4.1/plexus-utils-3.4.1/licenses/javolution.license.TXT
# BSD-4 - ./repository/org/jdom/jdom2/2.0.6/jdom2-2.0.6/META-INF/LICENSE.txt
# CDDL-1.1, GPL-2-with-classpath-exception - ./repository/javax/annotation/javax.annotation-api/1.3.2/javax.annotation-api-1.3.2/META-INF/LICENSE.txt
# CDDL-1.0 - ./repository/javax/activation/activation/1.1/activation-1.1/META-INF/LICENSE.txt
# EPL-1.0 - ./repository/junit/junit/4.12/junit-4.12/LICENSE-junit.txt
# GPL-2-with-classpath-exception, || ( LGPL-2.1 Apache-2.0 ), MIT - ./repository/org/checkerframework/dataflow-errorprone/3.15.0/dataflow-errorprone-3.15.0/META-INF/LICENSE.txt
# GPL-2-with-classpath-exception - ./repository/org/openjdk/jmh/jmh-generator-asm/1.29/jmh-generator-asm-1.29/LICENSE
# MIT - ./repository/org/checkerframework/checker-qual/3.8.0/checker-qual-3.8.0/META-INF/LICENSE.txt
# openssl - ./repository/io/grpc/grpc-netty-shaded/1.43.2/grpc-netty-shaded-1.43.2/META-INF/license/LICENSE.aix-netbsd.txt
# openssl, BSD, ISC - ./repository/io/grpc/grpc-netty-shaded/1.43.2/grpc-netty-shaded-1.43.2/META-INF/license/LICENSE.boringssl.txt
# SAX2-PD - ./repository/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.sax.txt
# W3C-Document-License - ./repository/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.dom-documentation.txt
# W3C-Software-Notice-and-License - ./repository/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.dom-software.txt
# Apache-2.0, W3C-Software-Notice-and-License - ./repository/org/apache/ant/ant-launcher/1.10.11/ant-launcher-1.10.11/META-INF/LICENSE.txt

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~s390 ~x86"
IUSE+="
android doc source test
r1
"
#REQUIRED_USE+=" !android" # Cannot fix at the moment ANDROID_HOME="/var/lib/portage/home/.android" sandbox violation
RESTRICT="mirror"
GRADLE_PV="7.3.3" # https://github.com/grpc/grpc-java/blob/v1.52.1/gradle/wrapper/gradle-wrapper.properties
JAVA_SLOT="11" # https://github.com/grpc/grpc-java/blob/v1.52.1/.github/workflows/testing.yml#L20
RDEPEND+="
	dev-libs/protobuf:0/3.21[static-libs]
	virtual/jre:${JAVA_SLOT}
"
DEPEND+=" ${RDEPEND}"
# SDK ver: https://github.com/grpc/grpc-java/blob/v1.52.1/android/build.gradle#L10
BDEPEND+="
	dev-java/gradle-bin:${GRADLE_PV}
	virtual/jdk:${JAVA_SLOT}
	android? (
		dev-util/android-sdk-update-manager
		dev-util/android-sdk-platform:29
		dev-util/android-sdk-platform:30
		dev-util/android-sdk-build-tools:30.0.2
		dev-util/android-sdk-commandlinetools
	)
"

GRADLE_PKGS_UNPACK_ANDROID=(
)

GRADLE_PKGS_UNPACK_NO_ANDROID=(
androidx.databinding/databinding-common/4.2.0/3723c4679dde4ea48598eda6a4735df5b130efca/databinding-common-4.2.0.jar
androidx.databinding/databinding-common/4.2.0/c7c96c7ef2132df04a1412599d9b9d9678b16c04/databinding-common-4.2.0.pom
androidx.databinding/databinding-compiler-common/4.2.0/148f958440981c6a9869a4b1eda6438a3c052296/databinding-compiler-common-4.2.0.pom
androidx.databinding/databinding-compiler-common/4.2.0/f2f0bebb7cd57cf7440aa99cdf02d066c2a390d6/databinding-compiler-common-4.2.0.jar
antlr/antlr/2.7.7/52f15b99911ab8b8bc8744675f5cf1994a626fb8/antlr-2.7.7.pom
antlr/antlr/2.7.7/83cd2cd674a217ade95a4bb83a8a14f351f48bd0/antlr-2.7.7.jar
com.android.databinding/baseLibrary/4.2.0/60a87775da182d9d6156d6e0fd7da74a9aced2ed/baseLibrary-4.2.0.jar
com.android.databinding/baseLibrary/4.2.0/6c7af85710fc96ab78836cf9960203388c0f1ee2/baseLibrary-4.2.0.pom
com.android.tools.analytics-library/crash/27.2.0/6c4a17cac6f9e58882123cccbfd642b0e602f726/crash-27.2.0.jar
com.android.tools.analytics-library/crash/27.2.0/acb718ae896af3171e73aa36e19b543ded255365/crash-27.2.0.pom
com.android.tools.analytics-library/protos/27.2.0/133ebd79a84b4aecc1e6bf0f90f84064054ae64f/protos-27.2.0.jar
com.android.tools.analytics-library/protos/27.2.0/54a413119a6eae78cc83016f9b92c0f316fe71a4/protos-27.2.0.pom
com.android.tools.analytics-library/shared/27.2.0/c44f980260c3b3e74d9684059581bd16518946e/shared-27.2.0.pom
com.android.tools.analytics-library/shared/27.2.0/eb396a103c26535b63bad79ed84ec082351a0764/shared-27.2.0.jar
com.android.tools.analytics-library/tracker/27.2.0/1e8912f3900eea3129b333b927255c1804d65ac8/tracker-27.2.0.pom
com.android.tools.analytics-library/tracker/27.2.0/52946983ba7136bb94ba0e99eb7fbbe78a1a5b17/tracker-27.2.0.jar
com.android.tools.build.jetifier/jetifier-core/1.0.0-beta09/6393d821ad5c2917a0182717ae8b8eee72c667de/jetifier-core-1.0.0-beta09.pom
com.android.tools.build.jetifier/jetifier-core/1.0.0-beta09/c98ee0e5579aed97e17f605a89b101115a2f5a61/jetifier-core-1.0.0-beta09.jar
com.android.tools.build.jetifier/jetifier-processor/1.0.0-beta09/c5b7c0ddbdfdeb69b842bcd9672f88bae14238c7/jetifier-processor-1.0.0-beta09.pom
com.android.tools.build.jetifier/jetifier-processor/1.0.0-beta09/fb2a015ff56e24939a88593ac73b84e627864476/jetifier-processor-1.0.0-beta09.jar
com.android.tools.build/aapt2-proto/4.2.0-7147631/1501d986817b6cef09fc198e8e6ca00a15c13f00/aapt2-proto-4.2.0-7147631.jar
com.android.tools.build/aapt2-proto/4.2.0-7147631/e025b85370a6d44cac93073338679b741099de53/aapt2-proto-4.2.0-7147631.pom
com.android.tools.build/aaptcompiler/4.2.0/51ff64dde379845091dcaf3f77f25f2496029734/aaptcompiler-4.2.0.pom
com.android.tools.build/aaptcompiler/4.2.0/6c406a804e2fa1f536ab187d34863dae96dd05d0/aaptcompiler-4.2.0.jar
com.android.tools.build/apksig/4.2.0/98c4358ab08d3ef7cd66c79cc91b632b63fc48ac/apksig-4.2.0.jar
com.android.tools.build/apksig/4.2.0/dde6a00d33cecabd472fc9af4f32d5a568c05a0/apksig-4.2.0.pom
com.android.tools.build/apkzlib/4.2.0/49cb407f13ef01fa8b6c21b4429b2f876767f68e/apkzlib-4.2.0.jar
com.android.tools.build/apkzlib/4.2.0/77bc8234b354ab252bb0bacc5f38f2a99a7a4501/apkzlib-4.2.0.pom
com.android.tools.build/builder-model/4.2.0/5e5536e15c44135d0814be7a2ef64988207cab52/builder-model-4.2.0.jar
com.android.tools.build/builder-model/4.2.0/dad0e7533523dff49e84e8bf53c3cfd1599a4261/builder-model-4.2.0.pom
com.android.tools.build/builder-test-api/4.2.0/70d70efb44c109513673cd44ea8fc187917ca87/builder-test-api-4.2.0.jar
com.android.tools.build/builder-test-api/4.2.0/f0bec2c8c9cfc4e0ef2b4e17211171e11315e6a4/builder-test-api-4.2.0.pom
com.android.tools.build/builder/4.2.0/19bdd710f32420068c8bd44728681633441b8eb/builder-4.2.0.pom
com.android.tools.build/builder/4.2.0/a82f979efe703211baee9917c8d2edd3df6382c8/builder-4.2.0.jar
com.android.tools.build/bundletool/1.1.0/25c00155d02bd47617b840814ef4aa52bcf8c805/bundletool-1.1.0.pom
com.android.tools.build/bundletool/1.1.0/582c071113a4447a8f9743a0dea8558f5c499c61/bundletool-1.1.0.jar
com.android.tools.build/gradle-api/4.2.0/22d4fcafb1385cd2953bb2b10d7895aea27f0d5b/gradle-api-4.2.0.pom
com.android.tools.build/gradle-api/4.2.0/57eacf3a9bd9755e77638da57344bea4d45bb251/gradle-api-4.2.0.jar
com.android.tools.build/gradle/4.2.0/341228eb834fd057e5bf1239d9e37e4564ba32cd/gradle-4.2.0.jar
com.android.tools.build/gradle/4.2.0/49deb48100aa392988b8d787fb4471efb89c1ef3/gradle-4.2.0.pom
com.android.tools.build/manifest-merger/27.2.0/45d01c90c6769039f26406a2915689d1ea37fd90/manifest-merger-27.2.0.pom
com.android.tools.build/manifest-merger/27.2.0/c074b9a439ac617236bc31f978b4520b0fc86fb7/manifest-merger-27.2.0.jar
com.android.tools.build/transform-api/2.0.0-deprecated-use-gradle-api/85bee1acea9e27152b920746c68133b30b11431/transform-api-2.0.0-deprecated-use-gradle-api.jar
com.android.tools.build/transform-api/2.0.0-deprecated-use-gradle-api/d2a89c5569f53a8c8adfe599ede88cb6f38a8a6e/transform-api-2.0.0-deprecated-use-gradle-api.pom
com.android.tools.ddms/ddmlib/27.2.0/59661295b59ef744dd5f2821573c2396a009e974/ddmlib-27.2.0.jar
com.android.tools.ddms/ddmlib/27.2.0/de3859dea05e0f61479a8f97cd3b5488fafc7043/ddmlib-27.2.0.pom
com.android.tools.layoutlib/layoutlib-api/27.2.0/1fdc06a788d5e61e5826b947f908ee3c9b5a7844/layoutlib-api-27.2.0.pom
com.android.tools.layoutlib/layoutlib-api/27.2.0/e8e77f698e9b6f26d88207751d5ef65068133a57/layoutlib-api-27.2.0.jar
com.android.tools.lint/lint-gradle-api/27.2.0/408e5d1afe9c7d85a073a21a61667c5ef57369ff/lint-gradle-api-27.2.0.pom
com.android.tools.lint/lint-gradle-api/27.2.0/6ff70b4255a0458910d12f6c65017609618429a4/lint-gradle-api-27.2.0.jar
com.android.tools.lint/lint-model/27.2.0/997bf8f85c6b6a2ca99013a7a4deb5d68fe26a06/lint-model-27.2.0.jar
com.android.tools.lint/lint-model/27.2.0/b525df98bb3fd9c304deb4100b52aa8bf61aeb5d/lint-model-27.2.0.pom
com.android.tools/annotations/27.2.0/4a5ee7fff904cab29a827bc5044137f97fbaaffb/annotations-27.2.0.pom
com.android.tools/annotations/27.2.0/8994674629f58684e973ac01c570b75bc3725169/annotations-27.2.0.jar
com.android.tools/common/27.2.0/8876cc9627e78c16e674091a3ddfd0ae5612ddbf/common-27.2.0.pom
com.android.tools/common/27.2.0/b004d1abfcd4c3b83b62a6d672d8e03f0061210/common-27.2.0.jar
com.android.tools/dvlib/27.2.0/6d43a851ff6f97e3c920a36e9fab10924c9c6dfa/dvlib-27.2.0.jar
com.android.tools/dvlib/27.2.0/ddf13645a1ecc06a6de1f7cbff33c8a2e1fef4d6/dvlib-27.2.0.pom
com.android.tools/repository/27.2.0/8399a55f4ba312ab34b4162c3588a1d7f75ad8ec/repository-27.2.0.pom
com.android.tools/repository/27.2.0/effd29b0a3597bbc1a9503936fc6814b4cb27213/repository-27.2.0.jar
com.android.tools/sdk-common/27.2.0/96291744fe309ad0e1c7ec5bd5f2d36b9dcf693b/sdk-common-27.2.0.jar
com.android.tools/sdk-common/27.2.0/fbe3ad07b58bca1b3330c754f17a172a79726814/sdk-common-27.2.0.pom
com.android.tools/sdklib/27.2.0/53d092eda5e71f3009209baa5f5ace3aaa5a7e33/sdklib-27.2.0.jar
com.android.tools/sdklib/27.2.0/ce9a4b56206a85319fd17b086d6ee6b2c463d141/sdklib-27.2.0.pom
com.android/signflinger/4.2.0/99e94d23459e582bbca3c266465f8cdd1fe8b711/signflinger-4.2.0.jar
com.android/signflinger/4.2.0/b51c09d92daa8b4fc5b4a0de97d488f17443e22f/signflinger-4.2.0.pom
com.android/zipflinger/4.2.0/126e07e73a785f11c6a87bd091431e4830e2ba4e/zipflinger-4.2.0.pom
com.android/zipflinger/4.2.0/b9f6661c53cf54fa868db832d2847d7af96d3dc5/zipflinger-4.2.0.jar
com.fasterxml.jackson.core/jackson-annotations/2.13.2/4777fb9704d7933684b717b9cef3975d109de0b7/jackson-annotations-2.13.2.pom
com.fasterxml.jackson.core/jackson-annotations/2.13.2/ec18851f1976d5b810ae1a5fcc32520d2d38f77a/jackson-annotations-2.13.2.jar
com.fasterxml.jackson.core/jackson-core/2.13.2/a6a0e0620d51833feffc67bccb51937b2345763/jackson-core-2.13.2.jar
com.fasterxml.jackson.core/jackson-core/2.13.2/a899bde135264d4fd67ed30c1e3fb1dc85054d8f/jackson-core-2.13.2.pom
com.fasterxml.jackson.core/jackson-databind/2.13.2.2/43dda6b6dc13ad42a923b30f646ae6360710b51f/jackson-databind-2.13.2.2.pom
com.fasterxml.jackson.core/jackson-databind/2.13.2.2/ffeb635597d093509f33e1e94274d14be610f933/jackson-databind-2.13.2.2.jar
com.fasterxml.jackson.datatype/jackson-datatype-jsr310/2.13.2/5682ae6a490ec2e48fd2e1ed793bfeaaf7beeba3/jackson-datatype-jsr310-2.13.2.pom
com.fasterxml.jackson.datatype/jackson-datatype-jsr310/2.13.2/cddd9380efd4b81ea01e98be8fbdc9765a81793b/jackson-datatype-jsr310-2.13.2.jar
com.fasterxml.jackson.module/jackson-modules-java8/2.13.2/5a1cea0f373989ed135fa1b2b11dfde387ef5395/jackson-modules-java8-2.13.2.pom
com.fasterxml.jackson/jackson-base/2.13.2/2f0165ddb7321c116857b234fadc2f965febab2f/jackson-base-2.13.2.pom
com.fasterxml.jackson/jackson-bom/2.13.2/666455372ac024fec03363666094acb272302183/jackson-bom-2.13.2.pom
com.fasterxml.jackson/jackson-parent/2.13/f6a50c4f6c369a82cc6f38363410d6f3c03aaf7c/jackson-parent-2.13.pom
com.fasterxml/oss-parent/43/b07427a553422225d489ca19fd3fcdc38c02aa16/oss-parent-43.pom
com.github.ben-manes.caffeine/caffeine/2.8.8/298bb2108157513a39a1a52a686a1fe8b57cc973/caffeine-2.8.8.jar
com.github.ben-manes.caffeine/caffeine/2.8.8/7ba8a485742df1f8fe6709c49f4796ea3b9571fa/caffeine-2.8.8.pom
com.github.johnrengelman.shadow/com.github.johnrengelman.shadow.gradle.plugin/7.1.2/babe75f105fd72f21edc5c3b64ac0162af0b1501/com.github.johnrengelman.shadow.gradle.plugin-7.1.2.pom
com.github.kevinstern/software-and-algorithms/1.0/5e77666b72c6c5dd583c36148d17fc47f944dfb5/software-and-algorithms-1.0.jar
com.github.kevinstern/software-and-algorithms/1.0/969b642b8abd4e71b70b7b2a6cf4a436dbe4ea5c/software-and-algorithms-1.0.pom
com.github.kt3k.coveralls/com.github.kt3k.coveralls.gradle.plugin/2.12.0/96b81025d0ab9f51770b02b99501d97372bf5322/com.github.kt3k.coveralls.gradle.plugin-2.12.0.pom
com.github.siom79.japicmp/japicmp-base/0.14.3/b2afa7138264f9298ce7cbcbad79e578fc226676/japicmp-base-0.14.3.pom
com.github.siom79.japicmp/japicmp/0.14.3/31d98c5552446ba7773b1492ba25b3ee2eff0afc/japicmp-0.14.3.pom
com.github.siom79.japicmp/japicmp/0.14.3/ec7a8a0fafa1815846150db31075c09c672b657b/japicmp-0.14.3.jar
com.google.android/annotations/4.1.1.4/a1678ba907bf92691d879fef34e1a187038f9259/annotations-4.1.1.4.jar
com.google.android/annotations/4.1.1.4/c5a23d7076f3c7fd4b8f39b59ff02b1e164edc28/annotations-4.1.1.4.pom
com.google.api-client/google-api-client-bom/1.30.2/8d3bf703048491df0772fb189628d7ec8520cf97/google-api-client-bom-1.30.2.pom
com.google.api-client/google-api-client-bom/1.33.0/8f5ae261d768974098700195766622334f1657fd/google-api-client-bom-1.33.0.pom
com.google.api.grpc/google-api-grpc/0.65.0/59e23430dd5f1ca54e3c21d6d50499e3477fc209/google-api-grpc-0.65.0.pom
com.google.api.grpc/proto-google-cloud-logging-v2/0.95.1/42cf6b6d9bc6481f076bba167e48ee00b4256b88/proto-google-cloud-logging-v2-0.95.1.pom
com.google.api.grpc/proto-google-cloud-logging-v2/0.95.1/b955fb09fd89e63f74d6e57d7f7af85e090c2357/proto-google-cloud-logging-v2-0.95.1.jar
com.google.api.grpc/proto-google-cloud-monitoring-v3/1.64.0/2ce633485be8f83300f84a2c4f682c55002a1d36/proto-google-cloud-monitoring-v3-1.64.0.pom
com.google.api.grpc/proto-google-cloud-monitoring-v3/1.64.0/7655d905de12a9648910652512b73e9c776947a8/proto-google-cloud-monitoring-v3-1.64.0.jar
com.google.api.grpc/proto-google-cloud-trace-v1/0.65.0/a53e5dbf0ce5e235ea4f36f672fad82e3c37f957/proto-google-cloud-trace-v1-0.65.0.jar
com.google.api.grpc/proto-google-cloud-trace-v1/0.65.0/bae96fa63538bae2945257f991ebfdd7a0f53b4b/proto-google-cloud-trace-v1-0.65.0.pom
com.google.api.grpc/proto-google-cloud-trace-v2/0.65.0/6d80e9f386349769447d28cdda26616a2cefe1e3/proto-google-cloud-trace-v2-0.65.0.jar
com.google.api.grpc/proto-google-cloud-trace-v2/0.65.0/8b7fd671507fdf6dc04d30305b1bb678de4bbd93/proto-google-cloud-trace-v2-0.65.0.pom
com.google.api.grpc/proto-google-common-protos/2.9.0/e0a66fe8b224e56bb7672e4509afea8edd46223e/proto-google-common-protos-2.9.0.pom
com.google.api.grpc/proto-google-common-protos/2.9.0/e4ada41aaaf6ecdedf132f44251d0d50813f7f90/proto-google-common-protos-2.9.0.jar
com.google.api.grpc/proto-google-iam-v1/1.2.0/18e0ff91562f52e2966f4fd7dad614bdb793b1ad/proto-google-iam-v1-1.2.0.pom
com.google.api.grpc/proto-google-iam-v1/1.2.0/4ac276c6fc59c48ea916514bfcfaec66b8d607b4/proto-google-iam-v1-1.2.0.jar
com.google.api/api-common/2.1.2/b30a39e22d667e9adc1ec294ec1469d91ca3d4c/api-common-2.1.2.pom
com.google.api/api-common/2.1.2/eff20f72b42843d48d01c19099d4a22e8da773fa/api-common-2.1.2.jar
com.google.api/gax-bom/1.47.1/832b909db0eb3171b1af2f230c7d8457d5a1261e/gax-bom-1.47.1.pom
com.google.api/gax-bom/2.8.1/21b18fc5fdbc8366c6523a692deebe9beca1ea7b/gax-bom-2.8.1.pom
com.google.api/gax-grpc/2.8.1/87a6002f994771eb1e9e7e77ff66fa20d974d269/gax-grpc-2.8.1.pom
com.google.api/gax-grpc/2.8.1/a05a5132300512c128cecf57ac5b784153131c61/gax-grpc-2.8.1.jar
com.google.api/gax/2.8.1/ac4768c602b7f5bc37e114caa97480f08365b0ac/gax-2.8.1.pom
com.google.api/gax/2.8.1/c99dcb923675ae3e2fe8eb66f736e80f89c66231/gax-2.8.1.jar
com.google.appengine/appengine-api-1.0-sdk/1.9.59/b7c3ed8740c263927d2505d9179c607a8112b70f/appengine-api-1.0-sdk-1.9.59.pom
com.google.appengine/appengine-api-1.0-sdk/1.9.59/dd9e822cc50dd1a8512665e3f8c4fe94808c0cac/appengine-api-1.0-sdk-1.9.59.jar
com.google.appengine/appengine/1.9.59/3dcb3a005456691326ad7767e3319c6b222e2ec5/appengine-1.9.59.pom
com.google.auth/google-auth-library-bom/0.16.2/a9a3b678db27127e2d5eaa4629ede3e3864287bd/google-auth-library-bom-0.16.2.pom
com.google.auth/google-auth-library-bom/1.3.0/25b4c8f6b17c212f44008158b3d4db1c39b47787/google-auth-library-bom-1.3.0.pom
com.google.auth/google-auth-library-credentials/0.18.0/3f32fdfb390ea16353d2caa70158f5ce00924cd0/google-auth-library-credentials-0.18.0.pom
com.google.auth/google-auth-library-credentials/0.18.0/72d198af6d5288dc09c4031fd7d7d65b07e36b16/google-auth-library-credentials-0.18.0.jar
com.google.auth/google-auth-library-credentials/1.4.0/22ab0ed25b8c50514a8a74c91d5b32bc6f528cb/google-auth-library-credentials-1.4.0.pom
com.google.auth/google-auth-library-credentials/1.4.0/50f543f1da68956b4dec792c64e2f8a2f1dcf376/google-auth-library-credentials-1.4.0.jar
com.google.auth/google-auth-library-oauth2-http/0.18.0/47d7a326e5de135defea328baafdf2f29de733d1/google-auth-library-oauth2-http-0.18.0.jar
com.google.auth/google-auth-library-oauth2-http/0.18.0/658b7b97a0244ebb4d4c477db4060397356c6d3c/google-auth-library-oauth2-http-0.18.0.pom
com.google.auth/google-auth-library-oauth2-http/1.3.0/53e9584598927c2fff89882eeb81a39c8c0632b3/google-auth-library-oauth2-http-1.3.0.pom
com.google.auth/google-auth-library-oauth2-http/1.3.0/fb9d88528fe8061230d3a7cb1f2d0ab2423976ae/google-auth-library-oauth2-http-1.3.0.jar
com.google.auth/google-auth-library-oauth2-http/1.4.0/8826b67465d3fe4bfab5defecf312978a3386eec/google-auth-library-oauth2-http-1.4.0.pom
com.google.auth/google-auth-library-oauth2-http/1.4.0/948a5c7b51d8f07accafd1be2b12698a22d39908/google-auth-library-oauth2-http-1.4.0.jar
com.google.auth/google-auth-library-parent/0.18.0/9fa8ac4187cd92b21079693a150d276b78d71e4c/google-auth-library-parent-0.18.0.pom
com.google.auth/google-auth-library-parent/1.3.0/b53b525f57094b53afde73df527bd86e7f33a9bb/google-auth-library-parent-1.3.0.pom
com.google.auth/google-auth-library-parent/1.4.0/427a8178402fc08e28abd01592219cbde60ab7d5/google-auth-library-parent-1.4.0.pom
com.google.auto.service/auto-service-aggregator/1.0-rc6/ac147372117a5dc7f648693f20321197f6ca10df/auto-service-aggregator-1.0-rc6.pom
com.google.auto.service/auto-service-annotations/1.0-rc6/32c6a6313217c949396376d9caddb6b8c8f4e7c3/auto-service-annotations-1.0-rc6.jar
com.google.auto.service/auto-service-annotations/1.0-rc6/e8977ef4f17dc992a3f15bdc730b42f677969df0/auto-service-annotations-1.0-rc6.pom
com.google.auto.value/auto-value-annotations/1.6.2/ae1ff98291be961d9e1b14eb26bedaf0b5ac9d15/auto-value-annotations-1.6.2.pom
com.google.auto.value/auto-value-annotations/1.6.3/8ccd7ba6d7ea8de204f17f6e509d77a76f06d298/auto-value-annotations-1.6.3.pom
com.google.auto.value/auto-value-annotations/1.6.3/b88c1bb7f149f6d2cc03898359283e57b08f39cc/auto-value-annotations-1.6.3.jar
com.google.auto.value/auto-value-annotations/1.6.6/8d45c4bf06eb1abecc0d0d2c3dfa97bb825ba4ae/auto-value-annotations-1.6.6.pom
com.google.auto.value/auto-value-annotations/1.6.6/9947ae63d8ec42ea159283baf2e5b9c0ff100909/auto-value-annotations-1.6.6.jar
com.google.auto.value/auto-value-annotations/1.7/5be124948ebdc7807df68207f35a0f23ce427f29/auto-value-annotations-1.7.jar
com.google.auto.value/auto-value-annotations/1.7/ca51492a404fb37718543a97886b0320ee3c2fd7/auto-value-annotations-1.7.pom
com.google.auto.value/auto-value-annotations/1.8.2/546ae662e646e47a544ef68ebb43987a3146b692/auto-value-annotations-1.8.2.jar
com.google.auto.value/auto-value-annotations/1.8.2/b50f6be2fc88ebdf201fe89c871e2c0d4d96cf95/auto-value-annotations-1.8.2.pom
com.google.auto.value/auto-value-annotations/1.9/25a0fcef915f663679fcdb447541c5d86a9be4ba/auto-value-annotations-1.9.jar
com.google.auto.value/auto-value-annotations/1.9/a5c14e2bc293fe9d24d4ec21c2ba966e4832313d/auto-value-annotations-1.9.pom
com.google.auto.value/auto-value-parent/1.6.2/5eb0685cabce285064a62a7b9c6c256343a58285/auto-value-parent-1.6.2.pom
com.google.auto.value/auto-value-parent/1.6.3/7e21ec842ec2e34f4d8e277ef98be79401dce4c6/auto-value-parent-1.6.3.pom
com.google.auto.value/auto-value-parent/1.6.6/f1199a088cf284208854f708dd60a7977829d954/auto-value-parent-1.6.6.pom
com.google.auto.value/auto-value-parent/1.7/376ebf07d03456e91eedeb05b373507526bfe6ca/auto-value-parent-1.7.pom
com.google.auto.value/auto-value-parent/1.8.2/c86ec2e16ac581366a70e4739125a43b133210fb/auto-value-parent-1.8.2.pom
com.google.auto.value/auto-value-parent/1.9/a5a5f16386e4889a6bc0b98c6f6caced5f15764f/auto-value-parent-1.9.pom
com.google.auto.value/auto-value/1.9/60bc9ec1cd85efedb323928fe33a85b814f7abc0/auto-value-1.9.pom
com.google.auto.value/auto-value/1.9/fd4ec236e20ae0895c30e83260f611bcbc185086/auto-value-1.9.jar
com.google.auto/auto-common/1.1.2/371c587f59aed99a2a654fd07d90e6280819fa9f/auto-common-1.1.2.pom
com.google.auto/auto-common/1.1.2/85f292f609cb19a7a867263cfacd58217741860b/auto-common-1.1.2.jar
com.google.auto/auto-parent/6/f29db646babbca0049636b6724613035bbcedff/auto-parent-6.pom
com.google.auto/auto-parent/7/2ab24442738fb975a81595ef033f67a72358c1c/auto-parent-7.pom
com.google.cloud.tools.jib/com.google.cloud.tools.jib.gradle.plugin/3.2.1/cda95163637afe660e9f9e68b1c9e278dfe3e92f/com.google.cloud.tools.jib.gradle.plugin-3.2.1.pom
com.google.cloud.tools/appengine-gradle-plugin/2.3.0/8900085ea6f9498a380607b459fd3f934e437912/appengine-gradle-plugin-2.3.0.pom
com.google.cloud.tools/appengine-gradle-plugin/2.3.0/8a86585fa7107885f747e0936c88ae9b9305005e/appengine-gradle-plugin-2.3.0.jar
com.google.cloud.tools/appengine-plugins-core/0.9.0/8b8417b2aadbb22b3af6141d7dcdac18ccecddcc/appengine-plugins-core-0.9.0.pom
com.google.cloud.tools/appengine-plugins-core/0.9.0/e601398d7151c9fa657e454aa7818dd4a683de92/appengine-plugins-core-0.9.0.jar
com.google.cloud.tools/jib-build-plan/0.4.0/74ed8fc4a2c6cfb1e6c21ffd83f0292fd8523d31/jib-build-plan-0.4.0.pom
com.google.cloud.tools/jib-build-plan/0.4.0/b16394e7eda9aeff338841c6dc47ed5a8a9d8120/jib-build-plan-0.4.0.jar
com.google.cloud.tools/jib-gradle-plugin-extension-api/0.4.0/e20368cf494d5b560b38b4bbe7634fef183491eb/jib-gradle-plugin-extension-api-0.4.0.jar
com.google.cloud.tools/jib-gradle-plugin-extension-api/0.4.0/e7bf8b2a18e48d075e21b9eec885941035871b99/jib-gradle-plugin-extension-api-0.4.0.pom
com.google.cloud.tools/jib-plugins-extension-common/0.2.0/44797ae55365ca303456e3ce93ce291f04879c09/jib-plugins-extension-common-0.2.0.pom
com.google.cloud.tools/jib-plugins-extension-common/0.2.0/dd6b0e6412a5c9b59f9964a2389d8e0577e65d3f/jib-plugins-extension-common-0.2.0.jar
com.google.cloud/google-cloud-bom/0.100.0-alpha/daaa1f143e8c65b611453a3b3d6b1c2a5ab9c106/google-cloud-bom-0.100.0-alpha.pom
com.google.cloud/google-cloud-clients/0.100.0-alpha/cb70df9594bb8f113abad748f439431c5e80dc4a/google-cloud-clients-0.100.0-alpha.pom
com.google.cloud/google-cloud-core-grpc/2.3.5/30884dd6c45d34e99ebc984e3fbe2e4a69e3f220/google-cloud-core-grpc-2.3.5.pom
com.google.cloud/google-cloud-core-grpc/2.3.5/cd6952f6932149e20ba76705e83ad31a62a543c0/google-cloud-core-grpc-2.3.5.jar
com.google.cloud/google-cloud-core-parent/2.3.5/b6857c2cf7db92987c6dab387a3f6e18cd564269/google-cloud-core-parent-2.3.5.pom
com.google.cloud/google-cloud-core/2.3.5/a3dfdc439c0660c42dad7355edc6fc0f2d2eca77/google-cloud-core-2.3.5.jar
com.google.cloud/google-cloud-core/2.3.5/d26376d450456a2d97c4289818e9b62d9d97909a/google-cloud-core-2.3.5.pom
com.google.cloud/google-cloud-logging/3.6.1/3ae9a7089c5b76c000a5cf09ed0528e16ca2bf06/google-cloud-logging-3.6.1.pom
com.google.cloud/google-cloud-logging/3.6.1/9dc72423f9d8e1562fb1cd16194532629498dd34/google-cloud-logging-3.6.1.jar
com.google.cloud/google-cloud-monitoring/1.82.0/38baeb99536170b444182bc1c791c2240d233fb5/google-cloud-monitoring-1.82.0.jar
com.google.cloud/google-cloud-monitoring/1.82.0/cf870c6cb2fd7cab8daee6b389c2fd1cf9d074e2/google-cloud-monitoring-1.82.0.pom
com.google.cloud/google-cloud-shared-config/1.2.4/cb3f75d2cd6a92fa2ac6d39069648b2d2c41069a/google-cloud-shared-config-1.2.4.pom
com.google.cloud/google-cloud-trace/0.100.0-beta/3b9b1d614da59b877bddb8395387620c6275a27f/google-cloud-trace-0.100.0-beta.jar
com.google.cloud/google-cloud-trace/0.100.0-beta/b76064479f0b8e559cc18909d1c63d17833d52a2/google-cloud-trace-0.100.0-beta.pom
com.google.code.findbugs/jFormatString/3.0.0/7b3103607f633aeb40a35e10ee382ad52984d410/jFormatString-3.0.0.pom
com.google.code.findbugs/jFormatString/3.0.0/d3995f9be450813bc2ccee8f0774c1a3033a0f30/jFormatString-3.0.0.jar
com.google.code.findbugs/jsr305/1.3.9/67ea333a3244bc20a17d6f0c29498071dfa409fc/jsr305-1.3.9.pom
com.google.code.findbugs/jsr305/3.0.0/278c908b87e003ccbd36588d769655d2b870a7c7/jsr305-3.0.0.pom
com.google.code.findbugs/jsr305/3.0.2/25ea2e8b0c338a877313bd4672d3fe056ea78f0d/jsr305-3.0.2.jar
com.google.code.findbugs/jsr305/3.0.2/8d93cdf4d84d7e1de736df607945c6df0730a10f/jsr305-3.0.2.pom
com.google.code.gson/gson-parent/2.8.6/88d12a7aeaeaa9bbc773bc5f32690edf4d3ff9e6/gson-parent-2.8.6.pom
com.google.code.gson/gson-parent/2.8.9/c3fdad2fa3239f928ad9c77a9f9c9379f6bde7a/gson-parent-2.8.9.pom
com.google.code.gson/gson-parent/2.9.0/c6a7218f3573c254d33ffac6aa6efe7cb4f8186b/gson-parent-2.9.0.pom
com.google.code.gson/gson/2.8.6/9180733b7df8542621dc12e21e87557e8c99b8cb/gson-2.8.6.jar
com.google.code.gson/gson/2.8.6/b9d7e274612598f1e8835d8bbe30baa5b970ca32/gson-2.8.6.pom
com.google.code.gson/gson/2.8.9/8a432c1d6825781e21a02db2e2c33c5fde2833b9/gson-2.8.9.jar
com.google.code.gson/gson/2.8.9/e40b03e4cc2b52efb19af75c07596e9d15a52d82/gson-2.8.9.pom
com.google.code.gson/gson/2.9.0/8a1167e089096758b49f9b34066ef98b2f4b37aa/gson-2.9.0.jar
com.google.code.gson/gson/2.9.0/bfedf86dd09fdbb51b11621570b75d0697bf7a2a/gson-2.9.0.pom
com.google.crypto.tink/tink/1.3.0-rc2/5a666d168e1b821be33321a858f90baa5ab4b6cc/tink-1.3.0-rc2.pom
com.google.crypto.tink/tink/1.3.0-rc2/c7efb1ecc3b667b8a0789a1b019b06269037e19b/tink-1.3.0-rc2.jar
com.google.dagger/dagger/2.28.3/10d83810ef9e19714116ed518896c90c6606d633/dagger-2.28.3.jar
com.google.dagger/dagger/2.28.3/6a11b6b6db0c740dbd150e11f54c6f219fdc2891/dagger-2.28.3.pom
com.google.errorprone/error_prone_annotation/2.10.0/10d19cb62fdac2f18e1d0c4496c551727975f321/error_prone_annotation-2.10.0.pom
com.google.errorprone/error_prone_annotation/2.10.0/3a61c605f5ab30fd94edc36556fbbd30847aebb3/error_prone_annotation-2.10.0.jar
com.google.errorprone/error_prone_annotations/2.10.0/972fdb73175fce135e78555269ede8c8d3b36f74/error_prone_annotations-2.10.0.pom
com.google.errorprone/error_prone_annotations/2.10.0/9bc20b94d3ac42489cf6ce1e42509c86f6f861a1/error_prone_annotations-2.10.0.jar
com.google.errorprone/error_prone_annotations/2.11.0/c5a0ace696d3f8b1c1d8cc036d8c03cc0cbe6b69/error_prone_annotations-2.11.0.jar
com.google.errorprone/error_prone_annotations/2.11.0/ced1afa200bbf344ccdef14b92aa84f7863f395c/error_prone_annotations-2.11.0.pom
com.google.errorprone/error_prone_annotations/2.14.0/9f01b3654d3c536859705f09f8d267ee977b4004/error_prone_annotations-2.14.0.jar
com.google.errorprone/error_prone_annotations/2.14.0/b8f9d8ab8a705d8deef57834335e49b791b91024/error_prone_annotations-2.14.0.pom
com.google.errorprone/error_prone_annotations/2.2.0/88e3c593e9b3586e1c6177f89267da6fc6986f0c/error_prone_annotations-2.2.0.jar
com.google.errorprone/error_prone_annotations/2.2.0/e28b5b546020f18ea29e2b4756023f53ee91492b/error_prone_annotations-2.2.0.pom
com.google.errorprone/error_prone_annotations/2.3.1/19c878e6870c8382864dcc459de1c6bfe7f36e54/error_prone_annotations-2.3.1.pom
com.google.errorprone/error_prone_annotations/2.3.2/f9aadf833282cfd743aa5d330f927489ca9c8734/error_prone_annotations-2.3.2.pom
com.google.errorprone/error_prone_annotations/2.3.3/5229e1796fffb673f2c7d48b74a0275729113876/error_prone_annotations-2.3.3.pom
com.google.errorprone/error_prone_annotations/2.3.4/9a23fcb83bc8ed502506a8e6c648bf763dc5bcf9/error_prone_annotations-2.3.4.pom
com.google.errorprone/error_prone_annotations/2.3.4/dac170e4594de319655ffb62f41cbd6dbb5e601e/error_prone_annotations-2.3.4.jar
com.google.errorprone/error_prone_annotations/2.5.1/562d366678b89ce5d6b6b82c1a073880341e3fba/error_prone_annotations-2.5.1.jar
com.google.errorprone/error_prone_annotations/2.5.1/d759b1b643583e30d8bb6bb55f4ad434f26c44a4/error_prone_annotations-2.5.1.pom
com.google.errorprone/error_prone_check_api/2.10.0/5bec8cb0979875aca9f07d8dcee5266a6584bd03/error_prone_check_api-2.10.0.pom
com.google.errorprone/error_prone_check_api/2.10.0/6203cac373051702c0cf8ca0bd36332fdc64903f/error_prone_check_api-2.10.0.jar
com.google.errorprone/error_prone_core/2.10.0/34db1397d045fa76dad07e291db2bb75f97127c0/error_prone_core-2.10.0.pom
com.google.errorprone/error_prone_core/2.10.0/b79c7d01ab2154da1d029b94452b678dc424b22d/error_prone_core-2.10.0.jar
com.google.errorprone/error_prone_parent/2.10.0/d70888ba27b15543d639b0be077b1d0d6d38c40/error_prone_parent-2.10.0.pom
com.google.errorprone/error_prone_parent/2.11.0/bd585f378139da5b5e670840892c48e75d03cf7b/error_prone_parent-2.11.0.pom
com.google.errorprone/error_prone_parent/2.14.0/8b8370c00c3adf054df4006bfc3ac73baabd8084/error_prone_parent-2.14.0.pom
com.google.errorprone/error_prone_parent/2.2.0/72e2f31cb1952eada003d2ba7e82874cfe4b738c/error_prone_parent-2.2.0.pom
com.google.errorprone/error_prone_parent/2.3.1/a32c199defa0dcf9c42a32c26fec4d1fbb408e58/error_prone_parent-2.3.1.pom
com.google.errorprone/error_prone_parent/2.3.2/ea30b94538922c99fb231a2c9859790831eb0fb0/error_prone_parent-2.3.2.pom
com.google.errorprone/error_prone_parent/2.3.3/f28c999c5280f3c387fc3795d2b62904abe6665/error_prone_parent-2.3.3.pom
com.google.errorprone/error_prone_parent/2.3.4/a9b9dd42d174a5f96d6c195525877fc6d0b2028a/error_prone_parent-2.3.4.pom
com.google.errorprone/error_prone_parent/2.5.1/3cce581619abb2d892618745ef2f7f19087ecbc7/error_prone_parent-2.5.1.pom
com.google.errorprone/error_prone_type_annotations/2.10.0/41396cadb7fe56349abb7c22df6983879a5a9f14/error_prone_type_annotations-2.10.0.jar
com.google.errorprone/error_prone_type_annotations/2.10.0/56e3576cfc122a1dd2f5f197ce37fbeb6682221c/error_prone_type_annotations-2.10.0.pom
com.google.flatbuffers/flatbuffers-java/1.12.0/8201cc7b511177a37071249e891f2f2fea4b32e9/flatbuffers-java-1.12.0.jar
com.google.flatbuffers/flatbuffers-java/1.12.0/f93bdcc0b38ffbec623e6610e0cddacae758cb54/flatbuffers-java-1.12.0.pom
com.google.gradle/osdetector-gradle-plugin/1.7.0/9ae1420e906221dd5f73a4d4ba1bba9c827bbdf1/osdetector-gradle-plugin-1.7.0.pom
com.google.gradle/osdetector-gradle-plugin/1.7.0/f17fa284233d81e878f9fe448fba34abb1a5ae/osdetector-gradle-plugin-1.7.0.jar
com.google.guava/failureaccess/1.0.1/1dcf1de382a0bf95a3d8b0849546c88bac1292c9/failureaccess-1.0.1.jar
com.google.guava/failureaccess/1.0.1/e8160e78fdaaf7088621dc1649d9dd2dfcf8d0e8/failureaccess-1.0.1.pom
com.google.guava/guava-beta-checker/1.0/d0507876031b90d3925553e971cadc00f85847dd/guava-beta-checker-1.0.jar
com.google.guava/guava-beta-checker/1.0/e902c4457e265cada4edc5f2ccc3a3e0b2e2bede/guava-beta-checker-1.0.pom
com.google.guava/guava-bom/31.0.1-jre/bbac83bf4324a76fe321ca8cb97dcdc017ba37f3/guava-bom-31.0.1-jre.pom
com.google.guava/guava-parent/19.0/21fa0d898121cc408c19b74e4305403c6cc45b23/guava-parent-19.0.pom
com.google.guava/guava-parent/26.0-android/a2c0df489614352b7e8e503e274bd1dee5c42a64/guava-parent-26.0-android.pom
com.google.guava/guava-parent/27.0.1-jre/8f7a96c144da567471d3d763a240c25ba374ebb1/guava-parent-27.0.1-jre.pom
com.google.guava/guava-parent/28.1-android/a35bc2b0d0477bca2e4a88c9b864de91ce705f5b/guava-parent-28.1-android.pom
com.google.guava/guava-parent/28.1-jre/cf90295394521cc63bf7cfdd4b81236531ccefdb/guava-parent-28.1-jre.pom
com.google.guava/guava-parent/28.2-jre/9a6aa66406e84ac13100698e335cbcfe1959a58b/guava-parent-28.2-jre.pom
com.google.guava/guava-parent/30.0-android/46248e14a7e827870b0f5635709527dba2ff6fe1/guava-parent-30.0-android.pom
com.google.guava/guava-parent/30.1-jre/b732bbf7c4ceb14dfd6af514a8b8b71dd952e53b/guava-parent-30.1-jre.pom
com.google.guava/guava-parent/30.1.1-android/5f18c1c6a72fa43823fa49b21421f87844891831/guava-parent-30.1.1-android.pom
com.google.guava/guava-parent/30.1.1-jre/3d726f4e77f9b282e3b99bb1d62713a44cab3118/guava-parent-30.1.1-jre.pom
com.google.guava/guava-parent/31.1-android/13c71653747af29c2b7b3293d00d3a1b0df3a841/guava-parent-31.1-android.pom
com.google.guava/guava-parent/31.1-jre/99dae234b84eeaafa621086b6fff3530fb7e45d3/guava-parent-31.1-jre.pom
com.google.guava/guava-testlib/30.1.1-android/4a5703a1d0a7a51763e6f50435e3d4f29392144d/guava-testlib-30.1.1-android.pom
com.google.guava/guava-testlib/30.1.1-android/c8e78ea398a810f8ef85a9fa3857ed804b65bd28/guava-testlib-30.1.1-android.jar
com.google.guava/guava-testlib/31.1-android/1dec158dfc800745135e3d3018e88330048bc5f3/guava-testlib-31.1-android.pom
com.google.guava/guava-testlib/31.1-android/af16da7b56697bb2d1fdbcd41bd2e956408ffa28/guava-testlib-31.1-android.jar
com.google.guava/guava/19.0/65a43a21dbddcc19aa3ca50a63a4b33166bfbc77/guava-19.0.pom
com.google.guava/guava/19.0/6ce200f6b23222af3d8abb6b6459e6c44f4bb0e9/guava-19.0.jar
com.google.guava/guava/27.0.1-jre/a6ccf3af1d34509e5fb1f5bff675b9ae707ad628/guava-27.0.1-jre.pom
com.google.guava/guava/27.0.1-jre/bd41a290787b5301e63929676d792c507bbc00ae/guava-27.0.1-jre.jar
com.google.guava/guava/28.1-android/ad4f915dab2e5fecba3f440f8f77244647b96499/guava-28.1-android.pom
com.google.guava/guava/28.1-jre/1207be0906dcc3e4984e8daa60b389e2ebd0a7cd/guava-28.1-jre.pom
com.google.guava/guava/28.2-jre/360b614be6dda1311de8b0704e0caf0221262cce/guava-28.2-jre.pom
com.google.guava/guava/28.2-jre/8ec9ed76528425762174f0011ce8f74ad845b756/guava-28.2-jre.jar
com.google.guava/guava/30.0-android/12aff8dd7211f090c35e4c51a4256f1d5569c2e7/guava-30.0-android.jar
com.google.guava/guava/30.0-android/5e199fea9fbcc5061bd8a9f0ca002cea8713e0e5/guava-30.0-android.pom
com.google.guava/guava/30.1-jre/4056c9385578a442117d1a68118def38087164da/guava-30.1-jre.pom
com.google.guava/guava/30.1.1-android/34ff41652a00ad8949b211d60d2573f857330678/guava-30.1.1-android.pom
com.google.guava/guava/30.1.1-android/5963ed171d561cca6f14659f3439b46a1633ab13/guava-30.1.1-android.jar
com.google.guava/guava/30.1.1-jre/87e0fd1df874ea3cbe577702fe6f17068b790fd8/guava-30.1.1-jre.jar
com.google.guava/guava/30.1.1-jre/f55555f43cb33c8c2f911e962ae5e4bc2f522b0/guava-30.1.1-jre.pom
com.google.guava/guava/31.1-android/9222c47cc3ae890f07f7c961bbb3cb69050fe4aa/guava-31.1-android.jar
com.google.guava/guava/31.1-android/d3b929509399a698915b24ff47db781d0c526760/guava-31.1-android.pom
com.google.guava/guava/31.1-jre/3a6ac93765fbbc416179f7c7127b9ddddbf38d9/guava-31.1-jre.pom
com.google.guava/guava/31.1-jre/60458f877d055d0c9114d9e1a2efb737b4bc282c/guava-31.1-jre.jar
com.google.guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/1b77ba79f9b2b7dfd4e15ea7bb0d568d5eb9cb8d/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.pom
com.google.guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/b421526c5f297295adef1c886e5246c39d4ac629/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar
com.google.http-client/google-http-client-apache-v2/1.34.0/1acaee31d0a84e264b6ea58a02a31d8c2c351e0d/google-http-client-apache-v2-1.34.0.jar
com.google.http-client/google-http-client-apache-v2/1.34.0/7a56ccee161d1e17b39b6fc641d0e9d8eb7fd3e7/google-http-client-apache-v2-1.34.0.pom
com.google.http-client/google-http-client-bom/1.30.1/859ebf25048d7ef18421fe86b3b3b6a9d7c4b673/google-http-client-bom-1.30.1.pom
com.google.http-client/google-http-client-bom/1.32.1/134068ac6f14d261b268dda3a9441e4f831e5b6/google-http-client-bom-1.32.1.pom
com.google.http-client/google-http-client-bom/1.40.1/2f9931a959fbe97d4ce31462f6f1dfedc9e085d5/google-http-client-bom-1.40.1.pom
com.google.http-client/google-http-client-bom/1.41.0/6d673924eb084b991e9d37162add839c98c9f465/google-http-client-bom-1.41.0.pom
com.google.http-client/google-http-client-gson/1.41.0/1a754a5dd672218a2ac667d7ff2b28df7a5a240e/google-http-client-gson-1.41.0.jar
com.google.http-client/google-http-client-gson/1.41.0/38293ef013a7e0aaf9eac816da1cd1581ed66363/google-http-client-gson-1.41.0.pom
com.google.http-client/google-http-client-jackson2/1.32.1/5b158d4b8c26daa4340fd0497b6824975f9f11e7/google-http-client-jackson2-1.32.1.pom
com.google.http-client/google-http-client-jackson2/1.32.1/9bae3bc3b295fa5f281f105e4ab41094f06e83d8/google-http-client-jackson2-1.32.1.jar
com.google.http-client/google-http-client-parent/1.32.1/4ed400ce416cb560284a6bdf4206be97c36de145/google-http-client-parent-1.32.1.pom
com.google.http-client/google-http-client-parent/1.34.0/6e3b546349513ee888f5bf10014f663cb95d8177/google-http-client-parent-1.34.0.pom
com.google.http-client/google-http-client-parent/1.41.0/c766296014d0245f8ef3e64c88755e4e2bdc183d/google-http-client-parent-1.41.0.pom
com.google.http-client/google-http-client/1.34.0/263190d4ea87727af0d632d40ee4dc40716b1597/google-http-client-1.34.0.jar
com.google.http-client/google-http-client/1.34.0/36e3300e709414203bcfb52f4771a79fda5e6631/google-http-client-1.34.0.pom
com.google.http-client/google-http-client/1.41.0/6334215e876a7bda17072910e16b150868a7018b/google-http-client-1.41.0.jar
com.google.http-client/google-http-client/1.41.0/63419b79ad451fcc041ddee82e880a585cae9878/google-http-client-1.41.0.pom
com.google.j2objc/j2objc-annotations/1.1/b964a9414771661bdf35a3f10692a2fb0dd2c866/j2objc-annotations-1.1.pom
com.google.j2objc/j2objc-annotations/1.1/ed28ded51a8b1c6b112568def5f4b455e6809019/j2objc-annotations-1.1.jar
com.google.j2objc/j2objc-annotations/1.3/47e0dd93285dcc6b33181713bc7e8aed66742964/j2objc-annotations-1.3.pom
com.google.j2objc/j2objc-annotations/1.3/ba035118bc8bac37d7eff77700720999acd9986d/j2objc-annotations-1.3.jar
com.google.jimfs/jimfs-parent/1.1/2283f99a6aa73205190a20cfd35078e9f7d6cec9/jimfs-parent-1.1.pom
com.google.jimfs/jimfs/1.1/380866e1e495f899631b6e1d437e4b0a69e4faa3/jimfs-1.1.pom
com.google.jimfs/jimfs/1.1/8fbd0579dc68aba6186935cc1bee21d2f3e7ec1c/jimfs-1.1.jar
com.google.oauth-client/google-oauth-client-bom/1.30.1/5c5a6ff2cd9f8668ed2c1fd83c0923b3dec2a51d/google-oauth-client-bom-1.30.1.pom
com.google.osdetector/com.google.osdetector.gradle.plugin/1.7.0/45841a8fa2f734e55ccf891aa885b3dcf92fc1e7/com.google.osdetector.gradle.plugin-1.7.0.pom
com.google.protobuf/com.google.protobuf.gradle.plugin/0.8.19/8cd94a4131e49c755ce637057b3d4e08d68e00be/com.google.protobuf.gradle.plugin-0.8.19.pom
com.google.protobuf/protobuf-bom/3.10.0/4414dc69051a62cfdc674d840525f94f8979f408/protobuf-bom-3.10.0.pom
com.google.protobuf/protobuf-bom/3.19.2/64293bb00ea01eb8f529139c1f750d44f5f035a9/protobuf-bom-3.19.2.pom
com.google.protobuf/protobuf-bom/3.21.7/a4559522905c7d59992a01cfdb1b1e501b265144/protobuf-bom-3.21.7.pom
com.google.protobuf/protobuf-gradle-plugin/0.8.19/26206656bad32c22019ce1ae1806328b9d500d9e/protobuf-gradle-plugin-0.8.19.pom
com.google.protobuf/protobuf-gradle-plugin/0.8.19/7c122b7af82bd14df3501c1a748e79ab452a3c55/protobuf-gradle-plugin-0.8.19.jar
com.google.protobuf/protobuf-java-util/3.10.0/a68c906db83e93babbb4024ce91e7441bb7598dd/protobuf-java-util-3.10.0.jar
com.google.protobuf/protobuf-java-util/3.10.0/dd9dbd5ae7e5c6978bb725c387aaeb2dc07dfddb/protobuf-java-util-3.10.0.pom
com.google.protobuf/protobuf-java-util/3.21.7/8cb6e090c555e0e8bbbca42286952c3f5ae810d3/protobuf-java-util-3.21.7.pom
com.google.protobuf/protobuf-java-util/3.21.7/b379ede46ca813491f8588d1ab981cbf627e7dcc/protobuf-java-util-3.21.7.jar
com.google.protobuf/protobuf-java/3.10.0/410b61dd0088aab4caa05739558d43df248958c9/protobuf-java-3.10.0.jar
com.google.protobuf/protobuf-java/3.10.0/db94f4481e9ef506c7dfdbb0d059892aa283ab1a/protobuf-java-3.10.0.pom
com.google.protobuf/protobuf-java/3.21.7/96cfc7147192f1de72c3d7d06972155ffb7d180c/protobuf-java-3.21.7.jar
com.google.protobuf/protobuf-java/3.21.7/cfa3ced7f798d592b492e18a0a10bfd498a3f8/protobuf-java-3.21.7.pom
com.google.protobuf/protobuf-java/3.4.0/100272b91d96ed5b41df4bb11ba543140c36bd30/protobuf-java-3.4.0.pom
com.google.protobuf/protobuf-java/3.4.0/b32aba0cbe737a4ca953f71688725972e3ee927c/protobuf-java-3.4.0.jar
com.google.protobuf/protobuf-javalite/3.21.7/82b692be08383107fd1c6d44474b56df411edd27/protobuf-javalite-3.21.7.jar
com.google.protobuf/protobuf-javalite/3.21.7/b5207183f705cea2bf570715fb143c0f9461817/protobuf-javalite-3.21.7.pom
com.google.protobuf/protobuf-parent/3.10.0/92e4373db52230866c0352b343e3f83f25812c77/protobuf-parent-3.10.0.pom
com.google.protobuf/protobuf-parent/3.21.7/98fbd3a9ba3d13e4e3fbbd5aca93c78c3fe5e8c9/protobuf-parent-3.21.7.pom
com.google.protobuf/protobuf-parent/3.4.0/5d9f2b22310a535c4597b4ed3691e000221b3a17/protobuf-parent-3.4.0.pom
com.google.re2j/re2j/1.5/2ddd41c99436fa2b3cd9d26880541d7f3349828a/re2j-1.5.jar
com.google.re2j/re2j/1.5/5f8ad2dd0336ab66fb0215acc7a1d6e342f52ce5/re2j-1.5.pom
com.google.re2j/re2j/1.6/5665de1d1de34458aa0a1314a2e9777abe0619d9/re2j-1.6.pom
com.google.re2j/re2j/1.6/a13e879fd7971738d06020fefeb108cc14e14169/re2j-1.6.jar
com.google.testing.platform/core-proto/0.0.8-alpha01/305b6a8b905b9c117bc03761b4a1171a5b306685/core-proto-0.0.8-alpha01.pom
com.google.testing.platform/core-proto/0.0.8-alpha01/f107a202fcbb34706f08e7fb8c31ea25bf504d7c/core-proto-0.0.8-alpha01.jar
com.google.truth/truth-parent/1.0.1/ea474ed732e39616038245f134f408400a5150c0/truth-parent-1.0.1.pom
com.google.truth/truth/1.0.1/361459309085bd9441cb97b62f160e8b353a93c0/truth-1.0.1.jar
com.google.truth/truth/1.0.1/a762cf9d8fb591a526da0e2449803cd56fe7e8c7/truth-1.0.1.pom
com.google/google/1/c35a5268151b7a1bbb77f7ee94a950f00e32db61/google-1.pom
com.googlecode.java-diff-utils/diffutils/1.3.0/7d5e372ff32c90095800f96d8308c41af0285a41/diffutils-1.3.0.pom
com.googlecode.java-diff-utils/diffutils/1.3.0/7e060dd5b19431e6d198e91ff670644372f60fbd/diffutils-1.3.0.jar
com.googlecode.javaewah/JavaEWAH/1.1.6/759dda489d69ebd237d9ee353e67a460274b14f0/JavaEWAH-1.1.6.pom
com.googlecode.javaewah/JavaEWAH/1.1.6/94ad16d728b374d65bd897625f3fbb3da223a2b6/JavaEWAH-1.1.6.jar
com.googlecode.json-simple/json-simple/1.1/5e303a03d04e6788dddfa3655272580ae0fc13bb/json-simple-1.1.jar
com.googlecode.json-simple/json-simple/1.1/a2c3a73d894b86ac979b88be6537b284eb4bf916/json-simple-1.1.pom
com.googlecode.juniversalchardet/juniversalchardet/1.0.3/be6da8320adedafc712d645ddaaad00357b55408/juniversalchardet-1.0.3.pom
com.googlecode.juniversalchardet/juniversalchardet/1.0.3/cd49678784c46aa8789c060538e0154013bb421b/juniversalchardet-1.0.3.jar
com.jcraft/jsch/0.1.55/4960f6d19a24a432ed88262d2ef704fd37dbedd7/jsch-0.1.55.pom
com.jcraft/jsch/0.1.55/bbd40e5aa7aa3cfad5db34965456cee738a42a50/jsch-0.1.55.jar
com.jcraft/jzlib/1.1.1/a1551373315ffc2f96130a0e5704f74e151777ba/jzlib-1.1.1.jar
com.jcraft/jzlib/1.1.1/d990b68017884e9615990c39ef81cf2b5884d464/jzlib-1.1.1.pom
com.lmax/disruptor/3.4.2/97ce4834b8f02cbcdbaf6d1b8a146eaf4506ff0a/disruptor-3.4.2.pom
com.lmax/disruptor/3.4.2/e2543a63086b4189fbe418d05d56633bc1a815f7/disruptor-3.4.2.jar
com.puppycrawl.tools/checkstyle/6.17/1e838dffd2d94aca1da5b1ad42ae5400cd90e5d0/checkstyle-6.17.pom
com.puppycrawl.tools/checkstyle/6.17/a56892c3f5ab3e37329db531ace7b835df076015/checkstyle-6.17.jar
com.squareup.okhttp/okhttp/2.7.4/be9d156a8c5b63e56002f4d17340896355751202/okhttp-2.7.4.pom
com.squareup.okhttp/okhttp/2.7.4/f2c0782541a970b3c15f5e742999ca264b34d0bd/okhttp-2.7.4.jar
com.squareup.okhttp/okhttp/2.7.5/7a15a7db50f86c4b64aa3367424a60e3a325b8f1/okhttp-2.7.5.jar
com.squareup.okhttp/okhttp/2.7.5/c0e46fa7785ffa7947fb225e3c655df4d9ff8fb9/okhttp-2.7.5.pom
com.squareup.okhttp/parent/2.7.4/c036dcfbbdb5fb46c19aacd35e8bdd475c4dc40b/parent-2.7.4.pom
com.squareup.okhttp/parent/2.7.5/e56e28b93b60622eb120ae2caaeac1efb60a8918/parent-2.7.5.pom
com.squareup.okio/okio-parent/1.17.5/29b3e230ec3e4a07f4e5da4f110c53d941e0d8cb/okio-parent-1.17.5.pom
com.squareup.okio/okio-parent/1.6.0/208f2d22b9d4c8a3022120bc102c59e0b2be1911/okio-parent-1.6.0.pom
com.squareup.okio/okio/1.17.5/34336f82f14dde1c0752fd5f0546dbf3c3225aba/okio-1.17.5.jar
com.squareup.okio/okio/1.17.5/9ef2d5b00fbbbb09307bfe38464c6831a3df1a96/okio-1.17.5.pom
com.squareup.okio/okio/1.6.0/98476622f10715998eacf9240d6b479f12c66143/okio-1.6.0.jar
com.squareup.okio/okio/1.6.0/f1130f411594ddc3124991b298c5af9424e4beec/okio-1.6.0.pom
com.squareup/javapoet/1.10.0/111612d623e9d2047798f13324fcb29966f080e3/javapoet-1.10.0.pom
com.squareup/javapoet/1.10.0/712c178d35185d8261295913c9f2a7d6867a6007/javapoet-1.10.0.jar
com.squareup/javawriter/2.5.0/81241ff7078ef14f42ea2a8995fa09c096256e6b/javawriter-2.5.0.jar
com.squareup/javawriter/2.5.0/d932f2476f65ecd95dcd6fd8c568b3f466f6a482/javawriter-2.5.0.pom
com.sun.activation/all/1.2.0/9b1023e38195ea19d1a0ac79192d486da1904f97/all-1.2.0.pom
com.sun.activation/all/1.2.1/efca912f55f71e63ab2eb82552519b66dd123f98/all-1.2.1.pom
com.sun.activation/javax.activation/1.2.0/bdb776ae9b888b7ad8f9f424b9e67837eae916c5/javax.activation-1.2.0.pom
com.sun.activation/javax.activation/1.2.0/bf744c1e2776ed1de3c55c8dac1057ec331ef744/javax.activation-1.2.0.jar
com.sun.istack/istack-commons-runtime/3.0.8/d6a97364045aa6b99bf2d3c566a3f98599c2d296/istack-commons-runtime-3.0.8.jar
com.sun.istack/istack-commons-runtime/3.0.8/fd5dfcff9a1f1e7e4371c6a998b74ee0e52bdc4a/istack-commons-runtime-3.0.8.pom
com.sun.istack/istack-commons/3.0.8/3835dae3b9e529039b70bce883a1c7438713c295/istack-commons-3.0.8.pom
com.sun.xml.bind.mvn/jaxb-parent/2.3.2/5d96ada92105844d8a2eedfb63bf782a712cc0a/jaxb-parent-2.3.2.pom
com.sun.xml.bind.mvn/jaxb-runtime-parent/2.3.2/b9916bbbf37042807a649a2a7fcb6b97e193c28a/jaxb-runtime-parent-2.3.2.pom
com.sun.xml.bind.mvn/jaxb-txw-parent/2.3.2/1f872b3cb7c49c35501651aab063659a9775f06a/jaxb-txw-parent-2.3.2.pom
com.sun.xml.bind/jaxb-bom-ext/2.3.2/7a92d12e31a67bae498f840c8f7c334a4fee0fbb/jaxb-bom-ext-2.3.2.pom
com.sun.xml.fastinfoset/FastInfoset/1.2.16/4eb6a0adad553bf759ffe86927df6f3b848c8bea/FastInfoset-1.2.16.jar
com.sun.xml.fastinfoset/FastInfoset/1.2.16/e4d2eed02e0e0a9f4c892e6d43bdf3dfdc1fa2ee/FastInfoset-1.2.16.pom
com.sun.xml.fastinfoset/fastinfoset-project/1.2.16/86113f7ee9a5d995429bf75294b57b31f0a17d29/fastinfoset-project-1.2.16.pom
commons-beanutils/commons-beanutils/1.8.0/483da4e14bedeb5a1d4d2b1914e02396f6380154/commons-beanutils-1.8.0.pom
commons-beanutils/commons-beanutils/1.8.0/c651d5103c649c12b20d53731643e5fffceb536/commons-beanutils-1.8.0.jar
commons-beanutils/commons-beanutils/1.9.2/5748d82b6a32272a9df8607ed3753ffd00a05ceb/commons-beanutils-1.9.2.pom
commons-beanutils/commons-beanutils/1.9.2/7a87d845ad3a155297e8f67d9008f4c1e5656b71/commons-beanutils-1.9.2.jar
commons-cli/commons-cli/1.3.1/1303efbc4b181e5a58bf2e967dc156a3132b97c0/commons-cli-1.3.1.jar
commons-cli/commons-cli/1.3.1/7cfa08c046e048faf18b68b26742d3185d49fa94/commons-cli-1.3.1.pom
commons-codec/commons-codec/1.10/44b9477418d2942d45550f7e7c66c16262062d0e/commons-codec-1.10.pom
commons-codec/commons-codec/1.11/3acb4705652e16236558f0f4f2192cc33c3bd189/commons-codec-1.11.jar
commons-codec/commons-codec/1.11/93ee1760aba62d6896d578bd7d247d0fa52f0e7/commons-codec-1.11.pom
commons-codec/commons-codec/1.15/49d94806b6e3dc933dacbd8acb0fdbab8ebd1e5d/commons-codec-1.15.jar
commons-codec/commons-codec/1.15/c08f2dcdbba1a9466f3f9fa05e669fd61c3a47b7/commons-codec-1.15.pom
commons-collections/commons-collections/3.2.1/761ea405b9b37ced573d2df0d1e3a4e0f9edc668/commons-collections-3.2.1.jar
commons-collections/commons-collections/3.2.1/c812635cfb96cd2431ee315e73418eed86aeb5e4/commons-collections-3.2.1.pom
commons-io/commons-io/2.11.0/3fe5d6ebed1afb72c3e8c166dba0b0e00fdd1f16/commons-io-2.11.0.pom
commons-io/commons-io/2.11.0/a2503f302b11ebde7ebc3df41daebe0e4eea3689/commons-io-2.11.0.jar
commons-io/commons-io/2.4/9ece23effe8bce3904f3797a76b1ba6ab681e1b9/commons-io-2.4.pom
commons-io/commons-io/2.4/b1b6ea3b7e4aa4f492509a4952029cd8e48019ad/commons-io-2.4.jar
commons-lang/commons-lang/2.4/16313e02a793435009f1e458fa4af5d879f6fb11/commons-lang-2.4.jar
commons-lang/commons-lang/2.4/dadd4b8eb8f55df27c1e7f9083cb8223bd3e357e/commons-lang-2.4.pom
commons-lang/commons-lang/2.6/347d60b180fa80e5699d8e2cb72c99c93dda5454/commons-lang-2.6.pom
commons-lang/commons-lang/2.6/ce1edb914c94ebc388f086c6827e8bdeec71ac2/commons-lang-2.6.jar
commons-logging/commons-logging/1.1.1/76672afb562b9e903674ad3a544cdf2092f1faa3/commons-logging-1.1.1.pom
commons-logging/commons-logging/1.2/4bfc12adfe4842bf07b657f0369c4cb522955686/commons-logging-1.2.jar
commons-logging/commons-logging/1.2/75c03ba4b01932842a996ef8d3fc1ab61ddeac2/commons-logging-1.2.pom
gradle.plugin.com.github.johnrengelman/shadow/7.1.2/5939ec4270be8e6e908769bcbf3e1ba146de597f/shadow-7.1.2.pom
gradle.plugin.com.github.johnrengelman/shadow/7.1.2/5ac2940270cdbcb2252d35a8b6be42c5efe7930f/shadow-7.1.2.jar
gradle.plugin.com.google.cloud.tools/jib-gradle-plugin/3.2.1/24d387706445523b8b99d5a5aa814edb1be3fdb6/jib-gradle-plugin-3.2.1.pom
gradle.plugin.com.google.cloud.tools/jib-gradle-plugin/3.2.1/d2c1a3cdcf0b7d99a9327e93ffbf9f33737e9a97/jib-gradle-plugin-3.2.1.jar
gradle.plugin.com.google.gradle/osdetector-gradle-plugin/1.7.0/8653feb38852ae0dca6fa3a3d5974b55c9292639/osdetector-gradle-plugin-1.7.0.pom
gradle.plugin.com.google.gradle/osdetector-gradle-plugin/1.7.0/f17fa284233d81e878f9fe448fba34abb1a5ae/osdetector-gradle-plugin-1.7.0.jar
gradle.plugin.org.kt3k.gradle.plugin/coveralls-gradle-plugin/2.12.0/65125f7d52312bf3fca1697971c285cd1b5bef77/coveralls-gradle-plugin-2.12.0.jar
gradle.plugin.org.kt3k.gradle.plugin/coveralls-gradle-plugin/2.12.0/8ac3c81169ad398c7daf10a1094748c71b52c9dd/coveralls-gradle-plugin-2.12.0.pom
io.github.devatherock/jul-jsonformatter/1.1.0/1523c060f2765c3ae8c3ab1486106d989b9a7c58/jul-jsonformatter-1.1.0.pom
io.github.devatherock/jul-jsonformatter/1.1.0/1656427a3f3b872ec4b036186ed79dccce2889d9/jul-jsonformatter-1.1.0.jar
io.github.java-diff-utils/java-diff-utils/4.0/764316bbb1ed16ce8977740a5bc6c3934b68e0dd/java-diff-utils-4.0.pom
io.github.java-diff-utils/java-diff-utils/4.0/cda66ef45db96b93c75ad7c2f85301d293f8f5c6/java-diff-utils-4.0.jar
io.grpc/grpc-auth/1.27.2/7af91099b5bd3ff3b308652579df29d215219703/grpc-auth-1.27.2.jar
io.grpc/grpc-auth/1.27.2/a80c2b30b4bbf10dc70bb52074ba6477ebcbfb79/grpc-auth-1.27.2.pom
io.grpc/grpc-auth/1.6.1/7d92aed4885519987a3965e6ebbb6585a2f6bd59/grpc-auth-1.6.1.jar
io.grpc/grpc-auth/1.6.1/f873a9aafd402eadfa09f280e8abb941da834498/grpc-auth-1.6.1.pom
io.grpc/grpc-bom/1.43.1/16af027e60dd554a4e9ed64f00f050a76d7c5db7/grpc-bom-1.43.1.pom
io.grpc/grpc-context/1.22.1/1a074f9cf6f367b99c25e70dc68589f142f82d11/grpc-context-1.22.1.jar
io.grpc/grpc-context/1.22.1/1d1aa7f12ef9dfc266ff7caddacdc8b6a690bd8b/grpc-context-1.22.1.pom
io.grpc/grpc-context/1.27.2/5486f796fba991aab67a42e134a8b3ceca7a19dc/grpc-context-1.27.2.pom
io.grpc/grpc-context/1.6.1/69b365c36af4b43448495b3c195b5a45a3b230b6/grpc-context-1.6.1.pom
io.grpc/grpc-context/1.6.1/9c52ae577c2dd4b8c6ac6e49c1154e1dc37d98ee/grpc-context-1.6.1.jar
io.grpc/grpc-core/1.6.1/871c934f3c7fbb477ccf2dd4c2a47a0bcc1b82a9/grpc-core-1.6.1.jar
io.grpc/grpc-core/1.6.1/df17e989381273dfa8096ef22c90db053c6a9509/grpc-core-1.6.1.pom
io.grpc/grpc-grpclb/1.6.1/160e2fcae81c409a5c68adf805dbd52143453f9a/grpc-grpclb-1.6.1.jar
io.grpc/grpc-grpclb/1.6.1/1707b0067f78ed7d1a6418d99017ac439b555d11/grpc-grpclb-1.6.1.pom
io.grpc/grpc-netty-shaded/1.27.2/18ad2f0f245d276f1a244b5a5bfcaebb71ba7a1e/grpc-netty-shaded-1.27.2.jar
io.grpc/grpc-netty-shaded/1.27.2/6fe2df0769aed00a7ce786a4467ffd0457134ac3/grpc-netty-shaded-1.27.2.pom
io.grpc/grpc-netty-shaded/1.43.2/1a9d1398a727bbd5045e150c46c173d09d69737/grpc-netty-shaded-1.43.2.pom
io.grpc/grpc-netty-shaded/1.43.2/e4399db174148350bcd0462aba267b4cdef63f03/grpc-netty-shaded-1.43.2.jar
io.grpc/grpc-netty/1.6.1/6941e41b5f422da1670d5d01bf476644330b536e/grpc-netty-1.6.1.jar
io.grpc/grpc-netty/1.6.1/d5d115193ba28c43613d8a8c5799a0291beba83a/grpc-netty-1.6.1.pom
io.grpc/grpc-okhttp/1.6.1/33bfa743d19621d453aad885a8ff49a68c30520b/grpc-okhttp-1.6.1.pom
io.grpc/grpc-okhttp/1.6.1/b8b87068b478759937cd6b83c1f3f57e5057dcfa/grpc-okhttp-1.6.1.jar
io.grpc/grpc-protobuf-lite/1.6.1/124bca81a50bc76b6a6babcc4bc529e5a93db70f/grpc-protobuf-lite-1.6.1.jar
io.grpc/grpc-protobuf-lite/1.6.1/4c142b3992594decb634f39285c399e4e4e59796/grpc-protobuf-lite-1.6.1.pom
io.grpc/grpc-protobuf/1.6.1/a309df5d2627422ceb9cb08fb6a240656d75760a/grpc-protobuf-1.6.1.jar
io.grpc/grpc-protobuf/1.6.1/b187f4981d7a2f26ef9fbdc8650e52f1c521eac4/grpc-protobuf-1.6.1.pom
io.grpc/grpc-services/1.43.2/640afe074fbd01203b9805528d43d7005d8b7f84/grpc-services-1.43.2.jar
io.grpc/grpc-services/1.43.2/d7fa84927d2e749f826047e264608c5fb63ad5d2/grpc-services-1.43.2.pom
io.grpc/grpc-stub/1.6.1/e55ee05dd94d47ce132cdd44825e8e3f499307cc/grpc-stub-1.6.1.pom
io.grpc/grpc-stub/1.6.1/f32b7ad69749ab6c7be5dd21f1e520a315418790/grpc-stub-1.6.1.jar
io.grpc/grpc-testing/1.6.1/233059f9224f21167ae5e2fb4e86a3123e160b4f/grpc-testing-1.6.1.pom
io.grpc/grpc-testing/1.6.1/57b3135c24c7766cd7c299edae142e3ed484dee9/grpc-testing-1.6.1.jar
io.grpc/grpc-xds/1.43.2/dd1be194bbfbb51dba50796351e9f8680070cc2a/grpc-xds-1.43.2.pom
io.grpc/grpc-xds/1.43.2/f5e1e4e2b112a442e71d8b41870d701b94d6e6b3/grpc-xds-1.43.2.jar
io.netty/netty-buffer/4.1.79.Final/278d38da37281d57723f53d88b18cb256214e8d5/netty-buffer-4.1.79.Final.pom
io.netty/netty-buffer/4.1.79.Final/6c014412b599489b1db27c6bc08d8a46da94e397/netty-buffer-4.1.79.Final.jar
io.netty/netty-codec-http/4.1.79.Final/3c1161dbd45180071f319c8313cdbc37eacaf67a/netty-codec-http-4.1.79.Final.pom
io.netty/netty-codec-http/4.1.79.Final/882c70bc0a30a98bf3ce477f043e967ac026044c/netty-codec-http-4.1.79.Final.jar
io.netty/netty-codec-http2/4.1.79.Final/c2c1b534afb78b7e5013daa8fed06e74b845ddbc/netty-codec-http2-4.1.79.Final.pom
io.netty/netty-codec-http2/4.1.79.Final/eeffab0cd5efb699d5e4ab9b694d32fef6694b3/netty-codec-http2-4.1.79.Final.jar
io.netty/netty-codec-socks/4.1.79.Final/683a602694460e4d1562352e63374eb68186b9f/netty-codec-socks-4.1.79.Final.pom
io.netty/netty-codec-socks/4.1.79.Final/794a5937cdb1871c4ae350610752dec2929dc1d6/netty-codec-socks-4.1.79.Final.jar
io.netty/netty-codec/4.1.79.Final/18f5b02af7ca611978bc28f2cb58cbb3b9b0f0ef/netty-codec-4.1.79.Final.jar
io.netty/netty-codec/4.1.79.Final/66a5b0edbb512b1d520ad4991cb0f0971268702e/netty-codec-4.1.79.Final.pom
io.netty/netty-common/4.1.79.Final/2814bd465731355323aba0fdd22163bfce638a75/netty-common-4.1.79.Final.jar
io.netty/netty-common/4.1.79.Final/291da62a03c1197186e4e53ef26979e2bdcf9dc7/netty-common-4.1.79.Final.pom
io.netty/netty-handler-proxy/4.1.79.Final/54aace8683de7893cf28d4aab72cd60f49b5700/netty-handler-proxy-4.1.79.Final.jar
io.netty/netty-handler-proxy/4.1.79.Final/addd320a9460f0ae3bfd2e78d304429fbc936b78/netty-handler-proxy-4.1.79.Final.pom
io.netty/netty-handler/4.1.79.Final/2dc22423c8ed19906615fb936a5fcb7db14a4e6c/netty-handler-4.1.79.Final.jar
io.netty/netty-handler/4.1.79.Final/ce5c4d89397334d649f48f4320120d0d0f829438/netty-handler-4.1.79.Final.pom
io.netty/netty-parent/4.1.79.Final/d3cd2b09d7f19b980c3d505ab716e56cd45c7f00/netty-parent-4.1.79.Final.pom
io.netty/netty-resolver/4.1.79.Final/55ecb1ff4464b56564a90824a741c3911264aaa4/netty-resolver-4.1.79.Final.jar
io.netty/netty-resolver/4.1.79.Final/c30f7d7312732c4cda964765fd77c3c1d401a787/netty-resolver-4.1.79.Final.pom
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/28c15df4932f2df393a2b0425f97b2713fd6833f/netty-tcnative-boringssl-static-2.0.54.Final-linux-x86_64.jar
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/36672782c88f52b2d3533a1a420cc3b3ed3f404f/netty-tcnative-boringssl-static-2.0.54.Final-linux-aarch_64.jar
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/6ef1b6b565c2c007ed158c3ccd018a06df4627cf/netty-tcnative-boringssl-static-2.0.54.Final-osx-aarch_64.jar
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/72642c5cc6dfb055e3ae7de4dbed2ae66705b3e6/netty-tcnative-boringssl-static-2.0.54.Final.pom
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/b55fe4d12dff3daf695f5cf7f726c6b54fcec3f/netty-tcnative-boringssl-static-2.0.54.Final-osx-x86_64.jar
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/da9fb08256396c74ecdfebbb34be3ed261784d9c/netty-tcnative-boringssl-static-2.0.54.Final-windows-x86_64.jar
io.netty/netty-tcnative-boringssl-static/2.0.54.Final/f0c7625ee93ba70bc2cf38b9c662e82e2a81975c/netty-tcnative-boringssl-static-2.0.54.Final.jar
io.netty/netty-tcnative-classes/2.0.54.Final/998c2b1cb267c3eaf7a01dc362482a62ac7f4533/netty-tcnative-classes-2.0.54.Final.jar
io.netty/netty-tcnative-classes/2.0.54.Final/a4986f6ca487afc7f9b5e934877dd66ce0a97787/netty-tcnative-classes-2.0.54.Final.pom
io.netty/netty-tcnative-parent/2.0.54.Final/1a425f84c6bc8888bf87acc5913ae9c40336d58a/netty-tcnative-parent-2.0.54.Final.pom
io.netty/netty-transport-classes-epoll/4.1.79.Final/33504530ef339853639054454f787076d0f9832c/netty-transport-classes-epoll-4.1.79.Final.pom
io.netty/netty-transport-classes-epoll/4.1.79.Final/e7d4b2a35f76ab061acc999e60ed87e8386f2fa5/netty-transport-classes-epoll-4.1.79.Final.jar
io.netty/netty-transport-native-epoll/4.1.79.Final/26f1c61096c264dead91d9699be662b1499f5913/netty-transport-native-epoll-4.1.79.Final-linux-x86_64.jar
io.netty/netty-transport-native-epoll/4.1.79.Final/750b002ba4ea21f3d2f086c1c3492a8b61e2360c/netty-transport-native-epoll-4.1.79.Final-linux-aarch_64.jar
io.netty/netty-transport-native-epoll/4.1.79.Final/9c6ab610351cede1c585ce3684c8ec3cee5f1bb3/netty-transport-native-epoll-4.1.79.Final.pom
io.netty/netty-transport-native-epoll/4.1.79.Final/b6afca057f59891337326364a97cb23e72b303c2/netty-transport-native-epoll-4.1.79.Final.jar
io.netty/netty-transport-native-unix-common/4.1.79.Final/3876edd52922a0ffae2ccf06e3c04a6a9cdd2f5e/netty-transport-native-unix-common-4.1.79.Final.pom
io.netty/netty-transport-native-unix-common/4.1.79.Final/731937caec938b77b39df932a8da8aaca8d5ec05/netty-transport-native-unix-common-4.1.79.Final.jar
io.netty/netty-transport/4.1.79.Final/2c6ef401bdc60ebc46641509bbba72e2d2fb4f51/netty-transport-4.1.79.Final.pom
io.netty/netty-transport/4.1.79.Final/6cc2b49749b4fbcc39c687027e04e65e857552a9/netty-transport-4.1.79.Final.jar
io.opencensus/opencensus-api/0.24.0/ad702faf9bf2eef71759e20f49461b9211fe6f7c/opencensus-api-0.24.0.pom
io.opencensus/opencensus-api/0.24.0/f974451b19007ce820f433311ce8adb88e2b7d2c/opencensus-api-0.24.0.jar
io.opencensus/opencensus-api/0.28.0/10c5792549b6fd80f7da919318525b0ab9b47614/opencensus-api-0.28.0.pom
io.opencensus/opencensus-api/0.28.0/fc0d06a9d975a38c581dff59b99cf31db78bd99/opencensus-api-0.28.0.jar
io.opencensus/opencensus-api/0.31.0/6634f10ecd5eb3ac248f3ed5ee727c9a28c841bd/opencensus-api-0.31.0.jar
io.opencensus/opencensus-api/0.31.0/eebfb33763af627bf5061f34f7242a9ec799522c/opencensus-api-0.31.0.pom
io.opencensus/opencensus-contrib-exemplar-util/0.31.0/2ff352a41b7d6dbb4a2ae59142511b6ebcc8b207/opencensus-contrib-exemplar-util-0.31.0.pom
io.opencensus/opencensus-contrib-exemplar-util/0.31.0/a445c56cbb2cf79451449c4182788188ed5a843e/opencensus-contrib-exemplar-util-0.31.0.jar
io.opencensus/opencensus-contrib-grpc-metrics/0.31.0/bde79aa5440a4652419e432b78c3bbcf71b7e566/opencensus-contrib-grpc-metrics-0.31.0.pom
io.opencensus/opencensus-contrib-grpc-metrics/0.31.0/dafedf702ffa303ce28217b02288973775f49f92/opencensus-contrib-grpc-metrics-0.31.0.jar
io.opencensus/opencensus-contrib-http-util/0.24.0/6d96406c272d884038eb63b262458df75b5445/opencensus-contrib-http-util-0.24.0.jar
io.opencensus/opencensus-contrib-http-util/0.24.0/b693347533d4fc8b6ae9ef856eebc8f80769787c/opencensus-contrib-http-util-0.24.0.pom
io.opencensus/opencensus-contrib-http-util/0.28.0/1b522269fef6585d55098e183de5c678b5e443bd/opencensus-contrib-http-util-0.28.0.pom
io.opencensus/opencensus-contrib-http-util/0.28.0/f6cb276330197d51dd65327fc305a3df7e622705/opencensus-contrib-http-util-0.28.0.jar
io.opencensus/opencensus-contrib-resource-util/0.31.0/f63b361b53abad78538de4113ebfe9865a79bf1d/opencensus-contrib-resource-util-0.31.0.pom
io.opencensus/opencensus-contrib-resource-util/0.31.0/f99cdb766157bba8a7df1033ec00ff2d11a797ee/opencensus-contrib-resource-util-0.31.0.jar
io.opencensus/opencensus-exporter-metrics-util/0.31.0/23f2acb45869e59c6199cdf071f0d58440989229/opencensus-exporter-metrics-util-0.31.0.pom
io.opencensus/opencensus-exporter-metrics-util/0.31.0/e79445dbef35ca5e1255c01257fed7461638ef34/opencensus-exporter-metrics-util-0.31.0.jar
io.opencensus/opencensus-exporter-stats-stackdriver/0.31.0/4b7edb65452da93fc9b576c8f0a612f1f6c053ed/opencensus-exporter-stats-stackdriver-0.31.0.jar
io.opencensus/opencensus-exporter-stats-stackdriver/0.31.0/b4fcc713af9e930f5ce7c6388b83699390b20fe0/opencensus-exporter-stats-stackdriver-0.31.0.pom
io.opencensus/opencensus-exporter-trace-stackdriver/0.31.0/27fd9ca23b28f08ea12ff072658fb79446e89385/opencensus-exporter-trace-stackdriver-0.31.0.pom
io.opencensus/opencensus-exporter-trace-stackdriver/0.31.0/64c78a30c5e23094e7281fb4563525f3bd3d74e5/opencensus-exporter-trace-stackdriver-0.31.0.jar
io.opencensus/opencensus-impl-core/0.31.0/7cc49deb92f2cf906e053e8af5211a52dec437c9/opencensus-impl-core-0.31.0.jar
io.opencensus/opencensus-impl-core/0.31.0/84d025094ef1dd230621af503df88e03e6d9f23e/opencensus-impl-core-0.31.0.pom
io.opencensus/opencensus-impl/0.31.0/108c98ee4916759228cd505e84f36572b8f58a85/opencensus-impl-0.31.0.pom
io.opencensus/opencensus-impl/0.31.0/31fff001ba3442a9a36750bd3f195919161afc1a/opencensus-impl-0.31.0.jar
io.opencensus/opencensus-proto/0.2.0/3f19eb8f63c7bbec1f0741b76380dde17131a1f1/opencensus-proto-0.2.0.pom
io.opencensus/opencensus-proto/0.2.0/c05b6b32b69d5d9144087ea0ebc6fab183fb9151/opencensus-proto-0.2.0.jar
io.perfmark/perfmark-api/0.25.0/256709242dce8dddfd8d3e24dde21995048c3f0a/perfmark-api-0.25.0.pom
io.perfmark/perfmark-api/0.25.0/340a0c3d81cdcd9ecd7dc2ae00fb2633b469b157/perfmark-api-0.25.0.jar
it.unimi.dsi/fastutil/8.4.0/60fbeaa50799581f6244fcff1cebba0353ec0141/fastutil-8.4.0.jar
it.unimi.dsi/fastutil/8.4.0/7ec92f6e71ce4abebde5cebd574a6f27528959d7/fastutil-8.4.0.pom
jakarta.activation/jakarta.activation-api/1.2.1/562a587face36ec7eff2db7f2fc95425c6602bc1/jakarta.activation-api-1.2.1.jar
jakarta.activation/jakarta.activation-api/1.2.1/b9c1b2502949970360efe8d75ec5268d87d38a82/jakarta.activation-api-1.2.1.pom
jakarta.xml.bind/jakarta.xml.bind-api-parent/2.3.2/7be72e8345e33f747d5d813e313abd8df25f259e/jakarta.xml.bind-api-parent-2.3.2.pom
jakarta.xml.bind/jakarta.xml.bind-api/2.3.2/6142021e7186bf29f5f7639b968cfe250ce086dd/jakarta.xml.bind-api-2.3.2.pom
jakarta.xml.bind/jakarta.xml.bind-api/2.3.2/8d49996a4338670764d7ca4b85a1c4ccf7fe665d/jakarta.xml.bind-api-2.3.2.jar
javax.activation/activation/1.1/e6cb541461c2834bdea3eb920f1884d1eb508b50/activation-1.1.jar
javax.activation/activation/1.1/fd9dd0faa8f03f3ce0dc4eec22e57e818d8b9897/activation-1.1.pom
javax.annotation/javax.annotation-api/1.3.2/302fe96ef206b17f82893083b51b479541fa25ab/javax.annotation-api-1.3.2.pom
javax.annotation/javax.annotation-api/1.3.2/934c04d3cfef185a8008e7bf34331b79730a9d43/javax.annotation-api-1.3.2.jar
javax.inject/javax.inject/1/6975da39a7040257bd51d21a231b76c915872d38/javax.inject-1.jar
javax.inject/javax.inject/1/b8e00a8a0deb0ebef447570e37ff8146ccd92cbe/javax.inject-1.pom
javax.servlet/servlet-api/2.5/5959582d97d8b61f4d154ca9e495aafd16726e34/servlet-api-2.5.jar
javax.servlet/servlet-api/2.5/a159fa05cce714c83deff647655dd53db064b21c/servlet-api-2.5.pom
junit/junit/4.12/2973d150c0dc1fefe998f834810d68f278ea58ec/junit-4.12.jar
junit/junit/4.12/35fb238baee3f3af739074d723279ebea2028398/junit-4.12.pom
kr.motd.maven/os-maven-plugin/1.7.0/a4a427508bb685263764f245f25ae971f442d094/os-maven-plugin-1.7.0.pom
kr.motd.maven/os-maven-plugin/1.7.0/c50a6b3cb49e24d96b1252619a3c600c08796193/os-maven-plugin-1.7.0.jar
me.champeau.gradle.japicmp/me.champeau.gradle.japicmp.gradle.plugin/0.3.0/ffe408d731de246a2a5dd545cdd4899468131c61/me.champeau.gradle.japicmp.gradle.plugin-0.3.0.pom
me.champeau.gradle/japicmp-gradle-plugin/0.3.0/3037b8affba5fa5a0013fa529ce146009e20389/japicmp-gradle-plugin-0.3.0.jar
me.champeau.gradle/japicmp-gradle-plugin/0.3.0/8f1327bcd0b2cb7879d067276504cdebcf6dcf36/japicmp-gradle-plugin-0.3.0.pom
me.champeau.jmh/jmh-gradle-plugin/0.6.6/554e39ffa637d1293dc913574d732802304b30e8/jmh-gradle-plugin-0.6.6.pom
me.champeau.jmh/jmh-gradle-plugin/0.6.6/ed111718946eba5796567456c63f48083f3f8ce7/jmh-gradle-plugin-0.6.6.jar
me.champeau.jmh/me.champeau.jmh.gradle.plugin/0.6.6/92f6c9bfb95bef041f7c58bd4cc72dea70650002/me.champeau.jmh.gradle.plugin-0.6.6.pom
net.bytebuddy/byte-buddy-agent/1.10.5/d1c949ee74c3421ffd3d9159c867777ded928448/byte-buddy-agent-1.10.5.jar
net.bytebuddy/byte-buddy-agent/1.10.5/ff5249283e247e83ca52318c199a37d07c87a9c6/byte-buddy-agent-1.10.5.pom
net.bytebuddy/byte-buddy-parent/1.10.5/6dcc6df682d0de2a216bc9952960ca83f8e9b1f7/byte-buddy-parent-1.10.5.pom
net.bytebuddy/byte-buddy/1.10.5/d39f2a6c7a3550e03fb12a870e0829b0fa87f036/byte-buddy-1.10.5.jar
net.bytebuddy/byte-buddy/1.10.5/f82260b7f4dad0d5560c571be5fcf4bfc7856473/byte-buddy-1.10.5.pom
net.java.dev.jna/jna-platform/5.6.0/d18424ffb8bbfd036d71bcaab9b546858f2ef986/jna-platform-5.6.0.jar
net.java.dev.jna/jna-platform/5.6.0/f86d5b088d311a7dee895e06cb2a08ccada7cbde/jna-platform-5.6.0.pom
net.java.dev.jna/jna/5.6.0/330f2244e9030119ab3030fc3fededc86713d9cc/jna-5.6.0.jar
net.java.dev.jna/jna/5.6.0/e542808a6326ec0302c0b09011cb4363e1ece380/jna-5.6.0.pom
net.java/jvnet-parent/1/b55a1b046dbe82acdee8edde7476eebcba1e57d8/jvnet-parent-1.pom
net.java/jvnet-parent/3/f8f3be3e980551a39b5679411e171aeb6931aaec/jvnet-parent-3.pom
net.ltgt.errorprone/net.ltgt.errorprone.gradle.plugin/2.0.2/62bebd434c8734fa63dd3e2ad0e650c643901cbe/net.ltgt.errorprone.gradle.plugin-2.0.2.pom
net.ltgt.gradle/gradle-errorprone-plugin/2.0.2/65fe741fa6c02dbf0c56b9e8c2684384c85f0ca0/gradle-errorprone-plugin-2.0.2.jar
net.ltgt.gradle/gradle-errorprone-plugin/2.0.2/cff5014d4ff0a044c2da317dfbf3f13e500c76ae/gradle-errorprone-plugin-2.0.2.pom
net.sf.androidscents.signature/android-api-level-14/4.0_r4/6e6fa4fd1c502c408c3d1ce92ea4e77dcb5aaba9/android-api-level-14-4.0_r4.signature
net.sf.androidscents.signature/android-api-level-14/4.0_r4/9e78bf7f55c47e53fa2f57903b58f9aa8fd3ae5e/android-api-level-14-4.0_r4.pom
net.sf.androidscents.signature/android-api-level-19/4.4.2_r4/2bbd4b4fbfab29bce0fb82fbd95bb406203ea366/android-api-level-19-4.4.2_r4.pom
net.sf.androidscents/androidscents-parent/1/8bfcb9a9f82d4d033408b2482192bfca18a1a6bf/androidscents-parent-1.pom
net.sf.ezmorph/ezmorph/1.0.6/1e55d2a0253ea37745d33062852fd2c90027432/ezmorph-1.0.6.jar
net.sf.ezmorph/ezmorph/1.0.6/525ab6696d703a52adb42dfb48ec9b1d4e9fb8b0/ezmorph-1.0.6.pom
net.sf.jopt-simple/jopt-simple/4.6/306816fb57cf94f108a43c95731b08934dcae15c/jopt-simple-4.6.jar
net.sf.jopt-simple/jopt-simple/4.6/c6b45d57089efa973a68f3bdf8fc6b125fa532ee/jopt-simple-4.6.pom
net.sf.jopt-simple/jopt-simple/4.9/ea3cd0a93e4e8adc1cdadd544c9168bc5aa985a8/jopt-simple-4.9.pom
net.sf.jopt-simple/jopt-simple/4.9/ee9e9eaa0a35360dcfeac129ff4923215fd65904/jopt-simple-4.9.jar
net.sf.json-lib/json-lib/2.3/88bc1ed6a0d53b2f433aa412ac5badd219875a66/json-lib-2.3.pom
net.sf.json-lib/json-lib/2.3/f35340c0a0380141f62c72b76c8fb4bfa638d8c1/json-lib-2.3-jdk15.jar
net.sf.kxml/kxml2/2.3.0/8efa75f9cdc57687076b2125b1a098e6f42e737d/kxml2-2.3.0.pom
net.sf.kxml/kxml2/2.3.0/ccbc77a5fd907ef863c29f3596c6f54ffa4e9442/kxml2-2.3.0.jar
net.sf.proguard/proguard-base/6.0.3/7135739d2d3834964c543ed21e2936ce34747aca/proguard-base-6.0.3.jar
net.sf.proguard/proguard-base/6.0.3/d53b864b20f6ab75c66017adcb06c44a912a2076/proguard-base-6.0.3.pom
net.sf.proguard/proguard-gradle/6.0.3/6583a613d9b6d02a699d4dd24d8b8825da3d8e8b/proguard-gradle-6.0.3.pom
net.sf.proguard/proguard-gradle/6.0.3/e5becf2356695a396b788110e386c38bad523bfc/proguard-gradle-6.0.3.jar
net.sf.proguard/proguard-parent/6.0.3/f76c32555b227be8f5d8c753ccc7f49c5196345e/proguard-parent-6.0.3.pom
net.sourceforge.nekohtml/nekohtml/1.9.16/1f90944625f3dfba92086aa6d7959105dc1381c/nekohtml-1.9.16.pom
net.sourceforge.nekohtml/nekohtml/1.9.16/61e35204e5a8fdb864152f84e2e3b33ab56f50ab/nekohtml-1.9.16.jar
org.antlr/antlr4-master/4.5.2-1/4e87b0d0b499acf795e1304a58dc68bcdd8ed614/antlr4-master-4.5.2-1.pom
org.antlr/antlr4-master/4.5.3/c7e4123f86c15b492adba2fc5377949c4ea43946/antlr4-master-4.5.3.pom
org.antlr/antlr4-runtime/4.5.2-1/6c4013c6b772dd3e8cc00837ccf5edd7619e8d21/antlr4-runtime-4.5.2-1.pom
org.antlr/antlr4-runtime/4.5.2-1/7fe31fde811943a1970cc97359557c57747026ef/antlr4-runtime-4.5.2-1.jar
org.antlr/antlr4/4.5.3/9ecf07c69a057cb13cea8a153d242007f5cc8003/antlr4-4.5.3.pom
org.antlr/antlr4/4.5.3/f35db7e4b2446e4174ba6a73db7bd6b3e6bb5da1/antlr4-4.5.3.jar
org.apache.ant/ant-launcher/1.10.11/b7a6baf478827a41351061b89bde2fd23d0328f5/ant-launcher-1.10.11.pom
org.apache.ant/ant-launcher/1.10.11/ea0a0475fb6dfcdcf48b30410fd9d4f5c80df07e/ant-launcher-1.10.11.jar
org.apache.ant/ant-parent/1.10.11/f5464a5be0dc72f4fb6b283d30c9daa76dd10e47/ant-parent-1.10.11.pom
org.apache.ant/ant/1.10.11/72f702c7d8de0de614e2b93409146197157e1d63/ant-1.10.11.pom
org.apache.ant/ant/1.10.11/b875cd48a0bc955ae9c5c477ad991e1f26fb24d2/ant-1.10.11.jar
org.apache.commons/commons-compress/1.20/a63d6a48347a2848f6a798c9efad976829011f7c/commons-compress-1.20.pom
org.apache.commons/commons-compress/1.20/b8df472b31e1f17c232d2ad78ceb1c84e00c641b/commons-compress-1.20.jar
org.apache.commons/commons-compress/1.21/4ec95b60d4e86b5c95a0e919cb172a0af98011ef/commons-compress-1.21.jar
org.apache.commons/commons-compress/1.21/f9f4f26a1ea08778cc818c1555587741605bb4da/commons-compress-1.21.pom
org.apache.commons/commons-math3/3.2/7828e6c3b4118e5a2f8350db99e60a2be2e3ce29/commons-math3-3.2.pom
org.apache.commons/commons-math3/3.2/ec2544ab27e110d2d431bdad7d538ed509b21e62/commons-math3-3.2.jar
org.apache.commons/commons-math3/3.6.1/d0ee0ddf185d57393ae8fb5cc28bba6efff7389c/commons-math3-3.6.1.pom
org.apache.commons/commons-math3/3.6.1/e4ba98f1d4b3c80ec46392f25e094a6a2e58fcbf/commons-math3-3.6.1.jar
org.apache.commons/commons-parent/11/3f29657e1e3d6856344728ddbcf696477e943d59/commons-parent-11.pom
org.apache.commons/commons-parent/17/84bc2f457fac92c947cde9c15c81786ded79b3c1/commons-parent-17.pom
org.apache.commons/commons-parent/25/67b84199ca4acf0d8fbc5256d90b80f746737e94/commons-parent-25.pom
org.apache.commons/commons-parent/28/9ff25b2866ef063a8828ba67d1e35c78f73e830a/commons-parent-28.pom
org.apache.commons/commons-parent/33/a9bd6ae1e11cb313ec4a4c9bcd58c7a9ea60a5cd/commons-parent-33.pom
org.apache.commons/commons-parent/34/1f6be162a806d8343e3cd238dd728558532473a5/commons-parent-34.pom
org.apache.commons/commons-parent/35/d88c24ebb385e5404f34573f24362b17434e3f33/commons-parent-35.pom
org.apache.commons/commons-parent/37/a85dfae7a1295e5aed75bd952e6795832e4abcc5/commons-parent-37.pom
org.apache.commons/commons-parent/39/4bc32d3cda9f07814c548492af7bf19b21798d46/commons-parent-39.pom
org.apache.commons/commons-parent/42/35d45eda74fe511d3d60b68e1dac29ed55043354/commons-parent-42.pom
org.apache.commons/commons-parent/48/1cdeb626cf4f0cec0f171ec838a69922efc6ef95/commons-parent-48.pom
org.apache.commons/commons-parent/5/a0a168281558e7ae972f113fa128bc46b4973edd/commons-parent-5.pom
org.apache.commons/commons-parent/52/4ee86dedc66d0010ccdc29e5a4ce014c057854/commons-parent-52.pom
org.apache.commons/commons-parent/9/217cc375e25b647a61956e1d6a88163f9e3a387c/commons-parent-9.pom
org.apache.httpcomponents/httpclient/4.2.1/83298fccf32e7416cd85584bedc3cfe13dac7750/httpclient-4.2.1.pom
org.apache.httpcomponents/httpclient/4.5.10/1022b146f63aded20cf4fe7f1e6be83b95e104e6/httpclient-4.5.10.pom
org.apache.httpcomponents/httpclient/4.5.10/7ca2e4276f4ef95e4db725a8cd4a1d1e7585b9e5/httpclient-4.5.10.jar
org.apache.httpcomponents/httpclient/4.5.11/7a07893a7adfa1a23e8af49d64d41243e2eac8cd/httpclient-4.5.11.pom
org.apache.httpcomponents/httpclient/4.5.11/f6d42fee5110c227bac18a550a297e028f2fb21a/httpclient-4.5.11.jar
org.apache.httpcomponents/httpclient/4.5.13/e5b134e5cd3e28dc431ca5397e9b53d28d1cfa74/httpclient-4.5.13.pom
org.apache.httpcomponents/httpclient/4.5.13/e5f6cae5ca7ecaac1ec2827a9e2d65ae2869cada/httpclient-4.5.13.jar
org.apache.httpcomponents/httpclient/4.5.6/db40edda8b95d880d2a810560fd5e46eb4fa6909/httpclient-4.5.6.pom
org.apache.httpcomponents/httpcomponents-client/4.2.1/e30c6fc39878b543ecf15d45d804d2d9e646f749/httpcomponents-client-4.2.1.pom
org.apache.httpcomponents/httpcomponents-client/4.5.10/39ab210aa188f90f0fe88b24633a793dc7001ab0/httpcomponents-client-4.5.10.pom
org.apache.httpcomponents/httpcomponents-client/4.5.11/35bcf92e8e6aa56efcc8918322ac68be654f5407/httpcomponents-client-4.5.11.pom
org.apache.httpcomponents/httpcomponents-client/4.5.13/61045e5bac5f6b0a7e3301053de0d78fc92f09db/httpcomponents-client-4.5.13.pom
org.apache.httpcomponents/httpcomponents-client/4.5.6/135a0a91d1ad2909b08196580ef2c363932bb87e/httpcomponents-client-4.5.6.pom
org.apache.httpcomponents/httpcomponents-core/4.4.10/43dd1af3c408840fa4d19679da7db9c8dec9f7fa/httpcomponents-core-4.4.10.pom
org.apache.httpcomponents/httpcomponents-core/4.4.12/20aa4b420a2a3be42a3cfdfcd3c3130db752038b/httpcomponents-core-4.4.12.pom
org.apache.httpcomponents/httpcomponents-core/4.4.13/221f9ef52d6147e7c193f540c495db26f25d64b6/httpcomponents-core-4.4.13.pom
org.apache.httpcomponents/httpcomponents-core/4.4.15/3533a4d4bbf8fb489bc20795ba2826d3a95baa7d/httpcomponents-core-4.4.15.pom
org.apache.httpcomponents/httpcomponents-parent/10/1ba3c5940f24525444492ae12b6a1015df8a477b/httpcomponents-parent-10.pom
org.apache.httpcomponents/httpcomponents-parent/11/3ee7a841cc49326e8681089ea7ad6a3b81b88581/httpcomponents-parent-11.pom
org.apache.httpcomponents/httpcore/4.4.10/cbbf1989463d9f3e284c1348e50ea8bf426e4e1c/httpcore-4.4.10.pom
org.apache.httpcomponents/httpcore/4.4.12/21ebaf6d532bc350ba95bd81938fa5f0e511c132/httpcore-4.4.12.jar
org.apache.httpcomponents/httpcore/4.4.12/cf09664de14114fcfd6fe080a8bf9e7aea0c3783/httpcore-4.4.12.pom
org.apache.httpcomponents/httpcore/4.4.13/7d4610db34bf2175d0d3813d7faac9cf7ca7c0e5/httpcore-4.4.13.pom
org.apache.httpcomponents/httpcore/4.4.13/853b96d3afbb7bf8cc303fe27ee96836a10c1834/httpcore-4.4.13.jar
org.apache.httpcomponents/httpcore/4.4.15/7f2e0c573eaa7a74bac2e89b359e1f73d92a0a1d/httpcore-4.4.15.jar
org.apache.httpcomponents/httpcore/4.4.15/fcd592279d3c26678aad344894e20f9a01102a16/httpcore-4.4.15.pom
org.apache.httpcomponents/httpmime/4.5.11/a0da6f21987ce0cf521b39f97f7a4e9480b05e54/httpmime-4.5.11.jar
org.apache.httpcomponents/httpmime/4.5.11/e67919e2c3376188cd9edb48831948afd433be97/httpmime-4.5.11.pom
org.apache.httpcomponents/httpmime/4.5.6/164343da11db817e81e24e0d9869527e069850c9/httpmime-4.5.6.jar
org.apache.httpcomponents/httpmime/4.5.6/b9dcad423fba1978379049cf0cf3cf535c667af7/httpmime-4.5.6.pom
org.apache.httpcomponents/project/6/66760f9423ccea444890e51a0c1fc6220baa6bbe/project-6.pom
org.apache.logging.log4j/log4j-api/2.17.1/6761bf5b5204fdb16605513364e53ef8438a3aa8/log4j-api-2.17.1.pom
org.apache.logging.log4j/log4j-api/2.17.1/d771af8e336e372fb5399c99edabe0919aeaf5b2/log4j-api-2.17.1.jar
org.apache.logging.log4j/log4j-core/2.17.1/779f60f3844dadc3ef597976fcb1e5127b1f343d/log4j-core-2.17.1.jar
org.apache.logging.log4j/log4j-core/2.17.1/eb8b8548c75f74638bcfc530c03892cc22b589f8/log4j-core-2.17.1.pom
org.apache.logging.log4j/log4j/2.17.1/a2dfa3b5d5ad65dcd6cb19dc721ea3c35d81a13e/log4j-2.17.1.pom
org.apache.logging/logging-parent/3/5aacbd3590605400bd3b29892751c6d70d810a75/logging-parent-3.pom
org.apache.tomcat/annotations-api/6.0.53/94cfa8a6ebc6b36e966bff433d4eeebf933f3f41/annotations-api-6.0.53.jar
org.apache.tomcat/annotations-api/6.0.53/ca221338c1220d12088398b7b6676a4d0f416874/annotations-api-6.0.53.pom
org.apache/apache/13/15aff1faaec4963617f07dbe8e603f0adabc3a12/apache-13.pom
org.apache/apache/15/95c70374817194cabfeec410fe70c3a6b832bafe/apache-15.pom
org.apache/apache/16/8a90e31780e5cd0685ccaf25836c66e3b4e163b7/apache-16.pom
org.apache/apache/18/bd408bbea3840f2c7f914b29403e39a90f84fd5f/apache-18.pom
org.apache/apache/21/649b700a1b2b4a1d87e7ae8e3f47bfe101b2a4a5/apache-21.pom
org.apache/apache/23/404949e96725e63a10a6d8f9d9b521948d170d5/apache-23.pom
org.apache/apache/3/1bc0010136a890e2fd38d901a0b7ecdf0e3f9871/apache-3.pom
org.apache/apache/4/602b647986c1d24301bc3d70e5923696bc7f1401/apache-4.pom
org.apache/apache/7/a5f679b14bb06a3cb3769eb04e228c8b9e12908f/apache-7.pom
org.apache/apache/9/de55d73a30c7521f3d55e8141d360ffbdfd88caa/apache-9.pom
org.bouncycastle/bcpg-jdk15on/1.61/422656435514ab8a28752b117d5d2646660a0ace/bcpg-jdk15on-1.61.jar
org.bouncycastle/bcpg-jdk15on/1.61/7932e6f9fcc6293993c676f3acec5a45e9dec043/bcpg-jdk15on-1.61.pom
org.bouncycastle/bcpkix-jdk15on/1.56/2e2e47a19e0c53e7d204a6ad071c9e64c7c4c43f/bcpkix-jdk15on-1.56.pom
org.bouncycastle/bcpkix-jdk15on/1.56/4648af70268b6fdb24674fb1fd7c1fcc73db1231/bcpkix-jdk15on-1.56.jar
org.bouncycastle/bcpkix-jdk15on/1.61/6789be8b6e12bc0120ff315d1342f1b93d284d8c/bcpkix-jdk15on-1.61.pom
org.bouncycastle/bcpkix-jdk15on/1.61/89bb3aa5b98b48e584eee2a7401b7682a46779b4/bcpkix-jdk15on-1.61.jar
org.bouncycastle/bcpkix-jdk15on/1.67/2e8437c0c4f64198b37d21ecec695e6cf3cc86d0/bcpkix-jdk15on-1.67.pom
org.bouncycastle/bcpkix-jdk15on/1.67/5f48020a2a60a8d6bcbecceca23529d225b28efb/bcpkix-jdk15on-1.67.jar
org.bouncycastle/bcprov-jdk15on/1.56/16220ab4e1b41786b0396e908ed91437c620ee3c/bcprov-jdk15on-1.56.pom
org.bouncycastle/bcprov-jdk15on/1.56/a153c6f9744a3e9dd6feab5e210e1c9861362ec7/bcprov-jdk15on-1.56.jar
org.bouncycastle/bcprov-jdk15on/1.61/df4b474e71be02c1349c3292d98886f888d1f7/bcprov-jdk15on-1.61.jar
org.bouncycastle/bcprov-jdk15on/1.61/e226b538a0426e269cadeb162b0db45d0274c7dc/bcprov-jdk15on-1.61.pom
org.bouncycastle/bcprov-jdk15on/1.67/8c0998045da87dbc2f1d4b6480458ed811ca7b82/bcprov-jdk15on-1.67.jar
org.bouncycastle/bcprov-jdk15on/1.67/c622f23fc3d1acf7c0cf66755ad7455781c4d489/bcprov-jdk15on-1.67.pom
org.checkerframework/checker-compat-qual/2.5.5/435dc33e3019c9f019e15f01aa111de9d6b2b79c/checker-compat-qual-2.5.5.jar
org.checkerframework/checker-compat-qual/2.5.5/493796785b3c508c4c25e539321218511bd1c1ae/checker-compat-qual-2.5.5.pom
org.checkerframework/checker-qual/2.10.0/5786699a0cb71f9dc32e6cca1d665eef07a0882f/checker-qual-2.10.0.jar
org.checkerframework/checker-qual/2.10.0/aaceb55005b10d5e636a249169afc6d579618fa9/checker-qual-2.10.0.pom
org.checkerframework/checker-qual/2.5.2/7cee753353b0fc94e0300ad3dbf155069260c4d7/checker-qual-2.5.2.pom
org.checkerframework/checker-qual/2.5.2/cea74543d5904a30861a61b4643a5f2bb372efc4/checker-qual-2.5.2.jar
org.checkerframework/checker-qual/2.5.8/5eb0c9262e891ee4dfa3410b9be611e47c79779f/checker-qual-2.5.8.pom
org.checkerframework/checker-qual/3.12.0/d5692f0526415fcc6de94bb5bfbd3afd9dd3b3e5/checker-qual-3.12.0.jar
org.checkerframework/checker-qual/3.12.0/fb8dca6f40fcb30f7b89de269940bf3316fb9845/checker-qual-3.12.0.pom
org.checkerframework/checker-qual/3.20.0/6318ad604fc1a7753c1672ce0b3f85db0b1735b1/checker-qual-3.20.0.pom
org.checkerframework/checker-qual/3.20.0/c13d84bf34ed1a652c44bf73fe8a97d4f1ce17ff/checker-qual-3.20.0.jar
org.checkerframework/checker-qual/3.5.0/408a4451ff5bdef60400a49657867db100ea0f83/checker-qual-3.5.0.pom
org.checkerframework/checker-qual/3.8.0/3436c1d07252b6eefe053d8ef380ab251813f359/checker-qual-3.8.0.pom
org.checkerframework/checker-qual/3.8.0/6b83e4a33220272c3a08991498ba9dc09519f190/checker-qual-3.8.0.jar
org.checkerframework/dataflow-errorprone/3.15.0/7004cda299790fb01db2cc452242d7657a232ae5/dataflow-errorprone-3.15.0.jar
org.checkerframework/dataflow-errorprone/3.15.0/e2ff733b144552b6bd8085d2ab5c17410115cff3/dataflow-errorprone-3.15.0.pom
org.codehaus.groovy.modules.http-builder/http-builder/0.7.1/96c528bf4e173a66cd2b846ab9619c10a78b4f04/http-builder-0.7.1.pom
org.codehaus.groovy.modules.http-builder/http-builder/0.7.1/a21771ae3da5ce9f5c4d7a60c1e716666aa2acf9/http-builder-0.7.1.jar
org.codehaus.mojo.signature/java17/1.0/150d716b05282cad6af6e63f847c230c1106575b/java17-1.0.signature
org.codehaus.mojo.signature/java17/1.0/47c3589d6c23cc3333e7468d25c80702d2f509b9/java17-1.0.pom
org.codehaus.mojo.signature/java18/1.0/a18665119edb4d4699d46a2f247c512c6fa5ede8/java18-1.0.pom
org.codehaus.mojo.signature/signatures-parent/1.2/e509fe2a3922aa79b0a913b4f979be7848fa6ee7/signatures-parent-1.2.pom
org.codehaus.mojo/animal-sniffer-annotations/1.17/80948bd07c5db60753d8d5a9164b8b2272e0842a/animal-sniffer-annotations-1.17.pom
org.codehaus.mojo/animal-sniffer-annotations/1.17/f97ce6decaea32b36101e37979f8b647f00681fb/animal-sniffer-annotations-1.17.jar
org.codehaus.mojo/animal-sniffer-annotations/1.21/419a9acd297cb6fe6f91b982d909f2c20e9fa5c0/animal-sniffer-annotations-1.21.jar
org.codehaus.mojo/animal-sniffer-annotations/1.21/4468907f1901b842bab7bc4c7ef16f84d6e576df/animal-sniffer-annotations-1.21.pom
org.codehaus.mojo/animal-sniffer-ant-tasks/1.18/894dad44e7280c41baa21e69f1598528ba74147b/animal-sniffer-ant-tasks-1.18.pom
org.codehaus.mojo/animal-sniffer-ant-tasks/1.18/d7680c00c162fd70129feeab82fd50a331b64386/animal-sniffer-ant-tasks-1.18.jar
org.codehaus.mojo/animal-sniffer-parent/1.17/eea4b805793494ebb025e5a9926ea3cf1ee8b34d/animal-sniffer-parent-1.17.pom
org.codehaus.mojo/animal-sniffer-parent/1.18/dd9080d0b2019e3cbb8b97dc7c057787062172f2/animal-sniffer-parent-1.18.pom
org.codehaus.mojo/animal-sniffer-parent/1.20/a1725fa054a1b943fa3a8e7ee72f1b57b507488d/animal-sniffer-parent-1.20.pom
org.codehaus.mojo/animal-sniffer-parent/1.21/33f21501882f382578c943ddf5e9035de80ee9fa/animal-sniffer-parent-1.21.pom
org.codehaus.mojo/animal-sniffer/1.18/38bf8ac5d9c7710dc0b19cc3f2db204cb69a4ff5/animal-sniffer-1.18.pom
org.codehaus.mojo/animal-sniffer/1.18/96ad9bc74a75d77884f5985a1601884db979d8ac/animal-sniffer-1.18.jar
org.codehaus.mojo/animal-sniffer/1.20/3d6d625c394579cd27e85f8980f0c3800f47bead/animal-sniffer-1.20.jar
org.codehaus.mojo/animal-sniffer/1.20/bb77674578a2cc39819c4a38c632547d71ca2fd1/animal-sniffer-1.20.pom
org.codehaus.mojo/mojo-parent/31/8dfcf4f187dc3f6ba3402e0dc5df5e0eeff62751/mojo-parent-31.pom
org.codehaus.mojo/mojo-parent/38/d1eff1fac710c195be11a8ac729f8b4735ffd3e3/mojo-parent-38.pom
org.codehaus.mojo/mojo-parent/40/d2fa7c95447827e9bbcb8c60bd9484c51202732e/mojo-parent-40.pom
org.codehaus.mojo/mojo-parent/50/8caf7f67d94e762418df68f034c88b6f18433860/mojo-parent-50.pom
org.codehaus.mojo/mojo-parent/61/11fdf4908dbf89fc128efc868ad990ad0a0a8b8a/mojo-parent-61.pom
org.codehaus.mojo/mojo-parent/65/599365e99855a082531d962070c67aeba360d0e/mojo-parent-65.pom
org.codehaus.plexus/plexus-utils/3.4.1/35061118d2f5f4fa1289b40656dfd7567ccc98b6/plexus-utils-3.4.1.pom
org.codehaus.plexus/plexus-utils/3.4.1/4de9992988c534efd668bfcca0480ebe13e0c0eb/plexus-utils-3.4.1.jar
org.codehaus.plexus/plexus/8/b3982e53f063775a9ab1d8522a5928ffadfcf54a/plexus-8.pom
org.codehaus/codehaus-parent/4/8b133202d50bec1e59bddc9392cb44d1fe5facc8/codehaus-parent-4.pom
org.conscrypt/conscrypt-openjdk-uber/2.5.2/68bfb5b8daeb0dc51aa96b1dd9254694183214bd/conscrypt-openjdk-uber-2.5.2.pom
org.conscrypt/conscrypt-openjdk-uber/2.5.2/d858f142ea189c62771c505a6548d8606ac098fe/conscrypt-openjdk-uber-2.5.2.jar
org.eclipse.ee4j/project/1.0.2/5730bedee1faaeeb62b0afc4ed1c4571f87a8eb4/project-1.0.2.pom
org.eclipse.ee4j/project/1.0.5/d391c5ed15d8fb1dadba9c5d1017006d56c50332/project-1.0.5.pom
org.eclipse.jgit/org.eclipse.jgit-parent/4.4.1.201607150455-r/65ce6e675c18f16d1c3a019d98e5e2b1b96e3104/org.eclipse.jgit-parent-4.4.1.201607150455-r.pom
org.eclipse.jgit/org.eclipse.jgit-parent/5.5.1.201910021850-r/c19dca7c869f8b2b3fd1fa3c7690e74a325affab/org.eclipse.jgit-parent-5.5.1.201910021850-r.pom
org.eclipse.jgit/org.eclipse.jgit/4.4.1.201607150455-r/4919cd4deb6c3321f548416e68f65143bdeeeba9/org.eclipse.jgit-4.4.1.201607150455-r.pom
org.eclipse.jgit/org.eclipse.jgit/4.4.1.201607150455-r/63998ced66e425d9e8bcd0c59f710c98f0c021ff/org.eclipse.jgit-4.4.1.201607150455-r.jar
org.eclipse.jgit/org.eclipse.jgit/5.5.1.201910021850-r/27301329c61100002e7a03841ab6367adaef507/org.eclipse.jgit-5.5.1.201910021850-r.pom
org.eclipse.jgit/org.eclipse.jgit/5.5.1.201910021850-r/e0ba7a468e8c62da8521ca3a06a061d4dde95223/org.eclipse.jgit-5.5.1.201910021850-r.jar
org.glassfish.jaxb/jaxb-bom/2.3.2/c7cd28b5d3871feba8cebf6d4587043fb0d6fd0a/jaxb-bom-2.3.2.pom
org.glassfish.jaxb/jaxb-runtime/2.3.2/5528bc882ea499a09d720b42af11785c4fc6be2a/jaxb-runtime-2.3.2.jar
org.glassfish.jaxb/jaxb-runtime/2.3.2/f46a0f023205138c366f0b0c9316f8663bb32a4f/jaxb-runtime-2.3.2.pom
org.glassfish.jaxb/txw2/2.3.2/22d24b523eb02a955e8bfa7af6572207a3490482/txw2-2.3.2.pom
org.glassfish.jaxb/txw2/2.3.2/ce5be7da2e442c25ec14c766cb60cb802741727b/txw2-2.3.2.jar
org.glassfish/javax.json/1.0.4/3178f73569fd7a1e5ffc464e680f7a8cc784b85a/javax.json-1.0.4.jar
org.glassfish/javax.json/1.0.4/d2e9a3dae7592cc57e1272dde8c7802da2dc9452/javax.json-1.0.4.pom
org.glassfish/json/1.0.4/eb133db30d301d71aa4710950f1f1e17d391f4d5/json-1.0.4.pom
org.hamcrest/hamcrest-core/1.3/42a25dc3219429f0e5d060061f71acb49bf010a0/hamcrest-core-1.3.jar
org.hamcrest/hamcrest-core/1.3/872e413497b906e7c9fa85ccc96046c5d1ef7ece/hamcrest-core-1.3.pom
org.hamcrest/hamcrest-parent/1.3/80391bd32bfa4837a15215d5e9f07c60555c379a/hamcrest-parent-1.3.pom
org.hdrhistogram/HdrHistogram/2.1.12/6eb7552156e0d517ae80cc2247be1427c8d90452/HdrHistogram-2.1.12.jar
org.hdrhistogram/HdrHistogram/2.1.12/9797702ee3e52e4be6bfbbc9fd20ac5447e7a541/HdrHistogram-2.1.12.pom
org.javassist/javassist/3.24.0-GA/d7466fc2e3af7c023e95c510f06448ad29b225b3/javassist-3.24.0-GA.jar
org.javassist/javassist/3.24.0-GA/eb5345e1531ecaee8f01c9b211f2fed81d400352/javassist-3.24.0-GA.pom
org.jdom/jdom2/2.0.6/11e250d112bc9f2a0e1a595a5f6ecd2802af2691/jdom2-2.0.6.pom
org.jdom/jdom2/2.0.6/6f14738ec2e9dd0011e343717fa624a10f8aab64/jdom2-2.0.6.jar
org.jetbrains.intellij.deps/trove4j/1.0.20181211/216c2e14b070f334479d800987affe4054cd563f/trove4j-1.0.20181211.jar
org.jetbrains.intellij.deps/trove4j/1.0.20181211/ad9cb821b804f05ed013ce89e3ec4d32d101bd79/trove4j-1.0.20181211.pom
org.jetbrains.kotlin/kotlin-reflect/1.4.31/5cfd82ac5a5ee1e1d60c94e7390070301f73853e/kotlin-reflect-1.4.31.pom
org.jetbrains.kotlin/kotlin-reflect/1.4.31/63db9d66c3d20f7b8f66196e7ba86969daae8b8a/kotlin-reflect-1.4.31.jar
org.jetbrains.kotlin/kotlin-stdlib-common/1.4.31/6dd50665802f54ba9bc3f70ecb20227d1bc81323/kotlin-stdlib-common-1.4.31.jar
org.jetbrains.kotlin/kotlin-stdlib-common/1.4.31/d954657abc560bd88f1045a5aaa1f9349957ccd7/kotlin-stdlib-common-1.4.31.pom
org.jetbrains.kotlin/kotlin-stdlib-jdk7/1.4.31/84ce8e85f6e84270b2b501d44e9f0ba6ff64fa71/kotlin-stdlib-jdk7-1.4.31.jar
org.jetbrains.kotlin/kotlin-stdlib-jdk7/1.4.31/9ad248cfa8fe2534a9138aaac3c94a12443031c/kotlin-stdlib-jdk7-1.4.31.pom
org.jetbrains.kotlin/kotlin-stdlib-jdk8/1.4.31/7ac4821d502469063c8c20fd4f73564b7b4ae215/kotlin-stdlib-jdk8-1.4.31.pom
org.jetbrains.kotlin/kotlin-stdlib-jdk8/1.4.31/e613be5465ef1e6fd0468707690b7ebf625ea2fe/kotlin-stdlib-jdk8-1.4.31.jar
org.jetbrains.kotlin/kotlin-stdlib/1.4.31/578554985765fe941f4fab7874e27b62dc1918db/kotlin-stdlib-1.4.31.pom
org.jetbrains.kotlin/kotlin-stdlib/1.4.31/a58e0fb9812a6a93ca24b5da75e4b5a0cb89c957/kotlin-stdlib-1.4.31.jar
org.jetbrains/annotations/13.0/919f0dfe192fb4e063e7dacadee7f8bb9a2672a9/annotations-13.0.jar
org.jetbrains/annotations/13.0/fa7d3d07cc80547e2d15bf4839d3267c637c642f/annotations-13.0.pom
org.json/json/20180813/218ad36b491e585397587a361b0a6d5c973eba53/json-20180813.pom
org.json/json/20180813/8566b2b0391d9d4479ea225645c6ed47ef17fe41/json-20180813.jar
org.junit/junit-bom/5.7.2/e8848369738c03e40af5507686216f9b8b44b6a3/junit-bom-5.7.2.pom
org.junit/junit-bom/5.8.1/c2c7f6a8e4d6724187175501f9de55f30148bdf0/junit-bom-5.8.1.pom
org.junit/junit-bom/5.8.2/90eab8a5a400f15b8e1cb6e65af0ceb616f23bba/junit-bom-5.8.2.pom
org.jvnet.staxex/stax-ex/1.8.1/78011e483a21102fb4858f3e8f269a677e50aa23/stax-ex-1.8.1.jar
org.jvnet.staxex/stax-ex/1.8.1/93132b1ebaf1c419ad3d2216924af39c68f43b51/stax-ex-1.8.1.pom
org.mockito/mockito-core/3.3.3/1f5ef203a284440a02e4c9f5ad6c7312c3832603/mockito-core-3.3.3.pom
org.mockito/mockito-core/3.3.3/4878395d4e63173f3825e17e5e0690e8054445f1/mockito-core-3.3.3.jar
org.mortbay.jetty.alpn/jetty-alpn-agent/2.0.10/1d86438f5ae71fcbf8c4d4a5359276ec70d8bea/jetty-alpn-agent-2.0.10.pom
org.mortbay.jetty.alpn/jetty-alpn-agent/2.0.10/8200ed4c92533ee1843004e8ace3b2b7881d6554/jetty-alpn-agent-2.0.10.jar
org.objenesis/objenesis-parent/2.6/cfc0966402e8174fbacd5c5dd355b5815364a4fe/objenesis-parent-2.6.pom
org.objenesis/objenesis/2.6/639033469776fd37c08358c6b92a4761feb2af4b/objenesis-2.6.jar
org.objenesis/objenesis/2.6/b6d1f689e0d2b2d96b0730fad7b5d96902bf64d8/objenesis-2.6.pom
org.openjdk.jmh/jmh-core/1.29/9d84f2bf7e527263180e7264f4e3a1e69425344a/jmh-core-1.29.pom
org.openjdk.jmh/jmh-core/1.29/c801e462e04b8403c93efb21b9d039689a0c6bd7/jmh-core-1.29.jar
org.openjdk.jmh/jmh-generator-asm/1.29/89b5f28e1a1ca744199770ec2df849ad24ff42bb/jmh-generator-asm-1.29.jar
org.openjdk.jmh/jmh-generator-asm/1.29/bd03db5cdabcac9df7fee14f601cf507fe4d78af/jmh-generator-asm-1.29.pom
org.openjdk.jmh/jmh-generator-bytecode/1.29/50b5a8017f8996a4b8a60db4173aa96d0da4089a/jmh-generator-bytecode-1.29.pom
org.openjdk.jmh/jmh-generator-bytecode/1.29/da930ad7e59da95aab2ef7107a70bff4f31647e2/jmh-generator-bytecode-1.29.jar
org.openjdk.jmh/jmh-generator-reflection/1.29/5107c3d0eceff99cf16aed2768bf04d0e138ef66/jmh-generator-reflection-1.29.jar
org.openjdk.jmh/jmh-generator-reflection/1.29/8d9fca3f001ee84c9c925314a3ea011f5dec72da/jmh-generator-reflection-1.29.pom
org.openjdk.jmh/jmh-parent/1.29/55ddf2e5719e456dfbfa5bc49dda0a661963748c/jmh-parent-1.29.pom
org.ow2.asm/asm-analysis/7.0/20186ccd5304839aea81893ebc65addc6ad4ca5e/asm-analysis-7.0.pom
org.ow2.asm/asm-analysis/7.0/4b310d20d6f1c6b7197a75f1b5d69f169bc8ac1f/asm-analysis-7.0.jar
org.ow2.asm/asm-analysis/9.2/467a33724d063fedc0a041e68af8fb17c06ebd94/asm-analysis-9.2.pom
org.ow2.asm/asm-analysis/9.2/7487dd756daf96cab9986e44b9d7bcb796a61c10/asm-analysis-9.2.jar
org.ow2.asm/asm-commons/7.0/478006d07b7c561ae3a92ddc1829bca81ae0cdd1/asm-commons-7.0.jar
org.ow2.asm/asm-commons/7.0/7b5da826fcab00989f748b7c4f72e75e668da210/asm-commons-7.0.pom
org.ow2.asm/asm-commons/9.2/8ee5279931bc860b7dd3a764c67ac1a7cb2bc07c/asm-commons-9.2.pom
org.ow2.asm/asm-commons/9.2/f4d7f0fc9054386f2893b602454d48e07d4fbead/asm-commons-9.2.jar
org.ow2.asm/asm-tree/7.0/29bc62dcb85573af6e62e5b2d735ef65966c4180/asm-tree-7.0.jar
org.ow2.asm/asm-tree/7.0/9a26ff62a5b01e4fa15ce96fcdb78738817d3066/asm-tree-7.0.pom
org.ow2.asm/asm-tree/9.2/2e168ad097e0b56f1aa6695a80982b8f455b1ba8/asm-tree-9.2.pom
org.ow2.asm/asm-tree/9.2/d96c99a30f5e1a19b0e609dbb19a44d8518ac01e/asm-tree-9.2.jar
org.ow2.asm/asm-util/7.0/18d4d07010c24405129a6dbb0e92057f8779fb9d/asm-util-7.0.jar
org.ow2.asm/asm-util/7.0/944ed3d072e935fe950cb08e6e5fabbec76d81b/asm-util-7.0.pom
org.ow2.asm/asm/7.0/c6b547ce67397df979bde680a1d0cdf8ceb63f6a/asm-7.0.pom
org.ow2.asm/asm/7.0/d74d4ba0dee443f68fb2dcb7fcdb945a2cd89912/asm-7.0.jar
org.ow2.asm/asm/9.0/938b82b2a78eb9b1d383a5fcb243a1801c6e2ea0/asm-9.0.pom
org.ow2.asm/asm/9.0/af582ff60bc567c42d931500c3fdc20e0141ddf9/asm-9.0.jar
org.ow2.asm/asm/9.1/927153d04a920d5f06a9a4aefd5f6be60726117d/asm-9.1.pom
org.ow2.asm/asm/9.1/a99500cf6eea30535eeac6be73899d048f8d12a8/asm-9.1.jar
org.ow2.asm/asm/9.2/81a03f76019c67362299c40e0ba13405f5467bff/asm-9.2.jar
org.ow2.asm/asm/9.2/b24408a1c2214bc57380faf45b37bd67be7732b5/asm-9.2.pom
org.ow2/ow2/1.5/d8edc69335f4d9f95f511716fb689c86fb0ebaae/ow2-1.5.pom
org.pcollections/pcollections/2.1.2/1561eb634b7d77f24b43056b0dc5dc529a008357/pcollections-2.1.2.pom
org.pcollections/pcollections/2.1.2/15925fd6c32a29fe3f40a048d238c5ca58cb8362/pcollections-2.1.2.jar
org.slf4j/slf4j-api/1.7.2/3fceb45ce8f7a6f87f3f2077a24a3833d1ecb4c6/slf4j-api-1.7.2.pom
org.slf4j/slf4j-api/1.7.2/81d61b7f33ebeab314e07de0cc596f8e858d97/slf4j-api-1.7.2.jar
org.slf4j/slf4j-parent/1.7.2/26c68730e36b29249e0c3bb70eba4a5dbaa4f76c/slf4j-parent-1.7.2.pom
org.sonatype.oss/oss-parent/4/281323f0e2b10184d6c6b230909401166b437e01/oss-parent-4.pom
org.sonatype.oss/oss-parent/5/3ae20880ad3d5da6b1caec19e3de7e70dd2dd762/oss-parent-5.pom
org.sonatype.oss/oss-parent/6/765c355ec09ad070065d9d12a9245bba5c689d96/oss-parent-6.pom
org.sonatype.oss/oss-parent/7/46b8a785b60a2767095b8611613b58577e96d4c9/oss-parent-7.pom
org.sonatype.oss/oss-parent/9/e5cdc4d23b86d79c436f16fed20853284e868f65/oss-parent-9.pom
org.tensorflow/tensorflow-lite-metadata/0.1.0-rc2/7aa9b3e16d85c2aae5eff741265315a37c9f731a/tensorflow-lite-metadata-0.1.0-rc2.jar
org.tensorflow/tensorflow-lite-metadata/0.1.0-rc2/d9f873d0c60a45135fbaffcca3ca575c11d5d89c/tensorflow-lite-metadata-0.1.0-rc2.pom
org.threeten/threetenbp/1.5.2/8e64f828bb8628e07a6e82d8cf316b269084d71c/threetenbp-1.5.2.pom
org.threeten/threetenbp/1.5.2/9aec3509609fc41f29ddc46119a124b8659e2c25/threetenbp-1.5.2.jar
org.vafer/jdependency/2.7.0/2046838b82c9a153c49e9bd3b3926b530e3f8d37/jdependency-2.7.0.pom
org.vafer/jdependency/2.7.0/402ee1ea1c872bf10e6ca8d47bf698697e75f98e/jdependency-2.7.0.jar
org.yaml/snakeyaml/1.21/18775fdda48574784f40b47bf478ab0593f92e4d/snakeyaml-1.21.jar
org.yaml/snakeyaml/1.21/c1f2acea3d242d534be2b0468b77f9a4969df205/snakeyaml-1.21.pom
ru.vyarus.animalsniffer/ru.vyarus.animalsniffer.gradle.plugin/1.5.4/9fc53b74ef7060468fa620ee17f9777f2afb3a4a/ru.vyarus.animalsniffer.gradle.plugin-1.5.4.pom
ru.vyarus/gradle-animalsniffer-plugin/1.5.4/400d2a9de0992840e6dd22ad25548ee39f41d19f/gradle-animalsniffer-plugin-1.5.4.pom
ru.vyarus/gradle-animalsniffer-plugin/1.5.4/614ea910e70b29d3f0fdc41688dc078fbaf93d12/gradle-animalsniffer-plugin-1.5.4.jar
ru.vyarus/gradle-animalsniffer-plugin/1.5.4/cf671e9cd5013ba356a61cdca60247f8887b033c/gradle-animalsniffer-plugin-1.5.4.pom
xerces/xercesImpl/2.12.0/673c91f8212d2f2add1a7557174af19069e87070/xercesImpl-2.12.0.pom
xerces/xercesImpl/2.12.0/f02c844149fd306601f20e0b34853a670bef7fa2/xercesImpl-2.12.0.jar
xerces/xercesImpl/2.9.1/1136d197e2755bbde296ceee217ec5fe2917477b/xercesImpl-2.9.1.jar
xerces/xercesImpl/2.9.1/3dc01c1914df28486113a9a46f18caa350fb8f77/xercesImpl-2.9.1.pom
xml-apis/xml-apis/1.4.01/1c657bc14f11cbfcebb2ebf63eebd5cd85b08872/xml-apis-1.4.01.pom
xml-apis/xml-apis/1.4.01/3789d9fada2d3d458c4ba2de349d48780f381ee3/xml-apis-1.4.01.jar
xml-resolver/xml-resolver/1.2/3d0f97750b3a03e0971831566067754ba4bfd68c/xml-resolver-1.2.jar
xml-resolver/xml-resolver/1.2/f18c0830ec69bbd60e39f6c22492e7fd86489f2e/xml-resolver-1.2.pom
)
GRADLE_PKGS_URIS_ANDROID="
"
GRADLE_PKGS_URIS_NO_ANDROID="
https://dl.google.com/dl/android/maven2/androidx/databinding/databinding-common/4.2.0/databinding-common-4.2.0.jar
https://dl.google.com/dl/android/maven2/androidx/databinding/databinding-common/4.2.0/databinding-common-4.2.0.pom
https://dl.google.com/dl/android/maven2/androidx/databinding/databinding-compiler-common/4.2.0/databinding-compiler-common-4.2.0.jar
https://dl.google.com/dl/android/maven2/androidx/databinding/databinding-compiler-common/4.2.0/databinding-compiler-common-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/databinding/baseLibrary/4.2.0/baseLibrary-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/databinding/baseLibrary/4.2.0/baseLibrary-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/signflinger/4.2.0/signflinger-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/signflinger/4.2.0/signflinger-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/crash/27.2.0/crash-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/crash/27.2.0/crash-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/protos/27.2.0/protos-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/protos/27.2.0/protos-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/shared/27.2.0/shared-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/shared/27.2.0/shared-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/tracker/27.2.0/tracker-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/analytics-library/tracker/27.2.0/tracker-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/annotations/27.2.0/annotations-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/annotations/27.2.0/annotations-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/aapt2-proto/4.2.0-7147631/aapt2-proto-4.2.0-7147631.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/aapt2-proto/4.2.0-7147631/aapt2-proto-4.2.0-7147631.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/aaptcompiler/4.2.0/aaptcompiler-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/aaptcompiler/4.2.0/aaptcompiler-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/apksig/4.2.0/apksig-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/apksig/4.2.0/apksig-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/apkzlib/4.2.0/apkzlib-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/apkzlib/4.2.0/apkzlib-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder-model/4.2.0/builder-model-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder-model/4.2.0/builder-model-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder-test-api/4.2.0/builder-test-api-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder-test-api/4.2.0/builder-test-api-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder/4.2.0/builder-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/builder/4.2.0/builder-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/bundletool/1.1.0/bundletool-1.1.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/bundletool/1.1.0/bundletool-1.1.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle-api/4.2.0/gradle-api-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle-api/4.2.0/gradle-api-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle/4.2.0/gradle-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle/4.2.0/gradle-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/jetifier/jetifier-core/1.0.0-beta09/jetifier-core-1.0.0-beta09.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/jetifier/jetifier-core/1.0.0-beta09/jetifier-core-1.0.0-beta09.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/jetifier/jetifier-processor/1.0.0-beta09/jetifier-processor-1.0.0-beta09.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/jetifier/jetifier-processor/1.0.0-beta09/jetifier-processor-1.0.0-beta09.pom
https://dl.google.com/dl/android/maven2/com/android/tools/build/manifest-merger/27.2.0/manifest-merger-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/build/manifest-merger/27.2.0/manifest-merger-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/common/27.2.0/common-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/common/27.2.0/common-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/ddms/ddmlib/27.2.0/ddmlib-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/ddms/ddmlib/27.2.0/ddmlib-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/dvlib/27.2.0/dvlib-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/dvlib/27.2.0/dvlib-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/layoutlib/layoutlib-api/27.2.0/layoutlib-api-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/layoutlib/layoutlib-api/27.2.0/layoutlib-api-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/lint/lint-gradle-api/27.2.0/lint-gradle-api-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/lint/lint-gradle-api/27.2.0/lint-gradle-api-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/lint/lint-model/27.2.0/lint-model-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/lint/lint-model/27.2.0/lint-model-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/repository/27.2.0/repository-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/repository/27.2.0/repository-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/sdk-common/27.2.0/sdk-common-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/sdk-common/27.2.0/sdk-common-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/tools/sdklib/27.2.0/sdklib-27.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/tools/sdklib/27.2.0/sdklib-27.2.0.pom
https://dl.google.com/dl/android/maven2/com/android/zipflinger/4.2.0/zipflinger-4.2.0.jar
https://dl.google.com/dl/android/maven2/com/android/zipflinger/4.2.0/zipflinger-4.2.0.pom
https://dl.google.com/dl/android/maven2/com/google/testing/platform/core-proto/0.0.8-alpha01/core-proto-0.0.8-alpha01.jar
https://dl.google.com/dl/android/maven2/com/google/testing/platform/core-proto/0.0.8-alpha01/core-proto-0.0.8-alpha01.pom
https://maven-central.storage-download.googleapis.com/maven2/antlr/antlr/2.7.7/antlr-2.7.7.jar
https://maven-central.storage-download.googleapis.com/maven2/antlr/antlr/2.7.7/antlr-2.7.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/github/ben-manes/caffeine/caffeine/2.8.8/caffeine-2.8.8.jar
https://maven-central.storage-download.googleapis.com/maven2/com/github/ben-manes/caffeine/caffeine/2.8.8/caffeine-2.8.8.pom
https://maven-central.storage-download.googleapis.com/maven2/com/github/kevinstern/software-and-algorithms/1.0/software-and-algorithms-1.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/github/kevinstern/software-and-algorithms/1.0/software-and-algorithms-1.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/android/annotations/4.1.1.4/annotations-4.1.1.4.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/android/annotations/4.1.1.4/annotations-4.1.1.4.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api-client/google-api-client-bom/1.30.2/google-api-client-bom-1.30.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api-client/google-api-client-bom/1.33.0/google-api-client-bom-1.33.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/api-common/2.1.2/api-common-2.1.2.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/api-common/2.1.2/api-common-2.1.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax-bom/1.47.1/gax-bom-1.47.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax-bom/2.8.1/gax-bom-2.8.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax-grpc/2.8.1/gax-grpc-2.8.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax-grpc/2.8.1/gax-grpc-2.8.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax/2.8.1/gax-2.8.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/gax/2.8.1/gax-2.8.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/google-api-grpc/0.65.0/google-api-grpc-0.65.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-logging-v2/0.95.1/proto-google-cloud-logging-v2-0.95.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-logging-v2/0.95.1/proto-google-cloud-logging-v2-0.95.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-monitoring-v3/1.64.0/proto-google-cloud-monitoring-v3-1.64.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-monitoring-v3/1.64.0/proto-google-cloud-monitoring-v3-1.64.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-trace-v1/0.65.0/proto-google-cloud-trace-v1-0.65.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-trace-v1/0.65.0/proto-google-cloud-trace-v1-0.65.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-trace-v2/0.65.0/proto-google-cloud-trace-v2-0.65.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-cloud-trace-v2/0.65.0/proto-google-cloud-trace-v2-0.65.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-common-protos/2.9.0/proto-google-common-protos-2.9.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-common-protos/2.9.0/proto-google-common-protos-2.9.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-iam-v1/1.2.0/proto-google-iam-v1-1.2.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/api/grpc/proto-google-iam-v1/1.2.0/proto-google-iam-v1-1.2.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/appengine/appengine-api-1.0-sdk/1.9.59/appengine-api-1.0-sdk-1.9.59.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/appengine/appengine-api-1.0-sdk/1.9.59/appengine-api-1.0-sdk-1.9.59.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/appengine/appengine/1.9.59/appengine-1.9.59.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-bom/0.16.2/google-auth-library-bom-0.16.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-bom/1.3.0/google-auth-library-bom-1.3.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-credentials/1.4.0/google-auth-library-credentials-1.4.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-credentials/1.4.0/google-auth-library-credentials-1.4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-oauth2-http/1.3.0/google-auth-library-oauth2-http-1.3.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-oauth2-http/1.3.0/google-auth-library-oauth2-http-1.3.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-oauth2-http/1.4.0/google-auth-library-oauth2-http-1.4.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-oauth2-http/1.4.0/google-auth-library-oauth2-http-1.4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-parent/1.3.0/google-auth-library-parent-1.3.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auth/google-auth-library-parent/1.4.0/google-auth-library-parent-1.4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/auto-common/1.1.2/auto-common-1.1.2.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/auto-common/1.1.2/auto-common-1.1.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/auto-parent/7/auto-parent-7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/service/auto-service-aggregator/1.0-rc6/auto-service-aggregator-1.0-rc6.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/service/auto-service-annotations/1.0-rc6/auto-service-annotations-1.0-rc6.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/service/auto-service-annotations/1.0-rc6/auto-service-annotations-1.0-rc6.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.6.3/auto-value-annotations-1.6.3.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.6.3/auto-value-annotations-1.6.3.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.7/auto-value-annotations-1.7.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.7/auto-value-annotations-1.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.8.2/auto-value-annotations-1.8.2.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.8.2/auto-value-annotations-1.8.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.9/auto-value-annotations-1.9.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-annotations/1.9/auto-value-annotations-1.9.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-parent/1.6.3/auto-value-parent-1.6.3.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-parent/1.7/auto-value-parent-1.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-parent/1.8.2/auto-value-parent-1.8.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value-parent/1.9/auto-value-parent-1.9.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value/1.9/auto-value-1.9.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/auto/value/auto-value/1.9/auto-value-1.9.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-bom/0.100.0-alpha/google-cloud-bom-0.100.0-alpha.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-clients/0.100.0-alpha/google-cloud-clients-0.100.0-alpha.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-core-grpc/2.3.5/google-cloud-core-grpc-2.3.5.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-core-grpc/2.3.5/google-cloud-core-grpc-2.3.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-core-parent/2.3.5/google-cloud-core-parent-2.3.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-core/2.3.5/google-cloud-core-2.3.5.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-core/2.3.5/google-cloud-core-2.3.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-logging/3.6.1/google-cloud-logging-3.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-logging/3.6.1/google-cloud-logging-3.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-monitoring/1.82.0/google-cloud-monitoring-1.82.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-monitoring/1.82.0/google-cloud-monitoring-1.82.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-shared-config/1.2.4/google-cloud-shared-config-1.2.4.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-trace/0.100.0-beta/google-cloud-trace-0.100.0-beta.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/google-cloud-trace/0.100.0-beta/google-cloud-trace-0.100.0-beta.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/tools/appengine-gradle-plugin/2.3.0/appengine-gradle-plugin-2.3.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/tools/appengine-gradle-plugin/2.3.0/appengine-gradle-plugin-2.3.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/tools/appengine-plugins-core/0.9.0/appengine-plugins-core-0.9.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/cloud/tools/appengine-plugins-core/0.9.0/appengine-plugins-core-0.9.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/findbugs/jFormatString/3.0.0/jFormatString-3.0.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/findbugs/jFormatString/3.0.0/jFormatString-3.0.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/findbugs/jsr305/3.0.0/jsr305-3.0.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson-parent/2.8.9/gson-parent-2.8.9.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson-parent/2.9.0/gson-parent-2.9.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson/2.8.9/gson-2.8.9.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson/2.8.9/gson-2.8.9.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson/2.9.0/gson-2.9.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/code/gson/gson/2.9.0/gson-2.9.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotation/2.10.0/error_prone_annotation-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotation/2.10.0/error_prone_annotation-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.10.0/error_prone_annotations-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.10.0/error_prone_annotations-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.14.0/error_prone_annotations-2.14.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.14.0/error_prone_annotations-2.14.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.3.3/error_prone_annotations-2.3.3.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.5.1/error_prone_annotations-2.5.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_annotations/2.5.1/error_prone_annotations-2.5.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_check_api/2.10.0/error_prone_check_api-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_check_api/2.10.0/error_prone_check_api-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_core/2.10.0/error_prone_core-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_core/2.10.0/error_prone_core-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_parent/2.10.0/error_prone_parent-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_parent/2.14.0/error_prone_parent-2.14.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_parent/2.3.3/error_prone_parent-2.3.3.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_parent/2.5.1/error_prone_parent-2.5.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_type_annotations/2.10.0/error_prone_type_annotations-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/errorprone/error_prone_type_annotations/2.10.0/error_prone_type_annotations-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/google/1/google-1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-beta-checker/1.0/guava-beta-checker-1.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-beta-checker/1.0/guava-beta-checker-1.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-bom/31.0.1-jre/guava-bom-31.0.1-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/19.0/guava-parent-19.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/28.1-android/guava-parent-28.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/28.2-jre/guava-parent-28.2-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/30.1-jre/guava-parent-30.1-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/30.1.1-android/guava-parent-30.1.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/30.1.1-jre/guava-parent-30.1.1-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-parent/31.1-android/guava-parent-31.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-testlib/30.1.1-android/guava-testlib-30.1.1-android.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-testlib/30.1.1-android/guava-testlib-30.1.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-testlib/31.1-android/guava-testlib-31.1-android.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava-testlib/31.1-android/guava-testlib-31.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/19.0/guava-19.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/19.0/guava-19.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/28.1-android/guava-28.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/28.2-jre/guava-28.2-jre.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/28.2-jre/guava-28.2-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/30.1-jre/guava-30.1-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/30.1.1-android/guava-30.1.1-android.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/30.1.1-android/guava-30.1.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/30.1.1-jre/guava-30.1.1-jre.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/30.1.1-jre/guava-30.1.1-jre.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/31.1-android/guava-31.1-android.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/guava/guava/31.1-android/guava-31.1-android.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-bom/1.30.1/google-http-client-bom-1.30.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-bom/1.40.1/google-http-client-bom-1.40.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-bom/1.41.0/google-http-client-bom-1.41.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-gson/1.41.0/google-http-client-gson-1.41.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-gson/1.41.0/google-http-client-gson-1.41.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client-parent/1.41.0/google-http-client-parent-1.41.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client/1.41.0/google-http-client-1.41.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/http-client/google-http-client/1.41.0/google-http-client-1.41.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/oauth-client/google-oauth-client-bom/1.30.1/google-oauth-client-bom-1.30.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-bom/3.19.2/protobuf-bom-3.19.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-bom/3.21.7/protobuf-bom-3.21.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java-util/3.21.7/protobuf-java-util-3.21.7.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java-util/3.21.7/protobuf-java-util-3.21.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java/3.21.7/protobuf-java-3.21.7.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java/3.21.7/protobuf-java-3.21.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java/3.4.0/protobuf-java-3.4.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-java/3.4.0/protobuf-java-3.4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-javalite/3.21.7/protobuf-javalite-3.21.7.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-javalite/3.21.7/protobuf-javalite-3.21.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-parent/3.21.7/protobuf-parent-3.21.7.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/protobuf/protobuf-parent/3.4.0/protobuf-parent-3.4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/re2j/re2j/1.5/re2j-1.5.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/re2j/re2j/1.5/re2j-1.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/re2j/re2j/1.6/re2j-1.6.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/re2j/re2j/1.6/re2j-1.6.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/truth/truth-parent/1.0.1/truth-parent-1.0.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/google/truth/truth/1.0.1/truth-1.0.1.jar
https://maven-central.storage-download.googleapis.com/maven2/com/google/truth/truth/1.0.1/truth-1.0.1.pom
https://maven-central.storage-download.googleapis.com/maven2/com/googlecode/java-diff-utils/diffutils/1.3.0/diffutils-1.3.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/googlecode/java-diff-utils/diffutils/1.3.0/diffutils-1.3.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/lmax/disruptor/3.4.2/disruptor-3.4.2.jar
https://maven-central.storage-download.googleapis.com/maven2/com/lmax/disruptor/3.4.2/disruptor-3.4.2.pom
https://maven-central.storage-download.googleapis.com/maven2/com/puppycrawl/tools/checkstyle/6.17/checkstyle-6.17.jar
https://maven-central.storage-download.googleapis.com/maven2/com/puppycrawl/tools/checkstyle/6.17/checkstyle-6.17.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/okhttp/2.7.4/okhttp-2.7.4.jar
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/okhttp/2.7.4/okhttp-2.7.4.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/okhttp/2.7.5/okhttp-2.7.5.jar
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/okhttp/2.7.5/okhttp-2.7.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/parent/2.7.4/parent-2.7.4.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okhttp/parent/2.7.5/parent-2.7.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio-parent/1.17.5/okio-parent-1.17.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio-parent/1.6.0/okio-parent-1.6.0.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio/1.17.5/okio-1.17.5.jar
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio/1.17.5/okio-1.17.5.pom
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio/1.6.0/okio-1.6.0.jar
https://maven-central.storage-download.googleapis.com/maven2/com/squareup/okio/okio/1.6.0/okio-1.6.0.pom
https://maven-central.storage-download.googleapis.com/maven2/commons-beanutils/commons-beanutils/1.9.2/commons-beanutils-1.9.2.jar
https://maven-central.storage-download.googleapis.com/maven2/commons-beanutils/commons-beanutils/1.9.2/commons-beanutils-1.9.2.pom
https://maven-central.storage-download.googleapis.com/maven2/commons-cli/commons-cli/1.3.1/commons-cli-1.3.1.jar
https://maven-central.storage-download.googleapis.com/maven2/commons-cli/commons-cli/1.3.1/commons-cli-1.3.1.pom
https://maven-central.storage-download.googleapis.com/maven2/commons-codec/commons-codec/1.15/commons-codec-1.15.jar
https://maven-central.storage-download.googleapis.com/maven2/commons-codec/commons-codec/1.15/commons-codec-1.15.pom
https://maven-central.storage-download.googleapis.com/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar
https://maven-central.storage-download.googleapis.com/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/github/devatherock/jul-jsonformatter/1.1.0/jul-jsonformatter-1.1.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/github/devatherock/jul-jsonformatter/1.1.0/jul-jsonformatter-1.1.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/github/java-diff-utils/java-diff-utils/4.0/java-diff-utils-4.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/github/java-diff-utils/java-diff-utils/4.0/java-diff-utils-4.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-auth/1.27.2/grpc-auth-1.27.2.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-auth/1.27.2/grpc-auth-1.27.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-auth/1.6.1/grpc-auth-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-auth/1.6.1/grpc-auth-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-bom/1.43.1/grpc-bom-1.43.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-context/1.27.2/grpc-context-1.27.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-context/1.6.1/grpc-context-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-context/1.6.1/grpc-context-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-core/1.6.1/grpc-core-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-core/1.6.1/grpc-core-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-grpclb/1.6.1/grpc-grpclb-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-grpclb/1.6.1/grpc-grpclb-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty-shaded/1.27.2/grpc-netty-shaded-1.27.2.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty-shaded/1.27.2/grpc-netty-shaded-1.27.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty-shaded/1.43.2/grpc-netty-shaded-1.43.2.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty-shaded/1.43.2/grpc-netty-shaded-1.43.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty/1.6.1/grpc-netty-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-netty/1.6.1/grpc-netty-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-okhttp/1.6.1/grpc-okhttp-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-okhttp/1.6.1/grpc-okhttp-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-protobuf-lite/1.6.1/grpc-protobuf-lite-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-protobuf-lite/1.6.1/grpc-protobuf-lite-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-protobuf/1.6.1/grpc-protobuf-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-protobuf/1.6.1/grpc-protobuf-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-services/1.43.2/grpc-services-1.43.2.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-services/1.43.2/grpc-services-1.43.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-stub/1.6.1/grpc-stub-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-stub/1.6.1/grpc-stub-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-testing/1.6.1/grpc-testing-1.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-testing/1.6.1/grpc-testing-1.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-xds/1.43.2/grpc-xds-1.43.2.jar
https://maven-central.storage-download.googleapis.com/maven2/io/grpc/grpc-xds/1.43.2/grpc-xds-1.43.2.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-buffer/4.1.79.Final/netty-buffer-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-buffer/4.1.79.Final/netty-buffer-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-http/4.1.79.Final/netty-codec-http-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-http/4.1.79.Final/netty-codec-http-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-http2/4.1.79.Final/netty-codec-http2-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-http2/4.1.79.Final/netty-codec-http2-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-socks/4.1.79.Final/netty-codec-socks-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec-socks/4.1.79.Final/netty-codec-socks-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec/4.1.79.Final/netty-codec-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-codec/4.1.79.Final/netty-codec-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-common/4.1.79.Final/netty-common-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-common/4.1.79.Final/netty-common-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-handler-proxy/4.1.79.Final/netty-handler-proxy-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-handler-proxy/4.1.79.Final/netty-handler-proxy-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-handler/4.1.79.Final/netty-handler-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-handler/4.1.79.Final/netty-handler-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-parent/4.1.79.Final/netty-parent-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-resolver/4.1.79.Final/netty-resolver-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-resolver/4.1.79.Final/netty-resolver-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final-linux-aarch_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final-linux-x86_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final-osx-aarch_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final-osx-x86_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final-windows-x86_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-boringssl-static/2.0.54.Final/netty-tcnative-boringssl-static-2.0.54.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-classes/2.0.54.Final/netty-tcnative-classes-2.0.54.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-classes/2.0.54.Final/netty-tcnative-classes-2.0.54.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-tcnative-parent/2.0.54.Final/netty-tcnative-parent-2.0.54.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-classes-epoll/4.1.79.Final/netty-transport-classes-epoll-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-classes-epoll/4.1.79.Final/netty-transport-classes-epoll-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-epoll/4.1.79.Final/netty-transport-native-epoll-4.1.79.Final-linux-aarch_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-epoll/4.1.79.Final/netty-transport-native-epoll-4.1.79.Final-linux-x86_64.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-epoll/4.1.79.Final/netty-transport-native-epoll-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-epoll/4.1.79.Final/netty-transport-native-epoll-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-unix-common/4.1.79.Final/netty-transport-native-unix-common-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport-native-unix-common/4.1.79.Final/netty-transport-native-unix-common-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport/4.1.79.Final/netty-transport-4.1.79.Final.jar
https://maven-central.storage-download.googleapis.com/maven2/io/netty/netty-transport/4.1.79.Final/netty-transport-4.1.79.Final.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-api/0.28.0/opencensus-api-0.28.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-api/0.28.0/opencensus-api-0.28.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-api/0.31.0/opencensus-api-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-api/0.31.0/opencensus-api-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-exemplar-util/0.31.0/opencensus-contrib-exemplar-util-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-exemplar-util/0.31.0/opencensus-contrib-exemplar-util-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-grpc-metrics/0.31.0/opencensus-contrib-grpc-metrics-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-grpc-metrics/0.31.0/opencensus-contrib-grpc-metrics-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-http-util/0.28.0/opencensus-contrib-http-util-0.28.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-http-util/0.28.0/opencensus-contrib-http-util-0.28.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-resource-util/0.31.0/opencensus-contrib-resource-util-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-contrib-resource-util/0.31.0/opencensus-contrib-resource-util-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-metrics-util/0.31.0/opencensus-exporter-metrics-util-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-metrics-util/0.31.0/opencensus-exporter-metrics-util-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-stats-stackdriver/0.31.0/opencensus-exporter-stats-stackdriver-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-stats-stackdriver/0.31.0/opencensus-exporter-stats-stackdriver-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-trace-stackdriver/0.31.0/opencensus-exporter-trace-stackdriver-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-exporter-trace-stackdriver/0.31.0/opencensus-exporter-trace-stackdriver-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-impl-core/0.31.0/opencensus-impl-core-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-impl-core/0.31.0/opencensus-impl-core-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-impl/0.31.0/opencensus-impl-0.31.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-impl/0.31.0/opencensus-impl-0.31.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-proto/0.2.0/opencensus-proto-0.2.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/opencensus/opencensus-proto/0.2.0/opencensus-proto-0.2.0.pom
https://maven-central.storage-download.googleapis.com/maven2/io/perfmark/perfmark-api/0.25.0/perfmark-api-0.25.0.jar
https://maven-central.storage-download.googleapis.com/maven2/io/perfmark/perfmark-api/0.25.0/perfmark-api-0.25.0.pom
https://maven-central.storage-download.googleapis.com/maven2/javax/annotation/javax.annotation-api/1.3.2/javax.annotation-api-1.3.2.jar
https://maven-central.storage-download.googleapis.com/maven2/javax/annotation/javax.annotation-api/1.3.2/javax.annotation-api-1.3.2.pom
https://maven-central.storage-download.googleapis.com/maven2/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar
https://maven-central.storage-download.googleapis.com/maven2/javax/servlet/servlet-api/2.5/servlet-api-2.5.pom
https://maven-central.storage-download.googleapis.com/maven2/junit/junit/4.12/junit-4.12.jar
https://maven-central.storage-download.googleapis.com/maven2/junit/junit/4.12/junit-4.12.pom
https://maven-central.storage-download.googleapis.com/maven2/net/bytebuddy/byte-buddy-agent/1.10.5/byte-buddy-agent-1.10.5.jar
https://maven-central.storage-download.googleapis.com/maven2/net/bytebuddy/byte-buddy-agent/1.10.5/byte-buddy-agent-1.10.5.pom
https://maven-central.storage-download.googleapis.com/maven2/net/bytebuddy/byte-buddy-parent/1.10.5/byte-buddy-parent-1.10.5.pom
https://maven-central.storage-download.googleapis.com/maven2/net/bytebuddy/byte-buddy/1.10.5/byte-buddy-1.10.5.jar
https://maven-central.storage-download.googleapis.com/maven2/net/bytebuddy/byte-buddy/1.10.5/byte-buddy-1.10.5.pom
https://maven-central.storage-download.googleapis.com/maven2/net/java/jvnet-parent/3/jvnet-parent-3.pom
https://maven-central.storage-download.googleapis.com/maven2/net/sf/androidscents/androidscents-parent/1/androidscents-parent-1.pom
https://maven-central.storage-download.googleapis.com/maven2/net/sf/androidscents/signature/android-api-level-14/4.0_r4/android-api-level-14-4.0_r4.pom
https://maven-central.storage-download.googleapis.com/maven2/net/sf/androidscents/signature/android-api-level-14/4.0_r4/android-api-level-14-4.0_r4.signature
https://maven-central.storage-download.googleapis.com/maven2/net/sf/androidscents/signature/android-api-level-19/4.4.2_r4/android-api-level-19-4.4.2_r4.pom
https://maven-central.storage-download.googleapis.com/maven2/org/antlr/antlr4-master/4.5.2-1/antlr4-master-4.5.2-1.pom
https://maven-central.storage-download.googleapis.com/maven2/org/antlr/antlr4-runtime/4.5.2-1/antlr4-runtime-4.5.2-1.jar
https://maven-central.storage-download.googleapis.com/maven2/org/antlr/antlr4-runtime/4.5.2-1/antlr4-runtime-4.5.2-1.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/apache/16/apache-16.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.jar
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-parent/33/commons-parent-33.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-parent/37/commons-parent-37.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-parent/39/commons-parent-39.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/commons/commons-parent/48/commons-parent-48.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.jar
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpclient/4.5.13/httpclient-4.5.13.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpcomponents-client/4.5.13/httpcomponents-client-4.5.13.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.15/httpcomponents-core-4.4.15.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpcore/4.4.15/httpcore-4.4.15.jar
https://maven-central.storage-download.googleapis.com/maven2/org/apache/httpcomponents/httpcore/4.4.15/httpcore-4.4.15.pom
https://maven-central.storage-download.googleapis.com/maven2/org/apache/tomcat/annotations-api/6.0.53/annotations-api-6.0.53.jar
https://maven-central.storage-download.googleapis.com/maven2/org/apache/tomcat/annotations-api/6.0.53/annotations-api-6.0.53.pom
https://maven-central.storage-download.googleapis.com/maven2/org/bouncycastle/bcpkix-jdk15on/1.67/bcpkix-jdk15on-1.67.jar
https://maven-central.storage-download.googleapis.com/maven2/org/bouncycastle/bcpkix-jdk15on/1.67/bcpkix-jdk15on-1.67.pom
https://maven-central.storage-download.googleapis.com/maven2/org/bouncycastle/bcprov-jdk15on/1.67/bcprov-jdk15on-1.67.jar
https://maven-central.storage-download.googleapis.com/maven2/org/bouncycastle/bcprov-jdk15on/1.67/bcprov-jdk15on-1.67.pom
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/2.10.0/checker-qual-2.10.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/2.10.0/checker-qual-2.10.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/3.20.0/checker-qual-3.20.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/3.20.0/checker-qual-3.20.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/3.5.0/checker-qual-3.5.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/3.8.0/checker-qual-3.8.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/checker-qual/3.8.0/checker-qual-3.8.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/dataflow-errorprone/3.15.0/dataflow-errorprone-3.15.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/checkerframework/dataflow-errorprone/3.15.0/dataflow-errorprone-3.15.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/codehaus-parent/4/codehaus-parent-4.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-annotations/1.21/animal-sniffer-annotations-1.21.jar
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-annotations/1.21/animal-sniffer-annotations-1.21.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-ant-tasks/1.18/animal-sniffer-ant-tasks-1.18.jar
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-ant-tasks/1.18/animal-sniffer-ant-tasks-1.18.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-parent/1.18/animal-sniffer-parent-1.18.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer-parent/1.21/animal-sniffer-parent-1.21.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer/1.18/animal-sniffer-1.18.jar
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/animal-sniffer/1.18/animal-sniffer-1.18.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/mojo-parent/31/mojo-parent-31.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/mojo-parent/38/mojo-parent-38.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/mojo-parent/50/mojo-parent-50.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/mojo-parent/65/mojo-parent-65.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/signature/java17/1.0/java17-1.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/signature/java17/1.0/java17-1.0.signature
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/signature/java18/1.0/java18-1.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/codehaus/mojo/signature/signatures-parent/1.2/signatures-parent-1.2.pom
https://maven-central.storage-download.googleapis.com/maven2/org/conscrypt/conscrypt-openjdk-uber/2.5.2/conscrypt-openjdk-uber-2.5.2.jar
https://maven-central.storage-download.googleapis.com/maven2/org/conscrypt/conscrypt-openjdk-uber/2.5.2/conscrypt-openjdk-uber-2.5.2.pom
https://maven-central.storage-download.googleapis.com/maven2/org/eclipse/jgit/org.eclipse.jgit-parent/4.4.1.201607150455-r/org.eclipse.jgit-parent-4.4.1.201607150455-r.pom
https://maven-central.storage-download.googleapis.com/maven2/org/eclipse/jgit/org.eclipse.jgit/4.4.1.201607150455-r/org.eclipse.jgit-4.4.1.201607150455-r.jar
https://maven-central.storage-download.googleapis.com/maven2/org/eclipse/jgit/org.eclipse.jgit/4.4.1.201607150455-r/org.eclipse.jgit-4.4.1.201607150455-r.pom
https://maven-central.storage-download.googleapis.com/maven2/org/glassfish/javax.json/1.0.4/javax.json-1.0.4.jar
https://maven-central.storage-download.googleapis.com/maven2/org/glassfish/javax.json/1.0.4/javax.json-1.0.4.pom
https://maven-central.storage-download.googleapis.com/maven2/org/glassfish/json/1.0.4/json-1.0.4.pom
https://maven-central.storage-download.googleapis.com/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
https://maven-central.storage-download.googleapis.com/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.pom
https://maven-central.storage-download.googleapis.com/maven2/org/hamcrest/hamcrest-parent/1.3/hamcrest-parent-1.3.pom
https://maven-central.storage-download.googleapis.com/maven2/org/hdrhistogram/HdrHistogram/2.1.12/HdrHistogram-2.1.12.jar
https://maven-central.storage-download.googleapis.com/maven2/org/hdrhistogram/HdrHistogram/2.1.12/HdrHistogram-2.1.12.pom
https://maven-central.storage-download.googleapis.com/maven2/org/junit/junit-bom/5.8.1/junit-bom-5.8.1.pom
https://maven-central.storage-download.googleapis.com/maven2/org/junit/junit-bom/5.8.2/junit-bom-5.8.2.pom
https://maven-central.storage-download.googleapis.com/maven2/org/mockito/mockito-core/3.3.3/mockito-core-3.3.3.jar
https://maven-central.storage-download.googleapis.com/maven2/org/mockito/mockito-core/3.3.3/mockito-core-3.3.3.pom
https://maven-central.storage-download.googleapis.com/maven2/org/mortbay/jetty/alpn/jetty-alpn-agent/2.0.10/jetty-alpn-agent-2.0.10.jar
https://maven-central.storage-download.googleapis.com/maven2/org/mortbay/jetty/alpn/jetty-alpn-agent/2.0.10/jetty-alpn-agent-2.0.10.pom
https://maven-central.storage-download.googleapis.com/maven2/org/objenesis/objenesis-parent/2.6/objenesis-parent-2.6.pom
https://maven-central.storage-download.googleapis.com/maven2/org/objenesis/objenesis/2.6/objenesis-2.6.jar
https://maven-central.storage-download.googleapis.com/maven2/org/objenesis/objenesis/2.6/objenesis-2.6.pom
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-asm/1.29/jmh-generator-asm-1.29.jar
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-asm/1.29/jmh-generator-asm-1.29.pom
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-bytecode/1.29/jmh-generator-bytecode-1.29.jar
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-bytecode/1.29/jmh-generator-bytecode-1.29.pom
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-reflection/1.29/jmh-generator-reflection-1.29.jar
https://maven-central.storage-download.googleapis.com/maven2/org/openjdk/jmh/jmh-generator-reflection/1.29/jmh-generator-reflection-1.29.pom
https://maven-central.storage-download.googleapis.com/maven2/org/ow2/asm/asm/7.0/asm-7.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/ow2/asm/asm/9.0/asm-9.0.jar
https://maven-central.storage-download.googleapis.com/maven2/org/ow2/asm/asm/9.0/asm-9.0.pom
https://maven-central.storage-download.googleapis.com/maven2/org/pcollections/pcollections/2.1.2/pcollections-2.1.2.jar
https://maven-central.storage-download.googleapis.com/maven2/org/pcollections/pcollections/2.1.2/pcollections-2.1.2.pom
https://maven-central.storage-download.googleapis.com/maven2/org/sonatype/oss/oss-parent/4/oss-parent-4.pom
https://maven-central.storage-download.googleapis.com/maven2/org/threeten/threetenbp/1.5.2/threetenbp-1.5.2.jar
https://maven-central.storage-download.googleapis.com/maven2/org/threeten/threetenbp/1.5.2/threetenbp-1.5.2.pom
https://maven-central.storage-download.googleapis.com/maven2/org/yaml/snakeyaml/1.21/snakeyaml-1.21.jar
https://maven-central.storage-download.googleapis.com/maven2/org/yaml/snakeyaml/1.21/snakeyaml-1.21.pom
https://maven-central.storage-download.googleapis.com/maven2/ru/vyarus/gradle-animalsniffer-plugin/1.5.4/gradle-animalsniffer-plugin-1.5.4.pom
https://plugins.gradle.org/m2/com/android/tools/build/transform-api/2.0.0-deprecated-use-gradle-api/transform-api-2.0.0-deprecated-use-gradle-api.jar
https://plugins.gradle.org/m2/com/android/tools/build/transform-api/2.0.0-deprecated-use-gradle-api/transform-api-2.0.0-deprecated-use-gradle-api.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-annotations/2.13.2/jackson-annotations-2.13.2.jar
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-annotations/2.13.2/jackson-annotations-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-core/2.13.2/jackson-core-2.13.2.jar
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-core/2.13.2/jackson-core-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-databind/2.13.2.2/jackson-databind-2.13.2.2.jar
https://plugins.gradle.org/m2/com/fasterxml/jackson/core/jackson-databind/2.13.2.2/jackson-databind-2.13.2.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.13.2/jackson-datatype-jsr310-2.13.2.jar
https://plugins.gradle.org/m2/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.13.2/jackson-datatype-jsr310-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/jackson-base/2.13.2/jackson-base-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/jackson-bom/2.13.2/jackson-bom-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/jackson-parent/2.13/jackson-parent-2.13.pom
https://plugins.gradle.org/m2/com/fasterxml/jackson/module/jackson-modules-java8/2.13.2/jackson-modules-java8-2.13.2.pom
https://plugins.gradle.org/m2/com/fasterxml/oss-parent/43/oss-parent-43.pom
https://plugins.gradle.org/m2/com/github/johnrengelman/shadow/com.github.johnrengelman.shadow.gradle.plugin/7.1.2/com.github.johnrengelman.shadow.gradle.plugin-7.1.2.pom
https://plugins.gradle.org/m2/com/github/kt3k/coveralls/com.github.kt3k.coveralls.gradle.plugin/2.12.0/com.github.kt3k.coveralls.gradle.plugin-2.12.0.pom
https://plugins.gradle.org/m2/com/github/siom79/japicmp/japicmp-base/0.14.3/japicmp-base-0.14.3.pom
https://plugins.gradle.org/m2/com/github/siom79/japicmp/japicmp/0.14.3/japicmp-0.14.3.jar
https://plugins.gradle.org/m2/com/github/siom79/japicmp/japicmp/0.14.3/japicmp-0.14.3.pom
https://plugins.gradle.org/m2/com/google/auth/google-auth-library-credentials/0.18.0/google-auth-library-credentials-0.18.0.jar
https://plugins.gradle.org/m2/com/google/auth/google-auth-library-credentials/0.18.0/google-auth-library-credentials-0.18.0.pom
https://plugins.gradle.org/m2/com/google/auth/google-auth-library-oauth2-http/0.18.0/google-auth-library-oauth2-http-0.18.0.jar
https://plugins.gradle.org/m2/com/google/auth/google-auth-library-oauth2-http/0.18.0/google-auth-library-oauth2-http-0.18.0.pom
https://plugins.gradle.org/m2/com/google/auth/google-auth-library-parent/0.18.0/google-auth-library-parent-0.18.0.pom
https://plugins.gradle.org/m2/com/google/auto/auto-parent/6/auto-parent-6.pom
https://plugins.gradle.org/m2/com/google/auto/value/auto-value-annotations/1.6.2/auto-value-annotations-1.6.2.pom
https://plugins.gradle.org/m2/com/google/auto/value/auto-value-annotations/1.6.6/auto-value-annotations-1.6.6.jar
https://plugins.gradle.org/m2/com/google/auto/value/auto-value-annotations/1.6.6/auto-value-annotations-1.6.6.pom
https://plugins.gradle.org/m2/com/google/auto/value/auto-value-parent/1.6.2/auto-value-parent-1.6.2.pom
https://plugins.gradle.org/m2/com/google/auto/value/auto-value-parent/1.6.6/auto-value-parent-1.6.6.pom
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-build-plan/0.4.0/jib-build-plan-0.4.0.jar
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-build-plan/0.4.0/jib-build-plan-0.4.0.pom
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-gradle-plugin-extension-api/0.4.0/jib-gradle-plugin-extension-api-0.4.0.jar
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-gradle-plugin-extension-api/0.4.0/jib-gradle-plugin-extension-api-0.4.0.pom
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-plugins-extension-common/0.2.0/jib-plugins-extension-common-0.2.0.jar
https://plugins.gradle.org/m2/com/google/cloud/tools/jib-plugins-extension-common/0.2.0/jib-plugins-extension-common-0.2.0.pom
https://plugins.gradle.org/m2/com/google/cloud/tools/jib/com.google.cloud.tools.jib.gradle.plugin/3.2.1/com.google.cloud.tools.jib.gradle.plugin-3.2.1.pom
https://plugins.gradle.org/m2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.pom
https://plugins.gradle.org/m2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar
https://plugins.gradle.org/m2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.pom
https://plugins.gradle.org/m2/com/google/code/gson/gson-parent/2.8.6/gson-parent-2.8.6.pom
https://plugins.gradle.org/m2/com/google/code/gson/gson/2.8.6/gson-2.8.6.jar
https://plugins.gradle.org/m2/com/google/code/gson/gson/2.8.6/gson-2.8.6.pom
https://plugins.gradle.org/m2/com/google/crypto/tink/tink/1.3.0-rc2/tink-1.3.0-rc2.jar
https://plugins.gradle.org/m2/com/google/crypto/tink/tink/1.3.0-rc2/tink-1.3.0-rc2.pom
https://plugins.gradle.org/m2/com/google/dagger/dagger/2.28.3/dagger-2.28.3.jar
https://plugins.gradle.org/m2/com/google/dagger/dagger/2.28.3/dagger-2.28.3.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.jar
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.2.0/error_prone_annotations-2.2.0.jar
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.2.0/error_prone_annotations-2.2.0.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.3.1/error_prone_annotations-2.3.1.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.3.2/error_prone_annotations-2.3.2.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.3.4/error_prone_annotations-2.3.4.jar
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_annotations/2.3.4/error_prone_annotations-2.3.4.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_parent/2.11.0/error_prone_parent-2.11.0.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_parent/2.2.0/error_prone_parent-2.2.0.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_parent/2.3.1/error_prone_parent-2.3.1.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_parent/2.3.2/error_prone_parent-2.3.2.pom
https://plugins.gradle.org/m2/com/google/errorprone/error_prone_parent/2.3.4/error_prone_parent-2.3.4.pom
https://plugins.gradle.org/m2/com/google/flatbuffers/flatbuffers-java/1.12.0/flatbuffers-java-1.12.0.jar
https://plugins.gradle.org/m2/com/google/flatbuffers/flatbuffers-java/1.12.0/flatbuffers-java-1.12.0.pom
https://plugins.gradle.org/m2/com/google/gradle/osdetector-gradle-plugin/1.7.0/osdetector-gradle-plugin-1.7.0.jar
https://plugins.gradle.org/m2/com/google/gradle/osdetector-gradle-plugin/1.7.0/osdetector-gradle-plugin-1.7.0.pom
https://plugins.gradle.org/m2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar
https://plugins.gradle.org/m2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.pom
https://plugins.gradle.org/m2/com/google/guava/guava-parent/26.0-android/guava-parent-26.0-android.pom
https://plugins.gradle.org/m2/com/google/guava/guava-parent/27.0.1-jre/guava-parent-27.0.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/guava-parent/28.1-jre/guava-parent-28.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/guava-parent/30.0-android/guava-parent-30.0-android.pom
https://plugins.gradle.org/m2/com/google/guava/guava-parent/31.1-jre/guava-parent-31.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/guava/27.0.1-jre/guava-27.0.1-jre.jar
https://plugins.gradle.org/m2/com/google/guava/guava/27.0.1-jre/guava-27.0.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/guava/28.1-jre/guava-28.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/guava/30.0-android/guava-30.0-android.jar
https://plugins.gradle.org/m2/com/google/guava/guava/30.0-android/guava-30.0-android.pom
https://plugins.gradle.org/m2/com/google/guava/guava/31.1-jre/guava-31.1-jre.jar
https://plugins.gradle.org/m2/com/google/guava/guava/31.1-jre/guava-31.1-jre.pom
https://plugins.gradle.org/m2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar
https://plugins.gradle.org/m2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-apache-v2/1.34.0/google-http-client-apache-v2-1.34.0.jar
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-apache-v2/1.34.0/google-http-client-apache-v2-1.34.0.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-bom/1.32.1/google-http-client-bom-1.32.1.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-jackson2/1.32.1/google-http-client-jackson2-1.32.1.jar
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-jackson2/1.32.1/google-http-client-jackson2-1.32.1.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-parent/1.32.1/google-http-client-parent-1.32.1.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client-parent/1.34.0/google-http-client-parent-1.34.0.pom
https://plugins.gradle.org/m2/com/google/http-client/google-http-client/1.34.0/google-http-client-1.34.0.jar
https://plugins.gradle.org/m2/com/google/http-client/google-http-client/1.34.0/google-http-client-1.34.0.pom
https://plugins.gradle.org/m2/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.jar
https://plugins.gradle.org/m2/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.pom
https://plugins.gradle.org/m2/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar
https://plugins.gradle.org/m2/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.pom
https://plugins.gradle.org/m2/com/google/jimfs/jimfs-parent/1.1/jimfs-parent-1.1.pom
https://plugins.gradle.org/m2/com/google/jimfs/jimfs/1.1/jimfs-1.1.jar
https://plugins.gradle.org/m2/com/google/jimfs/jimfs/1.1/jimfs-1.1.pom
https://plugins.gradle.org/m2/com/google/osdetector/com.google.osdetector.gradle.plugin/1.7.0/com.google.osdetector.gradle.plugin-1.7.0.pom
https://plugins.gradle.org/m2/com/google/protobuf/com.google.protobuf.gradle.plugin/0.8.19/com.google.protobuf.gradle.plugin-0.8.19.pom
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-bom/3.10.0/protobuf-bom-3.10.0.pom
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-gradle-plugin/0.8.19/protobuf-gradle-plugin-0.8.19.jar
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-gradle-plugin/0.8.19/protobuf-gradle-plugin-0.8.19.pom
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-java-util/3.10.0/protobuf-java-util-3.10.0.jar
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-java-util/3.10.0/protobuf-java-util-3.10.0.pom
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-java/3.10.0/protobuf-java-3.10.0.jar
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-java/3.10.0/protobuf-java-3.10.0.pom
https://plugins.gradle.org/m2/com/google/protobuf/protobuf-parent/3.10.0/protobuf-parent-3.10.0.pom
https://plugins.gradle.org/m2/com/googlecode/javaewah/JavaEWAH/1.1.6/JavaEWAH-1.1.6.jar
https://plugins.gradle.org/m2/com/googlecode/javaewah/JavaEWAH/1.1.6/JavaEWAH-1.1.6.pom
https://plugins.gradle.org/m2/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.jar
https://plugins.gradle.org/m2/com/googlecode/json-simple/json-simple/1.1/json-simple-1.1.pom
https://plugins.gradle.org/m2/com/googlecode/juniversalchardet/juniversalchardet/1.0.3/juniversalchardet-1.0.3.jar
https://plugins.gradle.org/m2/com/googlecode/juniversalchardet/juniversalchardet/1.0.3/juniversalchardet-1.0.3.pom
https://plugins.gradle.org/m2/com/jcraft/jsch/0.1.55/jsch-0.1.55.jar
https://plugins.gradle.org/m2/com/jcraft/jsch/0.1.55/jsch-0.1.55.pom
https://plugins.gradle.org/m2/com/jcraft/jzlib/1.1.1/jzlib-1.1.1.jar
https://plugins.gradle.org/m2/com/jcraft/jzlib/1.1.1/jzlib-1.1.1.pom
https://plugins.gradle.org/m2/com/squareup/javapoet/1.10.0/javapoet-1.10.0.jar
https://plugins.gradle.org/m2/com/squareup/javapoet/1.10.0/javapoet-1.10.0.pom
https://plugins.gradle.org/m2/com/squareup/javawriter/2.5.0/javawriter-2.5.0.jar
https://plugins.gradle.org/m2/com/squareup/javawriter/2.5.0/javawriter-2.5.0.pom
https://plugins.gradle.org/m2/com/sun/activation/all/1.2.0/all-1.2.0.pom
https://plugins.gradle.org/m2/com/sun/activation/all/1.2.1/all-1.2.1.pom
https://plugins.gradle.org/m2/com/sun/activation/javax.activation/1.2.0/javax.activation-1.2.0.jar
https://plugins.gradle.org/m2/com/sun/activation/javax.activation/1.2.0/javax.activation-1.2.0.pom
https://plugins.gradle.org/m2/com/sun/istack/istack-commons-runtime/3.0.8/istack-commons-runtime-3.0.8.jar
https://plugins.gradle.org/m2/com/sun/istack/istack-commons-runtime/3.0.8/istack-commons-runtime-3.0.8.pom
https://plugins.gradle.org/m2/com/sun/istack/istack-commons/3.0.8/istack-commons-3.0.8.pom
https://plugins.gradle.org/m2/com/sun/xml/bind/jaxb-bom-ext/2.3.2/jaxb-bom-ext-2.3.2.pom
https://plugins.gradle.org/m2/com/sun/xml/bind/mvn/jaxb-parent/2.3.2/jaxb-parent-2.3.2.pom
https://plugins.gradle.org/m2/com/sun/xml/bind/mvn/jaxb-runtime-parent/2.3.2/jaxb-runtime-parent-2.3.2.pom
https://plugins.gradle.org/m2/com/sun/xml/bind/mvn/jaxb-txw-parent/2.3.2/jaxb-txw-parent-2.3.2.pom
https://plugins.gradle.org/m2/com/sun/xml/fastinfoset/FastInfoset/1.2.16/FastInfoset-1.2.16.jar
https://plugins.gradle.org/m2/com/sun/xml/fastinfoset/FastInfoset/1.2.16/FastInfoset-1.2.16.pom
https://plugins.gradle.org/m2/com/sun/xml/fastinfoset/fastinfoset-project/1.2.16/fastinfoset-project-1.2.16.pom
https://plugins.gradle.org/m2/commons-beanutils/commons-beanutils/1.8.0/commons-beanutils-1.8.0.jar
https://plugins.gradle.org/m2/commons-beanutils/commons-beanutils/1.8.0/commons-beanutils-1.8.0.pom
https://plugins.gradle.org/m2/commons-codec/commons-codec/1.10/commons-codec-1.10.pom
https://plugins.gradle.org/m2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar
https://plugins.gradle.org/m2/commons-codec/commons-codec/1.11/commons-codec-1.11.pom
https://plugins.gradle.org/m2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar
https://plugins.gradle.org/m2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.pom
https://plugins.gradle.org/m2/commons-io/commons-io/2.11.0/commons-io-2.11.0.jar
https://plugins.gradle.org/m2/commons-io/commons-io/2.11.0/commons-io-2.11.0.pom
https://plugins.gradle.org/m2/commons-io/commons-io/2.4/commons-io-2.4.jar
https://plugins.gradle.org/m2/commons-io/commons-io/2.4/commons-io-2.4.pom
https://plugins.gradle.org/m2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
https://plugins.gradle.org/m2/commons-lang/commons-lang/2.4/commons-lang-2.4.pom
https://plugins.gradle.org/m2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
https://plugins.gradle.org/m2/commons-lang/commons-lang/2.6/commons-lang-2.6.pom
https://plugins.gradle.org/m2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.pom
https://plugins.gradle.org/m2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar
https://plugins.gradle.org/m2/commons-logging/commons-logging/1.2/commons-logging-1.2.pom
https://plugins.gradle.org/m2/gradle/plugin/com/github/johnrengelman/shadow/7.1.2/shadow-7.1.2.jar
https://plugins.gradle.org/m2/gradle/plugin/com/github/johnrengelman/shadow/7.1.2/shadow-7.1.2.pom
https://plugins.gradle.org/m2/gradle/plugin/com/google/cloud/tools/jib-gradle-plugin/3.2.1/jib-gradle-plugin-3.2.1.jar
https://plugins.gradle.org/m2/gradle/plugin/com/google/cloud/tools/jib-gradle-plugin/3.2.1/jib-gradle-plugin-3.2.1.pom
https://plugins.gradle.org/m2/gradle/plugin/com/google/gradle/osdetector-gradle-plugin/1.7.0/osdetector-gradle-plugin-1.7.0.jar
https://plugins.gradle.org/m2/gradle/plugin/com/google/gradle/osdetector-gradle-plugin/1.7.0/osdetector-gradle-plugin-1.7.0.pom
https://plugins.gradle.org/m2/gradle/plugin/org/kt3k/gradle/plugin/coveralls-gradle-plugin/2.12.0/coveralls-gradle-plugin-2.12.0.jar
https://plugins.gradle.org/m2/gradle/plugin/org/kt3k/gradle/plugin/coveralls-gradle-plugin/2.12.0/coveralls-gradle-plugin-2.12.0.pom
https://plugins.gradle.org/m2/io/grpc/grpc-context/1.22.1/grpc-context-1.22.1.jar
https://plugins.gradle.org/m2/io/grpc/grpc-context/1.22.1/grpc-context-1.22.1.pom
https://plugins.gradle.org/m2/io/opencensus/opencensus-api/0.24.0/opencensus-api-0.24.0.jar
https://plugins.gradle.org/m2/io/opencensus/opencensus-api/0.24.0/opencensus-api-0.24.0.pom
https://plugins.gradle.org/m2/io/opencensus/opencensus-contrib-http-util/0.24.0/opencensus-contrib-http-util-0.24.0.jar
https://plugins.gradle.org/m2/io/opencensus/opencensus-contrib-http-util/0.24.0/opencensus-contrib-http-util-0.24.0.pom
https://plugins.gradle.org/m2/it/unimi/dsi/fastutil/8.4.0/fastutil-8.4.0.jar
https://plugins.gradle.org/m2/it/unimi/dsi/fastutil/8.4.0/fastutil-8.4.0.pom
https://plugins.gradle.org/m2/jakarta/activation/jakarta.activation-api/1.2.1/jakarta.activation-api-1.2.1.jar
https://plugins.gradle.org/m2/jakarta/activation/jakarta.activation-api/1.2.1/jakarta.activation-api-1.2.1.pom
https://plugins.gradle.org/m2/jakarta/xml/bind/jakarta.xml.bind-api-parent/2.3.2/jakarta.xml.bind-api-parent-2.3.2.pom
https://plugins.gradle.org/m2/jakarta/xml/bind/jakarta.xml.bind-api/2.3.2/jakarta.xml.bind-api-2.3.2.jar
https://plugins.gradle.org/m2/jakarta/xml/bind/jakarta.xml.bind-api/2.3.2/jakarta.xml.bind-api-2.3.2.pom
https://plugins.gradle.org/m2/javax/activation/activation/1.1/activation-1.1.jar
https://plugins.gradle.org/m2/javax/activation/activation/1.1/activation-1.1.pom
https://plugins.gradle.org/m2/javax/inject/javax.inject/1/javax.inject-1.jar
https://plugins.gradle.org/m2/javax/inject/javax.inject/1/javax.inject-1.pom
https://plugins.gradle.org/m2/kr/motd/maven/os-maven-plugin/1.7.0/os-maven-plugin-1.7.0.jar
https://plugins.gradle.org/m2/kr/motd/maven/os-maven-plugin/1.7.0/os-maven-plugin-1.7.0.pom
https://plugins.gradle.org/m2/me/champeau/gradle/japicmp-gradle-plugin/0.3.0/japicmp-gradle-plugin-0.3.0.jar
https://plugins.gradle.org/m2/me/champeau/gradle/japicmp-gradle-plugin/0.3.0/japicmp-gradle-plugin-0.3.0.pom
https://plugins.gradle.org/m2/me/champeau/gradle/japicmp/me.champeau.gradle.japicmp.gradle.plugin/0.3.0/me.champeau.gradle.japicmp.gradle.plugin-0.3.0.pom
https://plugins.gradle.org/m2/me/champeau/jmh/jmh-gradle-plugin/0.6.6/jmh-gradle-plugin-0.6.6.jar
https://plugins.gradle.org/m2/me/champeau/jmh/jmh-gradle-plugin/0.6.6/jmh-gradle-plugin-0.6.6.pom
https://plugins.gradle.org/m2/me/champeau/jmh/me.champeau.jmh.gradle.plugin/0.6.6/me.champeau.jmh.gradle.plugin-0.6.6.pom
https://plugins.gradle.org/m2/net/java/dev/jna/jna-platform/5.6.0/jna-platform-5.6.0.jar
https://plugins.gradle.org/m2/net/java/dev/jna/jna-platform/5.6.0/jna-platform-5.6.0.pom
https://plugins.gradle.org/m2/net/java/dev/jna/jna/5.6.0/jna-5.6.0.jar
https://plugins.gradle.org/m2/net/java/dev/jna/jna/5.6.0/jna-5.6.0.pom
https://plugins.gradle.org/m2/net/java/jvnet-parent/1/jvnet-parent-1.pom
https://plugins.gradle.org/m2/net/ltgt/errorprone/net.ltgt.errorprone.gradle.plugin/2.0.2/net.ltgt.errorprone.gradle.plugin-2.0.2.pom
https://plugins.gradle.org/m2/net/ltgt/gradle/gradle-errorprone-plugin/2.0.2/gradle-errorprone-plugin-2.0.2.jar
https://plugins.gradle.org/m2/net/ltgt/gradle/gradle-errorprone-plugin/2.0.2/gradle-errorprone-plugin-2.0.2.pom
https://plugins.gradle.org/m2/net/sf/ezmorph/ezmorph/1.0.6/ezmorph-1.0.6.jar
https://plugins.gradle.org/m2/net/sf/ezmorph/ezmorph/1.0.6/ezmorph-1.0.6.pom
https://plugins.gradle.org/m2/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.jar
https://plugins.gradle.org/m2/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.pom
https://plugins.gradle.org/m2/net/sf/jopt-simple/jopt-simple/4.9/jopt-simple-4.9.jar
https://plugins.gradle.org/m2/net/sf/jopt-simple/jopt-simple/4.9/jopt-simple-4.9.pom
https://plugins.gradle.org/m2/net/sf/json-lib/json-lib/2.3/json-lib-2.3-jdk15.jar
https://plugins.gradle.org/m2/net/sf/json-lib/json-lib/2.3/json-lib-2.3.pom
https://plugins.gradle.org/m2/net/sf/kxml/kxml2/2.3.0/kxml2-2.3.0.jar
https://plugins.gradle.org/m2/net/sf/kxml/kxml2/2.3.0/kxml2-2.3.0.pom
https://plugins.gradle.org/m2/net/sf/proguard/proguard-base/6.0.3/proguard-base-6.0.3.jar
https://plugins.gradle.org/m2/net/sf/proguard/proguard-base/6.0.3/proguard-base-6.0.3.pom
https://plugins.gradle.org/m2/net/sf/proguard/proguard-gradle/6.0.3/proguard-gradle-6.0.3.jar
https://plugins.gradle.org/m2/net/sf/proguard/proguard-gradle/6.0.3/proguard-gradle-6.0.3.pom
https://plugins.gradle.org/m2/net/sf/proguard/proguard-parent/6.0.3/proguard-parent-6.0.3.pom
https://plugins.gradle.org/m2/net/sourceforge/nekohtml/nekohtml/1.9.16/nekohtml-1.9.16.jar
https://plugins.gradle.org/m2/net/sourceforge/nekohtml/nekohtml/1.9.16/nekohtml-1.9.16.pom
https://plugins.gradle.org/m2/org/antlr/antlr4-master/4.5.3/antlr4-master-4.5.3.pom
https://plugins.gradle.org/m2/org/antlr/antlr4/4.5.3/antlr4-4.5.3.jar
https://plugins.gradle.org/m2/org/antlr/antlr4/4.5.3/antlr4-4.5.3.pom
https://plugins.gradle.org/m2/org/apache/ant/ant-launcher/1.10.11/ant-launcher-1.10.11.jar
https://plugins.gradle.org/m2/org/apache/ant/ant-launcher/1.10.11/ant-launcher-1.10.11.pom
https://plugins.gradle.org/m2/org/apache/ant/ant-parent/1.10.11/ant-parent-1.10.11.pom
https://plugins.gradle.org/m2/org/apache/ant/ant/1.10.11/ant-1.10.11.jar
https://plugins.gradle.org/m2/org/apache/ant/ant/1.10.11/ant-1.10.11.pom
https://plugins.gradle.org/m2/org/apache/apache/13/apache-13.pom
https://plugins.gradle.org/m2/org/apache/apache/15/apache-15.pom
https://plugins.gradle.org/m2/org/apache/apache/18/apache-18.pom
https://plugins.gradle.org/m2/org/apache/apache/21/apache-21.pom
https://plugins.gradle.org/m2/org/apache/apache/23/apache-23.pom
https://plugins.gradle.org/m2/org/apache/apache/3/apache-3.pom
https://plugins.gradle.org/m2/org/apache/apache/4/apache-4.pom
https://plugins.gradle.org/m2/org/apache/apache/7/apache-7.pom
https://plugins.gradle.org/m2/org/apache/apache/9/apache-9.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar
https://plugins.gradle.org/m2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-math3/3.2/commons-math3-3.2.jar
https://plugins.gradle.org/m2/org/apache/commons/commons-math3/3.2/commons-math3-3.2.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/11/commons-parent-11.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/17/commons-parent-17.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/25/commons-parent-25.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/28/commons-parent-28.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/34/commons-parent-34.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/35/commons-parent-35.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/42/commons-parent-42.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/5/commons-parent-5.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/52/commons-parent-52.pom
https://plugins.gradle.org/m2/org/apache/commons/commons-parent/9/commons-parent-9.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.2.1/httpclient-4.2.1.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.5.10/httpclient-4.5.10.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.5.10/httpclient-4.5.10.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.5.11/httpclient-4.5.11.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.5.11/httpclient-4.5.11.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpclient/4.5.6/httpclient-4.5.6.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-client/4.2.1/httpcomponents-client-4.2.1.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-client/4.5.10/httpcomponents-client-4.5.10.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-client/4.5.11/httpcomponents-client-4.5.11.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-client/4.5.6/httpcomponents-client-4.5.6.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-core/4.4.10/httpcomponents-core-4.4.10.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-core/4.4.12/httpcomponents-core-4.4.12.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-core/4.4.13/httpcomponents-core-4.4.13.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-parent/10/httpcomponents-parent-10.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcomponents-parent/11/httpcomponents-parent-11.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcore/4.4.10/httpcore-4.4.10.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcore/4.4.12/httpcore-4.4.12.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcore/4.4.12/httpcore-4.4.12.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcore/4.4.13/httpcore-4.4.13.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpcore/4.4.13/httpcore-4.4.13.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpmime/4.5.11/httpmime-4.5.11.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpmime/4.5.11/httpmime-4.5.11.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpmime/4.5.6/httpmime-4.5.6.jar
https://plugins.gradle.org/m2/org/apache/httpcomponents/httpmime/4.5.6/httpmime-4.5.6.pom
https://plugins.gradle.org/m2/org/apache/httpcomponents/project/6/project-6.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-api/2.17.1/log4j-api-2.17.1.jar
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-api/2.17.1/log4j-api-2.17.1.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-core/2.17.1/log4j-core-2.17.1.jar
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j-core/2.17.1/log4j-core-2.17.1.pom
https://plugins.gradle.org/m2/org/apache/logging/log4j/log4j/2.17.1/log4j-2.17.1.pom
https://plugins.gradle.org/m2/org/apache/logging/logging-parent/3/logging-parent-3.pom
https://plugins.gradle.org/m2/org/bouncycastle/bcpg-jdk15on/1.61/bcpg-jdk15on-1.61.jar
https://plugins.gradle.org/m2/org/bouncycastle/bcpg-jdk15on/1.61/bcpg-jdk15on-1.61.pom
https://plugins.gradle.org/m2/org/bouncycastle/bcpkix-jdk15on/1.56/bcpkix-jdk15on-1.56.jar
https://plugins.gradle.org/m2/org/bouncycastle/bcpkix-jdk15on/1.56/bcpkix-jdk15on-1.56.pom
https://plugins.gradle.org/m2/org/bouncycastle/bcpkix-jdk15on/1.61/bcpkix-jdk15on-1.61.jar
https://plugins.gradle.org/m2/org/bouncycastle/bcpkix-jdk15on/1.61/bcpkix-jdk15on-1.61.pom
https://plugins.gradle.org/m2/org/bouncycastle/bcprov-jdk15on/1.56/bcprov-jdk15on-1.56.jar
https://plugins.gradle.org/m2/org/bouncycastle/bcprov-jdk15on/1.56/bcprov-jdk15on-1.56.pom
https://plugins.gradle.org/m2/org/bouncycastle/bcprov-jdk15on/1.61/bcprov-jdk15on-1.61.jar
https://plugins.gradle.org/m2/org/bouncycastle/bcprov-jdk15on/1.61/bcprov-jdk15on-1.61.pom
https://plugins.gradle.org/m2/org/checkerframework/checker-compat-qual/2.5.5/checker-compat-qual-2.5.5.jar
https://plugins.gradle.org/m2/org/checkerframework/checker-compat-qual/2.5.5/checker-compat-qual-2.5.5.pom
https://plugins.gradle.org/m2/org/checkerframework/checker-qual/2.5.2/checker-qual-2.5.2.jar
https://plugins.gradle.org/m2/org/checkerframework/checker-qual/2.5.2/checker-qual-2.5.2.pom
https://plugins.gradle.org/m2/org/checkerframework/checker-qual/2.5.8/checker-qual-2.5.8.pom
https://plugins.gradle.org/m2/org/checkerframework/checker-qual/3.12.0/checker-qual-3.12.0.jar
https://plugins.gradle.org/m2/org/checkerframework/checker-qual/3.12.0/checker-qual-3.12.0.pom
https://plugins.gradle.org/m2/org/codehaus/groovy/modules/http-builder/http-builder/0.7.1/http-builder-0.7.1.jar
https://plugins.gradle.org/m2/org/codehaus/groovy/modules/http-builder/http-builder/0.7.1/http-builder-0.7.1.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer-annotations/1.17/animal-sniffer-annotations-1.17.jar
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer-annotations/1.17/animal-sniffer-annotations-1.17.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer-parent/1.17/animal-sniffer-parent-1.17.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer-parent/1.20/animal-sniffer-parent-1.20.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer/1.20/animal-sniffer-1.20.jar
https://plugins.gradle.org/m2/org/codehaus/mojo/animal-sniffer/1.20/animal-sniffer-1.20.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/mojo-parent/40/mojo-parent-40.pom
https://plugins.gradle.org/m2/org/codehaus/mojo/mojo-parent/61/mojo-parent-61.pom
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus-utils/3.4.1/plexus-utils-3.4.1.jar
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus-utils/3.4.1/plexus-utils-3.4.1.pom
https://plugins.gradle.org/m2/org/codehaus/plexus/plexus/8/plexus-8.pom
https://plugins.gradle.org/m2/org/eclipse/ee4j/project/1.0.2/project-1.0.2.pom
https://plugins.gradle.org/m2/org/eclipse/ee4j/project/1.0.5/project-1.0.5.pom
https://plugins.gradle.org/m2/org/eclipse/jgit/org.eclipse.jgit-parent/5.5.1.201910021850-r/org.eclipse.jgit-parent-5.5.1.201910021850-r.pom
https://plugins.gradle.org/m2/org/eclipse/jgit/org.eclipse.jgit/5.5.1.201910021850-r/org.eclipse.jgit-5.5.1.201910021850-r.jar
https://plugins.gradle.org/m2/org/eclipse/jgit/org.eclipse.jgit/5.5.1.201910021850-r/org.eclipse.jgit-5.5.1.201910021850-r.pom
https://plugins.gradle.org/m2/org/glassfish/jaxb/jaxb-bom/2.3.2/jaxb-bom-2.3.2.pom
https://plugins.gradle.org/m2/org/glassfish/jaxb/jaxb-runtime/2.3.2/jaxb-runtime-2.3.2.jar
https://plugins.gradle.org/m2/org/glassfish/jaxb/jaxb-runtime/2.3.2/jaxb-runtime-2.3.2.pom
https://plugins.gradle.org/m2/org/glassfish/jaxb/txw2/2.3.2/txw2-2.3.2.jar
https://plugins.gradle.org/m2/org/glassfish/jaxb/txw2/2.3.2/txw2-2.3.2.pom
https://plugins.gradle.org/m2/org/javassist/javassist/3.24.0-GA/javassist-3.24.0-GA.jar
https://plugins.gradle.org/m2/org/javassist/javassist/3.24.0-GA/javassist-3.24.0-GA.pom
https://plugins.gradle.org/m2/org/jdom/jdom2/2.0.6/jdom2-2.0.6.jar
https://plugins.gradle.org/m2/org/jdom/jdom2/2.0.6/jdom2-2.0.6.pom
https://plugins.gradle.org/m2/org/jetbrains/annotations/13.0/annotations-13.0.jar
https://plugins.gradle.org/m2/org/jetbrains/annotations/13.0/annotations-13.0.pom
https://plugins.gradle.org/m2/org/jetbrains/intellij/deps/trove4j/1.0.20181211/trove4j-1.0.20181211.jar
https://plugins.gradle.org/m2/org/jetbrains/intellij/deps/trove4j/1.0.20181211/trove4j-1.0.20181211.pom
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-reflect/1.4.31/kotlin-reflect-1.4.31.jar
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-reflect/1.4.31/kotlin-reflect-1.4.31.pom
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-common/1.4.31/kotlin-stdlib-common-1.4.31.jar
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-common/1.4.31/kotlin-stdlib-common-1.4.31.pom
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-jdk7/1.4.31/kotlin-stdlib-jdk7-1.4.31.jar
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-jdk7/1.4.31/kotlin-stdlib-jdk7-1.4.31.pom
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-jdk8/1.4.31/kotlin-stdlib-jdk8-1.4.31.jar
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib-jdk8/1.4.31/kotlin-stdlib-jdk8-1.4.31.pom
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib/1.4.31/kotlin-stdlib-1.4.31.jar
https://plugins.gradle.org/m2/org/jetbrains/kotlin/kotlin-stdlib/1.4.31/kotlin-stdlib-1.4.31.pom
https://plugins.gradle.org/m2/org/json/json/20180813/json-20180813.jar
https://plugins.gradle.org/m2/org/json/json/20180813/json-20180813.pom
https://plugins.gradle.org/m2/org/junit/junit-bom/5.7.2/junit-bom-5.7.2.pom
https://plugins.gradle.org/m2/org/jvnet/staxex/stax-ex/1.8.1/stax-ex-1.8.1.jar
https://plugins.gradle.org/m2/org/jvnet/staxex/stax-ex/1.8.1/stax-ex-1.8.1.pom
https://plugins.gradle.org/m2/org/openjdk/jmh/jmh-core/1.29/jmh-core-1.29.jar
https://plugins.gradle.org/m2/org/openjdk/jmh/jmh-core/1.29/jmh-core-1.29.pom
https://plugins.gradle.org/m2/org/openjdk/jmh/jmh-parent/1.29/jmh-parent-1.29.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/7.0/asm-analysis-7.0.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/7.0/asm-analysis-7.0.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/9.2/asm-analysis-9.2.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-analysis/9.2/asm-analysis-9.2.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/7.0/asm-commons-7.0.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/7.0/asm-commons-7.0.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/9.2/asm-commons-9.2.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-commons/9.2/asm-commons-9.2.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/7.0/asm-tree-7.0.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/7.0/asm-tree-7.0.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/9.2/asm-tree-9.2.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-tree/9.2/asm-tree-9.2.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm-util/7.0/asm-util-7.0.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm-util/7.0/asm-util-7.0.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm/7.0/asm-7.0.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.1/asm-9.1.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.1/asm-9.1.pom
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.2/asm-9.2.jar
https://plugins.gradle.org/m2/org/ow2/asm/asm/9.2/asm-9.2.pom
https://plugins.gradle.org/m2/org/ow2/ow2/1.5/ow2-1.5.pom
https://plugins.gradle.org/m2/org/slf4j/slf4j-api/1.7.2/slf4j-api-1.7.2.jar
https://plugins.gradle.org/m2/org/slf4j/slf4j-api/1.7.2/slf4j-api-1.7.2.pom
https://plugins.gradle.org/m2/org/slf4j/slf4j-parent/1.7.2/slf4j-parent-1.7.2.pom
https://plugins.gradle.org/m2/org/sonatype/oss/oss-parent/5/oss-parent-5.pom
https://plugins.gradle.org/m2/org/sonatype/oss/oss-parent/6/oss-parent-6.pom
https://plugins.gradle.org/m2/org/sonatype/oss/oss-parent/7/oss-parent-7.pom
https://plugins.gradle.org/m2/org/sonatype/oss/oss-parent/9/oss-parent-9.pom
https://plugins.gradle.org/m2/org/tensorflow/tensorflow-lite-metadata/0.1.0-rc2/tensorflow-lite-metadata-0.1.0-rc2.jar
https://plugins.gradle.org/m2/org/tensorflow/tensorflow-lite-metadata/0.1.0-rc2/tensorflow-lite-metadata-0.1.0-rc2.pom
https://plugins.gradle.org/m2/org/vafer/jdependency/2.7.0/jdependency-2.7.0.jar
https://plugins.gradle.org/m2/org/vafer/jdependency/2.7.0/jdependency-2.7.0.pom
https://plugins.gradle.org/m2/ru/vyarus/animalsniffer/ru.vyarus.animalsniffer.gradle.plugin/1.5.4/ru.vyarus.animalsniffer.gradle.plugin-1.5.4.pom
https://plugins.gradle.org/m2/ru/vyarus/gradle-animalsniffer-plugin/1.5.4/gradle-animalsniffer-plugin-1.5.4.jar
https://plugins.gradle.org/m2/ru/vyarus/gradle-animalsniffer-plugin/1.5.4/gradle-animalsniffer-plugin-1.5.4.pom
https://plugins.gradle.org/m2/xerces/xercesImpl/2.12.0/xercesImpl-2.12.0.jar
https://plugins.gradle.org/m2/xerces/xercesImpl/2.12.0/xercesImpl-2.12.0.pom
https://plugins.gradle.org/m2/xerces/xercesImpl/2.9.1/xercesImpl-2.9.1.jar
https://plugins.gradle.org/m2/xerces/xercesImpl/2.9.1/xercesImpl-2.9.1.pom
https://plugins.gradle.org/m2/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.jar
https://plugins.gradle.org/m2/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.pom
https://plugins.gradle.org/m2/xml-resolver/xml-resolver/1.2/xml-resolver-1.2.jar
https://plugins.gradle.org/m2/xml-resolver/xml-resolver/1.2/xml-resolver-1.2.pom
"
JAVA_PKG_WANT_TARGET="${JAVA_SLOT}"
JAVA_PKG_WANT_SOURCE="${JAVA_SLOT}"

gen_uris() {
	local URIS=""
	local uri

	if [[ "${USE}" =~ "android" ]] ; then
		URIS="${GRADLE_PKGS_URIS_ANDROID}"
		echo " android? ( "
	else
		URIS="${GRADLE_PKGS_URIS_NO_ANDROID}"
		echo " !android? ( "
	fi

	# Prevent collision same jar names but different namespace/content/hash
	for uri in ${URIS} ; do
		if [[ "${uri}" =~ "gradle/plugin" ]] ; then
			local bn="${uri##*/}"
			echo " ${uri} -> ${bn}2"
		else
			echo " ${uri} "
		fi
	done
		echo " ) "
}

SRC_URI+="
	https://github.com/grpc/grpc-java/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
if [[ "${GEN_EBUILD}" == "1" ]] ; then
	:;
else
	SRC_URI+="
		$(gen_uris)
	"
fi
S="${WORKDIR}/${P}"
DOCS=( AUTHORS LICENSE NOTICE.txt README.md )
PATCHES=(
	"${FILESDIR}/${PN}-1.51.1-allow-sandbox-in-artifact-check.patch"
)

pkg_setup() {
	if ( [[ "${GEN_EBUILD}" == "1" ]] || use android || use doc ) \
		&& has network-sandbox ${FEATURES} ; then
eerror
eerror "Building requires network-sandbox to be disabled in FEATURES on a"
eerror "per-package level."
eerror
		die
	fi
	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	local java_vendor=$(java-pkg_get-vm-vendor)
	if ! [[ "${java_vendor}" =~ "openjdk" ]] ; then
ewarn
ewarn "Java vendor mismatch.  Runtime failure or quirks may show."
ewarn
ewarn "Actual Java vendor:  ${java_vendor}"
ewarn "Expected java vendor:  openjdk"
ewarn
	fi
	use android && ewarn "The android USE flag is still in development"
}

unpack_gradle()
{
	local paths=()
	IFS=$'\n'
	if use android ; then
		paths=(
			${GRADLE_PKGS_UNPACK_ANDROID[@]}
		)
	else
		paths=(
			${GRADLE_PKGS_UNPACK_NO_ANDROID[@]}
		)
	fi
	for x in ${paths[@]} ; do
		[[ "${x}" =~ "gradle.plugin." ]] && x="${x}2"
		d_rel="$(dirname ${x})"
		local d_rel=$(dirname "${x}" \
			| sed -r -e "s|/[0-9a-z]{38,40}||g" \
			| tr "/" "\n" \
			| sed -e "1s|[.]|/|g" \
			| tr "\n" "/" \
			| sed -e "s|/$||g")
		local d_base="${WORKDIR}/.m2/repository"
		local d="${d_base}/${d_rel}"
		mkdir -p "${d}" || die
		local s=$(realpath "${DISTDIR}/"$(basename ${x}))
		einfo "Copying ${s} to ${d}"
		cp -a "${s}" "${d}" || die

		if [[ "${s}" =~ ".pom2" ]] ; then
			mv "${d}"/$(basename "${s}") "${d}"/$(basename "${s/.pom2/.pom}") || die
		fi
		if [[ "${s}" =~ ".jar2" ]] ; then
			mv "${d}"/$(basename "${s}") "${d}"/$(basename "${s/.jar2/.jar}") || die
		fi
	done
	IFS=$' \t\n'
}

src_unpack() {
	unpack ${P}.tar.gz
	if [[ "${GEN_EBUILD}" == "1" ]] ; then
		:;
	else
		unpack_gradle
	fi
}

add_localmaven() {
	local path
	for path in $(find "${WORKDIR}" -name "settings.gradle" -o -name "build.gradle") ; do
		if grep -q -e "repositories {" "${path}" ; then
			local pos
			for pos in $(grep -n -e "repositories {" "${path}" | cut -f 1 -d ":" | tac) ; do
				# Prevent deletion of .m2 with url instead of localMaven()
				einfo "Editing ${path} at ${pos} for localMaven()"
				sed -i -e "${pos}a maven { url '${WORKDIR}/.m2/repository' }" "${path}" || die
			done
		fi
	done
}

src_configure() {
	if [[ "${GEN_EBUILD}" == "1" ]] ; then
		:;
	else
		add_localmaven
	fi
	if use android ; then
		echo "android.useAndroidX=true" > gradle.properties || die
	fi
	local bn=$(basename $(realpath "${ESYSROOT}/$(get_libdir)/ld-linux-"*".so.2") \
		| sed  -e 's|[.]|\\.|g')
	export ARTIFACT_CHECK_EXTRA="${bn}"
}

src_compile() {
	einfo "USER:\t\t\t${USER}"
	einfo "HOME:\t\t\t${HOME}"
	export USER_HOME="${HOME}"
	export GRADLE_USER_HOME="${USER_HOME}/.gradle"
	[[ -z "${ANDROID_HOME}" ]] && die "You need to \`source /etc/profile\`"
	export ANDROID_SDK_ROOT="${ESYSROOT}/${ANDROID_HOME}"
	export ANDROID_TOOLS="${ESYSROOT}/${ANDROID_HOME}/tools"
	export ANDROID_PLATFORM_TOOLS="${ESYSROOT}/${ANDROID_HOME}/platform-tools"
	export ANDROID_SDK_HOME="${HOME}/.android"
	mkdir -p "${ANDROID_SDK_HOME}" || die
	export PATH="${ESYSROOT}/usr/share/gradle-bin-${GRADLE_PV}/bin:${ANDROID_TOOLS}:${PLATFORM_TOOLS}:${PATH}"
	append-ldflags -L"${EPREFIX}/usr/$(get_libdir)"
	append-cxxflags -I"${EPREFIX}/usr/include"
	export LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)"
	einfo "ANDROID_HOME:\t\t${ANDROID_HOME}"
	einfo "ANDROID_SDK_ROOT:\t\t${ANDROID_SDK_ROOT}"
	einfo "ANDROID_TOOLS:\t\t${ANDROID_TOOLS}"
	einfo "ANDROID_PLATFORM_TOOLS:\t${ANDROID_PLATFORM_TOOLS}"
	einfo "GRADLE_USER_HOME:\t\t${GRADLE_USER_HOME}"
	einfo "PATH:\t\t\t${PATH}"

# For arches, see
# https://docs.gradle.org/current/javadoc/org/gradle/nativeplatform/platform/Architecture.html

	# See build.gradle
	local arch_flag
	if [[ "${ABI}" =~ "amd64" ]] ; then
		arch_flag="-PtargetAarch=x86_64"
	elif [[ "${ABI}" =~ "x86" ]] ; then
		arch_flag="-PtargetAarch=x86_32"
	elif [[ "${ABI}" =~ "ppc64" ]] ; then
		arch_flag="-PtargetAarch=ppcle_64"
	elif [[ "${ABI}" =~ "arm64" ]] ; then
		arch_flag="-PtargetAarch=aarch_64"
	elif [[ "${ABI}" =~ "s390" ]] ; then
		arch_flag="-PtargetAarch=s390_64"
	elif [[ "${ABI}" =~ "loong" ]] ; then
		arch_flag="-PtargetAarch=loongarch_64"
	# else
	#	autodetect
	fi

	# Breaks if -j1 or -Dorg.gradle.parallel=false
	local args=(
		${arch_flag}
		-Dgradle.user.home="${USER_HOME}"
		-Djava.util.prefs.systemRoot="${USER_HOME}/.java"
		-Djava.util.prefs.userRoot="${USER_HOME}/.java/.userPrefs"
		-Dmaven.repo.local="${USER_HOME}/.m2/repository"
		-Dorg.gradle.parallel=true
		-Duser.home="${WORKDIR}/homedir"
		-i
		-Pprotoc="${ESYSROOT}/usr/bin/protoc"
		-PskipAndroid=$(usex !android "true" "false")
	)

	# From Included projects: in logs
	local TG=(
		":grpc-all"
		":grpc-alts"
		":grpc-api"
		":grpc-auth"
		":grpc-authz"
		":grpc-benchmarks"
		":grpc-bom"
		":grpc-census"
		":grpc-compiler"
		":grpc-context"
		":grpc-core"
		":grpc-gae-interop-testing-jdk8"
		":grpc-gcp-observability"
		":grpc-googleapis"
		":grpc-grpclb"
		":grpc-interop-testing"
		":grpc-istio-interop-testing"
		":grpc-netty"
		":grpc-netty-shaded"
		":grpc-okhttp"
		":grpc-protobuf"
		":grpc-protobuf-lite"
		":grpc-rls"
		":grpc-services"
		":grpc-stub"
		":grpc-testing"
		":grpc-testing-proto"
		":grpc-xds"
	)

	if use android ; then
		TG+=(
			":grpc-android"
			":grpc-android-interop-testing"
			":grpc-binder"
			":grpc-cronet"
		)
	fi

	if ! use doc ; then
		local t
		for t in ${TG[@]} ; do
			[[ "${t}" =~ ":grpc-bom" ]] && continue
			args+=( -x "${t}:javadoc" )
		done
	fi

	if ! use test ; then
		local t
		for t in ${TG[@]} ; do
			[[ "${t}" =~ ":grpc-bom" ]] && continue
			args+=( -x "${t}:test" )
		done
	fi

	export 'GRADLE_OPTS=-Dorg.gradle.jvmargs='\''-Xmx1g'\'''
	mkdir -p "${WORKDIR}/homedir" || die

einfo "GRADLE_OPTS:\t\t\t${GRADLE_OPTS}"

einfo "gradle build ${flags} ${args[@]}"

	gradle \
		build \
		${args[@]} \
		|| die
	if [[ "${GEN_EBUILD}" == "1" ]] ; then
einfo
einfo "Update GRADLE_PKGS_URIS:"
einfo
		grep -o -E -r -e "http[s]?://.*(\.jar|\.pom|\.signature) " \
			"${T}/build.log" \
			| sort \
			| uniq \
			| sed -e "s| ||g"

einfo
einfo "Update GRADLE_PKGS_UNPACK:"
einfo
		# For EPREFIX offset adjust 12-
		find "${HOME}/caches/modules-2/files-2.1/" \
			-name "*.pom" \
			-o -name "*.jar" \
			-o -name "*.signature" \
			-not -type d \
			| cut -f 11- -d "/" \
			| sort \
			| uniq
		die
	fi
	addpredict /var/lib/portage/home/.java
	gradle \
		publishToMavenLocal \
		${args[@]} \
		|| die
}

src_install() {
	local modules=(
		$(ls -1 "${HOME}/.m2/repository/io/grpc")
	)

	for m in ${modules[@]} ; do
		if [[ ! -e "${HOME}/.m2/repository/io/grpc/${m}/${PV}/${m}-${PV}.jar" ]] ; then
ewarn "Skipping ${HOME}/.m2/repository/io/grpc/${m}/${PV}/${m}-${PV}.jar and related jars"
			continue
		fi
		java-pkg_jarinto "/usr/share/${PN}/lib"
		java-pkg_newjar \
			"${HOME}/.m2/repository/io/grpc/${m}/${PV}/${m}-${PV}.jar" \
			"${m}.jar"
		java-pkg_jarinto "/usr/share/${PN}/html/api"
		use doc && java-pkg_newjar \
			"${HOME}/.m2/repository/io/grpc/${m}/${PV}/${m}-${PV}-javadoc.jar" \
			"${m}-javadoc.jar"
		java-pkg_jarinto "/usr/share/${PN}/source"
		use source && java-pkg_newjar \
			"${HOME}/.m2/repository/io/grpc/${m}/${PV}/${m}-${PV}-sources.jar" \
			"${m}-sources.jar"
	done

	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
