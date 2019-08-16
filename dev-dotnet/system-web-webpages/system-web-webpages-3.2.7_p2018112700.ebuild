# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mono-env gac nupkg

REPO_NAME="AspNetWebStack"
HOMEPAGE="https://github.com/aspnet/AspNetWebStack"

EGIT_BRANCH="master"
EGIT_COMMIT="39d3064baf13181f5718ec5d85ba644b47d0704b"
SRC_URI="${HOMEPAGE}/archive/${EGIT_BRANCH}/${EGIT_COMMIT}.tar.gz -> ${REPO_NAME}-${EGIT_COMMIT}.tar.gz
	 https://github.com/mono/mono/raw/master/mcs/class/mono.snk"
RESTRICT="mirror"
#S="${WORKDIR}/${REPO_NAME}-${EGIT_COMMIT}"
S="${WORKDIR}/${REPO_NAME}-${EGIT_BRANCH}"

SLOT="0"

DESCRIPTION="parser and code generation infrastructure for Razor markup syntax"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
#USE_DOTNET="net45 net40 net20"
USE_DOTNET="net45"

IUSE="+${USE_DOTNET} developer debug nupkg"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

COMMON_DEPEND=">=dev-lang/mono-4.0.2.5
	dev-dotnet/system-web-razor
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
"

DLL_NAME=System.Web.WebPages
DLL_PATH=bin
FILE_TO_BUILD=./src/${DLL_NAME}/${DLL_NAME}.csproj
METAFILETOBUILD="${S}/${FILE_TO_BUILD}"

NUSPEC_ID=Microsoft.AspNet.WebPages

COMMIT_DATE_INDEX="$(get_version_component_count ${PV} )"
COMMIT_DATE="$(get_version_component_range $COMMIT_DATE_INDEX ${PV} )"
NUSPEC_VERSION=$(get_version_component_range 1-3)"${COMMIT_DATE//p/.}"
SNK_FILENAME="${S}/mono.snk"

src_prepare() {
	cp "${FILESDIR}/${NUSPEC_ID}.nuspec" "${S}" || die
	chmod -R +rw "${S}" || die
	patch_nuspec_file "${S}/${NUSPEC_ID}.nuspec"
	eapply "${FILESDIR}/remove-DataVisualiztion.patch"
	eapply "${FILESDIR}/disable-warning-as-error.patch"

	cp "${DISTDIR}/mono.snk" "${S}"

	eapply_user
}

patch_nuspec_file()
{
	if use nupkg; then
		if use debug; then
			DIR="Debug"
		else
			DIR="Release"
		fi
		FILES_STRING=`sed 's/[\/&]/\\\\&/g' <<-EOF || die "escaping replacement string characters"
		  <files> <!-- https://docs.nuget.org/create/nuspec-reference -->
		    <file src="${DLL_PATH}/${DIR}/${DLL_NAME}.*" target="lib/net45/" />
		    <file src="${DLL_PATH}/${DIR}/System.Web.WebPages.Deployment.*" target="lib/net45/" />
		    <file src="${DLL_PATH}/${DIR}/System.Web.Helpers.*" target="lib/net45/" />
		  </files>
		EOF
		`
		sed -i 's/<\/package>/'"${FILES_STRING//$'\n'/\\$'\n'}"'\n&/g' $1 || die "escaping line endings"
	fi
}

src_compile() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	exbuild "${METAFILETOBUILD}"
	exbuild "${S}/src/System.Web.Helpers/System.Web.Helpers.csproj"

	sn -R "${DLL_PATH}/${DIR}/System.Web.WebPages.dll" "${S}/mono.snk" || die
	sn -R "${DLL_PATH}/${DIR}/System.Web.WebPages.Deployment.dll" "${S}/mono.snk" || die
	sn -R "${DLL_PATH}/${DIR}/System.Web.Helpers.dll" "${S}/mono.snk" || die

	einfo nuspec: "${S}/${NUSPEC_ID}.nuspec"
	einfo nupkg: "${WORKDIR}/${NUSPEC_ID}.${NUSPEC_VERSION}.nupkg"

	enuspec -Prop BuildVersion=${NUSPEC_VERSION} "${S}/${NUSPEC_ID}.nuspec"
}

src_install() {
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi

	egacinstall "${DLL_PATH}/${DIR}/${DLL_NAME}.dll"
	egacinstall "${DLL_PATH}/${DIR}/System.Web.WebPages.Deployment.dll"
	egacinstall "${DLL_PATH}/${DIR}/System.Web.Helpers.dll"

	enupkg "${WORKDIR}/${NUSPEC_ID}.${NUSPEC_VERSION}.nupkg"

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${DLL_PATH}/${DIR}/${DLL_NAME}.dll.mdb"
		doins "${DLL_PATH}/${DIR}/System.Web.WebPages.Deployment.dll.mdb"
		doins "${DLL_PATH}/${DIR}/System.Web.Helpers.dll.mdb"
	fi

	dotnet_multilib_comply
}

