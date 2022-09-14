# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MSBuild is the build platform for .NET and VS."
HOMEPAGE="https://github.com/mono/msbuild"
LICENSE="
	( MIT all-rights-reserved )
	Apache-2.0
"
# https://github.com/mono/msbuild/blob/v16.9.0/LICENSE
# https://github.com/mono/msbuild/blob/xplat-master/THIRDPARTYNOTICES.txt
KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"
LANGS=(
cs
de
en
es
fr
it
ja
ko
pl
pt-BR
ru
tr
zh-Hans
zh-Hant
)
IUSE="
${LANGS[@]/#/l10n_}
symlink
"
REQUIRED_USE="
	l10n_en
"
RDEPEND="
	!dev-util/msbuild
	!dev-dotnet/msbuild
	>=dev-lang/mono-6.12
"
DEPEND="${RDEPEND}"
BDEPEND=""
MONO_PV="6.12.0.137"
SRC_URI="
https://github.com/mono/msbuild/releases/download/v${PV}/mono_msbuild_${MONO_PV}.zip
	-> ${P}.zip
"
S="${WORKDIR}/msbuild"
RESTRICT="mirror"

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto "/usr/share/msbuild/${SLOT}"
	doins -r *
	if use symlink ; then
		dosym "/usr/share/msbuild/${SLOT}/msbuild" "/usr/bin/msbuild"

		# Two variations based on msbuild --help
		dosym "/usr/share/msbuild/${SLOT}/msbuild" "/usr/bin/MSBuild.exe"
		dosym "/usr/share/msbuild/${SLOT}/msbuild" "/usr/bin/MSBuild"
	fi
einfo
einfo "Restoring file permissions"
einfo
	local x
	for x in $(find "${ED}") ; do
		local path=$(echo "${x}" | sed -e "s|${ED}||g")
		if file "${x}" | grep -q "executable" ; then
			fperms 0775 "${path}"
		elif file "${x}" | grep -q "shared object" ; then
			fperms 0775 "${path}"
		elif file "${x}" | grep -q "shared library" ; then
			fperms 0775 "${path}"
		fi
	done

	local l
	for l in ${LANGS[@]} ; do
		if ! use "l10n_${l}" ; then
			einfo "Pruning ${l}"
			for d in $(find "${ED}" -type d -name "${l}") ; do
				rm -vrf "${d}"
			done
		else
			einfo "Keeping ${l}"
		fi
	done

# The original wrapper is symlink ignorant.
cat <<EOF > "${ED}/usr/share/msbuild/${SLOT}/msbuild" || die
#!${EPREFIX}/bin/bash
PATH="/usr/share/msbuild/${SLOT}:\${PATH}"
ABSOLUTE_PATH=\$(realpath "\${BASH_SOURCE[0]}")
MSBUILD_SRC_DIR=\$(dirname "\${ABSOLUTE_PATH}")
mono \${MONO_OPTIONS} "\${MSBUILD_SRC_DIR}/MSBuild.dll" "\${@}"
EOF
}
