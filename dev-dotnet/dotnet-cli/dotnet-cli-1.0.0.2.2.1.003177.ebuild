# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

inherit dotnet versionator flag-o-matic

CORE_V=1.1.0
CORECLR_V=1.1.0
COREFX_V=1.1.0

BASE_PV=${PV%_p*}
P_BUILD=$(get_version_component_range 7)
DIST="ubuntu"
#DIST="fedora.23" #fedora.23 fedora.24
#DIST="debian"
DIST2="${DIST}-x64"
SDK_VERSION="$(get_version_component_range 1-3)"
SDK_PR_VERSION=$(echo $(if [[ "$(get_version_component_range 6)" == "0" ]]; then echo "$(get_version_component_range 5)"; else echo "$(get_version_component_range 5-6)"; fi))
SDK_PR_VERSION="${SDK_PR_VERSION//_/.}"
SDK_PR=$(echo $(if [[ "$(get_version_component_range 4)" == "0" ]]; then \
                      echo "alpha"; \
              elif [[ "$(get_version_component_range 4)" == "1" ]]; then \
                      echo "beta"; \
              elif [[ "$(get_version_component_range 4)" == "2" ]]; then \
                      echo "preview"; \
              elif [[ "$(get_version_component_range 4)" == "3" ]]; then \
                      echo "rc"; \
              elif [[ "$(get_version_component_range 4)" == "4" ]]; then \
                      echo ""; \
              fi))

CORECLR=coreclr-${CORECLR_V}
COREFX=corefx-${COREFX_V}

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

IUSE=""
SRC_URI="https://github.com/dotnet/coreclr/archive/v${CORECLR_V}.tar.gz -> ${CORECLR}.tar.gz
	https://github.com/dotnet/corefx/archive/v${COREFX_V}.tar.gz -> ${COREFX}.tar.gz
        https://dotnetcli.blob.core.windows.net/dotnet/${SDK_PR}/Binaries/${SDK_VERSION}-${SDK_PR}${SDK_PR_VERSION//./-}-${P_BUILD}/dotnet-dev-${DIST2}.${SDK_VERSION}-${SDK_PR}${SDK_PR_VERSION//./-}-${P_BUILD}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
        || ( ~dev-util/lldb-3.6.0  ~sys-devel/llvm-3.6.0[lldb] )
	>=sys-libs/libunwind-1.1-r1
	~dev-libs/icu-52
	>=dev-util/lttng-ust-2.8.1
	~dev-libs/openssl-1.0.1
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

pkg_setup() {
	ewarn "This ebuild is not complete due to missing dependencies."

	dotnet_pkg_setup
}

src_unpack() {
	unpack "${CORECLR}.tar.gz" "${COREFX}.tar.gz"
	mkdir "${CLI_S}" || die
	cd "${CLI_S}" || die
	unpack "dotnet-dev-${DIST2}.${SDK_VERSION}-${SDK_PR}${SDK_PR_VERSION//./-}-${P_BUILD}.tar.gz"
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

	sed -i -e "s|CMAKE_C_FLAGS \"-std=c11\"|CMAKE_C_FLAGS \"${EXTRA_CFLAGS} -std=c11\"|g" "${COREFX_S}"/src/Native/Unix/CMakeLists.txt || die
	sed -i -e "s|CMAKE_CXX_FLAGS \"-std=c++11\"|CMAKE_CXX_FLAGS \"${EXTRA_CFLAGS} -std=c++11\"|g" "${COREFX_S}"/src/Native/Unix/CMakeLists.txt || die
	sed -i -e "s|add_compile_options(-Weverything)||g" "${COREFX_S}"/src/Native/Unix/CMakeLists.txt || die
	sed -i -e "s|add_compile_options(-Werror)||g" "${COREFX_S}"/src/Native/Unix/CMakeLists.txt || die

	cd "${CORECLR_S}"
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-clang-3_9.patch"
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-PAL_SEHException.patch"
	epatch "${FILESDIR}/dotnet-cli-1.0.0.2.1.003177-gentoo-detect-coreclr-1.patch"
	sed -i -e "s|-sSL|--ssl --progress-bar|g" init-tools.sh

	cd "${COREFX_S}"
	epatch "${FILESDIR}/dotnet-cli-1.0.0.2.1.003177-gentoo-detect-corefx-1.patch"
	sed -i -e "s|GENTOO_DIST|${DIST}|g" init-tools.sh
	sed -i -e "s|-sSL|--ssl --progress-bar|g" init-tools.sh
	rm Tools/dotnetcli/dotnet.tar
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-gentoo-detect-corefx-2.patch"
	#expose debug spew
	sed -i -e "s| >> \$__init_tools_log||g" -e "s| > \$__init_tools_log||g" init-tools.sh || die
	epatch "${FILESDIR}/${PN}-1.0.0.2.1.003177-corefx-path-fix.patch"

	eapply_user
}

