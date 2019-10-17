# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="The Tao Framework for .NET is a collection of bindings to"
DESCRIPTION+=" facilitate cross-platform game-related development utilizing"
DESCRIPTION+=" the .NET platform."
HOMEPAGE="http://sourceforge.net/projects/taoframework/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net20 net40 net45"
IUSE="${USE_DOTNET} gac"
REQUIRED_USE="^^ ( ${USE_DOTNET} ) gac? ( || ( net40 net45 ) )"
RDEPEND="media-libs/openal
	 media-libs/libsdl
	 virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/p7zip
	dev-util/nant
	dev-util/nunit:2"
SLOT="0/${PV}"
inherit autotools dotnet eutils
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
inherit gac
RESTRICT="fetch"
S="${WORKDIR}/taoframework-${PV}/source"

src_prepare() {
	default
	sed -i \
-e 's|monodocer --assembly:$$x/$$x.dll --path:doc/$$x|monodocer --out:doc/$$x $$x/$$x.dll|g' \
		src/Makefile.am || die
	sed -i -e "s|PACKAGES = nunit||g" tests/Ode/Makefile.am || die
	sed -i \
-e "s|SYSTEM_LIBS =|SYSTEM_LIBS = /usr/share/nunit-2/nunit.framework.dll |g" \
		tests/Ode/Makefile.am || die
	sed -i -e "s|PACKAGES = nunit||g" tests/Sdl/Makefile.am || die
	sed -i \
-e "s|SYSTEM_LIBS =|SYSTEM_LIBS = /usr/share/nunit-2/nunit.framework.dll |g" \
		tests/Sdl/Makefile.am || die
	sed -i -e "s|gmcs|mcs|g" configure.ac || die
	if use net40 ; then
		eapply "${FILESDIR}/taoframework-2.1.0-use-mono-4.0.patch"
	elif use net45 ; then
		eapply "${FILESDIR}/taoframework-2.1.0-use-mono-4.5.patch"
	fi
	eautoreconf || die
}

_doins() {
	local module_name="$1"
	if use net40 || use net45 ; then
		gacinstall src/Tao.${module_name}/Tao.${module_name}.dll
	fi
	if use developer ; then
		if [ -e "src/Tao.${module_name}/Tao.${module_name}.xml" ] ; then
			doins src/Tao.${module_name}/Tao.${module_name}.xml
			if use net40 || use net45 ; then
				dotnet_distribute_file_matching_dll_in_gac
				"src/Tao.${module_name}/Tao.${module_name}.dll"
				"src/Tao.${module_name}/Tao.${module_name}.xml"
			fi
		fi
		if use net40 || use net45 ; then
			dotnet_distribute_file_matching_dll_in_gac
			"src/Tao.${module_name}/Tao.${module_name}.dll"
			"src/Tao.${module_name}/Tao.${module_name}.dll.config"
		fi
	fi
	doins src/Tao.${module_name}/Tao.${module_name}.dll.config
	doins src/Tao.${module_name}/Tao.${module_name}.dll
}

src_install() {
	emake DESTDIR="${D}" install
	local modules="FreeType Platform.Windows Lua OpenGl Ode Glfw DevIl \
		 FreeGlut PhysFs Sdl GlBindGen FFmpeg OpenAl Cg Platform.X11"
	for n in ${modules} ; do
		_doins ${n}
	done
	dotnet_multilib_comply
}
