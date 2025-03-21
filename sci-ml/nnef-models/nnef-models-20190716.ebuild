# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CAFFE_MODELS=(
bvlc_alexnet_caffemodel_nnef
bvlc_alexnet_onnx_nnef
bvlc_googlenet_caffemodel_nnef
bvlc_googlenet_onnx_nnef
)

CAFFE2_MODELS=(
inception_v1_caffe2_nnef
inception_v2_caffe2_nnef
mobilenet_v1_1_0_caffemodel_nnef
mobilenet_v2_1_0_caffemodel_nnef
resnet_v1_152_caffemodel_nnef
squeezenet_v1_0_caffemodel_nnef
squeezenet_v1_1_caffemodel_nnef
vgg16_caffemodel_nnef
vgg19_caffemodel_nnef
)

ONNX_MODELS=(
inception_v1_onnx_nnef
inception_v2_onnx_nnef
mobilenet_v2_1_0_onnx_nnef
resnet_v1_101_onnx_nnef
resnet_v1_18_onnx_nnef
resnet_v1_34_onnx_nnef
resnet_v1_50_onnx_nnef
resnet_v2_101_onnx_nnef
resnet_v2_18_onnx_nnef
resnet_v2_34_onnx_nnef
resnet_v2_50_onnx_nnef
shufflenet_onnx_nnef
squeezenet_v1_0_onnx_nnef
squeezenet_v1_1_onnx_nnef
vgg16_onnx_nnef
vgg19_onnx_nnef
)

TENSORFLOW_MODELS=(
inception_resnet_v2_tfpb_nnef
inception_v1_quant_tflite_nnef
inception_v2_quant_tflite_nnef
inception_v3_tfpb_nnef
inception_v3_quant_tflite_nnef
inception_v4_tfpb_nnef
inception_v4_quant_tflite_nnef
mobilenet_v1_1_0_tfpb_nnef
mobilenet_v1_1_0_quant_tflite_nnef
mobilenet_v2_1_0_tfpb_nnef
mobilenet_v2_1_0_quant_tflite_nnef
nasnet_mobile_tfpb_nnef
squeezenet_tfpb_nnef
)

USE_FILENAMES=(
"bvlc_alexnet_caffemodel_nnef:bvlc_alexnet.caffemodel.nnef.tgz"
"bvlc_alexnet_onnx_nnef:bvlc_alexnet.onnx.nnef.tgz"
"bvlc_googlenet_caffemodel_nnef:bvlc_googlenet.caffemodel.nnef.tgz"
"bvlc_googlenet_onnx_nnef:bvlc_googlenet.onnx.nnef.tgz"
"inception_resnet_v2_tfpb_nnef:inception_resnet_v2.tfpb.nnef.tgz"
"inception_v1_caffe2_nnef:inception_v1.caffe2.nnef.tgz"
"inception_v1_onnx_nnef:inception_v1.onnx.nnef.tgz"
"inception_v1_quant_tflite_nnef:inception_v1_quant.tflite.nnef.tgz"
"inception_v2_caffe2_nnef:inception_v2.caffe2.nnef.tgz"
"inception_v2_onnx_nnef:inception_v2.onnx.nnef.tgz"
"inception_v2_quant_tflite_nnef:inception_v2_quant.tflite.nnef.tgz"
"inception_v3_tfpb_nnef:inception_v3.tfpb.nnef.tgz"
"inception_v3_quant_tflite_nnef:inception_v3_quant.tflite.nnef.tgz"
"inception_v4_tfpb_nnef:inception_v4.tfpb.nnef.tgz"
"inception_v4_quant_tflite_nnef:inception_v4_quant.tflite.nnef.tgz"
"mobilenet_v1_1_0_caffemodel_nnef:mobilenet_v1_1.0.caffemodel.nnef.tgz"
"mobilenet_v1_1_0_tfpb_nnef:mobilenet_v1_1.0.tfpb.nnef.tgz"
"mobilenet_v1_1_0_quant_tflite_nnef:mobilenet_v1_1.0_quant.tflite.nnef.tgz"
"mobilenet_v2_1_0_caffemodel_nnef:mobilenet_v2_1.0.caffemodel.nnef.tgz"
"mobilenet_v2_1_0_onnx_nnef:mobilenet_v2_1.0.onnx.nnef.tgz"
"mobilenet_v2_1_0_tfpb_nnef:mobilenet_v2_1.0.tfpb.nnef.tgz"
"mobilenet_v2_1_0_quant_tflite_nnef:mobilenet_v2_1.0_quant.tflite.nnef.tgz"
"nasnet_mobile_tfpb_nnef:nasnet_mobile.tfpb.nnef.tgz"
"resnet_v1_101_onnx_nnef:resnet_v1_101.onnx.nnef.tgz"
"resnet_v1_152_caffemodel_nnef:resnet_v1_152.caffemodel.nnef.tgz"
"resnet_v1_18_onnx_nnef:resnet_v1_18.onnx.nnef.tgz"
"resnet_v1_34_onnx_nnef:resnet_v1_34.onnx.nnef.tgz"
"resnet_v1_50_onnx_nnef:resnet_v1_50.onnx.nnef.tgz"
"resnet_v2_101_onnx_nnef:resnet_v2_101.onnx.nnef.tgz"
"resnet_v2_18_onnx_nnef:resnet_v2_18.onnx.nnef.tgz"
"resnet_v2_34_onnx_nnef:resnet_v2_34.onnx.nnef.tgz"
"resnet_v2_50_onnx_nnef:resnet_v2_50.onnx.nnef.tgz"
"shufflenet_onnx_nnef:shufflenet.onnx.nnef.tgz"
"squeezenet_tfpb_nnef:squeezenet.tfpb.nnef.tgz"
"squeezenet_v1_0_caffemodel_nnef:squeezenet_v1.0.caffemodel.nnef.tgz"
"squeezenet_v1_0_onnx_nnef:squeezenet_v1.0.onnx.nnef.tgz"
"squeezenet_v1_1_caffemodel_nnef:squeezenet_v1.1.caffemodel.nnef.tgz"
"squeezenet_v1_1_onnx_nnef:squeezenet_v1.1.onnx.nnef.tgz"
"vgg16_caffemodel_nnef:vgg16.caffemodel.nnef.tgz"
"vgg16_onnx_nnef:vgg16.onnx.nnef.tgz"
"vgg19_caffemodel_nnef:vgg19.caffemodel.nnef.tgz"
"vgg19_onnx_nnef:vgg19.onnx.nnef.tgz"
)

