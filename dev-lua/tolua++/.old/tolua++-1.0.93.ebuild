# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

MY_P=${P/pp/++}

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="http://www.codenix.com/~tolua/"
SRC_URI="http://www.codenix.com/~tolua/tolua++-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-lang/lua:5.2"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${MY_P}

#pkg_setup() {
#	if [[ "$(tc-getCC)" == "clang" || "${tc-getCXX}" == "clang++" ]]; then
#		einfo "Forcing GCC"
#		export CC="gcc"
#		export CXX="g++"
#	fi
#}

src_prepare() {
	true
	#epatch "${FILESDIR}"/tolua++-1.0.93-lua-5_2.patch
	echo "Applying luaL_getn patch"
	for FILE in $(grep -l -r -e "luaL_getn")
	do
		echo "Editing ${FILE}..."
		sed -i -e 's|luaL_getn|luaL_len|' "${FILE}" || die 6
	done

	echo "Applying lua_getfenv patch"
	for FILE in $(grep -l -r -e "lua_getfenv")
	do
		echo "Editing ${FILE}..."
		sed -i -e 's|lua_getfenv|lua_getuservalue|' "${FILE}" || die 5
	done

	echo "Applying lua_setfenv patch"
	for FILE in $(grep -l -r -e "lua_setfenv")
	do
		echo "Editing ${FILE}..."
		sed -i -e 's|lua_setfenv|lua_setuservalue|' "${FILE}" || die 4
	done

	echo "Applying unpack patch"
	for FILE in $(grep -l -r -e "unpack")
	do
		echo "Editing ${FILE}..."
		sed -i -e 's|unpack|table.unpack|' "${FILE}" || die 3
	done

	#echo "Applying loadstring patch"
	#for FILE in $(grep -l -r -e "loadstring")
	#do
	#	echo "Editing ${FILE}..."
	#	sed -i -e 's|loadstring|load|' "${FILE}" || die 2
	#done

	echo "Applying arg.n patch"
	for FILE in $(grep -l -r -e "arg.n")
	do
		echo "Editing ${FILE}..."
		sed -i -r -e 's|arg.n|#arg|' "${FILE}" || die 2c
	done

	echo "Applying gfind patch"
	for FILE in $(grep -l -r -e "gfind")
	do
		echo "Editing ${FILE}..."
		sed -i -e 's|gfind|gmatch|' "${FILE}" || die 2a
	done

	echo "Applying table.getn patch"
	for FILE in $(grep -l -r -e "table.getn")
	do
		echo "Editing ${FILE}..."
		sed -i -r -e 's|table.getn[(]([^)]+)[)]|#\1|g' "${FILE}" || die 1
	done

	sed -i -e 's|function dostring(s) return do_(loadstring(s)) end|function dostring(s) return do_(load(s)) end|g' src/bin/lua/compat.lua
	sed -i -e 's|local f,e = loadstring(table.concat(chunk))|local f,e = load(table.concat(chunk), nil, nil, _extra_parameters)|g' src/bin/lua/package.lua
	sed -i -e 's|setfenv(f, _extra_parameters)||g' src/bin/lua/package.lua

	echo "Applying setfenv patch..."
	cat src/bin/lua/package.lua > src/bin/lua/package.lua.t
	echo "function setfenv(f, env)" >> src/bin/lua/package.lua.t
	echo "   return load(string.dump(f), nil, nil, env)" >> src/bin/lua/package.lua.t
	echo "end" >> src/bin/lua/package.lua.t
	mv src/bin/lua/package.lua.t src/bin/lua/package.lua || die 1a

	echo "Applying LUA_GLOBALSINDEX patch"
	echo "Editing src/lib/tolua_map.c..."
	#sed -i -e 's|lua_pushvalue(L,LUA_GLOBALSINDEX);|lua_pushglobaltable(L);|' src/lib/tolua_map.c
	sed -i -e 's|lua_pushvalue(L,LUA_GLOBALSINDEX);|tolua_push_globals_table(L);|' src/lib/tolua_map.c

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|if self.kind and self.kind == .var. then\n\t\tself.name = string.gsub\(self.name, \"\:.\*\$\", \"\"\) -- \?\?\?\n\tend||' src/bin/lua/declaration.lua || die 1.1a
	epatch "${FILESDIR}"/tolua-1.0.93-declaration-2.patch || die 1.1b

	cat src/lib/tolua_map.c > src/lib/tolua_map.c.t

	#from
	echo "static void tolua_push_globals_table (lua_State* L)" >> src/lib/tolua_map.c.t
	echo "{" >> src/lib/tolua_map.c.t
	echo "   lua_pushvalue(L,LUA_REGISTRYINDEX); /* registry */" >> src/lib/tolua_map.c.t
	echo "   lua_pushnumber(L,LUA_RIDX_GLOBALS); /* registry globalsindex */" >> src/lib/tolua_map.c.t
	echo "   lua_rawget(L, -2);                  /* registry registry[globalsindex] */" >> src/lib/tolua_map.c.t
	echo "   lua_remove(L, -2);                  /* registry[globalsindex] */" >> src/lib/tolua_map.c.t
	echo "}" >> src/lib/tolua_map.c.t
	mv src/lib/tolua_map.c.t src/lib/tolua_map.c || die 1c
	sed -i -e 's|TOLUA_API void tolua_beginmodule (lua_State\* L, const char\* name)|static void tolua_push_globals_table (lua_State* L);\nTOLUA_API void tolua_beginmodule (lua_State* L, const char* name)|' src/lib/tolua_map.c || die 1b

	sed -i -e 's|static int tolua_newmetatable (lua_State\* L, char\* name)|static int tolua_newmetatable (lua_State* L, const char* name)|' src/lib/tolua_map.c || die 1c

	sed -i -e 's|env.Copy()|env.Clone()|g' src/tests/SCsub

	sed -i -e 's|foreach = tab.foreach|foreach = function(t,f)\n  for k,v in pairs(t) do\n    f(k,v)\n  end\nend|g' src/bin/lua/compat.lua || die 1.2a
	sed -i -e 's|foreachi = tab.foreachi|foreachi = function(t,f)\n  for i,v in ipairs(t) do\n    f(i,v)\n  end\nend|g' src/bin/lua/compat.lua || die 1.2b
	sed -i -e 's|getn = tab.getn|getn = function(t)\n  return #t\nend|' src/bin/lua/compat.lua || die 1.2c
	sed -i -e "s|function read (...)|function read (...)\n  local arg = {...}|" src/bin/lua/compat.lua || die 1.2d
	sed -i -e "s|function write (...)|function write (...)\n  local arg = {...}|" src/bin/lua/compat.lua || die 1.2e

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|TOLUA_API int class_gc_event \(lua_State\* L\)\n\{\n|TOLUA_API int class_gc_event (lua_State\* L)\n{\n\tif (lua_type(L,1) != LUA_TUSERDATA) {\n\t\treturn 0;\n }\n|' src/lib/tolua_event.c || die 1.4

	epatch "${FILESDIR}"/tolua-1.0.93-cleanlua.patch || die 1.5
	epatch "${FILESDIR}"/tolua-1.0.93-featurelua.patch || die 1.6

	#sed -i -e 's|toluabind.c|toluabind_default.c|' ./src/bin/SCsub
	#sed -i -e 's|toluabind.c|toluabind_default.c|' ./src/bin/SCsub
	#sed -i -e 's|bootstrap = True|bootstrap = False|' src/bin/SCsub

	echo "Dumping lua scripts..."
	echo "Wiping src/bin/toluabind_default.c..."
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|static unsigned char B[] = {\n[\n,0-9 ]*};|static unsigned char B[] = {};|g" src/bin/toluabind_default.c

if $(false); then
	echo "Generating src/bin/toluabind_default.c..."
	for FILE in "compat-5.1.lua" "compat.lua" "basic.lua" "feature.lua" "verbatim.lua" "code.lua" "typedef.lua" "container.lua" "package.lua" "module.lua" "namespace.lua" "define.lua" "enumerate.lua" "declaration.lua" "variable.lua" "array.lua" "function.lua" "operator.lua" "template_class.lua" "class.lua" "clean.lua" "doit.lua"
	do
		echo "Editing src/bin/toluabind_default.c..."
		export DUMP_=$(cat src/bin/lua/${FILE} |hexdump -v -e ' 10/1 " %2d," "\n"' | sed -e 's|,   |, 20|g' | tr -d '\n')
		export DUMP="${DUMP_::-1}"
		#echo ${DUMP}
		#sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|static unsigned char B\[\] = \{\};\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua embedded: lua/tolua\+\+[/]src[/]bin[/]lua[/]${FILE}\"\)\;|static const unsigned char B\[\] = { ${DUMP} };\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua embedded: src\/bin\/lua\/${FILE}\"\)\;|g" src/bin/toluabind_default.c || die
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|static unsigned char B\[\] = \{\};\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua embedded: lua/tolua\+\+[/]src[/]bin[/]lua[/]${FILE}\"\)\;|static const unsigned char B\[\] = { ${DUMP} };\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua embedded: lua\/${FILE}\"\)\;|g" src/bin/toluabind_default.c || die
	done

	export DUMP_=$(sed -r -e ':a' -e 'N' -e '$!ba' -e 's|.*\$\[||g' -e 's|\$\]||g' src/bin/tolua_scons.pkg |hexdump -v -e ' 10/1 " %2d," "\n"' | sed -e 's|,   |, 20|g' | tr -d '\n')
	export DUMP="${DUMP_::-1}"
fi
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|static unsigned char B\[\] = \{\};\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua: embedded Lua code 23\"\)\;|static const unsigned char B\[\] = { ${DUMP} };\n   tolua_dobuffer\(tolua_S,\(char\*\)B,sizeof\(B\),\"tolua: embedded Lua code 23\"\)\;|g" src/bin/toluabind_default.c || die



	#cat doit.lua |hexdump -e ' 10/1 " %02x," "\n"' | sed -e 's|,   |, 20|g'
}

src_compile() {
	echo "## BEGIN gentoo.py

LIBS = ['lua5.2', 'dl', 'm']

## END gentoo.py" > ${S}/custom.py

	scons \
		CC="$(tc-getCC)" \
		CCFLAGS="${CFLAGS} -ansi -Wall -I/usr/include/lua5.2" \
		CXX="$(tc-getCXX)" \
		LINK="$(tc-getCC)" \
		LINKFLAGS="${LDFLAGS}" \
		shared=1 || die "scons failed"
}

src_install() {
	dobin bin/tolua++ || die "dobin failed"
#	dobin bin/tolua++_bootstrap || die "dobin failed"
#	dolib.a lib/libtolua++_static.a || die "dolib.a failed"
	dolib.so lib/libtolua++.so || die "dolib.so failed"
	insinto /usr/include
	doins include/tolua++.h || die "doins failed"
	dodoc README
	dohtml doc/*
}
