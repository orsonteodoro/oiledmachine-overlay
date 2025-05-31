# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22 - GCC 12.2

# TODO list:
_TODO='

# From angle:
[submodule "third_party/gles1_conform"] # private
	path = third_party/gles1_conform
	url = https://chrome-internal.googlesource.com/angle/es-cts
	gclient-condition = checkout_angle_internal

# From dawn (1eca38f)
[submodule "third_party/angle"] # could be circular
	path = third_party/angle
	url = https://chromium.googlesource.com/angle/angle
	gclient-condition = dawn_standalone
'

# TODO:
# Review and add vendored python packages.
# dawn .gitmodules

# 1.20.0 -> 1.20.2

# TODO package (optional):
# lintrunner-adapters
# onnxmltools
# pydocstyle
# tensorrt
# torch-ort

# For deps versioning, see
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/cmake/deps.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/tools/ci_build/github/linux/docker/scripts/manylinux/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/onnxruntime/python/tools/transformers/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/cmake/external/dnnl.cmake#L5
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/requirements-dev.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/requirements-doc.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/requirements-lintrunner.txt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/requirements-training.txt
# https://github.com/apache/tvm/blob/2379917985919ed3918dc12cad47f469f245be7a/python/gen_requirements.py#L65 ; commit from https://github.com/microsoft/onnxruntime/blob/v1.20.2/cmake/external/tvm.cmake
# https://github.com/google/dawn/blob/511eb80847afe6bded34ec491a38d5d78ba2d604/DEPS
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/Dockerfile.cuda
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/Dockerfile.openvino
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/Dockerfile.rocm
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/Dockerfile.tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/onnxruntime/python/tools/transformers/models/llama/requirements-cuda.txt#L2
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/README.md#cuda
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/README.md#openvino
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/README.md#tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.20.2/dockerfiles/README.md#rocm

# clog has same version as cpuinfo



# https://github.com/abseil/abseil-cpp/releases/download/20240722.0/abseil-cpp-20240722.0.tar.gz
ABSEIL_CPP_PV_1="20230125.3" # From cmake/external/onnx/CMakeLists.txt
ABSEIL_CPP_PV_2="20240722.0" # From cmake/deps.txt
ABSEIL_CPP_COMMIT_2="78be63686ba732b25052be15f8d6dee891c05749" # protobuf (PROTOBUF_PV_2) dep
ABSEIL_CPP_COMMIT_3="f81f6c011baf9b0132a5594c034fe0060820711d" # dawn (DAWN_COMMIT_1) dep
ABSEIL_CPP_COMMIT_4="1b7ed5a1932647009b72fdad8e0e834d55cf40d8" # dawn/angle dep
AMDGPU_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.20.2/cmake/CMakeLists.txt#L299
	gfx906
	gfx908
	gfx90a # ck
	#gfx942 # ck
	gfx1030
	gfx1100
	gfx1101
)
ANDROID_BUILD_TOOLS_COMMIT="994f942b63f57ebdbb928d99c2e8cfee7345582b" # dawn/angle dep
ANDROID_COMMIT="4f3ee3fd09733fd1514f18140419bf8d5924f55e" # dawn/angle dep
ANDROID_DEPS_COMMIT="4c82e77bef70cc86a43dc6fa40fdcd19823a5507" # dawn/angle dep
ANDROID_PLATFORM_COMMIT="6337c445f9963ec3914e7e0c5787941d07b46509" # dawn/angle dep
ANDROID_SDK_COMMIT="783f19f6e1217c42a31cd1d41de9a19f2664994c" # dawn/angle dep
ANGLE_COMMIT_1="f25948774f7c24ef4d28c42cb0fee0e69aac0489" # dawn (DAWN_COMMIT_1) dep
ANGLE_COMMIT_2="f8fc8ac36280440cd34dae318e0d492e3af42bab" # dawn/angle/dawn dep
ASTC_ENCODER_COMMIT="573c475389bf51d16a5c3fc8348092e094e50e8f" # dawn/angle dep
BENCHMARK_PV="1.8.5" # onnxruntime dep
BENCHMARK_COMMIT_1="2dd015dfef425c866d9a43f2c67d8b52d709acb6" # onnx (ONNX_PV_1) and onnx-tensorrt dep
BENCHMARK_COMMIT_2="0d98dba29d66e93259db7daa53a9327df767a415" # flatbuffers dep, from cmake/external/flatbuffers/benchmarks/CMakeLists.txt
BENCHMARK_COMMIT_3="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # protobuf dep
BENCHMARK_COMMIT_4="bf585a2789e30585b4e3ce6baf11ef2750b54677" # dawn/protobuf dep
BENCHMARK_COMMIT_5="efc89f0b524780b1994d5dddd83a92718e5be492" # dawn (DAWN_COMMIT_1) dep
BENCHMARK_COMMIT_6="dfc8a92abc88a9d630a9f8e01c678fedde4c3090" # swiftshader dep
BUILD_COMMIT_1="a6c1c751fd8c18d9e051b12600aec2753c1712c3" # dawn (DAWN_COMMIT_1) dep
BUILD_COMMIT_2="162c225df12d17ca67ce48c578af2d0946820119" # dawn/angle dep
BUILD_COMMIT_3="5328cf8d5599a47ce0157bd390e7de050b3efe69" # dawn/angle/dawn dep
BUILDTOOLS_COMMIT_1="9cac81256beb5d4d36c8801afeae38fea34b8486" # dawn (DAWN_COMMIT_1) dep
BUILDTOOLS_COMMIT_2="f8f6777fcf684dd891658ff32b195589e88fe2d8" # dawn/angle dep
CATAPULT_COMMIT_1="b9db9201194440dc91d7f73d4c939a8488994f60" # dawn (DAWN_COMMIT_1) dep
CATAPULT_COMMIT_2="c903c60cb7c1125882e5650d1d299c41707f1b5a" # dawn/angle dep
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CHERRY_COMMIT="4f8fb08d33ca5ff05a1c638f04c85bbb8d8b52cc" # dawn/angle dep
CLANG_COMMIT_1="06a29b5bbf392c68d73dc8df9015163cc5a98c40" # dawn (DAWN_COMMIT_1) dep
CLANG_COMMIT_2="fb801f8a4b25776becf0119b8b578d9b5a096285" # dawn/angle dep
CLANG_COMMIT_3="303336503ee5018769a2681538289058dbd28947" # dawn/angle/dawn dep
CLANG_FORMAT_COMMIT_1="95c834f3753e65ce6daa74e345c879566c1491d0" # dawn (DAWN_COMMIT_1) dep
CLANG_FORMAT_COMMIT_2="3c0acd2d4e73dd911309d9e970ba09d58bf23a62" # dawn/angle dep
CLSPV_COMMIT="a173c052455434a422bcfe5c12ffe44d574fd6e1" # dawn/angle dep
CMAKE_IN_SOURCE_BUILD=1
COLORAMA_COMMIT="3de9f013df4b470069d03d250224062e8cf15c49" # dawn/angle dep
COMPOSABLE_KERNEL_COMMIT="204da9c522cebec5220bba52cd3542ebcaf99e7a" # From cmake/deps.txt, >= rocm-6.2.0
COREMLTOOLS_PV="7.1"
CPPDAP_COMMIT="1fd23dda91e01550be1a421de307e6fedb2035a9" # swiftshader dep
CPU_FLAGS="
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avx512
"
CPUINFO_COMMIT="ca678952a9a8eaa6de112d154e8e104b22f9ab3f" # From cmake/deps.txt
CPU_FEATURES_COMMIT="936b9ab5515dead115606559502e3864958f7f6e" # angle dp
CUDNN_FRONTEND_PV="1.7.0"
CUTLASS_PV="3.5.1" # From cmake/deps.txt
CUTLASS_COMMIT="c2ee13a0fe99241b0e798ce647acf98e237f1d0c" # tvm dep
CXXOPTS_COMMIT="3c73d91c0b04e2b59462f0a741be8c07024c1bc0"
DATE_PV_1="3.0.1" # From cmake/deps.txt
DATE_PV_2="3.0.0" # From cmake/external/date/CMakeLists.txt
DAWN_COMMIT_1="511eb80847afe6bded34ec491a38d5d78ba2d604"
DAWN_COMMIT_2="1eca38fa52364bf66c0d288a0537a2813d72b39b" # dawn/angle dep
DEPOT_TOOLS_COMMIT_1="f5e10923392588205925c036948e111f72b80271" # dawn (DAWN_COMMIT_1) dep
DEPOT_TOOLS_COMMIT_2="1f6ef165b726ed7316b8e88666390e90a82e8e50" # depot dep
DEPOT_TOOLS_COMMIT_3="40cece20d0eaae6fd41fcbc008480e71f2e3aed9" # dawn/angle/dawn dep
DIRECTX_HEADERS_PV="1.613.1"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
DLPACK_COMMIT_1="ddeb264880a1fa7e7be238ab3901a810324fbe5f" # tvm dep
DLPACK_COMMIT_2="277508879878e0a5b5b43599b1bea11f66eb3c6c"
DMLC_CORE_COMMIT="09511cf9fe5ff103900a5eafb50870dc84cc17c8" # tvm dep
DXC_COMMIT_1="0e7591a6ee94c8c8eb0d536ce7815fd56a776451" # dawn (DAWN_COMMIT_1) dep
DXC_COMMIT_2="f810e92e72abd4e7e6301ad6d44e34ea57ff017d" # dawn/angle/dawn dep
DXHEADERS_COMMIT="980971e835876dc0cde415e8f9bc646e64667bf7" # dawn (DAWN_COMMIT_1) dep
CUDA_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.20.2/cmake/CMakeLists.txt#L1453
	sm_30
	sm_37
	sm_50
	sm_52
	sm_53
	sm_60
	sm_62
	sm_70
	sm_72
	sm_75
	sm_87
	sm_80
	sm_90
)
EGL_REGISTRY_COMMIT="7dea2ed79187cd13f76183c4b9100159b9e3e071" # dawn (DAWN_COMMIT_1) dep
EIGEN_COMMIT="e7248b26a1ed53fa030c5c459f7ea095dfd276ac" # From cmake/deps.txt
EMSDK_COMMIT="d52c46520124845b1e0e0525f2759299d840143f"
FLATBUFFERS_PV="23.5.26" # From cmake/deps.txt
FLATBUFFERS_COMMIT="fb9afbafc7dfe226b9db54d4923bfb8839635274" # dawn/angle dep
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
FP16_COMMIT="0a92994d729ff76a58f692d3028ca1b64b145d91" # From cmake/deps.txt
FXDIV_COMMIT="63058eff77e11aa15bf531df5dd34395ec3017c8" # From cmake/deps.txt
GIT_HOOKS_COMMIT="6d91964d33adee28dda9c7faf9ffd6f4672c381c" # swiftshader dep
GLFW_COMMIT="b35641f4a3c62aa86a0b3c983d163bc0fe36026d" # dawn (DAWN_COMMIT_1) dep
GLMARK2_COMMIT="ca8de51fedb70bace5351c6b002eb952c747e889" # dawn/angle dep
GLSLANG_COMMIT_1="df3398078fab37b50ab33192af01cbc5b5d5b377" # dawn (DAWN_COMMIT_1) or angle dep
GLSLANG_COMMIT_2="2b2523fb951f63f072cfba514c26f2feea5f4329" # swiftshader dep
GLSLANG_COMMIT_4="7c4d91e7819a1d27213aa3499953d54ae1a00e8f" # dawn/angle/dawn dep
GOOGLETEST_PV_1="1.15.0" # From cmake/deps.txt
GOOGLETEST_COMMIT_1="ff233bdd4cac0a0bf6e5cd45bda3406814cb2796" # flatbuffers dep, from cmake/external/flatbuffers/benchmarks/CMakeLists.txt
GOOGLETEST_COMMIT_2="4c9a3bb62bf3ba1f1010bf96f9c8ed767b363774" # protobuf dep
GOOGLETEST_COMMIT_3="e2239ee6043f73722e7aa812a459f54a28552929" # From cmake/external/flatbuffers/benchmarks/CMakeLists.txt or swiftshader
GOOGLETEST_COMMIT_4="7a7231c442484be389fdf01594310349ca0e42a8" # dawn (DAWN_COMMIT_1) dep
GOOGLETEST_COMMIT_5="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # protobuf dep
GOOGLETEST_COMMIT_6="dddb219c3eb96d7f9200f09b0a381f016e6b4562" # dawn/langsvr dep
GOOGLETEST_COMMIT_7="440527a61e1c91188195f7de212c63c77e8f0a45" # dawn/dxc dep
GOOGLETEST_COMMIT_8="0a03480824b4fc7883255dbd2fd8940c9f81e22e" # cppdap dep
GOOGLETEST_COMMIT_9="17bbed2084d3127bd7bcd27283f18d7a5861bea8" # dawn/angle dep
GOOGLETEST_COMMIT_10="ba96d0b1161f540656efdaed035b3c062b60e006" # angle/rapidjson dep
GOOGLETEST_COMMIT_11="703bd9caab50b139428cea1aaff9974ebee5742e" # angle/astc-encoder dep
GOOGLETEST_PV_2="1.10.0" # dawn/protobuf dep
GPUWEB_COMMIT_1="23db3e47ed3b3c7ab2c3638bcde7c7f76324457d" # dawn (DAWN_COMMIT_1) dep
GPUWEB_COMMIT_2="002b4939ba7ad3db1f83470e7c6a0a488fc548a6" # dawn/angle/dawn dep
GSL_PV="4.0.0" # From cmake/deps.txt
IJAR_COMMIT="3bd143299ed5b7a04fce3883ac52d7a0afdaf0a7" # dawn/angle dep
JINJA2_COMMIT_1="e2d024354e11cc6b041b0cff032d73f0c7e43a07" # dawn (DAWN_COMMIT_1) dep
JINJA2_COMMIT_2="2f6f2ff5e4c1d727377f5e1b9e1903d871f41e74" # dawn/angle dep
JSON_PV="3.10.5" # From cmake/deps.txt
JSON_COMMIT_1="f272ad533d32a40a3b2154a76f1ae9a45eacd6d3" # cppdap dep
JSON_COMMIT_2="ed5541440a36bf7dc1a544f9a84fa3e5ae97b71f" # swiftshader dep
JSONCPP_COMMIT_1="9059f5cad030ba11d37818847443a53918c327b1" # protobuf (PROTOBUF_PV_2) dep
JSONCPP_COMMIT_2="69098a18b9af0c47549d9a271c054d13ca92b006" # dawn (DAWN_COMMIT_1) dep
JSONCPP_COMMIT_3="f62d44704b4da6014aa231cfc116e7fd29617d2a" # dawn/angle dep
KLEIDIAI_PV="0.2.0"
LANGSVR_COMMIT="303c526231a90049a3e384549720f3fbd453cf66" # dawn (DAWN_COMMIT_1) dep
LIBBACKTRACE_COMMIT_1="08f7c7e69f8ea61a0c4151359bc8023be8e9217b" # tvm dep
LIBBACKTRACE_COMMIT_2="5a99ff7fed66b8ea8f09c9805c138524a7035ece" # swiftshader dep
LIBCXX_COMMIT_1="450ae0d29766e87ea12148e8c6c3352053f78e15" # dawn (DAWN_COMMIT_1) dep
LIBCXX_COMMIT_2="d8d9de41d76406e117a3ecc2f694ce4dc2141220" # dawn/angle dep
LIBCXXABI_COMMIT_1="e5b130d5dc3058457ea0658a55ae6bb968f75f0e" # dawn (DAWN_COMMIT_1) dep
LIBCXXABI_COMMIT_2="a834cb253992175f4a896c5fb1352ecd91abf11e" # dawn/angle dep
LIBDRM_COMMIT_1="ad78bb591d02162d3b90890aa4d0a238b2a37cde" # dawn (DAWN_COMMIT_1) dep
LIBDRM_COMMIT_2="474894ed17a037a464e5bd845a0765a50f647898" # dawn/angle dep
LIBFUZZER_COMMIT="26cc39e59b2bf5cbc20486296248a842c536878d" # dawn (DAWN_COMMIT_1) dep
LIBJPEG_TURBO_COMMIT="4426a8da65e8d1eb652210d0c5b3a339e05aec01" # dawn/angle dep
LIBPNG_COMMIT="d2ece84bd73af1cd5fae5e7574f79b40e5de4fba" # dawn/angle dep
LIBPROTOBUF_MUTATOR_COMMIT="a304ec48dcf15d942607032151f7e9ee504b5dcf" # dawn (DAWN_COMMIT_1) dep
LIBUNWIND_COMMIT="dc70138c3e68e2f946585f134e20815851e26263" # dawn/angle dep
LUNARG_VULKANTOOLS_COMMIT_1="a24a94aa0d1fc4e5556bdf9c6b2afe8eacc55326" # dawn/vulkan-deps dep
LUNARG_VULKANTOOLS_COMMIT_2="a12be94856baf210bb7ae9457dbdf907148caa0a" # dawn/angle/dawn/vulkan-deps dep
LLVM_COMMIT="d222fa4521531cc4ac14b8e157d231c108c003be" # dawn/angle dep
LLVM_COMPAT=( 17 18 )
LLVM_LIBC_COMMIT="a485ddbbb2ffe528c3ebf82b9d72a7297916531f" # dawn (DAWN_COMMIT_1) dep
LLVM_OPTIONAL=1
LLVM_PROJECT_COMMIT="fc3b34c50803274b8ba3b8a30df9177b7d29063c" # swiftshader dep
LSPROTOCOL_COMMIT="4a296ecf01c50008c9fbf07d48d15a1a4e97fded" # dawn/langsvr dep
MARKUPSAFE_COMMIT_1="0bad08bb207bbfc1d6f3bbc82b9242b0c50e5794" # dawn (DAWN_COMMIT_1) dep
MARKUPSAFE_COMMIT_2="6638e9b0a79afc2ff7edd9e84b518fe7d5d5fea9" # dawn/angle dep
MEMORY_COMMIT="bd3ae34fa1ef7cf9510cae571bd27dd09600f321" # dawn/angle dep
MESA_COMMIT="0a6aa58acae2a5b27ef783c22e976ec9b0d33ddc" # dawn/angle dep
MP11_PV="1.82.0"
NODE_ADDON_API_COMMIT="1e26dcb52829a74260ec262edb41fc22998669b6" # dawn (DAWN_COMMIT_1) dep
NSYNC_PV="1.26.0" # From cmake/deps.txt
ONNX_PV_1="1.16.1" # onnxruntime dep
ONNX_PV_2="1.16.0" # onnx-tensorrt dep
OPENCL_CTS_COMMIT="e0a31a03fc8f816d59fd8b3051ac6a61d3fa50c6" # dawn/angle dep
OPENCL_DOCS_COMMIT="774114e8761920b976d538d47fad8178d05984ec" # dawn/angle dep
OPENCL_ICD_LOADER_COMMIT="9b5e3849b49a1448996c8b96ba086cd774d987db" # dawn/angle dep
OPENGL_REGISTRY_COMMIT="5bae8738b23d06968e7c3a41308568120943ae77" # dawn (DAWN_COMMIT_1) dep
PERFETTO_COMMIT="d06bef7807a8b90de9bce77132e188f68459a714" # dawn/angle dep
PERF_COMMIT="04e8da746a4fffd3a20ff54872dcf234f0264155" # dawn/angle dep
POWERVR_EXAMPLES_COMMIT="409c9d54fdaffe68565283e38dcbbe6c58535925" # swiftshader dep
PSIMD_COMMIT="072586a71b55b7f8c584153d223e95687148a900" # From cmake/deps.txt
PYTHON_MARKDOWN_COMMIT="0f4473546172a64636f5d841410c564c0edad625" # dawn/angle dep
MB_COMMIT="bd684abf569033d9aae4c28c95ecb78e77db7bbb" # dawn/angle dep
MD_BROWSER_COMMIT="6cc8e58a83412dc31de6fb7614fadb0b51748d4b" # dawn/angle dep
MESON_COMMIT="9fd5eb605674067ce6f8876dc27e5e116024e8a6" # dawn/angle dep
MIMALLOC_PV="2.1.1" # From cmake/deps.txt
NASM_COMMIT="f477acb1049f5e043904b87b825c5915084a9a29" # dawn/angle dep
NODE_API_HEADERS_COMMIT="d5cfe19da8b974ca35764dd1c73b91d57cd3c4ce" # dawn (DAWN_COMMIT_1) dep
ONNX_TENSORRT_COMMIT="9f98e2ebe7507fe0774d06a44bbf4b0e82cc9ce7" # From cmake/deps.txt
ONNXRUNTIME_EXTENSIONS_COMMIT="94142d8391c9791ec71c38336436319a2d4ac7a0" # From cmake/deps.txt
OPENVINO_PV="2024.2.0"
OPENVINO_TARGETS=(
	cpu
	cpu_np
	gpu
	gpu_np
	npu
	npu_np
)
PROTOBUF_PV_1="21.12" # From cmake/deps.txt
PROTOBUF_PV_2="22.3" # From cmake/external/onnx/CMakeLists.txt
PARTITION_ALLOCATOR_COMMIT="2e6b2efb6f435aa3dd400cb3bdcead2a601f8f9a" # dawn (DAWN_COMMIT_1) dep
PROTOBUF_COMMIT="da2fe725b80ac0ba646fbf77d0ce5b4ac236f823" # dawn (DAWN_COMMIT_1) dep
PROTOC_WRAPPER_COMMIT_1="b5ea227bd88235ab3ccda964d5f3819c4e2d8032" # dawn dep
PROTOC_WRAPPER_COMMIT_2="dbcbea90c20ae1ece442d8ef64e61c7b10e2b013" # dawn/angle dep
PSMID_COMMIT="072586a71b55b7f8c584153d223e95687148a900" # From cmake/deps.txt
PTHREADPOOL_COMMIT="4fe0e1e183925bf8cfa6aae24237e724a96479b8" # From cmake/deps.txt
PYBIND11_COMMIT_1="5b0a6fc2017fcc176545afe3e09c9f9885283242" # onnx (ONNX_PV_1) dep
PYBIND11_PV="2.13.1" # From cmake/deps.txt, onnxruntime dep
PYTHON_COMMIT="64dd0e593f8e438764ced983a9f3f96061df748c" # dawn/angle dep
PYTHON_COMPAT=( "python3_"{10..12} )
RANG_COMMIT="cabe04d6d6b05356fa8f9741704924788f0dd762" # tvm dep
RAPIDJSON_COMMIT="781a4e667d84aeedbeb8184b7b62425ea66ec59f" # dawn/angle dep
REQUESTS_COMMIT="c7e0fc087ceeadb8b4c84a0953a422c474093d6d" # dawn/angle dep
ROCM_SLOTS=(
	rocm_6_0
)
RUST_COMMIT_1="a69a8ecdbf7a19fb129ae57650cac9f704cb7cf9" # dawn (DAWN_COMMIT_1) dep
RUST_COMMIT_2="b732825d28c8cc3277ef03713cc7e71b0db9c782" # dawn/angle dep
RUST_COMMIT_3="86af231a4eafdff5cc710204949b6b806954b926" # dawn/angle/dawn dep
RE2_PV="2024-07-02" # From cmake/deps.txt
SAFEINT_PV="3.0.28" # From cmake/deps.txt
SIX_COMMIT="580980eb7d380150995b82cd18e1254ab5eff77f" # dawn/angle dep
SPIRV_CROSS_COMMIT_1="b8fcf307f1f347089e3c46eb4451d27f32ebc8d3" # dawn (DAWN_COMMIT_1) dep
SPIRV_HEADERS_COMMIT_1="69ab0f32dc6376d74b3f5b0b7161c6681478badd" # dawn (DAWN_COMMIT_1) dep
SPIRV_HEADERS_COMMIT_2="db5a00f8cebe81146cafabf89019674a3c4bf03d" # dawn/dxc dep
SPIRV_HEADERS_COMMIT_3="f013f08e4455bcc1f0eed8e3dd5e2009682656d9" # dawn/angle/dawn dep
SPIRV_TOOLS_COMMIT_1="edc68950bf725edc89b3e1974c533454cf2ae37c" # dawn (DAWN_COMMIT_1) dep
SPIRV_TOOLS_COMMIT_2="72c291332a0558ab4121eff9db97e428b574b58b" # dawn/dxc dep
SPIRV_TOOLS_COMMIT_3="87fcbaf1bc8346469e178711eff27cfd20aa1960" # dawn/angle/dawn dep
SWIFTSHADER_COMMIT_1="3c4bdf66d81d01a215b88bfea3ac4cc8ca507779" # dawn (DAWN_COMMIT_1) dep
SWIFTSHADER_COMMIT_2="65157d32945d9a75fc9a657e878a1b2f61342f03" # dawn/angle/dawn dep
TENSORBOARD_COMMIT="373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81" # From cmake/deps.txt
TESTING_COMMIT_1="1bd0da6657e330cf26ed0702b3f456393587ad7c" # dawn (DAWN_COMMIT_1) dep
TESTING_COMMIT_2="25720e4d35105d689c4b642e48addf2f8a101afc" # dawn/angle dep
TVM_COMMIT="2379917985919ed3918dc12cad47f469f245be7a" # From cmake/external/tvm.cmake
TVM_VTA_COMMIT="36a91576edf633479c78649e050f18dd2ddc8103" # tvm dep
UTF8_RANGE_COMMIT="72c943dea2b9240cd09efde15191e144bc7c7d38" # From cmake/deps.txt, protobuf dep
WEBGPU_CTS_COMMIT="9cf0129e51b25c16310830dc040adb444fede64e" # dawn (DAWN_COMMIT_1) dep
WEBGPU_HEADERS="8049c324dc7b3c09dc96ea04cb02860f272c8686" # dawn (DAWN_COMMIT_1) dep
VALGRIND_COMMIT="f9f02d66abacbb6b1bf00573b7426ec6dc767b38" # dawn/angle dep
VK_GL_CTS_COMMIT="824d14748364bfdf6901dad2f81cbf5b5fe48e44" # dawn/angle dep
VULKAN_MEMORY_ALLOCATOR_COMMIT_1="52dc220fb326e6ae132b7f262133b37b0dc334a3" # dawn (DAWN_COMMIT_1) dep
VULKAN_MEMORY_ALLOCATOR_COMMIT_2="56300b29fbfcc693ee6609ddad3fdd5b7a449a21" # dawn/angle dep
VULKAN_DEPS_COMMIT_1="23ed8d76c58a57c4f14b0aba6197d5631a844f00" # dawn (DAWN_COMMIT_1) dep
VULKAN_DEPS_COMMIT_2="a5d4d42457c36561f14e4294a8205db8a736e60c" # dawn/angle/dawn dep
VULKAN_HEADERS_COMMIT_1="a6a5dc0d078ade9bde75bd78404462509cbdce99" # dawn (DAWN_COMMIT_1) dep
VULKAN_HEADERS_COMMIT_2="595c8d4794410a4e64b98dc58d27c0310d7ea2fd" # dawn/angle/dawn dep
VULKAN_LOADER_COMMIT_1="2761c159b9325baa5980e028ac081963b5d5dd9c" # dawn (DAWN_COMMIT_1) dep
VULKAN_LOADER_COMMIT_2="faeb5882c7faf3e683ebb1d9d7dbf9bc337b8fa6" # dawn/angle/dawn dep
VULKAN_TOOLS_COMMIT_1="7e82aea5fc1394d417a0df6a5680a4cce5c37286" # dawn (DAWN_COMMIT_1) dep
VULKAN_TOOLS_COMMIT_2="7d5cdf62e4f2935425faab1270fe1c9a401fa664" # dawn/angle/dawn dep
VULKAN_UTILITY_LIBRARIES_COMMIT_1="7ea05992a52e96426bd4c56ea12d208e0d6c9a5f" # dawn (DAWN_COMMIT_1) dep
VULKAN_UTILITY_LIBRARIES_COMMIT_2="45b881573538f8e481cb6e1d811a9076be6920c1" # dawn/angle/dawn dep
VULKAN_VALIDATION_LAYERS_COMMIT_1="13c0c4dc619d165b05061702a3c8eb604d21efa4" # dawn (DAWN_COMMIT_1) dep
VULKAN_VALIDATION_LAYERS_COMMIT_2="ae55cec94c028cf3467b1e0e789c4d01c069bda3" # dawn/angle/dawn dep
WAYLAND_COMMIT="75c1a93e2067220fa06208f20f8f096bb463ec08" # dawn/angle dep
WIL_PV="1.0.230629.1"
XNNPACK_COMMIT="309b75c9e56e0a674bf78d59872ce131f814dfb6" # From cmake/deps.txt
ZLIB_COMMIT_1="209717dd69cd62f24cbacc4758261ae2dd78cfac" # dawn (DAWN_COMMIT_1) dep
ZLIB_COMMIT_2="d3aea2341cdeaf7e717bc257a59aa7a9407d318a" # dawn/angle dep

