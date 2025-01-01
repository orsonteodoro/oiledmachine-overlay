# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dep-prepare.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: copy/move vendored folders
# @DESCRIPTION:
# Functions to copy/move unpacked vendored folders to within the project third_party folder

# @FUNCTION: dep_prepare_mv
# @DESCRIPTION:
# Move downloaded folder to dest folder
#
# Example:
#
# dep_prepare_mv "${WORKDIR}/optimizer-${ONNXOPTIMIZER_COMMIT}" "${S}/third_party/onnx-optimizer"
#
dep_prepare_mv() {
	local from="${1}"
	local to="${2}"
einfo "Moving dep ${from} -> ${to}"
	rm -rf "${to}" || die
	mkdir -p "${to}"
	cp -aT \
		"${from}" \
		"${to}" \
		|| die
	rm -rf "${from}" || die
}

# @FUNCTION: dep_prepare_cp
# @DESCRIPTION:
# Copy downloaded folder to dest folder
#
# Example:
#
# dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/third_party/onnx-optimizer/third_party/protobuf/third_party/benchmark"
#
dep_prepare_cp() {
	local from="${1}"
	local to="${2}"
einfo "Copying dep ${from} -> ${to}"
	rm -rf "${t}" || die
	mkdir -p "${to}"
	cp -aT \
		"${from}" \
		"${to}" \
		|| die
}