link_geneator_example() {
	uris=( \
		$(grep -o -E -r -e "\[NNEF\](.*)" "/var/tmp/portage/sci-misc/nnef-models-1.0.7/work/NNEF-Tools-nnef-v1.0.7/models" \
		| cut -f 2- -d ":" \
		| sed -e "s|\[NNEF\](||g" -e "s|)||g" \
		| sort \
		| uniq) \
	) ; \
	for x in ${uris[@]} ; \
	do \
		y=$(echo "${x}" | cut -f 5 -d "/" | sed -e "s|.tgz||g" -e "s|\.|_|g") ; \
		echo "[\"${y}\"]=\"${x}\"" ; \
	done
}

declare -A MODELS_URI=(
["bvlc_alexnet_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/bvlc_alexnet.caffemodel.nnef.tgz"
["bvlc_alexnet_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/bvlc_alexnet.onnx.nnef.tgz"
["bvlc_googlenet_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/bvlc_googlenet.caffemodel.nnef.tgz"
["bvlc_googlenet_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/bvlc_googlenet.onnx.nnef.tgz"
["inception_resnet_v2_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_resnet_v2.tfpb.nnef.tgz"
["inception_v1_caffe2_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v1.caffe2.nnef.tgz"
["inception_v1_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v1.onnx.nnef.tgz"
["inception_v1_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v1_quant.tflite.nnef.tgz"
["inception_v2_caffe2_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v2.caffe2.nnef.tgz"
["inception_v2_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v2.onnx.nnef.tgz"
["inception_v2_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v2_quant.tflite.nnef.tgz"
["inception_v3_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v3.tfpb.nnef.tgz"
["inception_v3_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v3_quant.tflite.nnef.tgz"
["inception_v4_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v4.tfpb.nnef.tgz"
["inception_v4_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/inception_v4_quant.tflite.nnef.tgz"
["mobilenet_v1_1_0_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v1_1.0.caffemodel.nnef.tgz"
["mobilenet_v1_1_0_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v1_1.0.tfpb.nnef.tgz"
["mobilenet_v1_1_0_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v1_1.0_quant.tflite.nnef.tgz"
["mobilenet_v2_1_0_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v2_1.0.caffemodel.nnef.tgz"
["mobilenet_v2_1_0_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v2_1.0.onnx.nnef.tgz"
["mobilenet_v2_1_0_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v2_1.0.tfpb.nnef.tgz"
["mobilenet_v2_1_0_quant_tflite_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/mobilenet_v2_1.0_quant.tflite.nnef.tgz"
["nasnet_mobile_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/nasnet_mobile.tfpb.nnef.tgz"
["resnet_v1_101_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v1_101.onnx.nnef.tgz"
["resnet_v1_152_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v1_152.caffemodel.nnef.tgz"
["resnet_v1_18_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v1_18.onnx.nnef.tgz"
["resnet_v1_34_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v1_34.onnx.nnef.tgz"
["resnet_v1_50_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v1_50.onnx.nnef.tgz"
["resnet_v2_101_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v2_101.onnx.nnef.tgz"
["resnet_v2_18_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v2_18.onnx.nnef.tgz"
["resnet_v2_34_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v2_34.onnx.nnef.tgz"
["resnet_v2_50_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/resnet_v2_50.onnx.nnef.tgz"
["shufflenet_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/shufflenet.onnx.nnef.tgz"
["squeezenet_tfpb_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/squeezenet.tfpb.nnef.tgz"
["squeezenet_v1_0_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/squeezenet_v1.0.caffemodel.nnef.tgz"
["squeezenet_v1_0_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/squeezenet_v1.0.onnx.nnef.tgz"
["squeezenet_v1_1_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/squeezenet_v1.1.caffemodel.nnef.tgz"
["squeezenet_v1_1_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/squeezenet_v1.1.onnx.nnef.tgz"
["vgg16_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/vgg16.caffemodel.nnef.tgz"
["vgg16_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/vgg16.onnx.nnef.tgz"
["vgg19_caffemodel_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/vgg19.caffemodel.nnef.tgz"
["vgg19_onnx_nnef"]="https://sfo2.digitaloceanspaces.com/nnef-public/vgg19.onnx.nnef.tgz"
)

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/KhronosGroup/NNEF-Tools.git"
	FALLBACK_COMMIT="c1aac758ad155d8c132e9b5166d9490b73f70811"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}"
	SRC_URI="
${MODELS_URI[@]}
	"
#https://github.com/KhronosGroup/NNEF-Tools/archive/refs/tags/nnef-v${PV}.tar.gz
fi

gen_license_models_caffe() {
	local x
	for x in ${CAFFE_MODELS[@]} ; do
		echo "
			${x}? (
				unrestricted-use
			)
		"
	done
}


gen_license_models_caffe2() {
	local x
	for x in ${CAFFE2_MODELS[@]} ; do
		echo "
			${x}? (
				Apache-2.0
			)
		"
	done
}

gen_license_models_onnx() {
	local x
	for x in ${ONNX_MODELS[@]} ; do
		echo "
			${x}? (
				Apache-2.0
			)
		"
	done
}

gen_license_models_tensorflow() {
	local x
	for x in ${TENSORFLOW_MODELS[@]} ; do
		echo "
			${x}? (
				Apache-2.0
			)
		"
	done
}


DESCRIPTION="A collection of neural network NNEF models for image recognition and classification"
HOMEPAGE="
https://github.com/KhronosGroup/NNEF-Tools/tree/main/models
"
LICENSE="
	Apache-2.0
	$(gen_license_models_caffe)
	$(gen_license_models_caffe2)
	$(gen_license_models_onnx)
	$(gen_license_models_tensorflow)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ${!MODELS_URI[@]}"
REQUIRED_USE="
	|| (
		${!MODELS_URI[@]}
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
)

unpack_by_use() {
	local x
	for x in ${USE_FILENAMES[@]} ; do
		local u="${x%:*}"
		local f="${x#*:}"
		if use "${u}" ; then
			mkdir -p "${u}" || die
			pushd "${u}" >/dev/null 2>&1 || die
				unpack "${DISTDIR}/${f}"
			popd >/dev/null 2>&1 || die
		fi
	done
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		:
	fi
	unpack_by_use
}

src_install() {
	insinto "/usr/share/${PN}"
	local x
	for x in ${USE_FILENAMES[@]} ; do
		local u="${x%:*}"
		local f="${x#*:}"
		if use "${u}" ; then
			doins -r "${u}"
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
