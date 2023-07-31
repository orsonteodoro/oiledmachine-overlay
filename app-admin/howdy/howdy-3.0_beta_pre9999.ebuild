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
cuda ffmpeg gtk pyv4l2
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
	media-libs/opencv[${PYTHON_USEDEP},contribhdf,python,v4l]
	sys-libs/pam
	cuda_targets_sm_50? (
		>=sci-libs/dlib-19.21[${PYTHON_USEDEP},cuda?,python]
	)
	ffmpeg? (
		dev-python/ffmpeg-python[${PYTHON_USEDEP}]
		media-video/ffmpeg[v4l]
	)
	gtk? (
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
PATCHES=(
)
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
RESTRICT="mirror"

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
		use fallback-commit && EGIT_COMMIT="30728a6d3634479c24ffd4e094c34a30bbb43058" # Mar 8, 2022
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
				config.ini || die
		fi
		if use ffmpeg ; then
			sed -i -e "s|recording_plugin = opencv|recording_plugin = ffmpeg|g" \
				config.ini || die
		fi
		if use pyv4l2 ; then
			sed -i -e "s|recording_plugin = opencv|recording_plugin = pyv4l2|g" \
				config.ini || die
		fi
		sed -i -e "s|/lib/security/howdy/config.ini|/$(get_libdir)/security/howdy/config.ini|g" \
			"pam/main.cc" || die
	popd
	pushd "${S}/howdy/src/pam" || die
		export EMESON_SOURCE="${S}/howdy/src/pam"
		local emesonargs=(
			-Dinih:with_INIReader=true
		)
		meson_src_configure
	popd
}

src_compile() {
	meson_src_compile
}

install_howdy() {
	insinto /$(get_libdir)/security/${PN}
	doins -r src/*
	insinto /$(get_libdir)/security/${PN}/dlib-data
	doins "${WORKDIR}/dlib_face_recognition_resnet_model_v1.dat"
	doins "${WORKDIR}/mmod_human_face_detector.dat"
	doins "${WORKDIR}/shape_predictor_5_face_landmarks.dat"
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
	popd
	exeinto /usr/bin
	dosym ../../$(get_libdir)/security/${PN}/cli.py /usr/bin/${PN}
	fperms 0755 /$(get_libdir)/security/${PN}/cli.py
	insinto /usr/share/bash-completion/completions
	doins src/autocomplete/howdy
	exeinto /$(get_libdir)/security
	doexe "${BUILD_DIR}/pam_howdy.so"
	dodir /usr/share/howdy
	rm -rf "${ED}/$(get_libdir)/security/howdy/pam-config"
}

install_howdy_gtk() {
	insinto /$(get_libdir)/${PN}-gtk
	doins -r src/*
}

src_install() {
	docinto licenses
	dodoc LICENSE
	pushd ${PN} || die
		install_howdy
	popd || die
	if use gtk ; then
		pushd ${PN}-gtk || die
			install_howdy_gtk
		popd || die
	fi
}

pkg_postinst() {
einfo
einfo "You need an IR camera for this to work properly."
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
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
