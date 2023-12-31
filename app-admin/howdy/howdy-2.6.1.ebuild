# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# You must add the following to /etc/portage/profile/package.use.mask
# media-libs/opencv -contribhdf

# For versioning, see
# https://github.com/boltgolt/howdy/blob/v2.6.1/src/cli.py#L111

PYTHON_COMPAT=( python3_{8..11} )

inherit python-single-r1

EGIT_COMMIT_DLIB_MODELS="daf943f7819a3dda8aec4276754ef918dc26491f"
DLIB_MODELS_DATE="20210412"
SRC_URI+="
https://github.com/boltgolt/howdy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${PV}"
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
KEYWORDS="~amd64"
SLOT="0"
CUDA_TARGETS_COMPAT=(
	sm_50
)
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
+bash-completion cuda -ffmpeg -pyv4l2 r13
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
	$(python_gen_cond_dep '
		sys-auth/pam-python[${PYTHON_SINGLE_USEDEP}]
		>=sci-libs/dlib-19.16[${PYTHON_USEDEP},python]
		dev-libs/boost[${PYTHON_USEDEP},python]
		dev-python/numpy[${PYTHON_USEDEP}]
		media-libs/opencv[${PYTHON_USEDEP},contribhdf,python,v4l]
	')
	>=dev-libs/inih-52
	app-admin/sudo
	sys-libs/pam
	cuda_targets_sm_50? (
		$(python_gen_cond_dep '
			>=sci-libs/dlib-19.21[${PYTHON_USEDEP},cuda?,python]
		')
		dev-util/nvidia-cuda-toolkit:=
	)
	ffmpeg? (
		$(python_gen_cond_dep '
			dev-python/ffmpeg-python[${PYTHON_USEDEP}]
		')
		media-video/ffmpeg[v4l]
	)
	pyv4l2? (
		$(python_gen_cond_dep '
			dev-python/pyv4l2[${PYTHON_USEDEP}]
		')
		media-libs/libv4l
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	|| (
		>=sys-devel/gcc-5
		>=sys-devel/clang-3.4
	)
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-2.6.1-use-py3-pythonparser.patch"
)

pkg_setup()
{
	if use ffmpeg && use pyv4l2 ; then
ewarn
ewarn "Only one capture source is allowed.  Disable either ffmpeg, pyv4l2, or"
ewarn "all."
ewarn
	fi
	python_setup
}

src_unpack() {
	unpack ${A}
	mv dlib_face_recognition_resnet_model_v1-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		dlib_face_recognition_resnet_model_v1.dat || die
	mv mmod_human_face_detector-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		mmod_human_face_detector.dat || die
	mv shape_predictor_5_face_landmarks-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat \
		shape_predictor_5_face_landmarks.dat || die
}

src_prepare() {
	default
	local F=(
		$(grep -l -r -e "lib/security" "${S}")
	)

	for f in ${F[@]} ; do
		[[ "${f}" =~ ("debian"|"archlinux") ]] && continue
einfo "Editing ${f}"
		sed -i \
			-e "s|/lib/security|/$(get_libdir)/security|g" \
			"${f}" \
			|| die
	done

ewarn
ewarn "If howdy breaks with an illegal instruction, try recompiling dlib with -O0."
ewarn
einfo "Changing python3 -> ${EPYTHON}"
	sed -i \
		-e "s|python3|${EPYTHON}|g" \
		tests/importing.sh \
		tests/compare.sh \
		src/cli.py \
		src/pam.py \
		|| die
}

src_configure() {
	pushd "${S}/src" || die
		if use cuda ; then
			sed -i \
				-e "s|use_cnn = false|use_cnn = true|g" \
				config.ini \
				|| die
		fi
		if use ffmpeg ; then
			sed -i \
				-e "s|recording_plugin = opencv|recording_plugin = ffmpeg|g" \
				config.ini \
				|| die
		fi
		if use pyv4l2 ; then
			sed -i \
				-e "s|recording_plugin = opencv|recording_plugin = pyv4l2|g" \
				config.ini \
				|| die
		fi

		# Disable for security and privacy reasons
		sed -i \
			-e "s|capture_failed = true|capture_failed = false|g" \
			-e "s|capture_successful = true|capture_successful = false|g" \
			config.ini \
			|| die

		# Set default camera
		sed -i \
			-e "s|device_path = none|device_path = /dev/video0|g" \
			config.ini \
			|| die

		# Increase match
		sed -i \
			-i -e "s|certainty = 3.5|certainty = 4|g" \
			config.ini \
			|| die

		# Change message
		# Women false positives are around 4.9-7.9.
		# Men false positives are around 4.50-7.2.
		sed -i \
			-i -e "s|from 1 to 10, values above 5 are not recommended|from 1 to 5, values above 5 must not be used|g" \
			config.ini \
			|| die
	popd
}

src_compile() {
	:;
}

src_install() {
	insinto /$(get_libdir)/security/${PN}
	doins -r src/*
	pushd "${ED}" || die
		local x
		for x in $(find "$(get_libdir)/security/${PN}" -type d) ; do
			x="/${x}"
einfo "DIR: fperms 0744 ${x}"
			fperms -R 0744 "/${x}"
		done
		for x in $(find "$(get_libdir)/security/${PN}" -type f) ; do
			x="/${x}"
einfo "FILE: fperms 0644 ${x}"
			fperms -R 0644 "/${x}"
		done
		x="/$(get_libdir)/security/${PN}"
einfo "DIR: fperms 0755 ${x}"
		fperms 0755 "${x}"

# It will work if you delete the folders first.
# https://github.com/boltgolt/howdy/issues/208
		fperms 0755 "/$(get_libdir)/security/${PN}/dlib-data"
# https://github.com/boltgolt/howdy/issues/450
		fperms 0755 "/$(get_libdir)/security/${PN}/recorders"
	popd
	exeinto /usr/bin
	dosym ../../$(get_libdir)/security/${PN}/cli.py /usr/bin/${PN}
	fperms 0755 /$(get_libdir)/security/${PN}/cli.py
	if use bash-completion ; then
		insinto /usr/share/bash-completion/completions
		doins autocomplete/howdy
	fi

	insinto /$(get_libdir)/security/${PN}/dlib-data
	doins "${WORKDIR}/dlib_face_recognition_resnet_model_v1.dat"
	doins "${WORKDIR}/mmod_human_face_detector.dat"
	doins "${WORKDIR}/shape_predictor_5_face_landmarks.dat"

	rm -rf "${ED}/$(get_libdir)/security/howdy/pam-config"

	docinto licenses
	dodoc LICENSE

	insinto /etc/howdy
	doins src/config.ini
	rm -rf "${ED}/$(get_libdir)/security/howdy/config.ini" || die
	dosym \
		"/etc/howdy/config.ini" \
		"/$(get_libdir)/security/${PN}/config.ini"
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
		local actual_file_permissions=$(stat -c "%a" "${path}")
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
einfo "  auth            sufficient      pam_python.so /$(get_libdir)/security/howdy/pam.py"
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

einfo
einfo "Apps that want to add howdy n-factor authentication need to have the pam"
einfo "USE flag enabled with the pam config changes."
einfo
einfo "For pam settings, see the ebuild."
einfo

ewarn
ewarn "You may consider using the =${CATEGORY}/${PN}-3* instead to reduce"
ewarn "the attack surface introduced by sys-auth/pam-python."
ewarn

ewarn
ewarn "SECURITY NOTICE"
ewarn
ewarn "The /etc/howdy/config.ini should edited as follows for security"
ewarn "hardening especially for previous installations of the 2.6"
ewarn "series:"
ewarn
ewarn "[snapshot]"
ewarn "capture_failed = false"
ewarn "capture_successful = false"
ewarn
ewarn "[video]"
ewarn "# This value needs to be re-tuned to the lowest possible for your face"
ewarn "# to reduce false positives while still able to detect your face."
ewarn "certainty = 4.0"
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
# OILEDMACHINE-OVERLAY-TEST:  ok works
# howdy reads config.ini:  pass
# sudo howdy test:  pass (It is always red in this version based on the source code.)
# sudo howdy add:  pass
# sudo -k nano test:  pass
# pkexec nano test:  fail
# gdm:  TBA (on hold.  bugged without howdy)
# sddm:  fails with default theme
# greetd:  TBA
# slim:  pass
# lxdm:  fails with default theme
# /bin/login:  pass (with terminal under X)

# Contents of /etc/pam.d/sudo used for testing:
# auth    sufficient              pam_python.so /lib64/security/howdy/pam.py
# auth    substack                system-auth
# account substack                system-auth
# session substack                system-auth

# Contents of /etc/pam.d/polkit-1 used for testing:
# #%PAM-1.0
# auth	     sufficient pam_python.so /lib64/security/howdy/pam.py
# auth	     include	system-auth
# account    include	system-auth
# password   include	system-auth
# session    include	system-auth

# Contents of /etc/pam.d/slim used for testing:
# auth    sufficient              pam_python.so /lib64/security/howdy/pam.py
# auth    substack                system-local-login
# account substack                system-local-login
# session substack                system-local-login

# Contents of /etc/pam.d/lxdm used for testing:
# #%PAM-1.0
# auth       sufficient   pam_python.so /lib64/security/howdy/pam.py
# auth	     substack     system-auth
# auth	     optional     pam_gnome_keyring.so
# Fails also at this location if howdy's pam.py placed here.
# account    include      system-auth
# -session   optional     pam_systemd.so class=greeter
# -session   optional     pam_elogind.so class=greeter
# session    optional     pam_keyinit.so force revoke
# session    include      system-auth
# #session   optional     pam_console.so
# session    optional     pam_gnome_keyring.so auto_start
# session    optional     pam_selinux.so

# Contents of /etc/pam.d/login used for testing:
# auth            sufficient      pam_python.so /lib64/security/howdy/pam.py
# auth            include         system-local-login
# account         include         system-local-login
# password        include         system-local-login
# session         optional        pam_lastlog.so
# session         include         system-local-login
