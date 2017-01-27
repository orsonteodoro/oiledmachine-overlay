# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

inherit versionator flag-o-matic

CORE_V=1.0.1
CORECLR_V=1.0.4
COREFX_V=1.0.0

BASE_PV=${PV%_p*}
P_BUILD=$(get_version_component_range 6)
DIST="debian"
DIST2="${DIST}-x64"
SDK_VERSION="$(get_version_component_range 1-3)"
SDK_PREVIEW_VERSION=$(echo $(if [[ "$(get_version_component_range 5)" == "0" ]]; then echo "$(get_version_component_range 4)"; else echo "$(get_version_component_range 4-5)"; fi))
SDK_PREVIEW_VERSION="${SDK_PREVIEW_VERSION//_/.}"
SDK_PR="preview" #preview or release

CORECLR=coreclr-${CORECLR_V}
COREFX=corefx-${COREFX_V}

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

IUSE=""
SRC_URI="https://github.com/dotnet/coreclr/archive/v${CORECLR_V}.tar.gz -> ${CORECLR}.tar.gz
	https://github.com/dotnet/corefx/archive/v${COREFX_V}.tar.gz -> ${COREFX}.tar.gz
        https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/${SDK_VERSION}-${SDK_PR}${SDK_PREVIEW_VERSION//./-}-${P_BUILD}/dotnet-dev-${DIST2}.${SDK_VERSION}-${SDK_PR}${SDK_PREVIEW_VERSION//./-}-${P_BUILD}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
        || ( dev-util/lldb  >=sys-devel/llvm-3.7.1-r3[lldb] )
	>=sys-libs/libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	>=app-crypt/mit-krb5-1.14.2
	>=sys-libs/zlib-1.2.8-r1 "
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7"

S=${WORKDIR}
CLI_S="${S}/dotnet_cli"
CORECLR_S="${S}/${CORECLR}"
COREFX_S="${S}/${COREFX}"

CORECLR_FILES=(
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libdbgshim.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'libsos.so'
	'libsosplugin.so'
	'System.Globalization.Native.so'
)

COREFX_FILES=(
	'System.IO.Compression.Native.so'
	'System.Native.a'
	'System.Native.so'
	'System.Net.Http.Native.so'
	'System.Net.Security.Native.so'
	'System.Security.Cryptography.Native.so'
)

src_unpack() {
	unpack "${CORECLR}.tar.gz" "${COREFX}.tar.gz"
	mkdir "${CLI_S}" || die
	cd "${CLI_S}" || die
	unpack "dotnet-dev-${DIST2}.${SDK_VERSION}-${SDK_PR}${SDK_PREVIEW_VERSION//./-}-${P_BUILD}.tar.gz"
}

src_prepare() {
	for file in "${CORECLR_FILES[@]}"; do
		#rm "${CLI_S}/shared/Microsoft.NETCore.App/${CORE_V}/${file}"
		rm "${CLI_S}"/shared/Microsoft.NETCore.App/*/${file}
	done
	for file in "${COREFX_FILES[@]}"; do
		#rm "${CLI_S}/shared/Microsoft.NETCore.App/${CORE_V}/${file}"
		rm "${CLI_S}"/shared/Microsoft.NETCore.App/*/${file}
	done

	#for clang because it treats warnings as errors
	EXTRA_CFLAGS="-Wno-all -Wno-deprecated-declarations -Wno-null-dereference -Wno-invalid-noreturn -Wno-reserved-user-defined-literal "
	sed -i -e "s|CMAKE_C_FLAGS_INIT                \"-Wall -std=c11\"|CMAKE_C_FLAGS_INIT                \" ${EXTRA_CFLAGS} -std=c11\"|g" "${CORECLR_S}"/src/pal/tools/clang-compiler-override.txt || die
	sed -i -e "s|CMAKE_CXX_FLAGS_INIT                \"-Wall -Wno-null-conversion -std=c++11\"|CMAKE_CXX_FLAGS_INIT                \" ${EXTRA_CFLAGS} -Wno-null-conversion -std=c++11\"|g" "${CORECLR_S}"/src/pal/tools/clang-compiler-override.txt || die

	sed -i -e "s|CMAKE_C_FLAGS \"-std=c11\"|CMAKE_C_FLAGS \"${EXTRA_CFLAGS} -std=c11\"|g" "${COREFX_S}"/src/Native/CMakeLists.txt || die
	sed -i -e "s|CMAKE_CXX_FLAGS \"-std=c++11\"|CMAKE_CXX_FLAGS \"${EXTRA_CFLAGS} -std=c++11\"|g" "${COREFX_S}"/src/Native/CMakeLists.txt || die
	sed -i -e "s|add_compile_options(-Weverything)||g" "${COREFX_S}"/src/Native/CMakeLists.txt || die
	sed -i -e "s|add_compile_options(-Werror)||g" "${COREFX_S}"/src/Native/CMakeLists.txt || die

	cd "${CORECLR_S}"
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-clang-3_9.patch"
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-PAL_SEHException.patch"

	eapply_user
}

src_compile() {
	einfo "Building coreclr"
	cd "${S}/${CORECLR}" || die
	./build.sh x64 release || die

	einfo "Building corefx"
	cd "${S}/${COREFX}" || die
	./build.sh native x64 release || die
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${CORE_V}/"

	dodir "${dest}"
	cp -pPR "${CLI_S}"/* "${ddest}" || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${CORECLR}/bin/Product/Linux.x64.Release/${file}" "${ddest_core}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${COREFX}/bin/Linux.x64.Release/Native/${file}" "${ddest_core}" || die
	done

	dosym "../../opt/dotnet_cli/dotnet" "/usr/bin/dotnet"

}

