# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: graalvm.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for offline download of GraalVM
# @DESCRIPTION:
# For offline download of GraalVM CE.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_graalvm_set_globals() {
	GRAALVM_EDITION="${GRAALVM_EDITION:-ce}"
einfo "GRAALVM_EDITION:\t${GRAALVM_EDITION}"
	GRAALVM_MAINTENACE_MODE="${GRAALVM_MAINTENACE_MODE:-1}"
}

_graalvm_set_globals
unset -f _graalvm_set_globals

# @ECLASS_VARIABLE: GRAAL_VM_CE_LICENSES
# @DESCRIPTION:
# All licenses associated with this project.
# Concatenate with the package license.
GRAAL_VM_CE_LICENSES="
	(
		all-rights-reserved
		MIT
	)
	GraalVM_CE_22.3_LICENSE
	GraalVM_CE_22.3_LICENSE_NATIVEIMAGE
	GraalVM_CE_22.3_THIRD_PARTY_LICENSE
	GPL-2-with-classpath-exception
	Apache-2.0
	BSD
	BSD-2
	CPL-1.0
	CDDL
	CDDL-1.1
	CC0-1.0
	EPL-1.0
	EPL-2.0
	icu-68.1
	JDOM
	JSON
	LGPL-2.1
	LGPL-2.1+
	MIT
	NAIST-IPADIC
	UPL-1.0
	unicode
	Unicode-DFS-2016
	W3C
	W3C-Software-Notice-and-License
	W3C-Software-and-Document-Notice-and-License
	W3C-Software-and-Document-Notice-and-License-20021231
	|| (
		GPL-2+
		LGPL-2.1+
		MPL-1.1
	)
	|| (
		Apache-2.0
		GPL-2+-with-classpath-exception
	)
" # It includes third party licenses.

# @ECLASS_VARIABLE: GRAALVM_CE_DEPENDS
# @DESCRIPTION:
# Concatinate it with BDEPENDs.
GRAALVM_CE_DEPENDS="
	sys-devel/gcc[cxx]
	sys-libs/glibc
	sys-libs/zlib
"

# @ECLASS_VARIABLE: GRAALVM_MODE
# @DESCRIPTION:
# For extracting versions.
# Valid values: live, offline

# @ECLASS_VARIABLE: GRAALVM_PV
# @DESCRIPTION:
# The GraalVM CE point release to download.

# @ECLASS_VARIABLE: GRAALVM_JAVA_PV
# @DESCRIPTION:
# The GraalVM Java version to download.

# @FUNCTION: graalvm_gen_native_image_uris
# @DESCRIPTION:
# Generates URIs for GraalVM CE native image downloads.
_graalvm_gen_base_ce_uris() {
	echo "
		kernel_Darwin? (
			arm64-macos? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/graalvm-ce-java${GRAALVM_JAVA_PV}-darwin-aarch64-${GRAALVM_PV}.tar.gz
			)
			x64-macos? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/graalvm-ce-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.tar.gz
			)
		)
		kernel_linux? (
			elibc_glibc? (
				amd64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/graalvm-ce-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.tar.gz

				)
				arm64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/graalvm-ce-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.tar.gz
				)
			)
		)
	"
}

# @FUNCTION: graalvm_gen_native_image_uris
# @DESCRIPTION:
# Generates URIs for GraalVM EE native image downloads.
_graalvm_gen_base_ee_uris() {
	echo "
		kernel_Darwin? (
			arm64-macos? (
graalvm-ee-java${GRAALVM_JAVA_PV}-darwin-aarch64-${GRAALVM_PV}.tar.gz
			)
			x64-macos? (
graalvm-ee-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.tar.gz
			)
		)
		kernel_linux? (
			elibc_glibc? (
				amd64? (
graalvm-ee-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.tar.gz

				)
				arm64? (
graalvm-ee-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.tar.gz
				)
			)
		)
	"
}

# @FUNCTION: graalvm_gen_base_uris
# @DESCRIPTION:
# Generates URIs for GraalVM base downloads.
graalvm_gen_base_uris() {
	if [[ "${GRAALVM_MAINTENACE_MODE}" == "1" ]] ; then
		_graalvm_gen_base_ce_uris_maintenance_mode
	elif [[ "${GRAALVM_EDITION}" == "ce" ]] ; then
		_graalvm_gen_base_ce_uris
	else
		_graalvm_gen_base_ee_uris
	fi
}

# @FUNCTION: graalvm_gen_native_image_uris
# @DESCRIPTION:
# Generates URIs for GraalVM CE native image downloads.
_graalvm_gen_native_image_ce_uris() {
	echo "
		kernel_Darwin? (
			arm64-macos? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/native-image-installable-svm-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.jar
	-> native-image-ce-installable-svm-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.jar
			)
			x64-macos? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/native-image-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
	-> native-image-ce-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
			)
		)
		kernel_linux? (
			elibc_glibc? (
				amd64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/native-image-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar
	-> native-image-ce-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar
				)
				arm64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/native-image-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
	-> native-image-ce-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
				)
			)
		)
	"
}

