# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# You must add the following to /etc/portage/profile/package.use.mask
# media-libs/opencv -contribhdf

# For versioning, see
# https://github.com/boltgolt/howdy/blob/beta/howdy/src/cli.py#L122

PYTHON_COMPAT=( python3_{8..11} )

inherit git-r3 meson python-r1

EGIT_COMMIT_DLIB_MODELS="daf943f7819a3dda8aec4276754ef918dc26491f"
DLIB_MODELS_DATE="20210412"
if [[ ${PV} =~ 9999 ]] ; then
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${PN}-${PV}"
else
	SRC_URI+="
https://github.com/boltgolt/howdy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${PV}"
fi
SRC_URI+="
https://github.com/davisking/dlib-models/raw/master/dlib_face_recognition_resnet_model_v1.dat.bz2
	-> dlib_face_recognition_resnet_model_v1-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
https://github.com/davisking/dlib-models/raw/master/mmod_human_face_detector.dat.bz2
	-> mmod_human_face_detector-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
https://github.com/davisking/dlib-models/raw/master/shape_predictor_5_face_landmarks.dat.bz2
	-> shape_predictor_5_face_landmarks-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
"

DESCRIPTION="Facial authentication for Linux"
HOMEPAGE="https://github.com/boltgolt/howdy"
LICENSE="MIT BSD CC0-1.0"
# CC0-1.0 - dlib-models
# BSD - howdy/src/recorders/v4l2.py

# Live ebuilds do not get KEYWORDS.  Distro policy.

SLOT="0"
CUDA_TARGETS_COMPAT=(
	sm_50
)
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
+bash-completion cuda -ffmpeg +gtk -pyv4l2 r12
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	cuda_targets_sm_50? (
		cuda
	)
