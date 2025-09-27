# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 24

MY_PN="Material Maker"
MY_PV="${PV/_rc/rc}"

GODOT_PV_DESKTOP="4.4.1"
GODOT_SLOT_DESKTOP=$(ver_cut "1-2" "${GODOT_PV_DESKTOP}")
PYTHON_COMPAT=( "python3_12" )
RCEDIT_PV="1.1.1"
STATUS="stable"

inherit desktop python-r1 xdg

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/RodZill4/material-maker.git"
	FALLBACK_COMMIT="1a86d73967479c43db5fa17e5adda5e54a0c886f" # Apr 23, 2023
	MY_PV="1_3"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="
https://github.com/RodZill4/material-maker/archive/refs/tags/${MY_PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/godotengine/godot-builds/releases/download/${GODOT_PV_DESKTOP}-stable/Godot_v${GODOT_PV_DESKTOP}-${STATUS}_linux.x86_64.zip
	"
fi

DESCRIPTION="A procedural textures authoring and 3D model painting tool based \
on the Godot game engine"
HOMEPAGE="
	https://github.com/RodZill4/material-maker
"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
BDEPEND="
	>=dev-games/godot-editor-${GODOT_PV_DESKTOP}:${GODOT_SLOT_DESKTOP}
	app-arch/unzip
	virtual/wine[abi_x86_32]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
"

pkg_setup() {
	python_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use "fallback-commit" && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		if grep -q \
			-e "MY_PV: ${MY_PV}$" \
			"${S}/.github/workflows/dev-desktop-builds.yml" \
		; then
eerror "Bump needed for MY_PV"
			die
		fi
	else
		unpack ${A}
	fi
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	unzip "${distdir}/Godot_v${GODOT_PV_DESKTOP}-${STATUS}_export_templates.tpz" "templates/linux_release.x86_64" || die
	mkdir -v -p "${HOME}/.local/share/godot/export_templates/${GODOT_PV_DESKTOP}.${STATUS}" || die
	mv "templates/linux_release.x86_64" "${HOME}/.local/share/godot/export_templates/${GODOT_PV_DESKTOP}.${STATUS}" || die
}

src_prepare() {
	default
}

src_configure() {
	:
}

desktop_gen_tres() {
	local slot="${GODOT_PV_DESKTOP%%.*}"
	mkdir -p "${HOME}/.config/godot" || die
	echo '[gd_resource type="EditorSettings" format=2]' >> "${HOME}/.config/godot/editor_settings-${slot}.tres"
	echo '[resource]' >> "${HOME}/.config/godot/editor_settings-${slot}.tres"
	echo 'export/windows/wine = "/usr/bin/wine"' >> "${HOME}/.config/godot/editor_settings-${slot}.tres"
	echo 'export/windows/rcedit = "'"${RCEDIT_PATH}"'/rcedit-'"${PV}"'-x64.exe"' >> "${HOME}/.config/godot/editor_settings-${slot}.tres"
	mkdir -v -p "build/${MY_PV}_${MY_PV}_linux" || die
}

desktop_build_winux() {
	local x
	for x in $(seq 0 18) ; do
		addpredict "/dev/input/event${x}"
	done
	addpredict "/dev/input/mice"
	addpredict "/dev/input/mouse0"
	"${WORKDIR}/Godot_v${GODOT_PV_DESKTOP}-${STATUS}_linux.x86_64" \
		--headless \
		-v \
		--export-release "${export_template}" \
		"build/${MY_PV}_${MY_PV}_${os}/${MY_PV}.${suffix}" \
		|| die
	"${WORKDIR}/Godot_v${GODOT_PV_DESKTOP}-${STATUS}_linux.x86_64" \
		--headless \
		-v \
		--export-release "${export_template}" \
		"build/${MY_PV}_${MY_PV}_${os}/${MY_PV}.${suffix}" \
		|| die
}

desktop_build_doc() {
	pushd material_maker/doc >/dev/null 2>&1 || die
		emake
	popd >/dev/null 2>&1 || die
}

desktop_copy_data_winux() {
	local pairs=(
		"addons/material_maker/nodes:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/environments:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/examples:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/library:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/meshes:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/misc/export:build/${MY_PV}_${MY_PV}_${os}"
		"material_maker/doc/_build/html:build/${MY_PV}_${MY_PV}_${os}/doc"
	)
	local src
	local dest
	for pair in ${pairs[@]} ; do
		local src="${pair%:*}"
		local dest="${pair#*:}"
		cp -vR "${src}" "${dest}"
	done
}

desktop_pack_winux() {
	cd build || die
	if use amd64 && use kernel_linux ; then
		tar zcvf \
			"${MY_PV}_${MY_PV}_linux.tar.gz" \
			"${MY_PV}_${MY_PV}_linux" \
			|| die
	else
eerror "ARCH=${ARCH} is not supported"
		die
	fi
}

src_compile() {
	local arch
	local os
	local export_template
	if use amd64 && use kernel_linux ; then
		suffix="x86_64"
		os="linux"
		export_template="Linux/X11"
	else
eerror "OS/ARCH not supported"
		die
	fi
	desktop_gen_tres
	if use kernel_linux ; then
		desktop_build_winux
		desktop_build_doc
		desktop_copy_data_winux
		desktop_pack_winux
	fi
}

src_install() {
	default
	pushd "${S}/build/${MY_PV}_${MY_PV}_linux" || die
		insinto "/opt/${PN}"
		doins -r *
		fperms "+x" "/opt/${PN}/${MY_PV}.x86_64"
	popd || die
	newicon "icon.png" "${PN}.png"
	make_desktop_entry \
		"/opt/${PN}" \
		"${MY_PN}" \
		"${PN}.png" \
		"Graphics;3DGraphics"
	exeinto "/usr/bin"
cat <<EOF > "${T}/${PN}"
#!/bin/bash
"/opt/${PN}/${MY_PV}.x86_64" "$@"
EOF
	doexe "${T}/${PN}"
}
