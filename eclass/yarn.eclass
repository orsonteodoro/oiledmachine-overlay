# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: yarn-utils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for offline install for npm/yarn eclass
# @DESCRIPTION:
# Eclass similar to the cargo.eclass.

# Requirements:  yarn.lock or package.json -> package-lock.json -> yarn.lock
# For the URI generator, see the tensorboard/transform-uris.sh script.

# For package.json -> yarn.lock:
# (The network-sandbox needs to be disabled temporarily.)
# npm i --package-lock-only
# yarn import

# The yarn.lock must be regenerated for security updates every week.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS src_unpack src_compile src_test src_install

BDEPEND+="
	sys-apps/yarn
"

# @ECLASS_VARIABLE: YARN_EXTERNAL_URIS
# @DESCRIPTION:
# Rows of URIs.
# Must be process through a URI transformer.  See tensorboard ebuild.
# Git snapshot URIs must manually added and look like:
# https://github.com/angular/dev-infra-private-build-tooling-builds/archive/<commit-id>.tar.gz -> yarnpkg-dev-infra-private-build-tooling-builds.git-<commit-id>.tgz

# @ECLASS_VARIABLE: YARN_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: YARN_ROOT
# @DESCRIPTION:
# The project root containing the yarn.lock file.

# @ECLASS_VARIABLE: YARN_INSTALL_PATH
# @DESCRIPTION:
# The destination install path relative to EROOT.

# @ECLASS_VARIABLE: YARN_EXE_LIST
# @DESCRIPTION:
# A pregenerated list of paths to turn on executable bit.
# Obtained partially from find ${YARN_INSTALL_PATH}/node_modules/ -path "*/.bin/*" | sort

# @FUNCTION: _yarn_cp_tarballs
# @INTERNAL
# @DESCRIPTION:
# Copies all tarballs to the offline cache
_yarn_cp_tarballs() {
	local dest="${WORKDIR}/npm-packages-offline-cache"
	mkdir -p "${dest}" || die
	IFS=$'\n'
	local uri
	for uri in ${YARN_EXTERNAL_URIS} ; do
		local bn
		if [[ "${uri}" =~ "->" && "${uri}" =~ ".git" ]] ; then
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			local fn="${bn/yarnpkg-}"
			fn="${fn/.tgz}"
			local path=$(mktemp -d -p "${T}")
			pushd "${path}" || die
				tar --strip-components=1 -xvf "${DISTDIR}/${bn}" || die
				tar -cf "${dest}/${fn}" * || die
			popd
			rm -rf "${path}" || die
		else
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			cat "${DISTDIR}/${bn}" > "${dest}/${bn/yarnpkg-}" || die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: yarn_src_unpack
# @DESCRIPTION:
# Unpacks a yarn application.
yarn_src_unpack() {
	if [[ -n "${YARN_TARBALL}" ]] ; then
		unpack ${YARN_TARBALL}
	else
		unpack ${P}.tar.gz
	fi
	_yarn_cp_tarballs
	cd "${S}" || die
	rm -rf "package-lock.json" || true
	yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
	mv "${HOME}/.yarnrc" "${WORKDIR}" || die
	if [[ -f "${FILESDIR}/${PV}/yarn.lock" && -n "${YARN_ROOT}" ]] ; then
		cp "${FILESDIR}/${PV}/yarn.lock" "${YARN_ROOT}" || die
	elif [[ -f "${FILESDIR}/${PV}/yarn.lock" && -n "${S}" ]] ; then
		cp "${FILESDIR}/${PV}/yarn.lock" "${S}" || die
	fi
	if [[ -n "${YARN_ROOT}" ]] ; then
		rm -rf "${YARN_ROOT}/.yarnrc" || die
	fi
	rm -rf "${S}/.yarnrc" || die
	yarn install \
		--frozen-lockfile \
		--prefer-offline \
		--verbose \
		|| die
}

# @FUNCTION: yarn_src_compile
# @DESCRIPTION:
# Builds a yarn application.
yarn_src_compile() {
	local cmd="${YARN_TEST_SCRIPT:-build}"
	grep -q -e "\"${cmd}\"" package.json || return
	yarn run ${cmd} \
		--frozen-lockfile \
		--prefer-offline \
		--verbose \
		|| die
}

# @FUNCTION: yarn_src_test
# @DESCRIPTION:
# Runs a yarn application test suite.
yarn_src_test() {
	local cmd="${YARN_TEST_SCRIPT:-test}"
	grep -q -e "\"${cmd}\"" package.json || return
	yarn run ${cmd} \
		--verbose \
		|| die
}

# @FUNCTION: yarn_src_install
# @DESCRIPTION:
# Installs a yarn application.
yarn_src_install() {
	local install_path="${YARN_INSTALL_PATH:-/opt/${PN}}"
	local rows=$(cat package.json \
		| jq '.bin' \
		| grep ":")
	insinto "${install_path}"
	doins -r *
	IFS=$'\n'
	local row
	for row in ${rows[@]} ; do
		local name=$(echo "${row}" \
			| cut -f 2 -d '"')
		local cmd=$(echo "${row}" \
			| cut -f 4 -d '"' \
			| sed -e "s|^\./||g")
		dosym "${YARN_INSTALL_PATH}/${cmd}" "/usr/bin/${name}"
	done
	local path
	for path in ${YARN_EXE_LIST} ; do
		chmod 0755 "${ED}${path}" || die
	done
	IFS=$' \t\n'
}
