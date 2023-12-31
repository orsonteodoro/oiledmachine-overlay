# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net35"
inherit dotnet lcnr git-r3

DESCRIPTION="Drivers and libraries for the Xbox Kinect device on Windows, \
Linux, and OS X"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"
LICENSE="|| ( Apache-2.0 GPL-2 )"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="${USE_DOTNET}"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
MY_PV="0.5.7"
RDEPEND=">=dev-libs/libfreenect-${MY_PV}"
DEPEND="${RDEPEND}"
PYTHON_DEPEND="!bindist? 2"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI=""
RESTRICT="mirror"
S="${WORKDIR}/${P}"
EGIT_COMMIT="HEAD"
EGIT_REPO_URI="https://github.com/OpenKinect/libfreenect.git"
EXPECTED_BUILD_FP="\
221c415858965eb4b41dabc218a6a2b647bcb5009d912f01ba4b798a5ce60431\
376c054b7f10050e445408355850de69c94ee4adec6f7c9d837318007a459433\
"

src_unpack() {
	default
	git-r3_fetch
	git-r3_checkout
	cd "${S}" || die
	local project_file="wrappers/csharp/src/lib/VS2010/freenectdotnet.csproj"
	[[ -e "${project_file}" ]] || die
	local actual_build_fp=$(sha512sum \
		"${project_file}" \
		| cut -f 1 -d " ")
	if [[ "${actual_build_fp}" != "${EXPECTED_BUILD_FP}" ]] ; then
eerror
eerror "Detected build files change"
eerror
eerror "Expected:  ${EXPECTED_BUILD_FP}"
eerror "Actual:  ${actual_build_fp}"
eerror
		die
	fi
}

src_prepare() {
	default
	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" \
		wrappers/csharp/src/lib/KinectNative.cs || die
}

src_compile() {
	cd "wrappers/csharp/src/lib/VS2010" || die
        exbuild "freenectdotnet.csproj"
	cat "${FILESDIR}/freenectdotnet.dll.config" \
		> "${S}/freenectdotnet.dll.config" || die
	if use arm || use x86 ; then
		sed -i -e "s|__WORDSIZE__|32|g" \
			"${S}/freenectdotnet.dll.config" || die
	fi
}

src_install() {
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	doins freenectdotnet.dll.config
	doexe wrappers/csharp/bin/freenectdotnet.dll
	dotnet_multilib_comply
	lcnr_install_header \
		"wrappers/csharp/src/lib/Accelerometer.cs" \
		"${PN}-csharp.LICENSE" \
		25
	docinto licenses
	dodoc APACHE20 GPL2
}
