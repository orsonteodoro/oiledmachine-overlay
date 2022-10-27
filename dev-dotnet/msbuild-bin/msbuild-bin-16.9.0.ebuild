# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MSBuild is the build platform for .NET and VS."
HOMEPAGE="https://github.com/mono/msbuild"
LICENSE="
	( MIT all-rights-reserved )
	( Apache-2.0 all-rights-reserved )
	BSD-2
	BSD
	DOTNET-libraries-and-runtime-components-patents
	MIT
	Ms-PL
	Unicode-DFS-2016
	ZLIB
	W3C-Software-and-Document-Notice-and-License
"
#
# https://github.com/mono/msbuild/blob/v16.9.0/LICENSE
# https://github.com/mono/msbuild/blob/xplat-master/THIRDPARTYNOTICES.txt
#
# For project names for reverse lookup of licenses, see
#
#   https://github.com/mono/msbuild/blob/v16.9.0/eng/Packages.props
#
# Ms-PL - Ionic.Zip.dll
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
BDEPEND="
	app-arch/unzip
"
MONO_PV="6.12.0.137"
NUGET_COMMON_PV="5.9.0.7122"
SRC_URI="
https://github.com/mono/msbuild/releases/download/v${PV}/mono_msbuild_${MONO_PV}.zip
	-> ${P}.zip
https://raw.githubusercontent.com/mono/msbuild/v${PV}/LICENSE
	-> ${P}-LICENSE
https://raw.githubusercontent.com/mono/msbuild/v${PV}/THIRDPARTYNOTICES.txt
	-> ${P}-THIRDPARTYNOTICES.txt
https://raw.githubusercontent.com/NuGet/NuGet.Client/${NUGET_COMMON_PV}/LICENSE.txt
	-> Nuget.Common-LICENSE.txt
https://raw.githubusercontent.com/dotnet/runtime/6c0cdd82ed0566f77abd4fcd95b80886efce9779/PATENTS.TXT
	-> dotnet-runtime-6c0cdd8-PATENTS.TXT
https://globalcdn.nuget.org/packages/system.security.cryptography.xml.4.7.0.nupkg
https://raw.githubusercontent.com/dotnet/runtime/v5.0.0/THIRD-PARTY-NOTICES.TXT
	-> dotnet-runtime-5.0.0-THIRD-PARTY-NOTICES.TXT
https://raw.githubusercontent.com/xamarin/mqtt/a308d2434d8f05df35987f988807d0ea78243ecf/LICENSE
	-> mqtt-a308d24-LICENSE
https://raw.githubusercontent.com/MobileEssentials/Merq/v1.1.17-rc/LICENSE
	-> Merq-1.0.0-LICENSE
https://raw.githubusercontent.com/jbevain/cecil/0.11.1/LICENSE.txt
	-> Mono.Cecil-0.11.1-LICENSE.txt
"
S="${WORKDIR}/msbuild"
RESTRICT="mirror"

src_unpack() {
	unpack ${P}.zip
	mkdir -p "${T}/licenses"

	# Repo missing 4.x tags
	unzip -p "${DISTDIR}/system.security.cryptography.xml.4.7.0.nupkg" THIRD-PARTY-NOTICES.TXT \
		> "${T}/licenses/dotnet-runtime-4.7.0-THIRD-PARTY-NOTICES.TXT" || die
}

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
	dodoc "${DISTDIR}/${P}-LICENSE"
	dodoc "${DISTDIR}/${P}-THIRDPARTYNOTICES.txt"

	# Third party licenses
	dodoc "${DISTDIR}/Nuget.Common-LICENSE.txt"
	dodoc "${T}/licenses/dotnet-runtime-4.7.0-THIRD-PARTY-NOTICES.TXT"
	dodoc "${DISTDIR}/dotnet-runtime-5.0.0-THIRD-PARTY-NOTICES.TXT"
	cat "${DISTDIR}/dotnet-runtime-6c0cdd8-PATENTS.TXT" \
		> "${T}/licenses/dotnet-runtime-PATENTS.TXT"
	dodoc "${T}/licenses/dotnet-runtime-PATENTS.TXT"
	dodoc "${DISTDIR}/mqtt-a308d24-LICENSE"
	dodoc "${DISTDIR}/Mono.Cecil-0.11.1-LICENSE.txt"

	# Same as v1.1.17-rc, v1.1.15-rc (d297683)
	dodoc "${DISTDIR}/Merq-1.0.0-LICENSE"

}
