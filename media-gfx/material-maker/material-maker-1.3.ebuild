# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

GODOT_PV_DESKTOP="3.5.2"
GODOT_PV_HTML5="3.5.1"
MY_PV="${PV/-/_}"
PYTHON_COMPAT=( python3_{10..11} ) # Upstream uses 3.10
RCEDIT_PV="1.1.1"

inherit python-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/RodZill4/material-maker.git"
	FALLBACK_COMMIT="1a86d73967479c43db5fa17e5adda5e54a0c886f" # Apr 23, 2023
	MY_PV="1_3"
	inherit git-r3
	IUSE+=" fallback-commit"
else
#	KEYWORDS="~amd64 ~x86" # Install not finished
	MY_PV="${PV/./_}"
	SRC_URI="
https://github.com/RodZill4/material-maker/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
elibc_mingw? (
	https://github.com/electron/rcedit/releases/download/v${RCEDIT_PV}/rcedit-x64.exe
		-> rcedit-${RCEDIT_PV}-x64.exe
)
	"
fi

DESCRIPTION="A procedural textures authoring and 3D model painting tool based \
on the Godot game engine"
HOMEPAGE="
	https://github.com/RodZill4/material-maker
"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" +desktop doc html5"
REQUIRED_USE="
	|| (
		desktop
		html5
	)
