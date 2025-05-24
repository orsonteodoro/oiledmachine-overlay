# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gradle.eclass
# @MAINTAINER:
# orsonteodoro@hotmail.com
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: gradle offline install for rebuilds

# This eclass is a Work in Progress.  For missing variables or command line options see the grpc-java ebuild.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GRADLE_ECLASS} ]]; then
_GRADLE_ECLASS=1

inherit edo

if [[ -z "${GRADLE_PV}" ]] ; then
	die "QA: GRADLE_PV must be defined"
fi

BDEPEND+="
	dev-java/gradle-bin:${GRADLE_PV}
"

gradle_check_network_sandbox() {
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Sandbox changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
eerror "Reason:  To download micropackages and offline cache"
eerror
eerror "Contents of /etc/portage/env/no-network-sandbox.conf"
eerror "FEATURES=\"\${FEATURES} -network-sandbox\""
eerror
eerror "Contents of /etc/portage/package.env"
eerror "${CATEGORY}/${PN} no-network-sandbox.conf"
eerror
		die
	fi
}

gradle_pkg_setup() {
	gradle_check_network_sandbox
}

gradle_src_configure() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	export GRADLE_CACHE_FOLDER="${EDISTDIR}/gradle-download-cache-${GRADLE_PV}/${CATEGORY}/${P}"
einfo "DEBUG:  Default cache folder:  ${HOME}/caches"
einfo "GRADLE_CACHE_FOLDER:  ${GRADLE_CACHE_FOLDER}"
	addwrite "${EDISTDIR}"
	addwrite "${GRADLE_CACHE_FOLDER}"
	mkdir -p "${GRADLE_CACHE_FOLDER}"
	rm -rf "${HOME}/caches" || die
	ln -s "${GRADLE_CACHE_FOLDER}" "${HOME}/caches" || die
	# TODO fix download issue:  disable parallel downloads.
}

egradle() {
	local options=(
		-Dgradle.user.home="${USER_HOME}"
		-Djava.util.prefs.systemRoot="${USER_HOME}/.java"
		-Djava.util.prefs.userRoot="${USER_HOME}/.java/.userPrefs"
		-Dmaven.repo.local="${USER_HOME}/.m2/repository"
		-Duser.home="${WORKDIR}/homedir"
		-i
	)
	edo gradle "$@" ${options[@]}
}

fi
