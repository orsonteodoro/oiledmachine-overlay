# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.24" # This is the .NET Runtime

SRC_URI="
amd64? (
	elibc_glibc? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz
	)
	elibc_musl? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-x64.tar.gz
	)
)
arm? (
	elibc_glibc? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm.tar.gz
	)
	elibc_musl? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm.tar.gz
	)
)
arm64? (
	elibc_glibc? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm64.tar.gz
	)
	elibc_musl? (
		https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-arm64.tar.gz
	)
)
"
S="${WORKDIR}"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"
LICENSE_THIRD_PARTY="
	all-rights-reserved
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	CC0-1.0
	custom
	public-domain
	Unicode-DFS-2016
	W3C-Software-and-Document-Notice-and-License-2015
	ZLIB
"
LICENSE="
	${LICENSE_THIRD_PARTY}
	MIT
"
# See also ThirdPartyNotices.txt
# The distro Apache-2.0 template does not have all rights reserved but the 1.0 template does
# The distro MIT license template does not have all rights reserved.
# custom - Keyword search:  "To anyone who acknowledges that this file is provided"
# custom - Keyword search:  "whole or in part, without restriction of any kind,"
# custom - Keyword search:  "code any way you wish, private, educational, or commercial."
# custom - Keyword search:  "related and neighboring rights"
# custom - Keyword search:  "purpose, commercial or non-commercial, and by any means"
KEYWORDS="~amd64 ~arm ~arm64"
RESTRICT="splitdebug"
RDEPEND="
	app-crypt/mit-krb5:0/0
	dev-libs/icu
	dev-util/lttng-ust:0/2.12
	sys-libs/zlib:0/1
"
IDEPEND="
	app-eselect/eselect-dotnet
"
PDEPEND="
	~dev-dotnet/dotnet-runtime-nugets-${RUNTIME_SLOT}
	~dev-dotnet/dotnet-runtime-nugets-3.1.32
"
QA_PREBUILT="*"

src_install() {
	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))" # e.g. 404 -> 400
	local workloads="metadata/workloads/${SDK_SLOT}.${featureband}"
	local dest="opt/${PN}-${SDK_SLOT}"

	dodir "${dest%/*}"
	mkdir -p "${S}/${workloads}" || die
	touch "${S}/${workloads}/userlocal" || die
	mv "${S}" "${ED}/${dest}" || die
	mkdir "${S}" || die
	fperms 0755 "/${dest}"
	dosym "../../${dest}/dotnet" "/usr/bin/dotnet-bin-${SDK_SLOT}"
}

pkg_postinst() {
	eselect dotnet update ifunset
}

pkg_postrm() {
	eselect dotnet update ifunset
}
