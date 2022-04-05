# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit meson python-r1

DESCRIPTION="Facial authentication for Linux"
HOMEPAGE="https://github.com/boltgolt/howdy"
LICENSE="MIT CC0-1.0"
# CC0-1.0 - dlib-models
#KEYWORDS="~amd64" # Still needs testing
SLOT="0"
IUSE+=" cuda gtk"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+="
	${PYTHON_DEPS}
	>=dev-libs/inih-52
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pypam[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},cuda?,contribhdf,python]
	sys-libs/pam
	>=sci-libs/dlib-19.16[${PYTHON_USEDEP}]
	cuda? ( >=dev-util/nvidia-cuda-toolkit-7.5 )
	gtk? (
		dev-python/elevate
		x11-libs/gtk+:3[introspection]
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=sys-devel/gcc-5
	dev-libs/boost[${PYTHON_USEDEP},python]
	dev-util/meson
"
PATCHES=(
	"${FILESDIR}/howdy-3.0_beta_pre20220131-pam_howdy-meson-build-fixes.patch"
)
EGIT_COMMIT="96767fe58ee381ba20cbddc88646335eb719ec8c"
EGIT_COMMIT_DLIB_MODELS="daf943f7819a3dda8aec4276754ef918dc26491f"
DLIB_MODELS_DATE="20210412"
SRC_URI="
https://github.com/boltgolt/howdy/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
https://github.com/davisking/dlib-models/raw/master/dlib_face_recognition_resnet_model_v1.dat.bz2
	-> dlib_face_recognition_resnet_model_v1-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
https://github.com/davisking/dlib-models/raw/master/mmod_human_face_detector.dat.bz2
	-> mmod_human_face_detector-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
https://github.com/davisking/dlib-models/raw/master/shape_predictor_5_face_landmarks.dat.bz2
	-> shape_predictor_5_face_landmarks-${EGIT_COMMIT_DLIB_MODELS:0:7}.dat.bz2
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

pkg_setup()
{
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
		howdy/src/pam/main.cc
		howdy/src/pam/README.md
		howdy/src/pam/meson.build
		howdy/src/pam-config/howdy
		README.md
		howdy-gtk/src/tab_video.py
		howdy-gtk/src/window.py
	)

	for f in ${F[@]} ; do
		einfo "Editing ${f}"
		sed -i -e "s|/lib/security|/$(get_libdir)/security|g" "${f}" || die
	done
}

src_configure() {
	pushd "${WORKDIR}/${PN}-${EGIT_COMMIT}/howdy/src" || die
		if [[ -e "/dev/video0" ]] ; then
			sed -i -e "s|device_path = none|device_path = /dev/video0|g" config.ini || die
		fi
		if use cuda ; then
			sed -i -e "s|use_cnn = false|use_cnn = true|g" config.ini || die
		fi
		sed -i -e "s|/lib/security/howdy/config.ini|/$(get_libdir)/security/howdy/config.ini|g" \
			"pam/main.cc" || die
	popd
	pushd "${WORKDIR}/${PN}-${EGIT_COMMIT}/howdy/src/pam" || die
		export EMESON_SOURCE="${WORKDIR}/${PN}-${EGIT_COMMIT}/howdy/src/pam"
		local emesonargs=(
			-Dinih:with_INIReader=true
		)
		meson_src_configure
	popd
}

src_compile() {
	meson_src_compile
}

src_install() {
	docinto licenses
	dodoc LICENSE
	pushd ${PN} || die
		insinto /$(get_libdir)/security/${PN}
		doins -r src/*
		insinto /$(get_libdir)/security/${PN}/dlib-data
		doins "${WORKDIR}/dlib_face_recognition_resnet_model_v1.dat"
		doins "${WORKDIR}/mmod_human_face_detector.dat"
		doins "${WORKDIR}/shape_predictor_5_face_landmarks.dat"
		fperms -R 0600 "/$(get_libdir)/security/${PN}"
		exeinto /usr/bin
		dosym ../../$(get_libdir)/security/${PN}/cli.py /usr/bin/${PN}
		fperms 0775 /$(get_libdir)/security/${PN}/cli.py
		insinto /usr/share/bash-completion/completions
		doins src/autocomplete/howdy
		exeinto /$(get_libdir)/security
		doexe "${BUILD_DIR}/libpam_howdy.so"
		dodir /usr/share/howdy
		mv "${ED}/$(get_libdir)/security/howdy/pam-config" "${ED}/usr/share/howdy/" || die
	popd || die
	if use gtk ; then
		pushd ${PN}-gtk || die
			insinto /$(get_libdir)/${PN}-gtk
			doins -r src/*
		popd || die
	fi
}

pkg_postinst() {
	if [[ ! -e "/dev/video0" ]] ; then
	einfo
	einfo "The following need to be edited in /lib/security/howdy/config.ini:"
	einfo
	einfo "  device_path = none"
	einfo
	einfo "to path of the camera (e.g. /dev/video0). "
	einfo
	fi
	einfo "The pam configuration can be found in /usr/share/howdy/pam-config."
}