"
BDEPEND="
	desktop? (
		=dev-games/godot-editor-${GODOT_PV_DESKTOP%.*}*
		=dev-games/godot-export-templates-bin-${GODOT_PV_DESKTOP%.*}*[standard]
		virtual/wine[abi_x86_32]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	html5? (
		=dev-games/godot-editor-${GODOT_PV_HTML5%.*}*
		=dev-games/godot-export-templates-bin-${GODOT_PV_HTML5%.*}*
	)
"

pkg_setup() {
ewarn "This ebuild is still in development."
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
	if use elibc_mingw ; then
		mkdir -v -p "${HOME}/.local/share/rcedit" || die
		cd "${HOME}/.local/share/rcedit" || die
		cat \
			"${DISTDIR}/rcedit-${PV}-x64.exe" \
			> \
			"rcedit-${PV}-x64.exe" \
			|| die
		export RCEDIT_PATH=$(pwd)
	fi
}

src_prepare() {
	default
}

src_configure() {
	if use kernel_Darwin ; then
		local certificate_path="${T}/build_certificate.p12"
		local provision_profile_path="${T}/build_pp.mobileprovision"
		local keychain_path="${T}/app-signing.keychain-db"

		[[ -z "${BUILD_CERTIFICATE_BASE64}" ]] && die "Missing environment variable"
		[[ -z "${BUILD_PROVISION_PROFILE_BASE64}" ]] && die "Missing environment variable"
		[[ -z "${KEYCHAIN_PASSWORD}" ]] && die "Missing environment variable"
		[[ -z "${P12_PASSWORD}" ]] && die "Missing environment variable"

		# Import certificate and provisioning profile from secrets
		echo -n "${BUILD_CERTIFICATE_BASE64}" | base64 --decode --output "${certificate_path}"
		echo -n "${BUILD_PROVISION_PROFILE_BASE64}" | base64 --decode --output "${provision_profile_path}"

		# Create temporary keychain
		security create-keychain -p "${KEYCHAIN_PASSWORD}" "${keychain_path}"
		security set-keychain-settings -lut 21600 "${keychain_path}"
		security unlock-keychain -p "${KEYCHAIN_PASSWORD}" "${keychain_path}"

		# Import certificate to keychain
		security import "${certificate_path}" -P "${P12_PASSWORD}" -A -t "cert" -f "pkcs12" -k "${keychain_path}"
		security list-keychain -d "user" -s "${keychain_path}"

		# Apply provisioning profile
		mkdir -p "${HOME}/Library/MobileDevice/Provisioning\ Profiles"
		cp "${provision_profile_path}" "${HOME}/Library/MobileDevice/Provisioning\ Profiles"
	fi
}

desktop_gen_tres() {
	echo '[gd_resource type="EditorSettings" format=2]' \
		>> "${HOME}/.config/godot/editor_settings-3.tres"
	echo '[resource]' \
		>> "${HOME}/.config/godot/editor_settings-3.tres"
	echo 'export/windows/wine = "/usr/bin/wine"' \
		>> "${HOME}/.config/godot/editor_settings-3.tres"
	if use elibc_mingw ; then
		echo 'export/windows/rcedit = "'"${$RCEDIT_PATH}"'/rcedit-'"${PV}"'-x64.exe"' \
			>> "${HOME}/.config/godot/editor_settings-3.tres"
		mkdir -v -p \
			"build/${MY_PV}_${MY_PV}_windows" \
			|| die
	fi
	if use kernel_linux ; then
		mkdir -v -p \
			"build/${MY_PV}_${MY_PV}_linux" \
			|| die
	fi
}

desktop_build_winux() {
	godot \
		--headless \
		-v \
		--export-release "${export_template}" \
		"build/${MY_PV}_${MY_PV}_${os}/${MY_PV}.${suffix}" \
		|| die
	godot \
		--headless \
		-v \
		--export-release "${export_template}" \
		"build/${MY_PV}_${MY_PV}_${os}/${MY_PV}.${suffix}" \
		|| die
}

desktop_build_mac() {
	bin/godot \
		-v \
		--export "${export_template}" \
		"build/mac/${MY_PV}.${suffix}" \
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

desktop_copy_data_mac() {
	local pairs=(
		"addons/material_maker/nodes:build/mac/${MY_PV}.app/Contents/${os}"
		"material_maker/environments:build/mac/${MY_PV}.app/Contents/${os}"
		"material_maker/examples:build/mac/${MY_PV}.app/Contents/${os}"
		"material_maker/library:build/mac/${MY_PV}.app/Contents/${os}"
		"material_maker/meshes:build/mac/${MY_PV}.app/Contents/${os}"
		"material_maker/misc/export:build/mac/${MY_PV}.app/Contents/${os}"
		"doc:build/mac/${MY_PV}.app/Contents/${os}/doc"
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
	if use elibc_mingw ; then
		zip -r \
			"${MY_PV}_${MY_PV}_windows.zip" \
			"${MY_PV}_${MY_PV}_windows" \
			|| die
	elif use amd64 && use kernel_linux ; then
		tar zcvf \
			"${MY_PV}_${MY_PV}_linux.tar.gz" \
			"${MY_PV}_${MY_PV}_linux" \
			|| die
	fi
}

desktop_pack_mac() {
	if use kernel_Darwin ; then
		if [[ -n "${CODESIGN_IDENTITY}" ]] ; then
			codesign \
				-s "${CODESIGN_IDENTITY}" \
				--force \
				--options runtime \
				--timestamp \
				--deep \
				"build/mac/material_maker.app" \
				|| die
		else
			codesign \
				-s - \
				--force \
				--deep \
				"build/mac/${MY_PV}.app" \
				|| die
		fi
		hdiutil create \
			-srcfolder \
			"build/mac" \
			-fs "HFS+" \
			-volname "${MY_PV}" \
			"build/mac/material_maker_${MY_PV}.dmg" \
			|| die
		if [[ -n "${CODESIGN_IDENTITY}" ]] ; then
			[[ -z "${APPLE_ID}" ]] && die "Missing environment variable"
			[[ -z "${APPLE_TEAM_ID}" ]] && die "Missing environment variable"
			[[ -z "${NOTARYTOOL_APP_PASSWORD}" ]] && die "Missing environment variable"
			xcrun notarytool submit \
				"build/mac/material_maker_${MY_PV}.dmg" \
				--apple-id "${APPLE_ID}" \
				--password "${NOTARYTOOL_APP_PASSWORD}" \
				--team-id "${APPLE_TEAM_ID}" \
				--wait \
				|| die
			xcrun stapler staple \
				"build/mac/material_maker_${MY_PV}.dmg" \
				|| die
		fi
	fi
}

src_compile() {
	if use desktop ; then
		local arch
		local os
		local export_template
		if use amd64 && use kernel_linux ; then
			suffix="x86_64"
			os="linux"
			export_template="Linux/X11"
		elif use elibc_mingw ; then
			suffix="exe"
			os="windows"
			export_template="Windows"
		elif use kernel_Darwin ; then
			suffix="zip"
			os="MacOS"
			export_template="Mac OSX"
		else
eerror "OS/ARCH not supported"
			die
		fi
		desktop_gen_tres
		if use kernel_linux || use elibc_mingw ; then
			desktop_build_winux
			desktop_build_doc
			desktop_copy_data_winux
			desktop_pack_winux
		elif use kernel_Darwin ; then
			desktop_build_mac
			desktop_build_doc
			desktop_copy_data_mac
			desktop_pack_mac
		fi
	elif use html5 ; then
		mkdir -p "build/export_html5" || die
		godot \
			-v \
			--export "HTML5" \
			"build/export_html5/index.html" \
			|| die
	fi
}

src_install() {
	default
ewarn "TODO:  finish install"
}