"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-libs/inih-52
	>=sci-libs/dlib-19.16[${PYTHON_USEDEP},cuda?,python]
	app-admin/sudo
	dev-libs/boost[${PYTHON_USEDEP},python]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},contribhdf,png,python,v4l]
	sys-libs/pam
	cuda_targets_sm_50? (
		>=sci-libs/dlib-19.21[${PYTHON_USEDEP},cuda?,python]
		dev-util/nvidia-cuda-toolkit:=
	)
	ffmpeg? (
		dev-python/ffmpeg-python[${PYTHON_USEDEP}]
		media-video/ffmpeg[v4l]
	)
	gtk? (
		$(python_gen_any_dep '
			dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
		')
		dev-python/elevate[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)
	pyv4l2? (
		dev-python/pyv4l2[${PYTHON_USEDEP}]
		media-libs/libv4l
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/meson
	|| (
		>=sys-devel/gcc-5
		>=sys-devel/clang-3.4
	)
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/howdy-3.0_beta_pre9999-howdy-gtk-fix-camera-id.patch"
)

pkg_setup()
{
	if use ffmpeg && use pyv4l2 ; then
ewarn
ewarn "Only one capture source is allowed.  Disable either ffmpeg, pyv4l2, or"
ewarn "all."
ewarn
	fi
	if has_version "dev-python/ffmpeg-python" && ! use ffmpeg ; then
ewarn
ewarn "You must enable the ffmpeg USE flag or unemerge ffmpeg-python."
ewarn
	fi
	python_setup
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="c5b17665d5e27c92abaad988e1b229c8d558220b" # Sep 24, 2023
		EGIT_BRANCH="beta"
		EGIT_REPO_URI="https://github.com/boltgolt/howdy.git"
		git-r3_fetch
		git-r3_checkout
	fi
	unpack ${A}
	mv dlib_face_recognition_resnet_model_v1-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		dlib_face_recognition_resnet_model_v1.dat || die
	mv mmod_human_face_detector-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		mmod_human_face_detector.dat || die
	mv shape_predictor_5_face_landmarks-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		shape_predictor_5_face_landmarks.dat || die

	local EXPECTED_VERSION="Howdy 3.0.0 BETA"
	local actual_version=$(grep -E -o \
		-e "Howdy [0-9]+\.[0-9]+\.[0-9]+[ ]?[A-Z]*" \
		"${S}/howdy/src/cli.py")
	if [[ "${EXPECTED_VERSION}" != "${actual_version}" ]] ; then
eerror
eerror "A change in version was detected:"
eerror
eerror "Actual version:\t${actual_version}"
eerror "Expected version:\t${EXPECTED_VERSION}"
eerror
eerror "This requires IUSE, *DEPENDs, EXPECTED_VERSION, src_install changes."
eerror
eerror "  or"
eerror
eerror "Use the fallback-commit USE flag."
eerror
		die
	fi
}

src_prepare() {
	default
	local F=(
		$(grep -l -r -e "lib/security" "${S}")
	)

	for f in ${F[@]} ; do
		[[ "${f}" =~ ("debian"|"archlinux") ]] && continue
einfo "Editing ${f}"
		sed -i -e "s|/lib/security|/$(get_libdir)/security|g" \
			"${f}" || die
	done
}

src_configure() {
	pushd "${S}/howdy/src" || die
		if use cuda ; then
			sed -i -e "s|use_cnn = false|use_cnn = true|g" \
				config.ini \
				|| die
		fi
		if use ffmpeg ; then
			sed -i -e "s|recording_plugin = opencv|recording_plugin = ffmpeg|g" \
				config.ini \
				|| die
		fi
		if use pyv4l2 ; then
			sed -i -e "s|recording_plugin = opencv|recording_plugin = pyv4l2|g" \
				config.ini \
				|| die
		fi
		sed -i -e "s|/lib/security/howdy/config.ini|/$(get_libdir)/security/howdy/config.ini|g" \
			"pam/main.cc" \
			|| die

		# Set default camera
		sed -i \
			sed -i -e "s|device_path = none|device_path = /dev/video0|g" \
			config.ini \
			|| die

		# Increase match
		sed -i \
			sed -i -e "s|certainty = 3.5|certainty = 4.4|g" \
			config.ini \
			|| die

		# Change message
		# Women false positives are around 4.9-7.9.
		# Men false positives are around 4.50-7.2.
		sed -i \
			sed -i -e "s|from 1 to 10, values above 5 are not recommended|from 1 to 5, values above 5 must not be used|g" \
			config.ini \
			|| die
	popd
	export EMESON_SOURCE="${S}"
	export BUILD_DIR="${S}_build"
	local emesonargs=(
		-Dinih:with_INIReader=true
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
	dodir /$(get_libdir)/security
	mv \
		"${ED}/usr/$(get_libdir)/security/pam_howdy.so" \
		"${ED}/$(get_libdir)/security" \
		|| die
	if ! use gtk ; then
		rm -rf "${ED}/usr/$(get_libdir)/howdy-gtk" || die
		rm -rf "${ED}/usr/bin/howdy-gtk" || die
	fi
	if ! use bash-completion ; then
		rm -rf "${ED}/usr/share/bash-completion" || die
	fi
	fperms 0755 /usr/share/dlib-data
	fperms 0755 /usr/$(get_libdir)/howdy/recorders

	insinto /usr/share/dlib-data
	doins "${WORKDIR}/dlib_face_recognition_resnet_model_v1.dat"
	doins "${WORKDIR}/mmod_human_face_detector.dat"
	doins "${WORKDIR}/shape_predictor_5_face_landmarks.dat"

	docinto licenses
	dodoc LICENSE

	insinto /etc/howdy
	doins howdy/src/config.ini
}

verify_folder_permissions() {
einfo "Performing permission scan for folders"
	local d

	d="/usr/share/dlib-data"
	if [[ -e "${d}" ]] ; then
		local actual_file_permissions=$(stat -c "%a" "${d}")
		local expected_file_permissions="755"
		if [[ "${actual_file_permissions}" != "${expected_file_permissions}" ]] ; then
eerror "${d} permissions are incorrect.  Do \`chmod 0${expected_file_permissions} ${d}\`"
		fi
	fi

	d="/usr/$(get_libdir)/howdy/recorders"
	if [[ -e "${d}" ]] ; then
		local actual_file_permissions=$(stat -c "%a" "${d}")
		local expected_file_permissions="755"
		if [[ "${actual_file_permissions}" != "${expected_file_permissions}" ]] ; then
eerror "${d} permissions are incorrect.  Do \`chmod 0${expected_file_permissions} ${d}\`"
		fi
	fi

	d="/$(get_libdir)/security/howdy/models"
	if [[ -e "${d}" ]] ; then
		local actual_file_permissions=$(stat -c "%a" "${d}")
		local expected_file_permissions="755"
		if [[ "${actual_file_permissions}" != "${expected_file_permissions}" ]] ; then
eerror "${d} permissions are incorrect.  Do \`chmod 0${expected_file_permissions} ${d}\`"
		fi
	fi

	d="/etc/howdy/models"
	if [[ -e "${d}" ]] ; then
		local actual_file_permissions=$(stat -c "%a" "${d}")
		local expected_file_permissions="755"
		if [[ "${actual_file_permissions}" != "${expected_file_permissions}" ]] ; then
eerror "${d} permissions are incorrect.  Do \`chmod 0${expected_file_permissions} ${d}\`"
		fi
	fi
}

verify_user_models_permissions() {
einfo "Performing permission scan for data models"
	IFS=$'\n'
	local L=(
		$(find "/$(get_libdir)/security/howdy/models" -type f 2>/dev/null)
		$(find "/etc/howdy/models" -type f 2>/dev/null)
	)
	local path
	for path in "${L[@]}" ; do
		local actual_file_permissions=$(stat -c "%a" "${d}")
		local expected_file_permissions="640"

		local actual_owner=$(stat -c "%G:%U" "${path}")
		local expected_owner="root:root"
		if [[ "${actual_owner}" != "${expected_owner}" ]] ; then
eerror "${path} has the wrong ownership.  Do \`chown ${expected_owner} ${path}\` or consider deleting the potentially compromised file.  Expected owner:  ${expected_owner}, Actual owner:  ${actual_owner}"
		fi
		if [[ "${actual_file_permissions}" != "${expected_file_permissions}" ]] ; then
eerror "${path} permissions are incorrect.  Do \`chmod 0${expected_file_permissions} ${path}\`.  Expected file permissions:  ${expected_file_permissions},  Actual file permissions:  ${actual_file_permissions}"
		fi
	done
	IFS=$' \t\n'
}

pkg_postinst() {
einfo
einfo "You need a v4l compatible camera for this to work properly."
einfo "IR cameras are recommended for it to work in the dark or mitigate against replay attack."
einfo "RGB/grayscale cameras require sufficent lighting for it to work."
einfo
einfo
einfo "The pam configuration can be found in"
einfo
einfo "  https://github.com/boltgolt/howdy/wiki/Only-using-howdy-for-specific-authentication-types"
einfo
einfo "It may be possible to apply these changes beyond sudo."
einfo
einfo
einfo "You must add/change the following to /etc/pam.d/ file(s) that would benefit"
einfo "by using howdy and before system-auth line."
einfo
einfo "  auth            sufficient      /$(get_libdir)/security/pam_howdy.so"
einfo
	if ! use ffmpeg ; then
ewarn
ewarn "If problems are encountered, use the ffmpeg USE flag."
ewarn
	fi
einfo
einfo "To setup, use the following commands:"
einfo
einfo "  # Copy the path, prefixed with /dev/, of the IR camera."
einfo "  v4l2-ctl --list-devices"
einfo
einfo "  # Paste it to the device_path, replacing none."
einfo "  sudo ${PN} config"
einfo
einfo "  # Add face"
einfo "  sudo ${PN} add"
einfo
einfo "  # Verify face recogniton works"
einfo "  sudo ${PN} test"
einfo

ewarn
ewarn "SECURITY NOTICE"
ewarn
ewarn "The /etc/howdy/config.ini should edited as follows for security"
ewarn "hardening:"
ewarn
ewarn "[snapshot]"
ewarn "capture_failed = false"
ewarn "capture_successful = false"
ewarn
ewarn "Saved snapshots should be deleted with shred (secure wipe) as well from:"
ewarn
ewarn "  # For 2.x installs:"
ewarn "  shred -fu \$(find /$(get_libdir)/security/howdy/snapshots -type f)"
ewarn "  # For 3.x installs:"
ewarn "  shred -fu \$(find /var/log/howdy/snapshots -type f)"
ewarn
ewarn "The user models should be removed securely if transfering disk ownership"
ewarn "with:"
ewarn
ewarn "  # For 2.x installs:"
ewarn "  shred -fu \$(find /$(get_libdir)/security/howdy/models -type f)"
ewarn "  # For 3.x installs:"
ewarn "  shred -fu \$(find /etc/howdy/models -type f)"
ewarn
ewarn "The user models (*.dat) files should never have write permissions for others"
ewarn "to prevent hijack or weakness."
ewarn
	verify_user_models_permissions
	verify_folder_permissions
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  failed
# howdy reads config.ini:  pass
# sudo howdy test:  pass
# sudo howdy add:  pass
# sudo howdy-gtk:  pass
# real world test:  fail
