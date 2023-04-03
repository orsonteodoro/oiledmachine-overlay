# Copyright 2023 Orson Teodoro
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
# npm i --package-lock-only
# yarn import

# The yarn.lock must be regenerated for security updates.

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

# @FUNCTION: _yarn_cpy_yarn_tarballs
# @INTERNAL
# @DESCRIPTION:
# Copies all tarballs to the offline cache
_yarn_cpy_yarn_tarballs() {
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
	_yarn_cpy_yarn_tarballs
	yarn install --verbose --prefer-offline || die
}

# @FUNCTION: yarn_src_compile
# @DESCRIPTION:
# Builds a yarn application.
yarn_src_compile() {
	yarn build --verbose --prefer-offline || die
}

# @FUNCTION: yarn_src_test
# @DESCRIPTION:
# Runts a yarn application test suite.
yarn_src_test() {
	yarn test --verbose || die
}

# @FUNCTION: yarn_src_install
# @DESCRIPTION:
# Installs a yarn application.
yarn_src_install() {
	if declare -f yarn_install_all ; then
		yarn_install_all
	fi
}
