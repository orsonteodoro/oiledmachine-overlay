# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GRADLE_PV="7.6" # https://github.com/grpc/grpc-java/blob/v1.30.2/gradle/wrapper/gradle-wrapper.properties
JAVA_COMPAT=( "java_slot_1_8" ) # https://github.com/grpc/grpc-java/blob/v1.30.2/README.md

inherit check-compiler-switch flag-o-matic gradle java-pkg-2

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI+="
https://github.com/grpc/grpc-java/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Java libraries for the high performance gRPC framework"
HOMEPAGE="https://grpc.io"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		Apache-2.0
		|| (
			GPL-2+
			MIT
		)
	)
	(
		Apache-1.1
		custom
	)
	Apache-1.0
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	CDDL
	CDDL-1.1
	custom
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
	|| (
		Apache-2.0
		LGPL-2.1+
	)
	|| (
		(
			Apache-1.1
			custom
		)
		Apache-1.1
		Apache-2.0
		BSD
		public-domain
	)
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	Apache-2.0
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

RESTRICT="mirror"
SLOT="0"
IUSE+="
${JAVA_COMPAT[@]}
android codegen doc source test
ebuild_revision_3
"
# Cannot fix at the moment ANDROID_HOME="/var/lib/portage/home/.android" sandbox violation
#	!android
REQUIRED_USE+="
	^^ (
		${JAVA_COMPAT[@]}
	)
	android? (
		java_slot_1_8
	)
"
gen_jre_rdepend() {
	local s
	for s in ${JAVA_COMPAT[@]} ; do
		echo "
			virtual/jre:${s}
		"
	done
}
gen_jdk_bdepend() {
	local s
	for s in ${JAVA_COMPAT[@]} ; do
		echo "
			virtual/jdk:${s}
		"
	done
}
RDEPEND+="
	dev-libs/protobuf:0/3.12[static-libs]
	dev-libs/protobuf:=
	|| (
		$(gen_jre_rdepend)
	)
"
DEPEND+="
	${RDEPEND}
"
# Build tools ver:  https://github.com/grpc/grpc-java/blob/v1.30.2/buildscripts/kokoro/android.sh
# SDK ver: https://github.com/grpc/grpc-java/blob/v1.30.2/android/build.gradle#L10
BDEPEND+="
	|| (
		$(gen_jre_rdepend)
	)
	android? (
		dev-util/android-sdk-update-manager
		dev-util/android-sdk-platform:28
		=dev-util/android-sdk-build-tools-28*
		dev-util/android-sdk-commandlinetools
	)
"

DOCS=( "AUTHORS" "LICENSE" "NOTICE.txt" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-1.51.1-allow-sandbox-in-artifact-check.patch"
	"${FILESDIR}/${PN}-1.54.2-allow-sandbox-so.patch"
)

pkg_setup() {
	check-compiler-switch_start
	gradle_check_network_sandbox
	if use java_slot_1_8 ; then
		export JAVA_PKG_WANT_TARGET="1.8"
		export JAVA_PKG_WANT_SOURCE="1.8"
		export JAVA_SLOT="1.8"
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

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	gradle_src_configure

	# See https://github.com/grpc/grpc-java/blob/v1.30.2/COMPILING.md?plain=1#L9
	if ! use codegen ; then
		echo "skipCodegen=true" >> gradle.properties || die
	fi

	if use android ; then
		echo "android.useAndroidX=true" >> gradle.properties || die
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
	if use android && [[ -z "${ANDROID_HOME}" ]] ; then
		die "You need to \`source /etc/profile\`"
	fi
	if use android ; then
		export ANDROID_SDK_ROOT="${ESYSROOT}/${ANDROID_HOME}"
		export ANDROID_TOOLS="${ESYSROOT}/${ANDROID_HOME}/tools"
		export ANDROID_PLATFORM_TOOLS="${ESYSROOT}/${ANDROID_HOME}/platform-tools"
		export ANDROID_SDK_HOME="${HOME}/.android"
		mkdir -p "${ANDROID_SDK_HOME}" || die
		export PATH="${ESYSROOT}/usr/share/gradle-bin-${GRADLE_PV}/bin:${ANDROID_TOOLS}:${ANDROID_PLATFORM_TOOLS}:${PATH}"
	fi
	append-ldflags -L"${EPREFIX}/usr/$(get_libdir)"
	append-cxxflags -I"${EPREFIX}/usr/include"
	export LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)"
	if use android ; then
einfo "ANDROID_HOME:\t\t${ANDROID_HOME}"
einfo "ANDROID_SDK_ROOT:\t\t${ANDROID_SDK_ROOT}"
einfo "ANDROID_TOOLS:\t\t${ANDROID_TOOLS}"
einfo "ANDROID_PLATFORM_TOOLS:\t${ANDROID_PLATFORM_TOOLS}"
	fi
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
		-Dorg.gradle.parallel=true
		-Pprotoc="${ESYSROOT}/usr/bin/protoc"
		-PskipAndroid=$(usex !android "true" "false")
	)
	local codegen_plugin_args=(
		${arch_flag}
		-Dorg.gradle.parallel=true
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
	if use codegen ; then
		TG+=(
			":grpc-compiler"
		)
	fi

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
			args+=(
				-x "${t}:javadoc"
			)
		done
	fi

	if ! use test ; then
		local t
		for t in ${TG[@]} ; do
			[[ "${t}" =~ ":grpc-bom" ]] && continue
			args+=(
				-x "${t}:test"
			)
		done
	fi

	export 'GRADLE_OPTS=-Dorg.gradle.jvmargs='\''-Xmx1g'\'''
	mkdir -p "${WORKDIR}/homedir" || die

einfo "GRADLE_OPTS:\t\t\t${GRADLE_OPTS}"

einfo "gradle build ${flags} ${args[@]}"
# See https://github.com/grpc/grpc-java/blob/v1.30.2/COMPILING.md

	if use codegen ; then
einfo "Building codegen plugin"
		pushd "compiler" >/dev/null 2>&1 || die
			egradle \
				"java_pluginExecutable" \
				${codegen_plugin_args[@]}
			egradle \
				"buildArtifacts" \
				${codegen_plugin_args[@]}
			egradle \
				"publishToMavenLocal" \
				${args[@]}
		popd >/dev/null 2>&1 || die
	fi

	egradle \
		"build" \
		${args[@]}
	addpredict "/var/lib/portage/home/.java"
	egradle \
		"publishToMavenLocal" \
		${args[@]}
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

	if use codegen ; then
		exeinto "/usr/bin"
		doexe "${S}/compiler/build/exe/java_plugin/protoc-gen-grpc-java"
		dosym \
			"/usr/bin/protoc-gen-grpc-java" \
			"/usr/bin/protoc-gen-grpc-java.exe"
	fi

	einstalldocs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