_build_corefx()
{
	cd "${COREFX_S}"
	export USER="portage"
	einfo "BuildTools..."
	export LD_LIBRARY_PATH="${COREFX_S}/Tools/dotnetcli/shared/Microsoft.NETCore.App/1.0.0/${LD_LIBRARY_PATH}:/usr/lib64"
	export HOME="${PORTAGE_BUILDDIR}/homedir"
	DOTNET_TOOLS_VERSION=$(cat "${COREFX_S}/DotnetCLIVersion.txt")
	BUILD_TOOLS_VERSION=$(cat "${COREFX_S}/BuildToolsVersion.txt")
	#wget -q -O "${COREFX_S}/Tools/dotnetcli/dotnet.tar" "https://dotnetcli.blob.core.windows.net/dotnet/Sdk/${DOTNET_TOOLS_VERSION}/dotnet-dev-${DIST}-x64.${DOTNET_TOOLS_VERSION}.tar.gz" || die
	curl --retry 10 --ssl --progress-bar --create-dirs -o "${COREFX_S}/Tools/dotnetcli/dotnet.tar" "https://dotnetcli.blob.core.windows.net/dotnet/Sdk/${DOTNET_TOOLS_VERSION}/dotnet-dev-${DIST}-x64.${DOTNET_TOOLS_VERSION}.tar.gz" || die

	echo "{ \"dependencies\": { \"Microsoft.DotNet.BuildTools\": \"$__BUILD_TOOLS_PACKAGE_VERSION\" }, \"frameworks\": { \"netcoreapp1.0\": { } } }" > "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/project.json"
	cd "${COREFX_S}/Tools/dotnetcli/"
	tar -xvf dotnet.tar
	cd "${COREFX_S}"

	"${COREFX_S}/Tools/dotnetcli/dotnet" restore "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/project.json" --no-cache --packages "${COREFX_S}/packages" --source "https://dotnet.myget.org/F/dotnet-buildtools/api/v3/index.json" --disable-parallel -v Debug

	"${COREFX_S}/packages/Microsoft.DotNet.BuildTools/${BUILD_TOOLS_VERSION}/lib/init-tools.sh" "${COREFX_S}" "${COREFX_S}/Tools/dotnetcli/dotnet" "${COREFX_S}/Tools"
	touch "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/done"

	einfo "Run..."
	"${COREFX_S}/Tools/dotnetcli/dotnet" "${COREFX_S}/Tools/run.exe" build-native x64 release
}

_check_lib()
{
	find . -name '*.so' -type f -print | xargs ldd | grep 'not found'
}

_build_corefx2()
{
	cd "${COREFX_S}"
	einfo "BuildTools..."
	export LD_LIBRARY_PATH="${CLI_S}/shared/Microsoft.NETCore.App/1.1.0"
	DOTNET_TOOLS_VERSION=$(cat "${COREFX_S}/DotnetCLIVersion.txt")
	BUILD_TOOLS_VERSION=$(cat "${COREFX_S}/BuildToolsVersion.txt")
	#wget -q -O "${COREFX_S}/Tools/dotnetcli/dotnet.tar" "https://dotnetcli.blob.core.windows.net/dotnet/Sdk/${DOTNET_TOOLS_VERSION}/dotnet-dev-${DIST}-x64.${DOTNET_TOOLS_VERSION}.tar.gz" || die
	curl --retry 10 --ssl --progress-bar --create-dirs -o "${COREFX_S}/Tools/dotnetcli/dotnet.tar" "https://dotnetcli.blob.core.windows.net/dotnet/Sdk/${DOTNET_TOOLS_VERSION}/dotnet-dev-${DIST}-x64.${DOTNET_TOOLS_VERSION}.tar.gz" || die

	echo "{ \"dependencies\": { \"Microsoft.DotNet.BuildTools\": \"$__BUILD_TOOLS_PACKAGE_VERSION\" }, \"frameworks\": { \"netcoreapp1.0\": { } } }" > "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/project.json"
	cd "${COREFX_S}/Tools/dotnetcli/"
	tar -xvf dotnet.tar
	cd "${COREFX_S}"

	"${CLI_S}/dotnet" restore "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/project.json" --no-cache --packages "${COREFX_S}/packages" --source "https://dotnet.myget.org/F/dotnet-buildtools/api/v3/index.json" --disable-parallel -v Debug

	"${COREFX_S}/packages/Microsoft.DotNet.BuildTools/${BUILD_TOOLS_VERSION}/lib/init-tools.sh" "${COREFX_S}" "${CLI_S}/dotnet" "${COREFX_S}/Tools"
	touch "${COREFX_S}/Tools/${BUILD_TOOLS_VERSION}/done"

	einfo "Run..."
	"${CLI_S}/dotnet" "${COREFX_S}/Tools/run.exe" build-native x64 release
}

src_compile() {
	einfo "Building coreclr"
	cd "${S}/${CORECLR}" || die
	./build.sh x64 release || die

	einfo "Building corefx"
	cd "${S}/${COREFX}" || die
	#./build-native.sh x64 release || die
	_build_corefx
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

	#fix for omnisharp-roslyn and https://github.com/aspnet/KestrelHttpServer/issues/963
	dosym "../../opt/dotnet_cli/shared/Microsoft.NETCore.App/${CORE_V}/System.Native.so" "/usr/$(get_libdir)/libSystem.Native.so"

	dotnet_multilib_comply
}