inherit cflags-hardened check-compiler-switch cmake cuda dep-prepare distutils-r1 flag-o-matic llvm-r1 rocm toolchain-funcs

# Vendored packages need to be added or reviewed for compleness.
# The reason for delay is submodule hell (the analog of dll hell or dependency hell).
#KEYWORDS="~amd64"
SRC_URI="

https://android.googlesource.com/platform/external/cherry/+archive/${CHERRY_COMMIT:0:7}.tar.gz
	-> cherry-${CHERRY_COMMIT:0:7}.tar.gz
https://android.googlesource.com/platform/external/libpng/+archive/${LIBPNG_COMMIT:0:7}.tar.gz
	-> libpng-${LIBPNG_COMMIT:0:7}.tar.gz
https://android.googlesource.com/platform/external/perfetto/+archive/${PERFETTO_COMMIT:0:7}.tar.gz
	-> perfetto-${PERFETTO_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/angle/angle/+archive/${ANGLE_COMMIT_1:0:7}.tar.gz
	-> angle-${ANGLE_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/angle/angle/+archive/${ANGLE_COMMIT_2:0:7}.tar.gz
	-> angle-${ANGLE_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/catapult/+archive/${CATAPULT_COMMIT_1}.tar.gz
	-> catapult-${CATAPULT_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/catapult/+archive/${CATAPULT_COMMIT_2}.tar.gz
	-> catapult-${CATAPULT_COMMIT_2:0:7}.tar.gz

https://chromium.googlesource.com/chromium/deps/libjpeg_turbo/+archive/${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
	-> libjpeg_turbo-${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/deps/nasm/+archive/${NASM_COMMIT:0:7}.tar.gz
	-> nasm-${NASM_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/base/allocator/partition_allocator/+archive/${PARTITION_ALLOCATOR_COMMIT:0:7}.tar.gz
	-> partition_allocator-${PARTITION_ALLOCATOR_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/build/+archive/${BUILD_COMMIT_1:0:7}.tar.gz
	-> build-${BUILD_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/build/+archive/${BUILD_COMMIT_2:0:7}.tar.gz
	-> build-${BUILD_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/build/+archive/${BUILD_COMMIT_3:0:7}.tar.gz
	-> build-${BUILD_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/buildtools/+archive/${BUILDTOOLS_COMMIT_1:0:7}.tar.gz
	-> buildtools-${BUILDTOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/buildtools/+archive/${BUILDTOOLS_COMMIT_2:0:7}.tar.gz
	-> buildtools-${BUILDTOOLS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp/+archive/${ABSEIL_CPP_COMMIT_3:0:7}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp/+archive/${ABSEIL_CPP_COMMIT_4:0:7}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/android_build_tools/+archive/${ANDROID_BUILD_TOOLS_COMMIT:0:7}.tar.gz
	-> android_build_tools-${ANDROID_BUILD_TOOLS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/android_deps/+archive/${ANDROID_DEPS_COMMIT:0:7}.tar.gz
	-> android-deps-${ANDROID_DEPS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/android_platform/+archive/${ANDROID_PLATFORM_COMMIT:0:7}.tar.gz
	-> android_platform-${ANDROID_PLATFORM_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/android_sdk/+archive/${ANDROID_SDK_COMMIT:0:7}.tar.gz
	-> android_sdk-${ANDROID_SDK_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/googletest/+archive/${GOOGLETEST_COMMIT_9:0:7}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_9:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/ijar/+archive/${IJAR_COMMIT:0:7}.tar.gz
	-> ijar-${IJAR_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/jinja2/+archive/${JINJA2_COMMIT_1:0:7}.tar.gz
	-> jinja2-${JINJA2_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/jinja2/+archive/${JINJA2_COMMIT_2:0:7}.tar.gz
	-> jinja2-${JINJA2_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/jsoncpp/+archive/${JSONCPP_COMMIT_3:0:7}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/markupsafe/+archive/${MARKUPSAFE_COMMIT_1:0:7}.tar.gz
	-> markupsafe-${MARKUPSAFE_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/markupsafe/+archive/${MARKUPSAFE_COMMIT_2:0:7}.tar.gz
	-> markupsafe-${MARKUPSAFE_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/protobuf/+archive/${PROTOBUF_COMMIT:0:7}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/Python-Markdown/+archive/${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz
	-> python-markdown-${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/six/+archive/${SIX_COMMIT:0:7}.tar.gz
	-> six-${SIX_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${ZLIB_COMMIT_1:0:7}.tar.gz
	-> zlib-${ZLIB_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${ZLIB_COMMIT_2:0:7}.tar.gz
	-> zlib-${ZLIB_COMMIT_2:0:7}.tar.gz



https://chromium.googlesource.com/chromium/src/testing/+archive/${TESTING_COMMIT_1:0:7}.tar.gz
	-> testing-${TESTING_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/testing/+archive/${TESTING_COMMIT_2:0:7}.tar.gz
	-> testing-${TESTING_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/android/+archive/${ANDROID_COMMIT:0:7}.tar.gz
	-> android-${ANDROID_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_1:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_2:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_3:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/mb/+archive/${MB_COMMIT:0:7}.tar.gz
	-> mb-${MB_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/md_browser/+archive/${MD_BROWSER_COMMIT:0:7}.tar.gz
	-> md_browser-${MD_BROWSER_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/memory/+archive/${MEMORY_COMMIT:0:7}.tar.gz
	-> memory-${MEMORY_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/perf/+archive/${PERF_COMMIT:0:7}.tar.gz
	-> perf-${PERF_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper/+archive/${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz
	-> protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper/+archive/${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz
	-> protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/python/+archive/${PYTHON_COMMIT:0:7}.tar.gz
	-> python-${PYTHON_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/rust/+archive/${RUST_COMMIT_1:0:7}.tar.gz
	-> rust-${RUST_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/rust/+archive/${RUST_COMMIT_2:0:7}.tar.gz
	-> rust-${RUST_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/rust/+archive/${RUST_COMMIT_3:0:7}.tar.gz
	-> rust-${RUST_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/valgrind/+archive/${VALGRIND_COMMIT:0:7}.tar.gz
	-> valgrind-${VALGRIND_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/tools/depot_tools/+archive/${DEPOT_TOOLS_COMMIT_1:0:7}.tar.gz
	-> depot_tools-${DEPOT_TOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/tools/depot_tools/+archive/${DEPOT_TOOLS_COMMIT_2:0:7}.tar.gz
	-> depot_tools-${DEPOT_TOOLS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/tools/depot_tools/+archive/${DEPOT_TOOLS_COMMIT_3:0:7}.tar.gz
	-> depot_tools-${DEPOT_TOOLS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromiumos/third_party/libdrm/+archive/${LIBDRM_COMMIT_1:0:7}.tar.gz
	-> libdrm-${LIBDRM_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromiumos/third_party/libdrm/+archive/${LIBDRM_COMMIT_2:0:7}.tar.gz
	-> libdrm-${LIBDRM_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/anongit.freedesktop.org/git/wayland/wayland/+archive/${WAYLAND_COMMIT:0:7}.tar.gz
	-> wayland-${WAYLAND_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/colorama/+archive/${COLORAMA_COMMIT:0:7}.tar.gz
	-> colorama-${COLORAMA_COMMIT:0:7}.tar.gz




https://chromium.googlesource.com/external/github.com/ARM-software/astc-encoder/+archive/${ASTC_ENCODER_COMMIT:0:7}.tar.gz
	-> astc-encoder-${ASTC_ENCODER_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/glfw/glfw/+archive/${GLFW_COMMIT:0:7}.tar.gz
	-> glfw-${GLFW_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/glmark2/glmark2/+archive/${GLMARK2_COMMIT:0:7}.tar.gz
	-> glmark2-${GLMARK2_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/google/clspv/+archive/${CLSPV_COMMIT:0:7}.tar.gz
	-> clspv-${CLSPV_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/google/cpu_features/+archive/${CPU_FEATURES_COMMIT:0:7}.tar.gz
	-> cpu_features-${CPU_FEATURES_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/google/flatbuffers/+archive/${FLATBUFFERS_COMMIT:0:7}.tar.gz
	-> flatbuffers-${FLATBUFFERS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/kennethreitz/requests/+archive/${REQUESTS_COMMIT:0:7}.tar.gz
	-> requests-${REQUESTS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/EGL-Registry/+archive/${EGL_REGISTRY_COMMIT:0:7}.tar.gz
	-> egl-registry-${EGL_REGISTRY_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenGL-Registry/+archive/${OPENGL_REGISTRY_COMMIT:0:7}.tar.gz
	-> opengl-registry-${OPENGL_REGISTRY_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Cross/+archive/${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz
	-> spirv-cross-${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers/+archive/${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers/+archive/${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools/+archive/${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools/+archive/${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/VK-GL-CTS/+archive/${VK_GL_CTS_COMMIT:0:7}.tar.gz
	-> vk-gl-cts-${VK_GL_CTS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/+archive/${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz
	-> VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/+archive/${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz
	-> VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/gpuweb/cts/+archive/${WEBGPU_CTS_COMMIT:0:7}.tar.gz
	-> webgpu-cts-${WEBGPU_CTS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_1:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_4:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_4:0:7}.tar.gz

https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenCL-CTS/+archive/${OPENCL_CTS_COMMIT:0:7}.tar.gz
	-> opencl-cts-${OPENCL_CTS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenCL-Docs/+archive/${OPENCL_DOCS_COMMIT:0:7}.tar.gz
	-> opencl-docs-${OPENCL_DOCS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenCL-ICD-Loader/+archive/${OPENCL_ICD_LOADER_COMMIT:0:7}.tar.gz
	-> opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT:0:7}.tar.gz

https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Headers/+archive/${VULKAN_HEADERS_COMMIT_1:0:7}.tar.gz
	-> vulkan-headers-${VULKAN_HEADERS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Headers/+archive/${VULKAN_HEADERS_COMMIT_2:0:7}.tar.gz
	-> vulkan-headers-${VULKAN_HEADERS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Loader/+archive/${VULKAN_LOADER_COMMIT_1:0:7}.tar.gz
	-> vulkan-loader-${VULKAN_LOADER_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Loader/+archive/${VULKAN_LOADER_COMMIT_2:0:7}.tar.gz
	-> vulkan-loader-${VULKAN_LOADER_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Tools/+archive/${VULKAN_TOOLS_COMMIT_1:0:7}.tar.gz
	-> vulkan-tools-${VULKAN_TOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Tools/+archive/${VULKAN_TOOLS_COMMIT_2:0:7}.tar.gz
	-> vulkan-tools-${VULKAN_TOOLS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Utility-Libraries/+archive/${VULKAN_UTILITY_LIBRARIES_COMMIT_1:0:7}.tar.gz
	-> vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Utility-Libraries/+archive/${VULKAN_UTILITY_LIBRARIES_COMMIT_2:0:7}.tar.gz
	-> vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-ValidationLayers/+archive/${VULKAN_VALIDATION_LAYERS_COMMIT_1:0:7}.tar.gz
	-> vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-ValidationLayers/+archive/${VULKAN_VALIDATION_LAYERS_COMMIT_2:0:7}.tar.gz
	-> vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/+archive/${LLVM_COMMIT:0:7}.tar.gz
	-> llvm-${LLVM_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format/+archive/${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz
	-> clang-format-${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format/+archive/${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz
	-> clang-format-${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/compiler-rt/lib/fuzzer/+archive/${LIBFUZZER_COMMIT:0:7}.tar.gz
	-> libfuzzer-${LIBFUZZER_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx/+archive/${LIBCXX_COMMIT_1:0:7}.tar.gz
	-> libc++-${LIBCXX_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx/+archive/${LIBCXX_COMMIT_2:0:7}.tar.gz
	-> libc++-${LIBCXX_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi/+archive/${LIBCXXABI_COMMIT_1:0:7}.tar.gz
	-> libc++abi-${LIBCXXABI_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi/+archive/${LIBCXXABI_COMMIT_2:0:7}.tar.gz
	-> libc++abi-${LIBCXXABI_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libc.git/+archive/${LLVM_LIBC_COMMIT:0:7}.tar.gz
	-> llvm-libc-${LLVM_LIBC_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libunwind/+archive/${LIBUNWIND_COMMIT:0:7}.tar.gz
	-> libunwind-${LIBUNWIND_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/LunarG/VulkanTools/+archive/${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz
	-> lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/LunarG/VulkanTools/+archive/${LUNARG_VULKANTOOLS_COMMIT_2:0:7}.tar.gz
	-> lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/Mesa3D/mesa/+archive/${MESA_COMMIT:0:7}.tar.gz
	-> mesa-${MESA_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/mesonbuild/meson/+archive/${MESON_COMMIT:0:7}.tar.gz
	-> meson-${MESON_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectX-Headers/+archive/${DXHEADERS_COMMIT:0:7}.tar.gz
	-> dxheaders-${DXHEADERS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+archive/${DXC_COMMIT_1:0:7}.tar.gz
	-> dxc-${DXC_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+archive/${DXC_COMMIT_2:0:7}.tar.gz
	-> dxc-${DXC_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/Tencent/rapidjson/+archive/${RAPIDJSON_COMMIT:0:7}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/webgpu-native/webgpu-headers/+archive/${WEBGPU_HEADERS:0:7}.tar.gz
	-> webgpu-headers-${WEBGPU_HEADERS:0:7}.tar.gz
https://chromium.googlesource.com/vulkan-deps/+archive/${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz
	-> vulkan-deps-${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/vulkan-deps/+archive/${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz
	-> vulkan-deps-${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz

https://dawn.googlesource.com/dawn/+archive/${DAWN_COMMIT_2:0:7}.tar.gz
	-> dawn-${DAWN_COMMIT_2:0:7}.tar.gz


https://swiftshader.googlesource.com/git-hooks/+archive/${GIT_HOOKS_COMMIT:0:7}.tar.gz
	-> git-hooks-${GIT_HOOKS_COMMIT:0:7}.tar.gz
https://swiftshader.googlesource.com/SwiftShader/+archive/${SWIFTSHADER_COMMIT_1:0:7}.tar.gz
	-> swiftshader-${SWIFTSHADER_COMMIT_1:0:7}.tar.gz
https://swiftshader.googlesource.com/SwiftShader/+archive/${SWIFTSHADER_COMMIT_2:0:7}.tar.gz
	-> swiftshader-${SWIFTSHADER_COMMIT_2:0:7}.tar.gz

https://github.com/powervr-graphics/Native_SDK/archive/${POWERVR_EXAMPLES_COMMIT}.tar.gz
	-> Native_SDK-${POWERVR_EXAMPLES_COMMIT:0:7}.tar.gz


https://github.com/abseil/abseil-cpp/archive/refs/tags/${ABSEIL_CPP_PV_1}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_PV_1}.tar.gz
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT_2}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_2:0:7}.tar.gz
https://github.com/apple/coremltools/archive/refs/tags/${COREMLTOOLS_PV}.tar.gz
	-> coremltools-${COREMLTOOLS_PV}.tar.gz
https://github.com/boostorg/mp11/archive/refs/tags/boost-${MP11_PV}.tar.gz
	-> mp11-${MP11_PV}.tar.gz
https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_PV}.tar.gz
	-> SafeInt-${SAFEINT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${DLPACK_COMMIT_2}.tar.gz
	-> dlpack-${DLPACK_COMMIT_2:0:7}.tar.gz
https://github.com/emscripten-core/emsdk/archive/${EMSDK_COMMIT}.tar.gz
	-> emsdk-${EMSDK_COMMIT:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_1}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_1:0:7}.tar.gz
https://github.com/google/cppdap/archive/${CPPDAP_COMMIT}.tar.gz
	-> cppdap-${CPPDAP_COMMIT}.tar.gz
https://github.com/google/dawn/archive/${DAWN_COMMIT_1}.tar.gz
	-> dawn-${DAWN_COMMIT_1}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz
	-> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/langsvr/archive/${LANGSVR_COMMIT}.tar.gz
	-> langsvr-${LANGSVR_COMMIT:0:7}.tar.gz
https://github.com/google/libprotobuf-mutator/archive/${LIBPROTOBUF_MUTATOR_COMMIT}.tar.gz
	-> libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT:0:7}.tar.gz
https://github.com/google/nsync/archive/refs/tags/${NSYNC_PV}.tar.gz
	-> nsync-${NSYNC_PV}.tar.gz
https://github.com/google/re2/archive/refs/tags/${RE2_PV}.tar.gz
	-> re2-${RE2_PV}.tar.gz
https://github.com/gpuweb/gpuweb/archive/${GPUWEB_COMMIT_1:0:7}.tar.gz
	-> gpuweb-${GPUWEB_COMMIT_1:0:7}.tar.gz
https://github.com/gpuweb/gpuweb/archive/${GPUWEB_COMMIT_2:0:7}.tar.gz
	-> gpuweb-${GPUWEB_COMMIT_2:0:7}.tar.gz
https://github.com/HowardHinnant/date/archive/v${DATE_PV_1}.tar.gz
	-> HowardHinnant-date-${DATE_PV_1}.tar.gz
https://github.com/HowardHinnant/date/archive/v${DATE_PV_2}.tar.gz
	-> HowardHinnant-date-${DATE_PV_2}.tar.gz
https://github.com/ianlancetaylor/libbacktrace/archive/${LIBBACKTRACE_COMMIT_2}.tar.gz
	-> libbacktrace-${LIBBACKTRACE_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Headers/archive/${SPIRV_HEADERS_COMMIT_2}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Tools/archive/${SPIRV_TOOLS_COMMIT_2}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_2}.tar.gz
https://github.com/llvm/llvm-project/archive/${LLVM_PROJECT_COMMIT}.tar.gz
	-> llvm-project-${LLVM_PROJECT_COMMIT:0:7}.tar.gz
https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v${DIRECTX_HEADERS_PV}.tar.gz
	-> DirectX-Headers-${DIRECTX_HEADERS_PV}.tar.gz
https://github.com/microsoft/GSL/archive/refs/tags/v${GSL_PV}.tar.gz
	-> microsoft-gsl-${GSL_PV}.tar.gz
https://github.com/microsoft/lsprotocol/archive/${LSPROTOCOL_COMMIT}.tar.gz
	-> lsprotocol-${LSPROTOCOL_COMMIT}.tar.gz
https://github.com/microsoft/wil/archive/refs/tags/v${WIL_PV}.tar.gz
	-> microsoft-wil-${WIL_PV}.tar.gz
https://github.com/nlohmann/json/archive/refs/tags/v${JSON_PV}.tar.gz
	-> nlohmann-json-${JSON_PV}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_1}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_1:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_2}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_2:0:7}.tar.gz
https://github.com/nodejs/node-addon-api/archive/${NODE_ADDON_API_COMMIT}.tar.gz
	-> node-addon-api-${NODE_ADDON_API_COMMIT:0:7}.tar.gz


https://github.com/onnx/onnx/archive/refs/tags/v${ONNX_PV_1}.tar.gz
	-> onnx-${ONNX_PV_1}.tar.gz
https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_COMMIT_1}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_1:0:1}.tar.gz
https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_COMMIT_2}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_2:0:7}.tar.gz
https://github.com/nodejs/node-api-headers/archive/${NODE_API_HEADERS_COMMIT}.tar.gz
	-> node-api-headers-${NODE_API_HEADERS_COMMIT:0:7}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV_1}.tar.gz
	-> protobuf-${PROTOBUF_PV_1}.tar.gz
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_2}/protobuf-${PROTOBUF_PV_2}.tar.gz
	-> protobuf-${PROTOBUF_PV_2}.tar.gz
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-aarch_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-osx-universal_binary.zip
https://github.com/protocolbuffers/utf8_range/archive/${UTF8_RANGE_COMMIT}.tar.gz
	-> utf8_range-${UTF8_RANGE_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT}.tar.gz
	-> pytorch-cpuinfo-${CPUINFO_COMMIT:0:7}.tar.gz
https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz
	-> cxxopts-${CXXOPTS_COMMIT:0:7}.tar.gz
https://gitlab.arm.com/kleidi/kleidiai/-/archive/v${KLEIDIAI_PV}/kleidiai-v${KLEIDIAI_PV}.tar.gz
	-> kleidiai-${KLEIDIAI_PV}.tar.gz
	!system-eigen? (
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
	-> eigen-${EIGEN_COMMIT:0:7}.tar.gz
	)
	abseil-cpp? (
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV_2}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_PV_2}.tar.gz
	)
	benchmark? (
https://github.com/google/benchmark/archive/refs/tags/v${BENCHMARK_PV}.tar.gz
	-> benchmark-${BENCHMARK_PV}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_2}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_2:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_3}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_3:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_4}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/google/benchmark/+archive/${BENCHMARK_COMMIT_5:0:7}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_5:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_6}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_6:0:7}.tar.gz
	)
	cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.tar.gz
	-> cudnn-frontend-${CUDNN_FRONTEND_PV}.tar.gz
https://github.com/NVIDIA/cutlass/archive/refs/tags/v${CUTLASS_PV}.tar.gz
	-> cutlass-${CUTLASS_PV}.tar.gz
	)
	composable-kernel? (
		!system-composable-kernel? (
https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> composable-kernel-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
		)
	)
	extensions? (
https://github.com/microsoft/onnxruntime-extensions/archive/${ONNXRUNTIME_EXTENSIONS_COMMIT}.tar.gz
	-> onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT:0:7}.tar.gz
	)
	mimalloc? (
https://github.com/microsoft/mimalloc/archive/refs/tags/v${MIMALLOC_PV}.tar.gz
	-> mimalloc-${MIMALLOC_PV}.tar.gz
	)
	python? (
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.tar.gz
	-> pybind11-${PYBIND11_PV}.tar.gz
	)
	tensorrt-oss-parser? (
https://github.com/onnx/onnx/archive/refs/tags/v${ONNX_PV_2}.tar.gz
	-> onnx-${ONNX_PV_2}.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
	)
	test? (
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_4}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_4:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_5}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_5:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_6}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_6:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_7}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_7:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_8}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_8:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_10}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_10:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_11}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_11:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_PV_1}.tar.gz
	-> googletest-${GOOGLETEST_PV_1}.tar.gz
https://github.com/google/googletest/archive/release-${GOOGLETEST_PV_2}.tar.gz
	-> googletest-${GOOGLETEST_PV_2}.tar.gz
	)
	training? (
https://github.com/tensorflow/tensorboard/archive/${TENSORBOARD_COMMIT}.tar.gz
	-> tensorboard-${TENSORBOARD_COMMIT:0:7}.tar.gz
	)
	tvm? (
https://github.com/agauniyal/rang/archive/${RANG_COMMIT}.tar.gz
	-> rang-${RANG_COMMIT:0:7}.tar.gz
https://github.com/apache/tvm/archive/${TVM_COMMIT}.tar.gz
	-> tvm-${TVM_COMMIT:0:7}.tar.gz
https://github.com/apache/tvm-vta/archive/${TVM_VTA_COMMIT}.tar.gz
	-> tvm-vta-${TVM_VTA_COMMIT:0:7}.tar.gz
https://github.com/dmlc/dlpack/archive/${DLPACK_COMMIT_1}.tar.gz
	-> dlpack-${DLPACK_COMMIT_1:0:7}.tar.gz
https://github.com/dmlc/dmlc-core/archive/${DMLC_CORE_COMMIT}.tar.gz
	-> dmlc-core-${DMLC_CORE_COMMIT:0:7}.tar.gz
https://github.com/tlc-pack/libbacktrace/archive/${LIBBACKTRACE_COMMIT_1}.tar.gz
	-> libbacktrace-${LIBBACKTRACE_COMMIT_1:0:7}.tar.gz
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
	)
	xnnpack? (
https://github.com/Maratyszcza/FP16/archive/${FP16_COMMIT}.tar.gz
	-> fp16-${FP16_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/${FXDIV_COMMIT}.tar.gz
	-> fxdiv-${FXDIV_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/psimd/archive/${PSMID_COMMIT}.tar.gz
	-> psimd-${PSIMD_COMMIT:0:7}.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/${PTHREADPOOL_COMMIT}.tar.gz
	-> pthreadpool-${PTHREADPOOL_COMMIT:0:7}.tar.gz
https://github.com/google/XNNPACK/archive/${XNNPACK_COMMIT}.tar.gz
	-> xnnpack-${XNNPACK_COMMIT:0:7}.tar.gz
	)




"

DESCRIPTION="Cross-platform inference and training machine-learning accelerator."
HOMEPAGE="
	https://onnxruntime.ai
	https://github.com/microsoft/onnxruntime
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	CC-BY-3.0
	CC-BY-4.0
	CC-PD
	CC0-1.0
	custom
	HPND
	ISC
	ISSL
	JSON
	LGPL-3+
	MIT
	MPL-2.0
	Ms-PL
	public-domain
	Unlicense
	UoI-NCSA
	ZLIB
"
# ThirdPartyNotices.txt -
#	custom
#	(
#		all-rights-reserved
#		MIT
#	)
#	Apache-2.0
#	Boost-1.0
#	BSD
#	BSD-2
#	CC-PD
#	HPND
#	ISC
#	ISSL
#	JSON
#	MIT
#	MPL-2.0
#	public-domain
#	Unlicense
#	UoI-NCSA
#	ZLIB
# all-rights-reserved Apache-2.0 - onnxruntime/core/common/status.cc
# CC-BY-3.0 CC-BY-4.0 - winml/test/collateral/images/LICENSE.md
# CC0-1.0 MIT - cmake/external/json/doc/mkdocs/docs/home/license.md
# custom - dockerfiles/LICENSE-IMAGE.txt
# custom keywords:  The copyright holders provide no reassurances
# LGPL-3+ MPL-2.0 cmake/external/eigen/scripts/relicense.py
# Ms-PL - cmake/external/safeint/Archive/license/license.json
# Unlicense - cmake/external/tvm/3rdparty/rang/LICENSE
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${OPENVINO_TARGETS[@]/#/openvino_targets_}
${ROCM_SLOTS[@]}
-abseil-cpp -benchmark -composable-kernel cpu -cuda cudnn debug doc -extensions
-javascript -llvm -lto -migraphx -mimalloc -mpi -onednn -openvino
+python -quant -rocm -system-eigen -system-composable-kernel test -tensorrt
-tensorrt-oss-parser -training training-ort -triton -tvm -xnnpack

openvino-auto
openvino-hetero
openvino-multi
ebuild_revision_15
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
# For providers, see also https://github.com/microsoft/onnxruntime/blob/v1.20.2/onnxruntime/test/perftest/command_args_parser.cc#L40
# abseil-cpp is required for protobuf and still links to it if disabled.
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	abseil-cpp
	composable-kernel? (
		amdgpu_targets_gfx90a
		rocm
	)
	cuda? (
		cudnn
		!lto
	)
	cudnn? (
		cuda
	)
	javascript? (
		llvm_slot_18
	)
	openvino? (
		|| (
			openvino_targets_cpu
			openvino_targets_cpu_np
			openvino_targets_gpu
			openvino_targets_gpu_np
			openvino_targets_npu
			openvino_targets_npu_np
		)
		|| (
			openvino-auto
			openvino-hetero
			openvino-multi
		)
	)
	quant? (
		python
	)
	rocm? (
		llvm_slot_17
		migraphx
	)
	tensorrt-oss-parser? (
		cuda
		tensorrt
	)
	test? (
		python
	)
	triton? (
		python
	)
	tvm? (
		python
	)
	|| (
		cpu
		cudnn
		migraphx
		onednn
		openvino
		rocm
		tensorrt
		xnnpack
	)
"
gen_rocm_rdepend() {
	local pv
	for pv in ${HIP_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				~dev-libs/rccl-${pv}:${s}$(get_rocm_usedep RCCL)
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/rocm-smi-${pv}:${s}
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipCUB-${pv}:${s}$(get_rocm_usedep HIPCUB)
				~sci-libs/hipFFT-${pv}:${s}$(get_rocm_usedep HIPFFT)
				~sci-libs/hipRAND-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
				system-composable-kernel? (
					sci-libs/composable-kernel:${s}$(get_rocm_usedep COMPOSABLE_KERNEL)
				)
			)
		"
		if use amdgpu_targets_gfx90a ; then
			echo "
				~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
			"
		fi
	done
}
DISABLED_RDEPEND="
	(
		>=dev-cpp/ms-gsl-4.0.0
		dev-cpp/ms-gsl:=
	)
	(
		>=dev-cpp/nlohmann_json-3.10.5
		dev-cpp/nlohmann_json:=
	)
	(
		>=dev-libs/clog-2024.07.09
		dev-libs/clog:=
	)
	(
		>=dev-libs/cpuinfo-2024.07.09
		dev-libs/cpuinfo:=
	)
	(
		>=dev-libs/date-3.0.1
		dev-libs/date:=
	)
	(
		>=dev-libs/flatbuffers-23.5.26
		dev-libs/flatbuffers:=
	)
	(
		>=dev-libs/nsync-1.26.0
		dev-libs/nsync:=
	)
	(
		>=dev-libs/protobuf-21.12:0/3.21
		dev-libs/protobuf:=
	)
	>=sci-ml/FP16-2021.03.16
	>=dev-libs/FXdiv-2020.12.08
	>=dev-libs/re2-0.2024.07.02:0/11
	benchmark? (
		>=dev-cpp/benchmark-1.8.5
	)
	xnnpack? (
		>=sci-ml/XNNPACK-2023.10.19
	)
"
RDEPEND="
	${PYTHON_DEPS}
	(
		!python? (
			>=sci-ml/onnx-1.16.1[disableStaticReg]
		)
		python? (
			$(python_gen_cond_dep '
				>=sci-ml/onnx-1.16.1[${PYTHON_USEDEP},disableStaticReg]
			')
		)
		sci-ml/onnx:=
	)
	(
		>=sys-cluster/openmpi-4.0.0[cuda?]
		sys-cluster/openmpi:=
	)
	>=dev-python/numpy-1.21.6
	>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
	app-admin/chrpath
	cuda? (
		|| (
			(
				=dev-util/nvidia-cuda-toolkit-11.8*
				!python? (
					>=sci-ml/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
				)
				cudnn? (
					=dev-libs/cudnn-8.8*
				)
				python? (
					>=sci-ml/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-11.8*
				!python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				cudnn? (
					=dev-libs/cudnn-9.1*
				)
				python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
			)
			(
				=dev-util/nvidia-cuda-toolkit-12.6*
				!python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				cudnn? (
					=dev-libs/cudnn-9.5*
				)
				python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	cudnn? (
		dev-libs/cudnn:=
	)
	javascript? (
		llvm_slot_18? (
			>=dev-util/emscripten-3.1.59:18-3.1
		)
	)
	onednn? (
		>=sci-ml/oneDNN-3.0.1
		sci-ml/oneDNN:=
	)
	openvino? (
		>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP}]
		openvino_targets_gpu? (
			>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP},video_cards_intel]
		)
		openvino_targets_npu? (
			>=sci-ml/openvino-${OPENVINO_PV}[${PYTHON_SINGLE_USEDEP},npu]
		)
	)
	rocm? (
		$(gen_rocm_rdepend)
		rocm_6_0? (
			!python? (
				|| (
					=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
				)
			)
			python? (
				|| (
					=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
				)
			)
		)
	)
	system-eigen? (
		>=dev-cpp/eigen-3.4.0[cuda?]
		dev-cpp/eigen:=
	)
	tensorrt? (
		>=dev-util/tensorrt-8.5.1
		=dev-util/nvidia-cuda-toolkit-11.8*
		dev-util/tensorrt:=
	)
	tvm? (
		$(python_gen_cond_dep '
			dev-python/attrs[${PYTHON_USEDEP}]
			dev-python/cloudpickle[${PYTHON_USEDEP}]
			dev-python/decorator[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/synr[${PYTHON_USEDEP}]
			dev-python/tornado[${PYTHON_USEDEP}]
		')
	)
	python? (
		>=sci-ml/transformers-4.18.0[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			training? (
				>=dev-python/numpy-1.16.6[${PYTHON_USEDEP}]
				dev-python/cerberus[${PYTHON_USEDEP}]
				dev-python/h5py[${PYTHON_USEDEP}]
				sci-ml/onnx[${PYTHON_USEDEP}]
			)
			>=dev-python/flatbuffers-23.5.26[${PYTHON_USEDEP}]
			>=dev-python/numpy-1.21.6[${PYTHON_USEDEP}]
			dev-python/coloredlogs[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/protobuf:=[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/py-cpuinfo[${PYTHON_USEDEP}]
			>=dev-python/sympy-1.12[${PYTHON_USEDEP}]
		')
		quant? (
			dev-python/neural-compressor[${PYTHON_SINGLE_USEDEP}]
		)
		training? (
			>=sci-ml/pytorch-1.13.1[${PYTHON_SINGLE_USEDEP}]
			sci-ml/pytorch-ort[${PYTHON_SINGLE_USEDEP}]
		)
		triton? (
			dev-python/triton[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-util/patchelf
	sys-devel/gcc:12
	$(python_gen_cond_dep '
		>=dev-python/setuptools-68.2.2[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-gallery[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/parameterized-0.8.1[${PYTHON_USEDEP}]
			>=dev-python/black-24.2.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.13.2[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/mypy[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]

			>=dev-util/ruff-0.5.4
			dev-python/clang-format[${PYTHON_USEDEP}]
			dev-python/lintrunner-adapters[${PYTHON_USEDEP}]
		')
	)
"
_PATCHES=(
	"${FILESDIR}/${PN}-1.20.0-use-system-composable-kernel.patch"
	"${FILESDIR}/${PN}-1.20.0-drop-nsync.patch"
	"${FILESDIR}/${PN}-1.19.2-onnx_proto-visibility.patch"
	"${FILESDIR}/${PN}-1.20.2-fix-eigen-external-deps.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup

	if use rocm_6_0 ; then
		LLVM_SLOT="17"
		ROCM_SLOT="6.0"
		export ROCM_VERSION="${HIP_6_0_VERSION}"
	fi

	use rocm && rocm_pkg_setup
}

_unpack() {
	local ARGS=( ${A} )

	local PROTOC_TARBALLS=(
		"protoc-${PROTOBUF_PV_1}-win32.zip;protoc_win32-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-win64.zip;protoc_win64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-aarch_64.zip;protoc_linux_aarch64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-x86_32.zip;protoc_linux_x86-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-linux-x86_64.zip;protoc_linux_x64-${PROTOBUF_PV_1}"
		"protoc-${PROTOBUF_PV_1}-osx-universal_binary.zip;protoc_mac_universal-${PROTOBUF_PV_1}"
	)

	# Only for tarballs from chromium.googlesource.com which do not have a root folder.
	local NO_ROOT_DIR_TARBALLS=(
		"abseil-cpp-${ABSEIL_CPP_COMMIT_3:0:7}.tar.gz;abseil-cpp-${ABSEIL_CPP_COMMIT_3}"
		"abseil-cpp-${ABSEIL_CPP_COMMIT_4:0:7}.tar.gz;abseil-cpp-${ABSEIL_CPP_COMMIT_4}"
		"android-${ANDROID_COMMIT:0:7}.tar.gz;android-${ANDROID_COMMIT}"
		"android-deps-${ANDROID_DEPS_COMMIT:0:7}.tar.gz;android-deps-${ANDROID_DEPS_COMMIT}"
		"android_build_tools-${ANDROID_BUILD_TOOLS_COMMIT:0:7}.tar.gz;android_build_tools-${ANDROID_BUILD_TOOLS_COMMIT}"
		"android_platform-${ANDROID_PLATFORM_COMMIT:0:7}.tar.gz;android_platform-${ANDROID_PLATFORM_COMMIT}"
		"android_sdk-${ANDROID_SDK_COMMIT:0:7}.tar.gz;android_sdk-${ANDROID_SDK_COMMIT}"
		"angle-${ANGLE_COMMIT_1:0:7}.tar.gz;angle-${ANGLE_COMMIT_1}"
		"angle-${ANGLE_COMMIT_2:0:7}.tar.gz;angle-${ANGLE_COMMIT_2}"
		"astc-encoder-${ASTC_ENCODER_COMMIT:0:7}.tar.gz;astc-encoder-${ASTC_ENCODER_COMMIT}"
		"benchmark-${BENCHMARK_COMMIT_5:0:7}.tar.gz;benchmark-${BENCHMARK_COMMIT_5}"
		"build-${BUILD_COMMIT_1:0:7}.tar.gz;build-${BUILD_COMMIT_1}"
		"build-${BUILD_COMMIT_2:0:7}.tar.gz;build-${BUILD_COMMIT_2}"
		"build-${BUILD_COMMIT_3:0:7}.tar.gz;build-${BUILD_COMMIT_3}"
		"buildtools-${BUILDTOOLS_COMMIT_1:0:7}.tar.gz;buildtools-${BUILDTOOLS_COMMIT_1}"
		"buildtools-${BUILDTOOLS_COMMIT_2:0:7}.tar.gz;buildtools-${BUILDTOOLS_COMMIT_2}"
		"catapult-${CATAPULT_COMMIT_1:0:7}.tar.gz;catapult-${CATAPULT_COMMIT_1}"
		"catapult-${CATAPULT_COMMIT_2:0:7}.tar.gz;catapult-${CATAPULT_COMMIT_2}"
		"cherry-${CHERRY_COMMIT:0:7}.tar.gz;cherry-${CHERRY_COMMIT}"
		"clang-${CLANG_COMMIT_1:0:7}.tar.gz;clang-${CLANG_COMMIT_1}"
		"clang-${CLANG_COMMIT_2:0:7}.tar.gz;clang-${CLANG_COMMIT_2}"
		"clang-${CLANG_COMMIT_3:0:7}.tar.gz;clang-${CLANG_COMMIT_3}"
		"clang-format-${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz;clang-format-${CLANG_FORMAT_COMMIT_1}"
		"clang-format-${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz;clang-format-${CLANG_FORMAT_COMMIT_2}"
		"clspv-${CLSPV_COMMIT:0:7}.tar.gz;clspv-${CLSPV_COMMIT}"
		"colorama-${COLORAMA_COMMIT:0:7}.tar.gz;colorama-${COLORAMA_COMMIT}"
		"cpu_features-${CPU_FEATURES_COMMIT:0:7}.tar.gz;cpu_features-${CPU_FEATURES_COMMIT}"
		"dawn-${DAWN_COMMIT_2:0:7}.tar.gz;dawn-${DAWN_COMMIT_2}"
		"depot_tools-${DEPOT_TOOLS_COMMIT_1:0:7}.tar.gz;depot_tools-${DEPOT_TOOLS_COMMIT_1}"
		"depot_tools-${DEPOT_TOOLS_COMMIT_2:0:7}.tar.gz;depot_tools-${DEPOT_TOOLS_COMMIT_2}"
		"depot_tools-${DEPOT_TOOLS_COMMIT_3:0:7}.tar.gz;depot_tools-${DEPOT_TOOLS_COMMIT_3}"
		"dxc-${DXC_COMMIT_1:0:7}.tar.gz;dxc-${DXC_COMMIT_1}"
		"dxc-${DXC_COMMIT_2:0:7}.tar.gz;dxc-${DXC_COMMIT_2}"
		"dxheaders-${DXHEADERS_COMMIT:0:7}.tar.gz;dxheaders-${DXHEADERS_COMMIT}"
		"egl-registry-${EGL_REGISTRY_COMMIT:0:7}.tar.gz;egl-registry-${EGL_REGISTRY_COMMIT}"
		"flatbuffers-${FLATBUFFERS_COMMIT:0:7}.tar.gz;flatbuffers-${FLATBUFFERS_COMMIT}"
		"git-hooks-${GIT_HOOKS_COMMIT:0:7}.tar.gz;git-hooks-${GIT_HOOKS_COMMIT}"
		"glfw-${GLFW_COMMIT:0:7}.tar.gz;glfw-${GLFW_COMMIT}"
		"glmark2-${GLMARK2_COMMIT:0:7}.tar.gz;glmark2-${GLMARK2_COMMIT}"
		"glslang-${GLSLANG_COMMIT_1:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_1}"
		"glslang-${GLSLANG_COMMIT_4:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_4}"
		"googletest-${GOOGLETEST_COMMIT_9:0:7}.tar.gz;googletest-${GOOGLETEST_COMMIT_9}"
		"ijar-${IJAR_COMMIT:0:7}.tar.gz;ijar-${IJAR_COMMIT}"
		"jinja2-${JINJA2_COMMIT_1:0:7}.tar.gz;jinja2-${JINJA2_COMMIT_1}"
		"jinja2-${JINJA2_COMMIT_2:0:7}.tar.gz;jinja2-${JINJA2_COMMIT_2}"
		"jsoncpp-${JSONCPP_COMMIT_3:0:7}.tar.gz;jsoncpp-${JSONCPP_COMMIT_3}"
		"libc++-${LIBCXX_COMMIT_1:0:7}.tar.gz;libc++-${LIBCXX_COMMIT_1}"
		"libc++-${LIBCXX_COMMIT_2:0:7}.tar.gz;libc++-${LIBCXX_COMMIT_2}"
		"libc++abi-${LIBCXXABI_COMMIT_1:0:7}.tar.gz;libc++abi-${LIBCXXABI_COMMIT_1}"
		"libc++abi-${LIBCXXABI_COMMIT_2:0:7}.tar.gz;libc++abi-${LIBCXXABI_COMMIT_2}"
		"libdrm-${LIBDRM_COMMIT_1:0:7}.tar.gz;libdrm-${LIBDRM_COMMIT_1}"
		"libdrm-${LIBDRM_COMMIT_2:0:7}.tar.gz;libdrm-${LIBDRM_COMMIT_2}"
		"libfuzzer-${LIBFUZZER_COMMIT:0:7}.tar.gz;libfuzzer-${LIBFUZZER_COMMIT}"
		"libjpeg_turbo-${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz;libjpeg_turbo-${LIBJPEG_TURBO_COMMIT}"
		"libpng-${LIBPNG_COMMIT:0:7}.tar.gz;libpng-${LIBPNG_COMMIT}"
		"libunwind-${LIBUNWIND_COMMIT:0:7}.tar.gz;libunwind-${LIBUNWIND_COMMIT}"
		"llvm-${LLVM_COMMIT:0:7}.tar.gz;llvm-${LLVM_COMMIT}"
		"llvm-libc-${LLVM_LIBC_COMMIT:0:7}.tar.gz;llvm-libc-${LLVM_LIBC_COMMIT}"
		"lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz;lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}"
		"lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_2:0:7}.tar.gz;lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_2}"
		"markupsafe-${MARKUPSAFE_COMMIT_1:0:7}.tar.gz;markupsafe-${MARKUPSAFE_COMMIT_1}"
		"markupsafe-${MARKUPSAFE_COMMIT_2:0:7}.tar.gz;markupsafe-${MARKUPSAFE_COMMIT_2}"
		"mb-${MB_COMMIT:0:7}.tar.gz;mb-${MB_COMMIT}"
		"md_browser-${MD_BROWSER_COMMIT:0:7}.tar.gz;md_browser-${MD_BROWSER_COMMIT}"
		"memory-${MEMORY_COMMIT:0:7}.tar.gz;memory-${MEMORY_COMMIT}"
		"mesa-${MESA_COMMIT:0:7}.tar.gz;mesa-${MESA_COMMIT}"
		"meson-${MESON_COMMIT:0:7}.tar.gz;meson-${MESON_COMMIT}"
		"nasm-${NASM_COMMIT:0:7}.tar.gz;nasm-${NASM_COMMIT}"
		"opencl-cts-${OPENCL_CTS_COMMIT:0:7}.tar.gz;opencl-cts-${OPENCL_CTS_COMMIT}"
		"opencl-docs-${OPENCL_DOCS_COMMIT:0:7}.tar.gz;opencl-docs-${OPENCL_DOCS_COMMIT}"
		"opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT:0:7}.tar.gz;opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT}"
		"opengl-registry-${OPENGL_REGISTRY_COMMIT:0:7}.tar.gz;opengl-registry-${OPENGL_REGISTRY_COMMIT}"
		"partition_allocator-${PARTITION_ALLOCATOR_COMMIT:0:7}.tar.gz;partition_allocator-${PARTITION_ALLOCATOR_COMMIT}"
		"perf-${PERF_COMMIT:0:7}.tar.gz;perf-${PERF_COMMIT}"
		"perfetto-${PERFETTO_COMMIT:0:7}.tar.gz;perfetto-${PERFETTO_COMMIT}"
		"protobuf-${PROTOBUF_COMMIT:0:7}.tar.gz;protobuf-${PROTOBUF_COMMIT}"
		"protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz;protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1}"
		"protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz;protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2}"
		"python-${PYTHON_COMMIT:0:7}.tar.gz;python-${PYTHON_COMMIT}"
		"python-markdown-${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz;python-markdown-${PYTHON_MARKDOWN_COMMIT}"
		"rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz;rapidjson-${RAPIDJSON_COMMIT}"
		"requests-${REQUESTS_COMMIT:0:7}.tar.gz;requests-${REQUESTS_COMMIT}"
		"rust-${RUST_COMMIT_1:0:7}.tar.gz;rust-${RUST_COMMIT_1}"
		"rust-${RUST_COMMIT_2:0:7}.tar.gz;rust-${RUST_COMMIT_2}"
		"rust-${RUST_COMMIT_3:0:7}.tar.gz;rust-${RUST_COMMIT_3}"
		"six-${SIX_COMMIT:0:7}.tar.gz;six-${SIX_COMMIT}"
		"spirv-cross-${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz;spirv-cross-${SPIRV_CROSS_COMMIT_1}"
		"spirv-headers-${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz;SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"
		"spirv-headers-${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz;SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}"
		"spirv-tools-${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz;SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"
		"spirv-tools-${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz;SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}"
		"swiftshader-${SWIFTSHADER_COMMIT_1:0:7}.tar.gz;swiftshader-${SWIFTSHADER_COMMIT_1}"
		"swiftshader-${SWIFTSHADER_COMMIT_2:0:7}.tar.gz;swiftshader-${SWIFTSHADER_COMMIT_2}"
		"testing-${TESTING_COMMIT_1:0:7}.tar.gz;testing-${TESTING_COMMIT_1}"
		"testing-${TESTING_COMMIT_2:0:7}.tar.gz;testing-${TESTING_COMMIT_2}"
		"valgrind-${VALGRIND_COMMIT:0:7}.tar.gz;valgrind-${VALGRIND_COMMIT}"
		"vk-gl-cts-${VK_GL_CTS_COMMIT:0:7}.tar.gz;vk-gl-cts-${VK_GL_CTS_COMMIT}"
		"vulkan-deps-${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz;vulkan-deps-${VULKAN_DEPS_COMMIT_1}"
		"vulkan-deps-${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz;vulkan-deps-${VULKAN_DEPS_COMMIT_2}"
		"vulkan-headers-${VULKAN_HEADERS_COMMIT_1:0:7}.tar.gz;vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"
		"vulkan-headers-${VULKAN_HEADERS_COMMIT_2:0:7}.tar.gz;vulkan-headers-${VULKAN_HEADERS_COMMIT_2}"
		"vulkan-loader-${VULKAN_LOADER_COMMIT_1:0:7}.tar.gz;vulkan-loader-${VULKAN_LOADER_COMMIT_1}"
		"vulkan-loader-${VULKAN_LOADER_COMMIT_2:0:7}.tar.gz;vulkan-loader-${VULKAN_LOADER_COMMIT_2}"
		"vulkan-tools-${VULKAN_TOOLS_COMMIT_1:0:7}.tar.gz;vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"
		"vulkan-tools-${VULKAN_TOOLS_COMMIT_2:0:7}.tar.gz;vulkan-tools-${VULKAN_TOOLS_COMMIT_2}"
		"vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1:0:7}.tar.gz;vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"
		"vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2:0:7}.tar.gz;vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}"
		"vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1:0:7}.tar.gz;vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}"
		"vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2:0:7}.tar.gz;vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}"
		"VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz;VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}"
		"VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz;VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2}"
		"wayland-${WAYLAND_COMMIT:0:7}.tar.gz;wayland-${WAYLAND_COMMIT}"
		"webgpu-cts-${WEBGPU_CTS_COMMIT:0:7}.tar.gz;webgpu-cts-${WEBGPU_CTS_COMMIT}"
		"webgpu-headers-${WEBGPU_HEADERS:0:7}.tar.gz;webgpu-headers-${WEBGPU_HEADERS}"
		"zlib-${ZLIB_COMMIT_1:0:7}.tar.gz;zlib-${ZLIB_COMMIT_1}"
		"zlib-${ZLIB_COMMIT_2:0:7}.tar.gz;zlib-${ZLIB_COMMIT_2}"
	)

	local f
	for f in ${ARGS[@]} ; do
		local is_no_root_submodule=0
		local row
		for row in ${NO_ROOT_DIR_TARBALLS[@]} ; do
			local f2="${row%;*}"
			local path="${row#*;}"
			if [[ "${f}" == "${f2}" ]] ; then
				mkdir -p "${WORKDIR}/${path}" || die
				pushd "${WORKDIR}/${path}" >/dev/null 2>&1 || die
					unpack "${f}"
				popd >/dev/null 2>&1 || die
				is_no_root_submodule=1
				break
			fi
		done
		local is_protoc_submodule=0
		for row in ${PROTOC_TARBALLS[@]} ; do
			local f2="${row%;*}"
			local path="${row#*;}"
			if [[ "${f}" == "${f2}" ]] ; then
				mkdir -p "${WORKDIR}/${path}" || die
				pushd "${WORKDIR}/${path}" >/dev/null 2>&1 || die
					unpack "${f}"
				popd >/dev/null 2>&1 || die
				is_protoc_submodule=1
				break
			fi
		done
		if (( ${is_no_root_submodule} == 0 && ${is_protoc_submodule} == 0 )) ; then
			unpack "${f}"
		fi
	done
}

src_unpack() {
	_unpack ${A}

	dep_prepare_mv "${WORKDIR}/emsdk-${EMSDK_COMMIT}" "${S}/cmake/external/emsdk"

	dep_prepare_mv "${WORKDIR}/onnx-${ONNX_PV_1}" "${S}/cmake/external/onnx"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/cmake/external/onnx/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/cmake/external/onnx/third_party/pybind11"

	dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV_1}" "${S}/cmake/external/onnx/third_party/abseil"
	dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_PV_2}" "${S}/cmake/external/onnx/third_party/protobuf"
	dep_prepare_mv "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_1}" "${S}/cmake/external/onnx/third_party/protobuf/third_party/jsoncpp"

	dep_prepare_mv "${WORKDIR}/coremltools-${COREMLTOOLS_PV}" "${S}/cmake/external/coremltools"
	dep_prepare_mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}" "${S}/cmake/external/pytorch_cpuinfo"
	dep_prepare_mv "${WORKDIR}/date-${DATE_PV_1}" "${S}/cmake/external/date-1"
	dep_prepare_mv "${WORKDIR}/date-${DATE_PV_2}" "${S}/cmake/external/date-2"
	dep_prepare_mv "${WORKDIR}/DirectX-Headers-${DIRECTX_HEADERS_PV}" "${S}/cmake/external/directx_headers"
	dep_prepare_mv "${WORKDIR}/dlpack-${DLPACK_COMMIT_2}" "${S}/cmake/external/dlpack"
	dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}" "${S}/cmake/external/flatbuffers"
	dep_prepare_mv "${WORKDIR}/GSL-${GSL_PV}" "${S}/cmake/external/microsoft_gsl"
	dep_prepare_mv "${WORKDIR}/json-${JSON_PV}" "${S}/cmake/external/json"
	dep_prepare_mv "${WORKDIR}/nsync-${NSYNC_PV}" "${S}/cmake/external/google_nsync"

	dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_PV_1}" "${S}/cmake/external/protobuf"
	if use benchmark ; then
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}" "${S}/cmake/external/protobuf/third_party/benchmark"
	fi

	dep_prepare_mv "${WORKDIR}/protoc_win64-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_win64"
	dep_prepare_mv "${WORKDIR}/protoc_win32-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_win32"
	dep_prepare_mv "${WORKDIR}/protoc_linux_x64-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_linux_x64"
	dep_prepare_mv "${WORKDIR}/protoc_linux_x86-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_linux_x86"
	dep_prepare_mv "${WORKDIR}/protoc_linux_aarch64-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_linux_aarch64"
	dep_prepare_mv "${WORKDIR}/protoc_mac_universal-${PROTOBUF_PV_1}" "${S}/cmake/external/protoc_mac_universal"

	dep_prepare_mv "${WORKDIR}/re2-${RE2_PV}" "${S}/cmake/external/re2"
	dep_prepare_mv "${WORKDIR}/SafeInt-${SAFEINT_PV}" "${S}/cmake/external/safeint"
	dep_prepare_mv "${WORKDIR}/mp11-boost-${MP11_PV}" "${S}/cmake/external/mp11"
	dep_prepare_mv "${WORKDIR}/utf8_range-${UTF8_RANGE_COMMIT}" "${S}/cmake/external/utf8_range"
	dep_prepare_mv "${WORKDIR}/wil-${WIL_PV}" "${S}/cmake/external/microsoft_wil"


	dep_prepare_mv "${WORKDIR}/dawn-${DAWN_COMMIT_1}" "${S}/cmake/external/dawn"
	dep_prepare_mv "${WORKDIR}/build-${BUILD_COMMIT_1}" "${S}/cmake/external/dawn/build"
	dep_prepare_cp "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_1}" "${S}/cmake/external/dawn/buildtools"
	dep_prepare_cp "${WORKDIR}/testing-${TESTING_COMMIT_1}" "${S}/cmake/external/dawn/testing"

	dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_3}" "${S}/cmake/external/dawn/third_party/abseil-cpp"

	dep_prepare_mv "${WORKDIR}/angle-${ANGLE_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle"
	dep_prepare_mv "${WORKDIR}/build-${BUILD_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/build"
	dep_prepare_mv "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/buildtools"
	dep_prepare_mv "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/clang-format/script"
	dep_prepare_mv "${WORKDIR}/testing-${TESTING_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/testing"
	dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/abseil-cpp"

	dep_prepare_mv "${WORKDIR}/android-deps-${ANDROID_DEPS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/android_deps"
	dep_prepare_mv "${WORKDIR}/android_build_tools-${ANDROID_BUILD_TOOLS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/android_build_tools"
	dep_prepare_mv "${WORKDIR}/android_platform-${ANDROID_PLATFORM_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/android_platform"
	dep_prepare_mv "${WORKDIR}/android_sdk-${ANDROID_SDK_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/android_sdk"

	dep_prepare_mv "${WORKDIR}/astc-encoder-${ASTC_ENCODER_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/astc-encoder/src"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_11}" "${S}/cmake/external/dawn/third_party/angle/third_party/astc-encoder/src/Source/GoogleTest"
	fi

	dep_prepare_mv "${WORKDIR}/catapult-${CATAPULT_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/catapult"
	dep_prepare_mv "${WORKDIR}/cherry-${CHERRY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/cherry"
	dep_prepare_mv "${WORKDIR}/colorama-${COLORAMA_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/colorama/src"
	dep_prepare_mv "${WORKDIR}/clspv-${CLSPV_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/clspv/src"
	dep_prepare_mv "${WORKDIR}/cpu_features-${CPU_FEATURES_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/cpu_features/src"

	dep_prepare_mv "${WORKDIR}/dawn-${DAWN_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn"
	dep_prepare_mv "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/buildtools"
	dep_prepare_cp "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/clang-format/script"
	dep_prepare_mv "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/depot_tools"
	dep_prepare_cp "${WORKDIR}/libc++-${LIBCXX_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libc++/src"
	dep_prepare_cp "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libc++abi/src"
	dep_prepare_mv "${WORKDIR}/build-${BUILD_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/build"
	dep_prepare_mv "${WORKDIR}/clang-${CLANG_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/clang"
	dep_prepare_mv "${WORKDIR}/rust-${RUST_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/rust"
	dep_prepare_mv "${WORKDIR}/testing-${TESTING_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/testing"
	dep_prepare_cp "${WORKDIR}/libfuzzer-${LIBFUZZER_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libFuzzer/src"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/catapult-${CATAPULT_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/catapult"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_5}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/google_benchmark/src"
	fi
	dep_prepare_cp "${WORKDIR}/jinja2-${JINJA2_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/jinja2"
	dep_prepare_cp "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/markupsafe"
	dep_prepare_cp "${WORKDIR}/glfw-${GLFW_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/glfw"
	dep_prepare_cp "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan_memory_allocator"
	dep_prepare_mv "${WORKDIR}/angle-${ANGLE_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/angle"

	dep_prepare_mv "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/cppdap-${CPPDAP_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/"
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/third_party/json"
	dep_prepare_cp "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/git-hooks"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/glslang"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/third_party/googletest"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/json"
	dep_prepare_cp "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/libbacktrace/src"
	dep_prepare_cp "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/llvm-project"
	dep_prepare_cp "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/PowerVR_Examples"

	dep_prepare_mv "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-validation-layers/src"

	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/glslang/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/spirv-cross/src"
	dep_prepare_mv "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/spirv-headers/src"
	dep_prepare_mv "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/spirv-tools/src"
	dep_prepare_mv "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-headers/src"
	dep_prepare_mv "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-loader/src"
	dep_prepare_mv "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-tools/src"
	dep_prepare_mv "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-utility-libraries/src"
	dep_prepare_mv "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-validation-layers/src"
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/zlib"
	dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/abseil-cpp"
	dep_prepare_mv "${WORKDIR}/dxc-${DXC_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc"
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxheaders"
	dep_prepare_cp "${WORKDIR}/webgpu-headers-${WEBGPU_HEADERS}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/webgpu-headers"
	dep_prepare_cp "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/khronos/OpenGL-Registry"
	dep_prepare_cp "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/khronos/EGL-Registry"
	dep_prepare_cp "${WORKDIR}/webgpu-cts-${WEBGPU_CTS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/webgpu-cts"
	dep_prepare_cp "${WORKDIR}/node-api-headers-${NODE_API_HEADERS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/node-api-headers"
	dep_prepare_cp "${WORKDIR}/node-addon-api-${NODE_ADDON_API_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/node-addon-api"
	dep_prepare_mv "${WORKDIR}/gpuweb-${GPUWEB_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/gpuweb"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/protobuf"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/protobuf/third_party/benchmark"
	fi
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_PV_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/protobuf/third_party/googletest"
	fi

	dep_prepare_cp "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/protoc_wrapper"
	dep_prepare_cp "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libprotobuf-mutator/src"
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/jsoncpp"

	dep_prepare_cp "${WORKDIR}/langsvr-${LANGSVR_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_6}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/lsprotocol-${LSPROTOCOL_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/lsprotocol"

	dep_prepare_cp "${WORKDIR}/partition_allocator-${PARTITION_ALLOCATOR_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/partition_alloc"


	dep_prepare_mv "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/depot_tools"
	dep_prepare_cp "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/EGL-Registry/src"
	dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/flatbuffers/src"
	#dep_prepare_mv "${WORKDIR}/gles1_conform-${}" "${S}/cmake/external/dawn/third_party/angle/third_party/gles1_conform"						# private
	dep_prepare_mv "${WORKDIR}/glmark2-${GLMARK2_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/glmark2/src"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_9}" "${S}/cmake/external/dawn/third_party/angle/third_party/googletest"
	fi
	dep_prepare_mv "${WORKDIR}/ijar-${IJAR_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/ijar"
	dep_prepare_mv "${WORKDIR}/libdrm-${LIBDRM_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/libdrm"
	dep_prepare_mv "${WORKDIR}/libjpeg_turbo-${LIBJPEG_TURBO_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/libjpeg_turbo"
	dep_prepare_mv "${WORKDIR}/libpng-${LIBPNG_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/libpng/src"
	dep_prepare_mv "${WORKDIR}/llvm-${LLVM_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/llvm/src"
	dep_prepare_mv "${WORKDIR}/jinja2-${JINJA2_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/jinja2"
	dep_prepare_mv "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/jsoncpp"
	dep_prepare_mv "${WORKDIR}/libc++-${LIBCXX_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/libc++/src"
	dep_prepare_mv "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/libc++abi/src"
	dep_prepare_mv "${WORKDIR}/libunwind-${LIBUNWIND_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/libunwind/src"
	dep_prepare_mv "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/markupsafe"
	dep_prepare_mv "${WORKDIR}/mesa-${MESA_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/mesa/src"
	dep_prepare_mv "${WORKDIR}/meson-${MESON_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/meson"
	dep_prepare_mv "${WORKDIR}/nasm-${NASM_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/nasm"
	dep_prepare_mv "${WORKDIR}/opencl-cts-${OPENCL_CTS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-CTS/src"
	dep_prepare_mv "${WORKDIR}/opencl-docs-${OPENCL_DOCS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-Docs/src"
	dep_prepare_mv "${WORKDIR}/opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-ICD-Loader/src"
	dep_prepare_cp "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/OpenGL-Registry/src"
	dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/perfetto"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/protobuf"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_4}" "${S}/cmake/external/dawn/third_party/angle/third_party/protobuf/third_party/benchmark"
	fi
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_PV_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/protobuf/third_party/googletest"
	fi

	dep_prepare_mv "${WORKDIR}/python-markdown-${PYTHON_MARKDOWN_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/Python-Markdown"
	dep_prepare_mv "${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/rapidjson/src"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_10}" "${S}/cmake/external/dawn/third_party/angle/third_party/rapidjson/src/thirdparty/gtest"
	fi
	dep_prepare_mv "${WORKDIR}/requests-${REQUESTS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/requests/src"
	dep_prepare_mv "${WORKDIR}/six-${SIX_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/six"

	dep_prepare_cp "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/cppdap-${CPPDAP_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/"
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/third_party/json"
	dep_prepare_cp "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/git-hooks"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/glslang"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/third_party/googletest"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/json"
	dep_prepare_cp "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/libbacktrace/src"
	dep_prepare_cp "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/llvm-project"
	dep_prepare_cp "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/PowerVR_Examples"

	dep_prepare_mv "${WORKDIR}/vk-gl-cts-${VK_GL_CTS_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/VK-GL-CTS/src"

	dep_prepare_cp "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-validation-layers/src"

	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-validation-layers/src"
	dep_prepare_mv "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/vulkan_memory_allocator"
	dep_prepare_mv "${WORKDIR}/wayland-${WAYLAND_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/third_party/wayland"
	dep_prepare_mv "${WORKDIR}/zlib-${ZLIB_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/third_party/zlib"
	dep_prepare_mv "${WORKDIR}/android-${ANDROID_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/android"
	dep_prepare_mv "${WORKDIR}/clang-${CLANG_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/tools/clang"
	dep_prepare_mv "${WORKDIR}/mb-${MB_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/mb"
	dep_prepare_mv "${WORKDIR}/md_browser-${MD_BROWSER_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/md_browser"
	dep_prepare_mv "${WORKDIR}/memory-${MEMORY_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/memory"
	dep_prepare_mv "${WORKDIR}/perf-${PERF_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/perf"
	dep_prepare_mv "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/tools/protoc_wrapper"
	dep_prepare_mv "${WORKDIR}/python-${PYTHON_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/python"
	dep_prepare_mv "${WORKDIR}/rust-${RUST_COMMIT_2}" "${S}/cmake/external/dawn/third_party/angle/tools/rust"
	dep_prepare_mv "${WORKDIR}/valgrind-${VALGRIND_COMMIT}" "${S}/cmake/external/dawn/third_party/angle/tools/valgrind"

	dep_prepare_mv "${WORKDIR}/catapult-${CATAPULT_COMMIT_1}" "${S}/cmake/external/dawn/third_party/catapult"
	dep_prepare_mv "${WORKDIR}/clang-${CLANG_COMMIT_1}" "${S}/cmake/external/dawn/tools/clang"
	dep_prepare_mv "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_1}" "${S}/cmake/external/dawn/third_party/clang-format/script"
	dep_prepare_mv "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/depot_tools"

	dep_prepare_mv "${WORKDIR}/dxc-${DXC_COMMIT_1}" "${S}/cmake/external/dawn/third_party/dxc"
	dep_prepare_mv "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/dxc/external/SPIRV-Headers"
	dep_prepare_mv "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_2}" "${S}/cmake/external/dawn/third_party/dxc/external/SPIRV-Tools"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_7}" "${S}/cmake/external/dawn/third_party/dxc/external/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}" "${S}/cmake/external/dawn/third_party/dxc/external/DirectX-Headers"

	dep_prepare_mv "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}" "${S}/cmake/external/dawn/third_party/dxheaders"
	dep_prepare_mv "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/khronos/EGL-Registry"
	dep_prepare_mv "${WORKDIR}/glfw-${GLFW_COMMIT}" "${S}/cmake/external/dawn/third_party/glfw"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/cmake/external/dawn/third_party/glslang/src"
	dep_prepare_mv "${WORKDIR}/gpuweb-${GPUWEB_COMMIT_1}" "${S}/cmake/external/dawn/third_party/gpuweb"
	dep_prepare_mv "${WORKDIR}/jinja2-${JINJA2_COMMIT_1}" "${S}/cmake/external/dawn/third_party/jinja2"
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_2}" "${S}/cmake/external/dawn/third_party/jsoncpp"

	dep_prepare_cp "${WORKDIR}/langsvr-${LANGSVR_COMMIT}" "${S}/cmake/external/dawn/third_party/langsvr"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_6}" "${S}/cmake/external/dawn/third_party/langsvr/third_party/googletest"
	fi
	dep_prepare_mv "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_2}" "${S}/cmake/external/dawn/third_party/langsvr/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/lsprotocol-${LSPROTOCOL_COMMIT}" "${S}/cmake/external/dawn/third_party/langsvr/third_party/lsprotocol"

	dep_prepare_mv "${WORKDIR}/libc++-${LIBCXX_COMMIT_1}" "${S}/cmake/external/dawn/third_party/libc++/src"
	dep_prepare_mv "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_1}" "${S}/cmake/external/dawn/third_party/libc++abi/src"
	dep_prepare_mv "${WORKDIR}/libdrm-${LIBDRM_COMMIT_1}" "${S}/cmake/external/dawn/third_party/libdrm/src"
	dep_prepare_mv "${WORKDIR}/libfuzzer-${LIBFUZZER_COMMIT}" "${S}/cmake/external/dawn/third_party/libFuzzer/src"
	dep_prepare_mv "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT}" "${S}/cmake/external/dawn/third_party/libprotobuf-mutator/src"
	dep_prepare_mv "${WORKDIR}/llvm-libc-${LLVM_LIBC_COMMIT}" "${S}/cmake/external/dawn/third_party/llvm-libc/src"
	dep_prepare_mv "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_1}" "${S}/cmake/external/dawn/third_party/markupsafe"
	dep_prepare_mv "${WORKDIR}/node-addon-api-${NODE_ADDON_API_COMMIT}" "${S}/cmake/external/dawn/third_party/node-addon-api"
	dep_prepare_mv "${WORKDIR}/node-api-headers-${NODE_API_HEADERS_COMMIT}" "${S}/cmake/external/dawn/third_party/node-api-headers"
	dep_prepare_mv "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT}" "${S}/cmake/external/dawn/third_party/khronos/OpenGL-Registry"
	dep_prepare_mv "${WORKDIR}/partition_allocator-${PARTITION_ALLOCATOR_COMMIT}" "${S}/cmake/external/dawn/third_party/partition_alloc"
	dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" "${S}/cmake/external/dawn/third_party/protobuf"
	if use benchmark ; then
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_4}" "${S}/cmake/external/dawn/third_party/protobuf/third_party/benchmark"
	fi
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_PV_2}" "${S}/cmake/external/dawn/third_party/protobuf/third_party/googletest"
	fi

	dep_prepare_mv "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1}" "${S}/cmake/external/dawn/tools/protoc_wrapper"
	dep_prepare_mv "${WORKDIR}/rust-${RUST_COMMIT_1}" "${S}/cmake/external/dawn/tools/rust"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/spirv-tools/src"

	dep_prepare_mv "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/swiftshader"
	if use benchmark ; then
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/benchmark"
	fi
	dep_prepare_mv "${WORKDIR}/cppdap-${CPPDAP_COMMIT}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/"
	dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_1}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/third_party/json"
	dep_prepare_mv "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/git-hooks"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/glslang"
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/googletest"
	fi
	dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_2}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/json"
	dep_prepare_mv "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/libbacktrace/src"
	dep_prepare_mv "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/llvm-project"
	dep_prepare_mv "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}" "${S}/cmake/external/dawn/third_party/swiftshader/third_party/PowerVR_Examples"

	dep_prepare_mv "${WORKDIR}/webgpu-cts-${WEBGPU_CTS_COMMIT}" "${S}/cmake/external/dawn/third_party/webgpu-cts"
	dep_prepare_mv "${WORKDIR}/webgpu-headers-${WEBGPU_HEADERS}" "${S}/cmake/external/dawn/third_party/webgpu-headers"
	dep_prepare_mv "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan_memory_allocator"

	dep_prepare_mv "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/glslang/src"
	dep_prepare_mv "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_mv "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_mv "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_mv "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-validation-layers/src"

	dep_prepare_mv "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-headers/src"
	dep_prepare_mv "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-loader/src"
	dep_prepare_mv "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-tools/src"
	dep_prepare_mv "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-utility-libraries/src"
	dep_prepare_mv "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}" "${S}/cmake/external/dawn/third_party/vulkan-validation-layers/src"
	dep_prepare_mv "${WORKDIR}/zlib-${ZLIB_COMMIT_1}" "${S}/cmake/external/dawn/third_party/zlib"

	if use benchmark ; then
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_5}" "${S}/cmake/external/dawn/third_party/google_benchmark/src"
	fi

	dep_prepare_mv "${WORKDIR}/kleidiai-v${KLEIDIAI_PV}" "${S}/cmake/external/kleidiai"

	if use abseil-cpp ; then
		dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV_2}" "${S}/cmake/external/abseil_cpp"
	fi
	if use benchmark ; then
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_PV}" "${S}/cmake/external/google_benchmark"
	fi
	if use cuda ; then
		dep_prepare_mv "${WORKDIR}/cudnn-frontend-${CUDNN_FRONTEND_PV}" "${S}/cmake/external/cudnn-frontend"
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_PV}" "${S}/cmake/external/cutlass"
	fi
	if use composable-kernel && ! use system-composable-kernel ; then
		dep_prepare_mv "${WORKDIR}/composable-kernel-${COMPOSABLE_KERNEL_COMMIT}" "${S}/cmake/external/composable_kernel"
	fi
	if ! use system-eigen ; then
		dep_prepare_mv "${WORKDIR}/eigen-${EIGEN_COMMIT}" "${S}/cmake/external/eigen"
	fi
	if use extensions ; then
		dep_prepare_mv "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}" "${S}/cmake/external/extensions"
	fi
	if use mimalloc ; then
		dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_PV}" "${S}/cmake/external/mimalloc"
	fi
	if use python ; then
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_PV}" "${S}/cmake/external/pybind11"
	fi
	if use training ; then
		dep_prepare_mv "${WORKDIR}/tensorboard-${TENSORBOARD_COMMIT}" "${S}/cmake/external/tensorboard"
	fi
	if use tensorrt-oss-parser ; then
		dep_prepare_mv "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}" "${S}/cmake/external/onnx_tensorrt"
		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_PV_2}" "${S}/cmake/external/onnx_tensorrt/third_party/onnx"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/cmake/external/onnx_tensorrt/third_party/onnx/third_party/pybind11"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/cmake/external/onnx_tensorrt/third_party/onnx/third_party/benchmark"
	fi
	if use test ; then
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_PV_1}" "${S}/cmake/external/googletest" # For onnxruntime_external_deps.cmake
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/cmake/external/flatbuffers/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}" "${S}/cmake/external/dawn/third_party/googletest"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_5}" "${S}/cmake/external/protobuf/third_party/googletest"
		if use benchmark ; then
			dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_2}" "${S}/cmake/external/flatbuffers/third_party/googlebenchmark"
		fi
	fi
	if use test || use training ; then
		dep_prepare_mv "${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}" "${S}/cmake/external/cxxopts"
	fi
	if use tvm ; then
		dep_prepare_mv "${WORKDIR}/tvm-${TVM_COMMIT}" "${S}/cmake/external/tvm"
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT}" "${S}/cmake/external/tvm/3rdparty/cutlass"
		dep_prepare_mv "${WORKDIR}/dlpack-${DLPACK_COMMIT_1}" "${S}/cmake/external/tvm/3rdparty/dlpack"
		dep_prepare_mv "${WORKDIR}/dmlc-core-${DMLC_CORE_COMMIT}" "${S}/cmake/external/tvm/3rdparty/dmlc-core"
		dep_prepare_mv "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_1}" "${S}/cmake/external/tvm/3rdparty/libbacktrace"
		dep_prepare_mv "${WORKDIR}/rang-${RANG_COMMIT}" "${S}/cmake/external/tvm/3rdparty/rang"
		dep_prepare_mv "${WORKDIR}/tvm-vta-${TVM_VTA_COMMIT}" "${S}/cmake/external/tvm/3rdparty/vta-hw"
	fi
	if use xnnpack ; then
		dep_prepare_mv "${WORKDIR}/FP16-${FP16_COMMIT}" "${S}/cmake/external/fp16"
		dep_prepare_mv "${WORKDIR}/FXdiv-${FXDIV_COMMIT}" "${S}/cmake/external/fxdiv"
		dep_prepare_mv "${WORKDIR}/psimd-${PSIMD_COMMIT}" "${S}/cmake/external/psimd"
		dep_prepare_mv "${WORKDIR}/XNNPACK-${XNNPACK_COMMIT}" "${S}/cmake/external/googlexnnpack"
		dep_prepare_mv "${WORKDIR}/pthreadpool-${PTHREADPOOL_COMMIT}" "${S}/cmake/external/pthreadpool"
	fi
}

src_prepare() {
	eapply ${_PATCHES[@]}

	CMAKE_USE_DIR="${S}/cmake"

	python_setup

	use cuda && cuda_src_prepare

	if use rocm ; then
		eapply "${FILESDIR}/${PN}-1.19.0-rocm-hardcoded-paths.patch"
	fi

	# Workaround for binary drivers.
	addpredict "/dev/ati"
	addpredict "/dev/dri"
	addpredict "/dev/nvidiactl"

	# fix build with gcc12(?), take idea from https://github.com/microsoft/onnxruntime/pull/11667 and https://github.com/microsoft/onnxruntime/pull/10014
	sed \
		-i \
		-e 's|dims)|TensorShape(dims))|g' \
		"onnxruntime/contrib_ops/cuda/quantization/qordered_ops/qordered_qdq.cc" \
		|| die

	# fix missing #include <iostream>
	sed \
		-i \
		-e '11a#include <iostream>' \
		"orttraining/orttraining/test/training_api/trainer/trainer.cc" \
		|| die

	sed \
		-i \
		-e 's/\"-mavx512f\"/\"-mavx512f -Wno-error\"/g' \
		"cmake/onnxruntime_mlas.cmake" \
		|| die

	#if use tensorrt ; then
		## Tensorrt 8.6 EA
		#eapply "${FILESDIR}/15089.diff"

		## Update Tensorboard 00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f
		#sed -e 's|373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81|00d59e65d866a6d4b9fe855dce81ee6ba8b40c4f|g' \
			#-e 's|67b833913605a4f3f499894ab11528a702c2b381|ff427b6a135344d86b65fa2928fbd29886eefaec|g' \
			#-i cmake/deps.txt || die sed "Sed failed"
					## Update onnx_tensorrt 6872a9473391a73b96741711d52b98c2c3e25146
					#sed -e 's|369d6676423c2a6dbf4a5665c4b5010240d99d3c|6872a9473391a73b96741711d52b98c2c3e25146|g' \
						#-e 's|62119892edfb78689061790140c439b111491275|75462057c95f7fdbc256179f0a0e9e4b7be28ae3|g' \
						#-i cmake/deps.txt || die sed "Sed failed"
	#fi

	cmake_src_prepare
	use rocm && rocm_src_prepare
}

src_configure() {
	ewarn "This ebuild is still in development.  Use the 1.19.x series instead."
	export ROCM_PATH="${ESYSROOT}/${EROCM_PATH}"
	export MIOPEN_PATH="${ESYSROOT}/${EROCM_PATH}"
	#export ROCM_VERSION="${ROCM_VERSION}"-

	python && python_setup
	CMAKE_BUILD_TYPE=$(usex debug RelWithDebInfo Release)
	CMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	CMAKE_TLS_VERIFY=ON
	PYTHON_EXECUTABLE="/usr/bin/${EPYTHON}"
	PYTHON_INCLUDE_DIR="$(python_get_includedir)"
	PYTHON_LIBRARY="$(python_get_library_path)"

	export CC="${CHOST}-gcc-12"
	export CXX="${CHOST}-g++-12"
	export CPP="${CC}"

	strip-unsupported-flags

	if use system-eigen ; then
		append-cppflags "-I/usr/include/eigen3"
	fi

#		$(test-flags-CXX -Wno-dangling-reference) \
	append-cxxflags \
		$(test-flags-CXX -Wno-c++20-compat) \
		$(test-flags-CXX -Wno-error=unused-parameter) \
		$(test-flags-CXX -Wno-error=maybe-uninitialized) \
		$(test-flags-CXX -Wno-array-bounds) \
		$(test-flags-CXX -Wno-stringop-overread)

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
		-DFETCHCONTENT_SOURCE_DIR_CXXOPTS="${S}/cmake/external/flatbuffers/third_party/cxxopts"
		-DFETCHCONTENT_SOURCE_DIR_DATE="${S}/cmake/external/date-1"
		-DFETCHCONTENT_SOURCE_DIR_DATE_SRC="${S}/cmake/external/date-2"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${S}/cmake/external/flatbuffers"
		-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC="${S}/cmake/external/google_nsync"
		-DFETCHCONTENT_SOURCE_DIR_GSL="${S}/cmake/external/microsoft_gsl"
		-DFETCHCONTENT_SOURCE_DIR_MP11="${S}/cmake/external/mp11"
		-DFETCHCONTENT_SOURCE_DIR_MICROSOFT_WIL="${S}/cmake/external/microsoft_wil"
		-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON="${S}/cmake/external/json"
		-DFETCHCONTENT_SOURCE_DIR_ONNX="${S}/cmake/external/onnx"
		-DFETCHCONTENT_SOURCE_DIR_ABSEIL="${S}/cmake/external/onnx/third_party/abseil" # For cmake/external/onnx/CMakeLists.txt
		-DFETCHCONTENT_SOURCE_DIR_DAWN="${S}/cmake/external/dawn"
		-DFETCHCONTENT_SOURCE_DIR_KLEIDIAI="${S}/cmake/external/kleidiai"
		#-DFETCHCONTENT_SOURCE_DIR_PROTOBUF="${S}/cmake/external/onnx/third_party/protobuf" # For cmake/external/onnx/CMakeLists.txt # Disabled because it is ambiguous.
		-DFETCHCONTENT_SOURCE_DIR_PROTOBUF="${S}/cmake/external/protobuf"
		-DFETCHCONTENT_SOURCE_DIR_PYBIND11_PROJECT="${S}/cmake/external/pybind11"
		-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG="${S}/cmake/external/pytorch_cpuinfo"
		-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CPUINFO="${S}/cmake/external/pytorch_cpuinfo"
		-DFETCHCONTENT_SOURCE_DIR_RE2="${S}/cmake/external/re2"
		-DFETCHCONTENT_SOURCE_DIR_SAFEINT="${S}/cmake/external/safeint"
		-DFETCHCONTENT_SOURCE_DIR_UTF8_RANGE="${S}/cmake/external/utf8_range"

# We use vendored packages because the build scripts get confused between system and vendored.
# Using ALWAYS causes confusion between system's abseil and vendored abseil.
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=NEVER

		-Donnxruntime_ARMNN_BN_USE_CPU=ON
		-Donnxruntime_ARMNN_RELU_USE_CPU=ON
		-Donnxruntime_BUILD_APPLE_FRAMEWORK=OFF
		-Donnxruntime_BUILD_BENCHMARKS=$(usex benchmark)
		-Donnxruntime_BUILD_CSHARP=OFF
		-Donnxruntime_BUILD_FOR_NATIVE_MACHINE=OFF
		-Donnxruntime_BUILD_JAVA=OFF
		-Donnxruntime_BUILD_MS_EXPERIMENTAL_OPS=OFF
		-Donnxruntime_BUILD_NODEJS=OFF
		-Donnxruntime_BUILD_OBJC=OFF
		-Donnxruntime_BUILD_SHARED_LIB=ON

		-Donnxruntime_BUILD_UNIT_TESTS=$(usex test)
		-Donnxruntime_BUILD_WEBASSEMBLY_STATIC_LIB=OFF
		-Donnxruntime_CROSS_COMPILING=$(tc-is-cross-compiler && echo ON || echo OFF)
		-Donnxruntime_DISABLE_ABSEIL=$(usex !abseil-cpp)
		-Donnxruntime_DISABLE_CONTRIB_OPS=ON
		-Donnxruntime_DISABLE_EXCEPTIONS=$(usex !debug)
		-Donnxruntime_DISABLE_ML_OPS=ON
		-Donnxruntime_DISABLE_RTTI=OFF
		-Donnxruntime_ENABLE_CPU_FP16_OPS=OFF
		-Donnxruntime_ENABLE_EAGER_MODE=OFF
		-Donnxruntime_ENABLE_EXTERNAL_CUSTOM_OP_SCHEMAS=OFF
		-Donnxruntime_ENABLE_LANGUAGE_INTEROP_OPS=OFF
		-Donnxruntime_ENABLE_LAZY_TENSOR=OFF
		-Donnxruntime_ENABLE_LTO=$(usex lto)
		-Donnxruntime_ENABLE_MEMLEAK_CHECKER=ON
		-Donnxruntime_ENABLE_MEMORY_PROFILE=OFF
		-Donnxruntime_ENABLE_MICROSOFT_INTERNAL=OFF
		-Donnxruntime_ENABLE_NVTX_PROFILE=OFF
		-Donnxruntime_ENABLE_PYTHON=$(usex python)
		-Donnxruntime_ENABLE_ROCM_PROFILING=OFF
		-Donnxruntime_ENABLE_TRAINING=$(usex training)
		-Donnxruntime_ENABLE_TRAINING_OPS=OFF
		-Donnxruntime_ENABLE_TRAINING_APIS=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_API_EXCEPTION_CATCHING=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_DEBUG_INFO=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_CATCHING=ON
		-Donnxruntime_ENABLE_WEBASSEMBLY_EXCEPTION_THROWING=ON
		-Donnxruntime_ENABLE_WEBASSEMBLY_PROFILING=OFF
		-Donnxruntime_ENABLE_WEBASSEMBLY_THREADS=OFF
		-Donnxruntime_EXTENDED_MINIMAL_BUILD=OFF
		-Donnxruntime_GCOV_COVERAGE=OFF
		-Donnxruntime_MINIMAL_BUILD=OFF
		-Donnxruntime_MINIMAL_BUILD_CUSTOM_OPS=OFF
		-Donnxruntime_PYBIND_EXPORT_OPSCHEMA=OFF
		-Donnxruntime_REDUCED_OPS_BUILD=OFF
		-Donnxruntime_REQUIRE_PYTHON_EMBED_LIB=OFF
		-Donnxruntime_RUN_ONNX_TESTS=$(usex test)
		-Donnxruntime_USE_ACL=OFF
		-Donnxruntime_USE_ACL_1902=OFF
		-Donnxruntime_USE_ACL_1905=OFF
		-Donnxruntime_USE_ACL_1908=OFF
		-Donnxruntime_USE_ACL_2002=OFF
		-Donnxruntime_USE_ARMNN=OFF
		-Donnxruntime_USE_AVX=$(usex cpu_flags_x86_avx)
		-Donnxruntime_USE_AVX2=$(usex cpu_flags_x86_avx2)
		-Donnxruntime_USE_AVX512=$(usex cpu_flags_x86_avx512)
		-Donnxruntime_USE_CANN=OFF
		-Donnxruntime_USE_CUDA=$(usex cuda)
		-Donnxruntime_USE_DML=OFF
		-Donnxruntime_USE_DNNL=$(usex onednn)
		-Donnxruntime_USE_EXTENSIONS=$(usex extensions)
		-Donnxruntime_USE_FULL_PROTOBUF=OFF
		-Donnxruntime_USE_JSEP=$(usex javascript)
		-Donnxruntime_USE_LLVM=$(usex llvm)
		-Donnxruntime_USE_MIGRAPHX=$(usex migraphx)
		-Donnxruntime_USE_MIMALLOC=$(usex mimalloc)
		-Donnxruntime_USE_MPI=$(usex mpi)
		-Donnxruntime_USE_NCCL=OFF
		-Donnxruntime_USE_NNAPI_BUILTIN=OFF
		-Donnxruntime_USE_OPENVINO=$(usex openvino)
		-Donnxruntime_USE_PREINSTALLED_EIGEN=$(usex system-eigen)
		-Donnxruntime_USE_RKNPU=OFF
		-Donnxruntime_USE_ROCM=$(usex rocm)
		-Donnxruntime_USE_TELEMETRY=OFF
		-Donnxruntime_USE_TENSORRT=$(usex tensorrt)
		-Donnxruntime_USE_TENSORRT_BUILTIN_PARSER=$(usex !tensorrt-oss-parser)
		-Donnxruntime_USE_TVM=$(usex tvm)
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_TVM_USE_HASH=OFF
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
	)

	if use abseil-cpp ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP="${S}/cmake/external/abseil_cpp"
		)
	fi

	if use benchmark ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_GOOGLE_BENCHMARK="${S}/cmake/external/google_benchmark" # For onnxruntime_external_deps.cmake
			-DFETCHCONTENT_SOURCE_DIR_GOOGLEBENCHMARK="${S}/cmake/external/flatbuffers/third_party/googlebenchmark" # flatbuffers
			-DFETCHCONTENT_SOURCE_DIR_BENCHMARK="${S}/cmake/external/google_benchmark" # json
		)
	fi

	if use composable-kernel && use system-composable-kernel ; then
		mycmakeargs+=(
			-DCOMPOSABLE_KERNEL_DIR="${ESYSROOT}/${EROCM_PATH}/lib/cmake/composable-kernel" # TODO verify against multislot
		)
	elif use composable-kernel && ! use system-composable-kernel ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_COMPOSABLE_KERNEL="${S}/cmake/external/composable_kernel"
		)
	fi

	if use cuda ; then
		local CA
		for CA in ${CUDA_TARGETS_COMPAT[*]}; do
			use "${CA/#/cuda_targets_}" && CUDA_ARCH+="${CA#sm_*}-real;"
		done
		mycmakeargs+=(
			-DCMAKE_CUDA_ARCHITECTURES="${CUDA_ARCH%%;}"
			-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gccdir)"
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts -fno-lto ${NVCCFLAGS}"
			-DCMAKE_CUDA_STANDARD_REQUIRED=ON
			-DCMAKE_CXX_STANDARD_REQUIRED=ON
			-DFETCHCONTENT_SOURCE_DIR_CUDNN_FRONTEND="${S}/cmake/external/cudnn-frontend"
			-DFETCHCONTENT_SOURCE_DIR_CUTLASS="${S}/cmake/external/cutlass"
			-Donnxruntime_CUDA_HOME="/opt/cuda"
			-Donnxruntime_CUDNN_HOME="/usr"
			-Donnxruntime_ENABLE_CUDA_LINE_NUMBER_INFO=OFF
			-Donnxruntime_ENABLE_CUDA_PROFILING=OFF
			-Donnxruntime_NVCC_THREADS=1
			-Donnxruntime_TVM_CUDA_RUNTIME=OFF
			-Donnxruntime_USE_NCCL=OFF # Multi GPU CUDA
		)
	fi

	if use system-eigen ; then
		mycmakeargs+=(
			-Deigen_SOURCE_PATH="/usr/include/eigen3"
		)
	else
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_EIGEN="${S}/cmake/external/eigen"
		)
	fi

	if use extensions ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_EXTENSIONS="${S}/cmake/external/extensions"
		)
	fi

	if use mimalloc ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_MIMALLOC="${S}/cmake/external/mimalloc"
		)
	fi

	if use openvino ; then
		mycmakeargs+=(
			-Donnxruntime_USE_OPENVINO_AUTO=$(usex openvino-auto)
			-Donnxruntime_USE_OPENVINO_CPU=$(usex openvino_targets_cpu)
			-Donnxruntime_USE_OPENVINO_CPU_NP=$(usex openvino_targets_cpu_np)
			-Donnxruntime_USE_OPENVINO_GPU=$(usex openvino_targets_gpu)
			-Donnxruntime_USE_OPENVINO_GPU_NP=$(usex openvino_targets_gpu_np)
			-Donnxruntime_USE_OPENVINO_HETERO=$(usex openvino-hetero)
			-Donnxruntime_USE_OPENVINO_MULTI=$(usex openvino-multi)
			-Donnxruntime_USE_OPENVINO_NPU=$(usex openvino_targets_npu)
			-Donnxruntime_USE_OPENVINO_NPU_NP=$(usex openvino_targets_npu_np)
		)
	fi

	if use python ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_PYBIND11="${S}/cmake/external/pybind11"
		)
	fi

	if use rocm ; then
		mycmakeargs+=(
			-DCMAKE_HIP_ARCHITECTURES="$(get_amdgpu_flags)"
			-DCMAKE_HIP_COMPILER="${ESYSROOT}/${EROCM_PATH}/llvm/bin/clang++"
			-Donnxruntime_ENABLE_TRITON=$(usex triton)
			-Donnxruntime_ROCM_HOME="${ESYSROOT}/${EROCM_PATH}"
			-Donnxruntime_ROCM_VERSION="${ROCM_VERSION}"
			-Donnxruntime_USE_TRITON_KERNEL=$(usex triton)
			-Donnxruntime_USE_COMPOSABLE_KERNEL=$(usex composable-kernel)
		)
		if use amdgpu_targets_gfx90a ; then
			mycmakeargs+=(
				-Donnxruntime_USE_HIPBLASLT=ON
			)
		else
			mycmakeargs+=(
				-Donnxruntime_USE_HIPBLASLT=OFF
			)
		fi
	fi

	if use training ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_TENSORBOARD="${S}/cmake/external/tensorboard"
		)
	fi

	if use tensorrt-oss-parser ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_ONNX_TENSORRT="${S}/cmake/external/onnx_tensorrt"
			-Donnx_tensorrt_SOURCE_PATH="${S}/cmake/external/onnx-tensorrt"
		)
	fi

	if use test ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST="${S}/cmake/external/googletest" # For onnxruntime_external_deps.cmake and onnx
		)
	fi

	if use test || use training ; then
		mycmakeargs+=(
		)
	fi

	if use tvm ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_TVM="${S}/cmake/external/tvm"
		)
	fi

	if use xnnpack ; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_FP16="${S}/cmake/external/fp16"
			-DFETCHCONTENT_SOURCE_DIR_FXDIV="${S}/cmake/external/fxdiv"
			-DFETCHCONTENT_SOURCE_DIR_GOOGLEXNNPACK="${S}/cmake/external/googlexnnpack"
			-DFETCHCONTENT_SOURCE_DIR_PSIMD="${S}/cmake/external/psimd"
			-DFETCHCONTENT_SOURCE_DIR_PTHREADPOOL="${S}/cmake/external/pthreadpool"
		)
	fi


	if use rocm ; then
		rocm_src_configure
	else
		cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	if use python ; then
		cd "cmake" || die
		cp -a \
			"../"{"setup.py","pyproject.toml","docs"} \
			"." \
			|| die
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install
	if use python ; then
		cd cmake
		distutils-r1_src_install
	fi
	if use rocm ; then
		rocm_mv_docs
		rocm_fix_rpath
	fi

# Generated from
# find /var/tmp/portage/sci-ml/onnxruntime-1.20.2/work/onnxruntime-1.20.2/cmake/_deps -name "*.so*" | cut -f 9- -d "/"
	local LIBS=(
cmake/_deps/pytorch_cpuinfo-build/libcpuinfo.so
cmake/_deps/re2-build/libre2.so.11
cmake/_deps/re2-build/libre2.so.11.0.0
cmake/_deps/re2-build/libre2.so
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_optional_access.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_optional_access.so
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_variant_access.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/types/libabsl_bad_variant_access.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_sink.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_message.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_proto.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_nullguard.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_check_op.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_log_sink_set.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_proto.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_globals.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_log_sink_set.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_globals.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_vlog_config_internal.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_format.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_fnmatch.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_format.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_entry.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_globals.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_globals.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_sink.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_check_op.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_vlog_config_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_message.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_entry.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_fnmatch.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_nullguard.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_conditions.so
cmake/_deps/abseil_cpp-build/absl/log/libabsl_log_internal_conditions.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_handle.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_str_format_internal.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_string_view.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cord_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_string_view.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_info.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_functions.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_info.so
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_handle.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_str_format_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_strings.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/strings/libabsl_cordz_functions.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_program_name.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_private_handle_accessor.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_config.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_config.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_internal.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_private_handle_accessor.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_program_name.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_marshalling.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_marshalling.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag_internal.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_reflection.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_reflection.so
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/flags/libabsl_flags_commandlineflag.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_civil_time.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time.so
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time_zone.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/time/libabsl_civil_time.so
cmake/_deps/abseil_cpp-build/absl/time/libabsl_time_zone.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_synchronization.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_graphcycles_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_graphcycles_internal.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_kernel_timeout_internal.so
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_kernel_timeout_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/synchronization/libabsl_synchronization.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/container/libabsl_raw_hash_set.so
cmake/_deps/abseil_cpp-build/absl/container/libabsl_raw_hash_set.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/container/libabsl_hashtablez_sampler.so
cmake/_deps/abseil_cpp-build/absl/container/libabsl_hashtablez_sampler.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_low_level_hash.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_hash.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_city.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_hash.so
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_low_level_hash.so
cmake/_deps/abseil_cpp-build/absl/hash/libabsl_city.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_spinlock_wait.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_spinlock_wait.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_base.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_strerror.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_raw_logging_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_throw_delegate.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_malloc_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_throw_delegate.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_log_severity.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/base/libabsl_malloc_internal.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_strerror.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_raw_logging_internal.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_log_severity.so
cmake/_deps/abseil_cpp-build/absl/base/libabsl_base.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/numeric/libabsl_int128.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/numeric/libabsl_int128.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cord_state.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_internal.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc32c.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cord_state.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cpu_detect.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_cpu_detect.so
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc32c.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/crc/libabsl_crc_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_examine_stack.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_utf8_for_code_point.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_rust.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_symbolize.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_stacktrace.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_stacktrace.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_debugging_internal.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_utf8_for_code_point.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_rust.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_symbolize.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_decode_rust_punycode.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_decode_rust_punycode.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_debugging_internal.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_demangle_internal.so
cmake/_deps/abseil_cpp-build/absl/debugging/libabsl_examine_stack.so
cmake/_deps/abseil_cpp-build/absl/profiling/libabsl_exponential_biased.so.2407.0.0
cmake/_deps/abseil_cpp-build/absl/profiling/libabsl_exponential_biased.so
cmake/_deps/onnx-build/libonnx_proto.so
cmake/_deps/onnx-build/libonnx.so
cmake/_deps/protobuf-build/libprotobuf.so.32
cmake/_deps/protobuf-build/libprotobuf-lite.so.32
cmake/_deps/protobuf-build/libprotoc.so
cmake/_deps/protobuf-build/libprotobuf.so
cmake/_deps/protobuf-build/libprotoc.so.3.21.12.0
cmake/_deps/protobuf-build/libprotobuf-lite.so
cmake/_deps/protobuf-build/libprotobuf-lite.so.3.21.12.0
cmake/_deps/protobuf-build/libprotoc.so.32
cmake/_deps/protobuf-build/libprotobuf.so.3.21.12.0
	)

	cd "${S}" || die
	keepdir "/usr/$(get_libdir)/${PN}"
	exeinto "/usr/$(get_libdir)/${PN}"
	local path
	for path in ${LIBS[@]} ; do
		if [[ -L "${path}" ]] ; then
			cp -a "${path}" "${ED}/usr/$(get_libdir)/${PN}" || die
		else
			doexe "${path}"
		fi
	done

	for path in $(find "${ED}" -type f) ; do
		if file "${path}" | grep -q "ELF.*shared object" ; then
			patchelf --set-rpath "/usr/$(get_libdir)/${PN}:\$ORIGIN" "${path}" || die
		fi
	done
}
