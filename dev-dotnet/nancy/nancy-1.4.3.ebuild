# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"


inherit dotnet multilib gac


DESCRIPTION="Nancy is a lightweight, low-ceremony, framework for building HTTP based services on .NET Framework/Core and Mono."
HOMEPAGE=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
PROJECT_NAME="Nancy"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
SRC_URI="https://github.com/NancyFx/Nancy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

COMMON_DEP=">=dev-lang/mono-4
            dev-dotnet/fluentvalidation
            dev-dotnet/markdownsharp
            dev-dotnet/csquery"

RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
        "
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/nancy-1.4.3-disable-wcf.patch"


	FILES=$(grep -l -r -e "<TargetFrameworkProfile>Client</TargetFrameworkProfile>")
	for f in $FILES
	do
		einfo "Editing $f..."
		sed -i -e "s|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g" "$f"
	done

	eapply "${FILESDIR}/nancy-1.4.3-refs-1.patch"
	eapply "${FILESDIR}/nancy-1.4.3-refs-2.patch"
	eapply "${FILESDIR}/nancy-1.4.3-refs-3.patch"

	eapply_user

	egenkey

       	#inject public key into assembly
        public_key=$(sn -tp "${S}/${PN}-keypair.snk" | tail -n 7 | head -n 5 | tr -d '\n')
        echo "pk is: ${public_key}"

	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"Nancy.Authentication.Token.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"Nancy.Authentication.Token.Tests, PublicKey=${public_key}\")\]|" "src/Nancy.Authentication.Token/Properties/Internals.cs"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"Nancy.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"Nancy.Tests, PublicKey=${public_key}\")\]|" "src/SharedAssemblyInfo.cs"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"Nancy.Hosting.Self.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"Nancy.Hosting.Self.Tests, PublicKey=${public_key}\")\]|" "src/SharedAssemblyInfo.cs"
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	cd "${S}/src"

        einfo "Building solution"
        exbuild_strong "${PROJECT_NAME}.sln" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

 	for x in ${USE_DOTNET}
	do
                FW_UPPER=${x:3:1}
       	        FW_LOWER=${x:4:1}
		egacinstall "src/Nancy/bin/${mydebug}/Nancy.dll" "${PN}/Nancy"
		if use developer ; then
	               	insinto "/usr/$(get_libdir)/mono/${PN}/Nancy"
			doins "src/Nancy/bin/${mydebug}/Nancy.dll.mdb"
			doins "src/Nancy/bin/${mydebug}/Nancy.XML"
		fi
	done


	FILES=$(find src/ -name "*.dll" | grep bin | grep -v Tests | grep -v Demo | grep -v Testing)
	for f in $FILES
	do
		full_path=${S}/$f
		rel_path=$f
		project=$(echo $(dirname $(dirname $(dirname $rel_path))) | sed -e "s|src/||g")
		#einfo "fullpath:  $full_path"
		#einfo "relpath:  $rel_path"
		#einfo "project:  $project"
		dir=$(dirname $f | cut -d'/' -f10-)
		filename=$(basename $f)

		if [[ $filename =~ "Nancy.dll" && "src/bin" ]] ; then
			continue
		fi

		if [[ $filename =~ "System.Web.Razor.dll" ]] ; then
			#ignore mono assembly
			continue
		fi

		for x in ${USE_DOTNET} ; do
	                FW_UPPER=${x:3:1}
        	        FW_LOWER=${x:4:1}
			if [[ "$filename" =~ ".dll" && ! ( "$filename" =~ ".dll.mdb" ) ]] ; then
				egacinstall $f "${PN}/$project"
			fi
		done

               	insinto "/usr/$(get_libdir)/mono/${PN}/$project"
		if use developer ; then
			if [ -f "$f.mdb" ] ; then
				doins $f.mdb
			fi
			if [ -f $(echo "$f" | sed -e "s|.dll|.XML|g") ] ; then
				doins $(echo "$f" | sed -e "s|.dll|.XML|g")
			fi
		fi
	done

	eend

	dotnet_multilib_comply
}
