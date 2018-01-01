# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

EAPI="6"

inherit dotnet eutils multilib mono versionator subversion autotools gac

DESCRIPTION="Tao Framework"
HOMEPAGE="http://sourceforge.net/projects/taoframework/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RESTRICT="fetch"

RDEPEND=">=dev-lang/mono-2.0
		media-libs/openal
		virtual/opengl
		media-libs/libsdl
	"
DEPEND="${RDEPEND}
                dev-util/nant
		dev-util/nunit:2
		app-arch/p7zip"

S="${WORKDIR}/taoframework-${PV}"
src_unpack() {
        ESVN_REPO_URI="svn://svn.code.sf.net/p/taoframework/code/tags/taoframework-2.1.0/"
        ESVN_REVISION="237"
        ESVN_OPTIONS="--trust-server-cert"
	ESVN_PROJECT="taoframework-code"
        subversion_src_unpack
}

src_prepare() {
	sed -i -e 's|monodocer --assembly:$$x/$$x.dll --path:doc/$$x|monodocer --out:doc/$$x $$x/$$x.dll|g' "${S}"/src/Makefile.am
	sed -i -e "s|PACKAGES = nunit||g" tests/Ode/Makefile.am
	sed -i -e "s|SYSTEM_LIBS =|SYSTEM_LIBS = /usr/share/nunit-2/nunit.framework.dll |g" tests/Ode/Makefile.am
	sed -i -e "s|PACKAGES = nunit||g" tests/Sdl/Makefile.am
	sed -i -e "s|SYSTEM_LIBS =|SYSTEM_LIBS = /usr/share/nunit-2/nunit.framework.dll |g" tests/Sdl/Makefile.am

	sed -i -e "s|gmcs|mcs|g" configure.ac

	eapply "${FILESDIR}/taoframework-2.1.0-use-mono-4.5.patch"

	eapply_user

	eautoreconf || die
}

src_configure() {
	econf || die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins src/Tao.FreeType/Tao.FreeType{.snk,.xml}
		doins src/Tao.Platform.Windows/Tao.Platform.Windows{.snk,.xml}
		doins src/Tao.Lua/Tao.Lua{.snk,.xml}
		doins src/Tao.OpenGl/Tao.OpenGl{.snk,.dll.config}
		doins src/Tao.Ode/Tao.Ode{.snk,.xml}
		doins src/Tao.Glfw/Tao.Glfw{.snk,.xml}
		doins src/Tao.DevIl/Tao.DevIl{.snk,.xml}
		doins src/Tao.FreeGlut/Tao.FreeGlut{.snk,.xml}
		doins src/Tao.PhysFs/Tao.PhysFs{.snk,.xml}
		doins src/Tao.Sdl/Tao.Sdl{.snk,.xml}
                doins src/Tao.GlBindGen/Tao.GlBindGen.snk
		doins src/Tao.FFmpeg/Tao.FFmpeg{.snk,.xml}
		doins src/Tao.OpenAl/Tao.OpenAl{.snk,.xml}
		doins src/Tao.Cg/Tao.Cg{.snk,.xml}
		doins src/Tao.Platform.X11/Tao.Platform.X11{.snk,.xml}
	fi

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins src/Tao.FreeType/Tao.FreeType.dll.config
	doins src/Tao.Platform.Windows/Tao.Platform.Windows.dll.config
	doins src/Tao.Lua/Tao.Lua.dll.config
	doins src/Tao.OpenGl/Tao.OpenGl.dll.config
	doins src/Tao.Ode/Tao.Ode.dll.config
	doins src/Tao.Glfw/Tao.Glfw.dll.config
	doins src/Tao.DevIl/Tao.DevIl.dll.config
	doins src/Tao.FreeGlut/Tao.FreeGlut.dll.config
	doins src/Tao.PhysFs/Tao.PhysFs.dll.config
	doins src/Tao.Sdl/Tao.Sdl.dll.config
	doins src/Tao.FFmpeg/Tao.FFmpeg.dll.config
	doins src/Tao.OpenAl/Tao.OpenAl.dll.config
	doins src/Tao.Cg/Tao.Cg.dll.config
	doins src/Tao.Platform.X11/Tao.Platform.X11.dll.config


	dotnet_multilib_comply
}