# @FUNCTION: graalvm_gen_native_image_uris
# @DESCRIPTION:
# Generates URIs for GraalVM EE native image downloads.
_graalvm_gen_native_image_ee_uris() {
	echo "
		kernel_Darwin? (
			arm64-macos? (
native-image-ee-installable-svm-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.jar
			)
			x64-macos? (
native-image-ee-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
			)
		)
		kernel_linux? (
			elibc_glibc? (
				amd64? (
native-image-ee-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar
				)
				arm64? (
native-image-ee-installable-svm-java${GRAALVM_JAVA_PV}-linux-aarch64-${GRAALVM_PV}.jar
				)
			)
		)
	"
}

# @FUNCTION: graalvm_gen_native_image_uris
# @DESCRIPTION:
# Generates URIs for GraalVM native image downloads.
graalvm_gen_native_image_uris() {
	if [[ "${GRAALVM_MAINTENACE_MODE}" == "1" ]] ; then
		_graalvm_gen_native_image_ce_uris_maintenance_mode
	elif [[ "${GRAALVM_EDITION}" == "ce" ]] ; then
		_graalvm_gen_native_image_ce_uris
	else
		_graalvm_gen_native_image_ee_uris
	fi
}

# @FUNCTION: _graalvm_gen_native_image_ce_uris_maintenance_mode
# @DESCRIPTION:
# For eclass/ebuild testing.
_graalvm_gen_native_image_ce_uris_maintenance_mode() {
	echo "
		kernel_linux? (
			elibc_glibc? (
				amd64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/native-image-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar
	-> native-image-ce-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar
				)
			)
		)
	"
}

# @FUNCTION: _graalvm_gen_base_ce_uris_maintenance_mode
# @DESCRIPTION:
# For eclass/ebuild testing.
_graalvm_gen_base_ce_uris_maintenance_mode() {
	echo "
		kernel_linux? (
			elibc_glibc? (
				amd64? (
https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_PV}/graalvm-ce-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.tar.gz

				)
			)
		)
	"
}

# @FUNCTION: graalvm_get_platarch
# @DESCRIPTION:
# Gets the platform and architecture.
graalvm_get_platarch() {
	if use kernel_Darwin && use arm64-macos ; then
		echo "darwin-aarch64"
	elif use kernel_Darwin && use x64-macos ; then
		echo "darwin-amd64"
	elif use kernel_linux && use amd64 && use elibc_glibc ; then
		echo "linux-amd64"
	elif use kernel_linux && use arm64 && use elibc_glibc ; then
		echo "linux-arm64"
	fi
}

# @FUNCTION: graalvm_get_base_tarball_name
# @DESCRIPTION:
# Gets the tarball name.
graalvm_get_base_tarball_name() {
	if use kernel_Darwin && use arm64-macos ; then
		echo "graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-darwin-aarch64-${GRAALVM_PV}.tar.gz"
	elif use kernel_Darwin && use x64-macos ; then
		echo "graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.tar.gz"
	elif use kernel_linux && use amd64 ; then
		echo "graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.tar.gz"
	elif use kernel_linux && use arm64 ; then
		echo "graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-linux-arm64-${GRAALVM_PV}.tar.gz"
	fi
}

# @FUNCTION: graalvm_get_native_image_tarball_name
# @DESCRIPTION:
# Gets the tarball name.
graalvm_get_native_image_tarball_name() {
	if use kernel_Darwin && use arm64-macos ; then
		echo "native-image-${GRAALVM_EDITION}-installable-svm-java${GRAALVM_JAVA_PV}-darwin-aarch64-${GRAALVM_PV}.jar"
	elif use kernel_Darwin && use x64-macos ; then
		echo "native-image-${GRAALVM_EDITION}-installable-svm-java${GRAALVM_JAVA_PV}-darwin-amd64-${GRAALVM_PV}.jar"
	elif use kernel_linux && use amd64 ; then
		echo "native-image-${GRAALVM_EDITION}-installable-svm-java${GRAALVM_JAVA_PV}-linux-amd64-${GRAALVM_PV}.jar"
	elif use kernel_linux && use arm64 ; then
		echo "native-image-${GRAALVM_EDITION}-installable-svm-java${GRAALVM_JAVA_PV}-linux-arm64-${GRAALVM_PV}.jar"
	fi
}

# @FUNCTION: graalvm_attach_graalvm
# @DESCRIPTION:
# Attach the GraalVM to the environment.
graalvm_attach_graalvm() {
	export GRAALVM_HOME="${WORKDIR}/graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-${GRAALVM_PV}"
	PATH_ORIG="${PATH}"
	export PATH="${WORKDIR}/graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-${GRAALVM_PV}/bin:${PATH}"
	export JAVA_HOME="${WORKDIR}/graalvm-${GRAALVM_EDITION}-java${GRAALVM_JAVA_PV}-${GRAALVM_PV}"
einfo "GRAALVM_HOME:\t${GRAALVM_HOME}"
einfo "PATH:\t${PATH}"
einfo "JAVA_HOME:\t${JAVA_HOME}"
	# JAVA_HOME_17_X86 environment variable will contain the OpenJDK base path.
	java -version
	java -version 2>&1 | grep -q "GraalVM.*${GRAALVM_PV}" || die
	if [[ "${GRAALVM_MODE}" == "live" ]] ; then
		gu install native-image || die
	else
		gu -L install "${DISTDIR}/$(graalvm_get_native_image_tarball_name)" || die
	fi
	export PATH="${PATH_ORIG}"
# We do not auto attach to path because some packages use multiple java slots.
ewarn "Developer QA: you are responsible to manually setting the PATH variable to GraalVM in the ebuild level."
}
