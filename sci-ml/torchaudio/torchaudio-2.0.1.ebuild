# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FLASHLIGHT_TEXT_COMMIT="98028c7da83d66c2aba6f5f8708c063d266ca5a4"
KALDI_COMMIT="3eea37dd09b55064e6362216f7e9a60641f29f09"
KENLM_COMMIT="5cea457db26950a73d638425c183b368c06ed7c6"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="audio"
PYTHON_COMPAT=( "python3_11" )

inherit dep-prepare distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/flashlight/text/archive/${FLASHLIGHT_TEXT_COMMIT}.tar.gz
	-> flashlight-text-${FLASHLIGHT_TEXT_COMMIT:0:7}.tar.gz
https://github.com/kaldi-asr/kaldi/archive/${KALDI_COMMIT}.tar.gz
	-> kaldi-${KALDI_COMMIT:0:7}.tar.gz
https://github.com/kpu/kenlm/archive/${KENLM_COMMIT}.tar.gz
	-> kenlm-${KENLM_COMMIT:0:7}.tar.gz
https://github.com/pytorch/audio/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
HOMEPAGE="
	https://github.com/pytorch/audio
	https://pypi.org/project/torchaudio
"
LICENSE="
	BSD-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_3
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/kaldi-io[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
	>=app-arch/bzip2-1.0.8
	>=app-arch/xz-utils-5.2.5
	>=sys-libs/zlib-1.2.12
	>=media-sound/sox-14.4.2[amr,encode,flac,ogg,opus]
	|| (
		media-video/ffmpeg:58.60.60
		media-video/ffmpeg:57.59.59
		media-video/ffmpeg:56.58.58
		media-video/ffmpeg:0/58.60.60
		media-video/ffmpeg:0/57.59.59
		media-video/ffmpeg:0/56.58.58
	)
	media-video/ffmpeg:=
	~sci-ml/pytorch-${PV}[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-system-libs.patch"
	"${FILESDIR}/${PN}-2.0.1-disable-init-submodule.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	dep_prepare_cp "${WORKDIR}/text-${FLASHLIGHT_TEXT_COMMIT}" "${S}/third_party/flashlight-text/submodule"
	dep_prepare_cp "${WORKDIR}/kaldi-${KALDI_COMMIT}" "${S}/third_party/kaldi/submodule"
	dep_prepare_cp "${WORKDIR}/kenlm-${KENLM_COMMIT}" "${S}/third_party/kenlm/kenlm"
}

python_configure() {
	export USE_SYSTEM_BZIP2=1
	export USE_SYSTEM_LZMA=1
	export USE_SYSTEM_SOX=1
	export USE_SYSTEM_ZLIB=1
	if has_version "media-video/ffmpeg:58.60.60" ; then # 6.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/58.60.60"
	elif has_version "media-video/ffmpeg:57.59.59" ; then # 5.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/57.59.59"
	elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/56.58.58"
	elif has_version "media-video/ffmpeg:0/58.58.58" ; then # 6.x unislot
		export FFMPEG_ROOT="/usr"
	elif has_version "media-video/ffmpeg:0/57.59.59" ; then # 5.x unislot
		export FFMPEG_ROOT="/usr"
	elif has_version "media-video/ffmpeg:0/56.58.58" ; then # 4.x unislot
		export FFMPEG_ROOT="/usr"
	fi
}

src_install() {
	distutils-r1_src_install
	local x
	for x in $(find "/usr/lib/${EPYTHON}/site-packages/torchaudio/" "${ED}/usr/lib/${EPYTHON}/site-packages/torio" -name "*ffmpeg*.so*") ; do
		local path=$(ldd "${x}" | grep -q "libav" && echo "${x}")
		if [[ -z "${path}" ]] ; then
				:
		elif has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
einfo "Fixing rpath for ${x}"
			patchelf --add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" "${x}" || die
		elif has_version "media-video/ffmpeg:57.59.59" ; then # 4.x
einfo "Fixing rpath for ${x}"
			patchelf --add-rpath "/usr/lib/ffmpeg/57.59.59/$(get_libdir)" "${x}" || die
		elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.x
einfo "Fixing rpath for ${x}"
			patchelf --add-rpath "/usr/lib/ffmpeg/56.58.58/$(get_libdir)" "${x}" || die
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
