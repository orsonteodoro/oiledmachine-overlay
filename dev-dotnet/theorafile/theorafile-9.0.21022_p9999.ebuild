# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1-3 ${PV})"

inherit dotnet eutils git-r3 multilib-minimal

DESCRIPTION="Theorafile - Ogg Theora Video Decoder Library"
HOMEPAGE="https://github.com/FNA-XNA/Theorafile"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="Theorafile"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug"
REQUIRED_USE="net40"
RDEPEND="
	dev-lang/mono[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
SRC_URI=""
RESTRICT="mirror"
S="${WORKDIR}/${P}"

src_unpack() {
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/FNA-XNA/Theorafile.git"
	git-r3_fetch
	git-r3_checkout
	local actual_pv=$(grep "ProductVersion" "${S}/csharp/Theorafile-CS.csproj" \
		| cut -f 2 -d ">" \
		| cut -f 1 -d "<")
	if [[ "${actual_pv}" != "${MY_PV}" ]] ; then
eerror
eerror "Bump the package version."
eerror
eerror "Actual version: ${actual_pv}"
eerror "Expected version: ${MY_PV}"
eerror
		die
	fi
}

get_targetplatform() {
# See mono /usr/lib/mono/4.5/csc.exe -help under -platform
	if [[ "${ABI}" == "x86" ]] ; then
		echo "x86"
	elif [[ "${ABI}" == "amd64" ]] ; then
		echo "x64"
	elif [[ "${ABI}" == "arm" ]] ; then
		echo "arm"
	else
		echo "AnyCPU"
	fi
}

src_prepare() {
	default
	prepare_abi() {
		cp -a "${S}" "${S}-${MULTILIB_ABI_FLAG}.${ABI}_net${FRAMEWORK}" || die
	}
	multilib_foreach_abi prepare_abi
}

src_configure() {
	configure_abi() {
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_net${FRAMEWORK}"
		cd "${BUILD_DIR}"
		local x
		for x in $(find . -name "*.csproj") ; do
			local march=$(get_targetplatform)
			sed -i -r \
				-e 's#bin\\Debug#bin\\x86\\Debug#g' \
				-e 's#bin\\Release#bin\\x86\\Release#g' \
				-e "s|x86|${march}|g" \
				"${x}" \
			|| die
		done
		sed -i -r \
			-e "s|x86|${march}|g" \
			"csharp/Theorafile-CS.sln" \
			|| die
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_net${FRAMEWORK}"
		cd "${BUILD_DIR}"
		emake || die
		cd csharp || die
		exbuild "Theorafile-CS.sln"
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local configuration=$(usex debug "Debug" "Release")
	install_abi() {
		export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_net${FRAMEWORK}"
		cd "${BUILD_DIR}"
		insinto "/usr/$(get_libdir)/mono/${FRAMEWORK}"
		exeinto "/usr/$(get_libdir)/mono/${FRAMEWORK}"
		doexe "libtheorafile.so"
		local march=$(get_targetplatform)
		doins "csharp/bin/${march}/${configuration}/Theorafile-CS.dll"
	}
	multilib_foreach_abi install_abi
	cd "${S}" || die
	docinto licenses
	dodoc licenses/*
}

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
