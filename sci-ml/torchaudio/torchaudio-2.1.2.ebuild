# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="audio"
PYTHON_COMPAT=( "python3_11" )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
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
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/kaldi-io[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
	>=media-sound/sox-14.4.2
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
	"${FILESDIR}/${PN}-2.5.1-system-libs.patch"
)

python_configure() {
	export USE_SYSTEM_SOX=1
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
