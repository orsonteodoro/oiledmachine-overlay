# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22 - GCC 12.2

# TODO:
# Review and add vendored python packages.
# dawn .gitmodules
# Change configure for re2

# 1.20.0 -> 1.20.2
# 1.20.2 -> 1.26.0

# TODO package (optional):
# lintrunner-adapters
# onnxmltools
# pydocstyle
# tensorrt
# torch-ort

# For deps versioning, see
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/deps.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/tools/ci_build/github/linux/docker/scripts/manylinux/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/python/tools/transformers/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/external/dnnl.cmake#L5
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-dev.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-doc.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-lintrunner.txt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/requirements-training.txt
# https://github.com/google/dawn/blob/511eb80847afe6bded34ec491a38d5d78ba2d604/DEPS
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.cuda
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.openvino
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.rocm
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/Dockerfile.tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/python/tools/transformers/models/llama/requirements-cuda.txt#L2
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#cuda
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#openvino
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#tensorrt
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/dockerfiles/README.md#rocm
# https://github.com/microsoft/onnxruntime/blob/v1.26.0/tools/ci_build/github/linux/docker/inference/x86_64/python/openvino/Dockerfile#L25

# clog has same version as cpuinfo

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CMAKE_IN_SOURCE_BUILD=1
CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_OPTIONAL=1
PYTHON_COMPAT=( "python3_"{10..12} )
RE2_SLOT="20250512"
ENABLE_WEBGPU=0

ABSEIL_CPP_PV_2="20250814.0" # From cmake/deps.txt
BENCHMARK_PV="1.8.5" # onnxruntime dep
COREMLTOOLS_PV="7.1" # From cmake/deps.txt
CUDNN_FRONTEND_PV="1.12.0" # From cmake/deps.txt as cudnn_frontend
CUTLASS_PV="4.4.2" # From cmake/deps.txt
DATE_PV_1="3.0.1" # From cmake/deps.txt
DIRECTX_HEADERS_PV="1.613.1"
DUKTAPE_PV="2.7.0" # From From cmake/deps.txt
EMSDK_PV="4.0.23" # From .gitmodules
FLATBUFFERS_PV="23.5.26" # From cmake/deps.txt
GOOGLETEST_PV_1="1.17.0" # From cmake/deps.txt
GSL_PV="4.0.0" # From cmake/deps.txt
JSON_PV="3.11.3" # From cmake/deps.txt
KLEIDIAI_PV="1.20.0" # From cmake/deps.txt
MP11_PV="1.82.0" # From cmake/deps.txt
ONNX_PV_1="1.21.0" # From .gitmodules or cmake/deps.txt
MIMALLOC_PV="2.1.1" # From cmake/deps.txt
OPENVINO_PV="2026.1.0"
PROTOBUF_PV_1="21.12" # From cmake/deps.txt
PYBIND11_PV="3.0.2" # From cmake/deps.txt, onnxruntime dep
RE2_PV="2024-07-02" # From cmake/deps.txt
SAFEINT_PV="3.0.28" # From cmake/deps.txt
VULKAN_HEADERS_PV="1.4.344" # From cmake/deps.txt
WIL_PV="1.0.250325.1" # From cmake/deps.txt as microsoft_wil

LIBPROTOBUF_MUTATOR_COMMIT_1="7a2ed51a6b682a83e345ff49fc4cfd7ca47550db" # From .gitmodules

CPUINFO_COMMIT="403d652dca4c1046e8145950b1c0997a9f748b57" # From cmake/deps.txt
CXXOPTS_COMMIT="3c73d91c0b04e2b59462f0a741be8c07024c1bc0" # From cmake/deps.txt
DAWN_COMMIT_1="ec7b457e5bb1fcec6f59733c4f3dd84d2f885a38" # From cmake/deps.txt
DLPACK_COMMIT_2="5c210da409e7f1e51ddf445134a4376fdbd70d7d" # From cmake/deps.txt
EIGEN_COMMIT="1d8b82b0740839c0de7f1242a3585e3390ff5f33" # From cmake/deps.txt
FP16_COMMIT="0a92994d729ff76a58f692d3028ca1b64b145d91" # From cmake/deps.txt
FXDIV_COMMIT="63058eff77e11aa15bf531df5dd34395ec3017c8" # From cmake/deps.txt
KLEIDIAI_QMX_COMMIT="2f10c9a8d32f81ffeeb6d4885a29cc35d2b0da87" # From cmake/deps.txt
PSIMD_COMMIT="072586a71b55b7f8c584153d223e95687148a900" # From cmake/deps.txt
ONNX_TENSORRT_COMMIT="d5dce67db7c2e64b07e055571f5ec06f7f254de2" # From cmake/deps.txt
ONNXRUNTIME_EXTENSIONS_COMMIT="c24b7bab0c12f53da76d0c31b03b9f0f8ec8f3b4" # From cmake/deps.txt
PTHREADPOOL_COMMIT="dcc9f28589066af0dbd4555579281230abbf74dd" # From cmake/deps.txt
TENSORBOARD_COMMIT="373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81" # From cmake/deps.txt
XNNPACK_COMMIT="3cf85e705098622d59056dcb8f5f963ea7bb0a00" # From cmake/deps.txt

ONNX_COMMIT_1="dfba0ad9ca26d584a8b71e3f4569fd62f85c2932" # external/onnx-tensorrt dep
PYBIND11_COMMIT_1="a2e59f0e7065404b44dfe92a28aca47ba1378dc4" # external/onnx-tensorrt/onnx dep

BENCHMARK_COMMIT_3="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # external/protobuf dep
GOOGLETEST_COMMIT_5="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # external/protobuf dep

BENCHMARK_COMMIT_2="0d98dba29d66e93259db7daa53a9327df767a415" # external/flatbuffers dep, from cmake/external/flatbuffers/benchmarks/CMakeLists.txt
GOOGLETEST_COMMIT_3="e2239ee6043f73722e7aa812a459f54a28552929" # external/flatbuffers from cmake/external/flatbuffers/benchmarks/CMakeLists.txt, or dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/astc-encoder dep, dawn/angle/dawn/swiftshader dep

# dawn
ABSEIL_CPP_COMMIT_3="7ef32bbacabd0d04a6cfac92a542841c531e1b21" # dawn (DAWN_COMMIT_1) dep
ANGLE_COMMIT_1="cce16dfb64c7525c6a417f98c67423330db8f3d7" # dawn (DAWN_COMMIT_1) dep
BENCHMARK_COMMIT_5="188e8278990a9069ffc84441cb5a024fd0bede37" # dawn (DAWN_COMMIT_1) dep
BUILD_COMMIT_1="4c2c31b6776c1fe03a029f66ef530796f0add90d" # dawn (DAWN_COMMIT_1) dep
BUILDTOOLS_COMMIT_1="6a18683f555b4ac8b05ac8395c29c84483ac9588" # dawn (DAWN_COMMIT_1) dep
CATAPULT_COMMIT_1="59090f1f5e2b3ad9c90e4dc5fc8e79aed9110587" # dawn (DAWN_COMMIT_1) dep
CLANG_COMMIT_1="7fd7d7092fa5ee06380f06f66f1b7bd03fca71a8" # dawn (DAWN_COMMIT_1) dep
CLANG_FORMAT_COMMIT_1="c2725e0622e1a86d55f14514f2177a39efea4a0e" # dawn (DAWN_COMMIT_1) dep
DEPOT_TOOLS_COMMIT_1="425882d8c0acaab53bf2f8abbe7efcf5db5b168b" # dawn (DAWN_COMMIT_1) dep
DXC_COMMIT_1="3e6e148537683c22e3e74977d56516f16f39c7be" # dawn (DAWN_COMMIT_1) dep
DXHEADERS_COMMIT="980971e835876dc0cde415e8f9bc646e64667bf7" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep, dawn/dxc dep, dawn/angle/dawn/dxc dep
EGL_REGISTRY_COMMIT="7dea2ed79187cd13f76183c4b9100159b9e3e071" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/angle/dawn dep
EMSDK_COMMIT_1="b4258c35121c8d0e12f53568ffb22236d7816723" # dawn (DAWN_COMMIT_1) dep
GLFW_COMMIT_1="b35641f4a3c62aa86a0b3c983d163bc0fe36026d" # dawn (DAWN_COMMIT_1) dep
GLSLANG_COMMIT_1="022de31e7ffa5230068858d9e6cd85ae11170bda" # dawn (DAWN_COMMIT_1)
GOOGLETEST_COMMIT_4="4fe3307fb2d9f86d19777c7eb0e4809e9694dde7" # dawn (DAWN_COMMIT_1) dep
GPUWEB_COMMIT_1="b4b5752ff755fe33bf6a67fb6e5964ba9d40dcdc" # dawn (DAWN_COMMIT_1) dep
JINJA2_COMMIT_1="c3027d884967773057bf74b957e3fea87e5df4d7" # dawn (DAWN_COMMIT_1) dep
JSONCPP_COMMIT_2="42e892d96e47b1f6e29844cc705e148ec4856448" # dawn (DAWN_COMMIT_1) dep
LANGSVR_COMMIT="303c526231a90049a3e384549720f3fbd453cf66" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep
LIBCXX_COMMIT_1="7ab65651aed6802d2599dcb7a73b1f82d5179d05" # dawn (DAWN_COMMIT_1) dep
LIBCXXABI_COMMIT_1="8f11bb1d4438d0239d0dfc1bd9456a9f31629dda" # dawn (DAWN_COMMIT_1) dep
LIBDRM_COMMIT_1="369990d9660a387f618d0eedc341eb285016243b" # dawn (DAWN_COMMIT_1) dep
LIBFUZZER_COMMIT_1="bea408a6e01f0f7e6c82a43121fe3af4506c932e" # dawn (DAWN_COMMIT_1) dep
LIBPROTOBUF_MUTATOR_COMMIT_2="7bf98f78a30b067e22420ff699348f084f802e12" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep
LLVM_LIBC_COMMIT_1="d38523b674e26b7c8d61ed2e48d6cfe248b12da0" # dawn (DAWN_COMMIT_1) dep
MARKUPSAFE_COMMIT_1="4256084ae14175d38a3ff7d739dca83ae49ccec6" # dawn (DAWN_COMMIT_1) dep
MB_COMMIT_1="a975ec0340bd4b7dab6c8e43b15dbc638621a23c" # dawn (DAWN_COMMIT_1) dep
MEMORY_COMMIT_1="b635f27e932356a2e29450e5cfa544cdcc9ea6bb" # dawn (DAWN_COMMIT_1) dep
MESA_COMMIT_1="2e683eb7385c54f872acc47b371210d2282bc103" # dawn (DAWN_COMMIT_1) dep
MESON_COMMIT_1="d389906a136c2aac9820ded0f38d1e25ef25fb9a" # dawn (DAWN_COMMIT_1) dep
NODE_ADDON_API_COMMIT="1e26dcb52829a74260ec262edb41fc22998669b6" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep
OPENGL_REGISTRY_COMMIT_1="5bae8738b23d06968e7c3a41308568120943ae77" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep
NODE_API_HEADERS_COMMIT="d5cfe19da8b974ca35764dd1c73b91d57cd3c4ce" # dawn (DAWN_COMMIT_1) dep, dawn/angle/dawn dep
PARTITION_ALLOCATOR_COMMIT_1="008e4fdd7e31d9133d028659348e054d350ccc3e" # dawn (DAWN_COMMIT_1) dep
PROTOBUF_COMMIT_1="a0f4dc977fa2ef7f47708aec914a4fbfeefc6103" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep
PROTOC_WRAPPER_COMMIT_1="3438d4183bfc7c0d6850e8b970204cc8189f0323" # dawn (DAWN_COMMIT_1) dep
SPIRV_HEADERS_COMMIT_1="f31ca173eff866369e54d35e53375fadbabd58f4" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep
SPIRV_TOOLS_COMMIT_1="cb38b2342beedde25bcff582dc3528a135cf6e67" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep
SWIFTSHADER_COMMIT_1="b7b7fd22e5f28079b92412f47f6da4df43e4cd37" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep
TESTING_COMMIT_1="4d438b31b58e2dc84b592a052b6b97e05ceb6497" # dawn (DAWN_COMMIT_1) dep
WEBGPU_CTS_COMMIT_1="dbe37c7d554fd72651510c362cf62992e5f45e1f" # dawn (DAWN_COMMIT_1) dep
VULKAN_MEMORY_ALLOCATOR_COMMIT_1="cb0597213b0fcb999caa9ed08c2f88dc45eb7d50" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/angle/dawn dep
VULKAN_DEPS_COMMIT_1="a26b8836968dc480ad283234823e6ffc62052489" # dawn (DAWN_COMMIT_1) dep
VULKAN_HEADERS_COMMIT_1="49f1a381e2aec33ef32adf4a377b5a39ec016ec4" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep
VULKAN_LOADER_COMMIT_1="09a024d4e422f8e603412f582d76c2051ef51cfc" # dawn (DAWN_COMMIT_1) dep, dawn/vulkan-deps dep
VULKAN_TOOLS_COMMIT_1="39a19dccf79d28951516c3c7c9f1ee4a606fb733" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep
VULKAN_UTILITY_LIBRARIES_COMMIT_1="50af38b6cd43afb1462f9ad26b8d015382d11a3d" # dawn (DAWN_COMMIT_1) dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep
VULKAN_VALIDATION_LAYERS_COMMIT_1="145be10eff68bf41f1b556026ecf7da9a7c8d15b" # dawn (DAWN_COMMIT_1) dep, dawn/vulkan-deps
WEBGPU_HEADERS_COMMIT_1="0bfcdc4f487023d85e33597de0a94fc523e30fca" # dawn (DAWN_COMMIT_1) dep
WIN_COMMIT_1="baacfc6d5986b07abe0503216b491e234b94ba79" # dawn (DAWN_COMMIT_1) dep
ZLIB_COMMIT_1="7eda07b1e067ef3fd7eea0419c88b5af45c9a776" # dawn (DAWN_COMMIT_1) dep

CPPDAP_COMMIT="1fd23dda91e01550be1a421de307e6fedb2035a9" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
JSON_COMMIT_1="f272ad533d32a40a3b2154a76f1ae9a45eacd6d3" # dawn/swiftshader/cppdap dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader/cppdap dep
GOOGLETEST_COMMIT_8="0a03480824b4fc7883255dbd2fd8940c9f81e22e" # dawn/swiftshader/cppdap dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader/cppdap dep
JSON_COMMIT_2="ed5541440a36bf7dc1a544f9a84fa3e5ae97b71f" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
LIBBACKTRACE_COMMIT_2="5a99ff7fed66b8ea8f09c9805c138524a7035ece" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
POWERVR_EXAMPLES_COMMIT="409c9d54fdaffe68565283e38dcbbe6c58535925" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
BENCHMARK_COMMIT_6="dfc8a92abc88a9d630a9f8e01c678fedde4c3090" # dawn/swiftshader dep, dawn/angle/dawn/swiftshader dep
GLSLANG_COMMIT_2="2b2523fb951f63f072cfba514c26f2feea5f4329" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
GIT_HOOKS_COMMIT="6d91964d33adee28dda9c7faf9ffd6f4672c381c" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep
LLVM_PROJECT_COMMIT="fc3b34c50803274b8ba3b8a30df9177b7d29063c" # dawn/swiftshader dep, dawn/angle/swiftshader dep, dawn/angle/dawn/swiftshader dep

GLSLANG_COMMIT_6="022de31e7ffa5230068858d9e6cd85ae11170bda" # dawn/vulkan-deps dep
LUNARG_VULKANTOOLS_COMMIT_3="dcbd02e0e7a6ed2892af97bfeb3c9871c53fd7de" # dawn/vulkan-deps dep, dawn/angle/vulkan-deps

SPIRV_HEADERS_COMMIT_2="ad9184e76a66b1001c29db9b0a3e87f646c64de0" # dawn/dxc dep
SPIRV_TOOLS_COMMIT_2="0539c81f69a3daeb706fd3477dca61435b475156" # dawn/dxc dep

GOOGLETEST_COMMIT_6="dddb219c3eb96d7f9200f09b0a381f016e6b4562" # dawn/langsvr dep, dawn/angle/dawn/langsvr dep
LSPROTOCOL_COMMIT="4a296ecf01c50008c9fbf07d48d15a1a4e97fded" # dawn/langsvr dep, dawn/angle/dawn/langsvr dep

# dawn angle
ABSEIL_CPP_COMMIT_4="7ef32bbacabd0d04a6cfac92a542841c531e1b21" # dawn/angle dep
ANDROID_BUILD_TOOLS_COMMIT="84bfacac619befaf33f19c74600b6759e5388177" # dawn/angle dep
ANDROID_COMMIT="e36d13d26bcecaa89fba45ea73195debd530fabf" # dawn/angle dep
ANDROID_DEPS_COMMIT="2ec23d1684d2c1d8afb747aad2d2b2221b71ce68" # dawn/angle dep
ANDROID_PLATFORM_COMMIT="e3919359f2387399042d31401817db4a02d756ec" # dawn/angle dep
ANDROID_SDK_COMMIT="3af3898c67301201301f834693ff44326174ecea" # dawn/angle dep
ASTC_ENCODER_COMMIT="2319d9c4d4af53a7fc7c52985e264ce6e8a02a9b" # dawn/angle dep
BUILD_COMMIT_2="d0790d159683f591bcbea765f8f72f9c8f62f866" # dawn/angle dep
BUILDTOOLS_COMMIT_2="6a18683f555b4ac8b05ac8395c29c84483ac9588" # dawn/angle dep
CATAPULT_COMMIT_2="a476f554f8865b7d162ec9f1ad8aae1eab38e048" # dawn/angle dep
CHERRY_COMMIT="4f8fb08d33ca5ff05a1c638f04c85bbb8d8b52cc" # dawn/angle dep
CLANG_COMMIT_2="7fd7d7092fa5ee06380f06f66f1b7bd03fca71a8" # dawn/angle dep
CLANG_FORMAT_COMMIT_2="c2725e0622e1a86d55f14514f2177a39efea4a0e" # dawn/angle dep
CLSPV_COMMIT="8f35aa835ae973e1c802421ba5a873f5e967278c" # dawn/angle dep
COLORAMA_COMMIT="3de9f013df4b470069d03d250224062e8cf15c49" # dawn/angle dep
CPU_FEATURES_COMMIT="936b9ab5515dead115606559502e3864958f7f6e" # dawn/angle dep
DAWN_COMMIT_2="c1308bb3f17e9637f82be72f7ed0a75f3427dda4" # dawn/angle dep
DEPOT_TOOLS_COMMIT_2="6c6a6572eb0e27efd41f8724b4631ac2aa9df460" # dawn/angle dep
FLATBUFFERS_COMMIT="a86afae9399bbe631d1ea0783f8816e780e236cc" # dawn/angle dep
GLES1_CONFORM_COMMIT="dc9f502f709c9cd88d7f8d3974f1c77aa246958e" # dawn/angle dep
GLMARK2_COMMIT="6edcf02205fd1e8979dc3f3964257a81959b80c8" # dawn/angle dep
GLSLANG_COMMIT_5="f5f664dee8146676b04a332a7233959fc3ce9681" # dawn/angle dep, dawn/angle/vulkan-deps
GOOGLETEST_COMMIT_9="4fe3307fb2d9f86d19777c7eb0e4809e9694dde7" # dawn/angle dep
IJAR_COMMIT="94af60a05b33f9acb33477a8d969e48eb1c3029f" # dawn/angle dep
JINJA2_COMMIT_2="c3027d884967773057bf74b957e3fea87e5df4d7" # dawn/angle dep
JSONCPP_COMMIT_3="f62d44704b4da6014aa231cfc116e7fd29617d2a" # dawn/angle dep
LIBCXX_COMMIT_2="7ab65651aed6802d2599dcb7a73b1f82d5179d05" # dawn/angle dep
LIBCXXABI_COMMIT_2="8f11bb1d4438d0239d0dfc1bd9456a9f31629dda" # dawn/angle dep
#LIBDRM_COMMIT_2="474894ed17a037a464e5bd845a0765a50f647898" # dawn/angle dep
LIBJPEG_TURBO_COMMIT="6bb85251a8382b5e07f635a981ac685cc5ab5053" # dawn/angle dep
LIBPNG_COMMIT="8cc222cd3e79fa5190f3aa039a03a4cbea6cfbe7" # dawn/angle dep
LIBUNWIND_COMMIT="ba19d93d6d4f467fba11ff20fe2fc7c056f79345" # dawn/angle dep
LLVM_COMMIT="2f7df07563d93f442b05a711769e2613715ad279" # dawn/angle dep
LUNARG_VULKANTOOLS_COMMIT_1="49f1a381e2aec33ef32adf4a377b5a39ec016ec4" # dawn/angle dep
MARKUPSAFE_COMMIT_2="4256084ae14175d38a3ff7d739dca83ae49ccec6" # dawn/angle dep
MB_COMMIT_2="1fc5adbbce8acd2a5fdccefde5af9865b982429d" # dawn/angle dep
MD_BROWSER_COMMIT="b7cfebc8143108734248df4e855a1bff01173f77" # dawn/angle dep
MEMORY_COMMIT_2="b635f27e932356a2e29450e5cfa544cdcc9ea6bb" # dawn/angle dep
MESA_COMMIT_2="0a6aa58acae2a5b27ef783c22e976ec9b0d33ddc" # dawn/angle dep
MESON_COMMIT_2="9fd5eb605674067ce6f8876dc27e5e116024e8a6" # dawn/angle dep
OPENCL_CTS_COMMIT="9fc0d23b4cfccd84be8927363a77107dc554de30" # dawn/angle dep
OPENCL_DOCS_COMMIT="5b4ca15f0e5a5be87b56b99f652f728e05cab587" # dawn/angle dep
OPENCL_ICD_LOADER_COMMIT="ddf6c70230a79cdb8fcccfd3c775b09e6820f42e" # dawn/angle dep
OPENGL_REGISTRY_COMMIT_2="d38ff693f3e99ac5a61e3858de76c6c02976fa67" # dawn/angle dep
PERFETTO_COMMIT="5c17fc6e089cecec6bd75073875f57c99dcd2f02" # dawn/angle dep
PERF_COMMIT="36734d224eafc4240e41551f0e4a8060697d32c2" # dawn/angle dep
PYTHON_MARKDOWN_COMMIT="0f4473546172a64636f5d841410c564c0edad625" # dawn/angle dep
NASM_COMMIT="af5eeeb054bebadfbb79c7bcd100a95e2ad4525f" # dawn/angle dep
PROTOC_WRAPPER_COMMIT_2="3438d4183bfc7c0d6850e8b970204cc8189f0323" # dawn/angle dep
PYTHON_COMMIT="64dd0e593f8e438764ced983a9f3f96061df748c" # dawn/angle dep
RAPIDJSON_COMMIT="781a4e667d84aeedbeb8184b7b62425ea66ec59f" # dawn/angle dep
RE2_COMMIT="972a15cedd008d846f1a39b2e88ce48d7f166cbd" # dawn/angle dep
REQUESTS_COMMIT="c7e0fc087ceeadb8b4c84a0953a422c474093d6d" # dawn/angle dep
RUST_COMMIT_2="600a9985b2c64aefbcf83a8c6125416c3bae64b6" # dawn/angle dep
RUST_COMMIT_4="e3d65bfb06fd5ff6714170baf0368c97ba44b920" # dawn/angle dep
SIX_COMMIT="98dedb5909b3e39848c6de5122772f5a89abe61a" # dawn/angle dep
SPIRV_CROSS_COMMIT_1="b8fcf307f1f347089e3c46eb4451d27f32ebc8d3" # dawn/angle dep, dawn/angle dep, dawn/vulkan-deps dep, dawn/angle/vulkan-deps dep, dawn/angle/dawn/vulkan-deps dep
TESTING_COMMIT_2="265c79ac1aa8dcb9d1c42ddde44e6230521d16ab" # dawn/angle dep
VALGRIND_COMMIT_3="da34b95fdbf2032df6cda5f3828c2ba421592644" # dawn/angle dep
VK_GL_CTS_COMMIT="1698899cb078aacfb11d6b8eb5c4753d86bd2661" # dawn/angle dep
VULKAN_DEPS_COMMIT_3="196a50babcaaf1ef57048ef5484693f0d59f21c0" # dawn/angle dep
VULKAN_LOADER_COMMIT_3="a3d977588cb6fd17a28f23c3a96b5e88ca71d728" # dawn/angle dep, dawn/angle/vulkan-deps dep
VULKAN_VALIDATION_LAYERS_COMMIT_3="c24c2843cbede436a609f1b04ff94b78c29e69f0" # dawn/angle dep, dawn/angle/vulkan-deps dep
VULKAN_MEMORY_ALLOCATOR_COMMIT_1="cb0597213b0fcb999caa9ed08c2f88dc45eb7d50" # dawn/angle dep
WAYLAND_COMMIT="75c1a93e2067220fa06208f20f8f096bb463ec08" # dawn/angle dep
ZLIB_COMMIT_2="7eda07b1e067ef3fd7eea0419c88b5af45c9a776" # dawn/angle dep

GOOGLETEST_COMMIT_10="ba96d0b1161f540656efdaed035b3c062b60e006" # dawn/angle/rapidjson dep

# dawn angle dawn
ABSEIL_CPP_COMMIT_5="e1655ca1acab4bf3f4f293ac0e14a8ddec440332" # dawn/angle/dawn dep
ANGLE_COMMIT_2="e8ea89217ec0bdc50a287ad73d63dd5148c701bc" # dawn/angle/dawn dep
BENCHMARK_COMMIT_7="761305ec3b33abf30e08d50eb829e19a802581cc" # dawn/angle/dawn dep
BUILD_COMMIT_3="5ab9444db5e5037291c7dbeaa9b0424ff78103c8" # dawn/angle/dawn dep
BUILDTOOLS_COMMIT_3="628cf12465dae2a157524a23608a58b525d30623" # dawn/angle/dawn dep
CATAPULT_COMMIT_3="3b15c113688e725e3249b51e7a34a8d25353ddc7" # dawn/angle/dawn dep
CLANG_FORMAT_COMMIT_3="911fc51fb4657b50626a915f4a7509c463e4b169" # dawn/angle/dawn dep
CLANG_COMMIT_3="c32a3112f46745b6b0ec81b933bb3bd6303c7af0" # dawn/angle/dawn dep
DEPOT_TOOLS_COMMIT_3="16dfe4717b0ef0214c66dc2e575a7c0feebfea3c" # dawn/angle/dawn dep
EMSDK_COMMIT_2="eff90ca04a3785f571a8095b3a42b63799cf384a" # dawn/angle/dawn dep
GOOGLETEST_COMMIT_12="309dab8d4bbfcef0ef428762c6fec7172749de0f" # dawn/angle/dawn dep
LIBCXX_COMMIT_3="ddfdbbc1ab109b4fc6171f3d8c38faf4586701d2" # dawn/angle/dawn dep
LIBCXXABI_COMMIT_3="bb789ae647a626f62dd28806334314fd72071f6f" # dawn/angle/dawn dep
LLVM_LIBC_COMMIT_2="1f7cf83fb28c5bd777f4cdceed29bd52c69552b0" # dawn/angle/dawn dep
LIBDRM_COMMIT_3="ad78bb591d02162d3b90890aa4d0a238b2a37cde" # dawn/angle/dawn dep
DXC_COMMIT_2="eede01664e70e676186021aba3df7ee3b5f4a92b" # dawn/angle/dawn dep
GLSLANG_COMMIT_4="1c7030f06f356c2bd5d66d71e6b47f92eae8138e" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
GPUWEB_COMMIT_2="9ff5525e146d85b9b950ac344505c27777b63d32" # dawn/angle/dawn dep
JSONCPP_COMMIT_4="69098a18b9af0c47549d9a271c054d13ca92b006" # dawn/angle/dawn dep, dawn/langsvr dep, dawn/angle/dawn/langsvr dep
MARKUPSAFE_COMMIT_3="0bad08bb207bbfc1d6f3bbc82b9242b0c50e5794" # dawn/angle/dawn dep
MB_COMMIT_3="6c50647ee969539f9371fafdeeb38d6b2c13dc34" # dawn/angle/dawn dep
MEMORY_COMMIT_3="3c7b1f4daab1520239cb172059e2e16684fd3128" # dawn/angle/dawn dep
PARTITION_ALLOCATOR_COMMIT_2="fae4df38cef9720a13dd55a6b1d20600919e671b" # dawn/angle/dawn dep
PROTOBUF_COMMIT_2="fef7a765bb0d1122d32b99f588537b83e2dffe7b" # dawn/angle/dawn dep
PROTOC_WRAPPER_COMMIT_3="8ad6d21544b14c7f753852328d71861b363cc512" # dawn/angle/dawn dep
SPIRV_HEADERS_COMMIT_3="0ff65315141cf745c1ac286084943409edbe6504" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
SPIRV_TOOLS_COMMIT_3="25658c25da9548e5916cd0c73012603dd964ea04" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
SWIFTSHADER_COMMIT_2="f474b0ce14a6e466ef84c510d9b779c74341bc3d" # dawn/angle/dawn dep
TESTING_COMMIT_3="fec671f0c0fcb50654e60a118bb24051c516bb01" # dawn/angle/dawn dep
VALGRIND_COMMIT_4="da34b95fdbf2032df6cda5f3828c2ba421592644" # dawn/angle/dawn dep
VULKAN_DEPS_COMMIT_2="3114945eb0e3ec087a805053f0e0030dc7d54261" # dawn/angle/dawn dep
VULKAN_HEADERS_COMMIT_2="3dda5a1a87b62fdf3baf4680edc41c00e85a7a22" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
VULKAN_LOADER_COMMIT_2="d03e5159590351a04673e6451ea467fdb26ee85e" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
VULKAN_TOOLS_COMMIT_2="8e9daf5dd62ff81ba67a1c20dad64ee87f21005e" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
VULKAN_UTILITY_LIBRARIES_COMMIT_2="b861e607ec1e31dcd66133918bf9d6bd22da3c02" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
VULKAN_VALIDATION_LAYERS_COMMIT_2="bd4f8c9097e96beb0fb61946ac3275cdd5540b73" # dawn/angle/dawn dep, dawn/angle/dawn/vulkan-deps dep
WEBGPU_CTS_COMMIT_2="07253ddadf231da82375cc0fb992b75ee857c1e1" # dawn/angle/dawn dep
WEBGPU_HEADERS_COMMIT_2="079d4e5153eaabc4033584cc399c27f1acbb2548" # dawn/angle/dawn dep
WIN_COMMIT_3="24494b071e019a2baea4355d9870ffc5fc0bbafe" # dawn/angle/dawn dep

LUNARG_VULKANTOOLS_COMMIT_4="e3a3cccda048b88ee42bf51f1639453223380341" # dawn/angle/dawn/vulkan-deps dep

SPIRV_HEADERS_COMMIT_4="01e0577914a75a2569c846778c2f93aa8e6feddd" # dawn/angle/dawn/dxc dep
SPIRV_TOOLS_COMMIT_4="09ac18fad693787b7b1f1e4881877de866751732" # dawn/angle/dawn/dxc dep

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/CMakeLists.txt#L299
	"gfx906"
	"gfx908"
	"gfx90a" # ck
	#"gfx942" # ck
	"gfx1030"
	"gfx1100"
	"gfx1101"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	#${LIBCXX_COMPAT_CXX17_CUDA_12_6[@]/llvm_slot_} # 18
	#${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]/llvm_slot_} # 19
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512"
)

CUDA_TARGETS_COMPAT=(
# See https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/CMakeLists.txt#L1453
	"sm_30"
	"sm_37"
	"sm_50"
	"sm_52"
	"sm_53"
	"sm_60"
	"sm_62"
	"sm_70"
	"sm_72"
	"sm_75"
	"sm_87"
	"sm_80"
	"sm_90"
)

OPENVINO_TARGETS=(
	"cpu"
	"cpu_np"
	"gpu"
	"gpu_np"
	"npu"
	"npu_np"
)

ROCM_SLOTS=(
	"rocm_6_4"
)

inherit cflags-hardened check-compiler-switch cmake cuda dep-prepare distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot llvm-r1 rocm toolchain-funcs

KEYWORDS="~amd64"
if [[ "${ENABLE_WEBGPU}" == "1" ]] ; then
	SRC_URI+="
	webgpu? (
https://android.googlesource.com/platform/external/cherry/+archive/${CHERRY_COMMIT:0:7}.tar.gz
	-> cherry-${CHERRY_COMMIT:0:7}.tar.gz
https://android.googlesource.com/platform/external/libpng/+archive/${LIBPNG_COMMIT:0:7}.tar.gz
	-> libpng-${LIBPNG_COMMIT:0:7}.tar.gz
https://android.googlesource.com/platform/external/perfetto/+archive/${PERFETTO_COMMIT:0:7}.tar.gz
	-> perfetto-${PERFETTO_COMMIT:0:7}.tar.gz

https://chrome-internal.googlesource.com/angle/es-cts/+archive/${GLES1_CONFORM_COMMIT:0:7}.tar.gz
	-> flatbuffers-${GLES1_CONFORM_COMMIT:0:7}.tar.gz

https://chromium.googlesource.com/angle/angle/+archive/${ANGLE_COMMIT_1:0:7}.tar.gz
	-> angle-${ANGLE_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/angle/angle/+archive/${ANGLE_COMMIT_2:0:7}.tar.gz
	-> angle-${ANGLE_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/catapult/+archive/${CATAPULT_COMMIT_1}.tar.gz
	-> catapult-${CATAPULT_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/catapult/+archive/${CATAPULT_COMMIT_2}.tar.gz
	-> catapult-${CATAPULT_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/catapult/+archive/${CATAPULT_COMMIT_3}.tar.gz
	-> catapult-${CATAPULT_COMMIT_3:0:7}.tar.gz

https://chromium.googlesource.com/chromium/deps/libjpeg_turbo/+archive/${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
	-> libjpeg_turbo-${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/deps/nasm/+archive/${NASM_COMMIT:0:7}.tar.gz
	-> nasm-${NASM_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/base/allocator/partition_allocator/+archive/${PARTITION_ALLOCATOR_COMMIT_1:0:7}.tar.gz
	-> partition_allocator-${PARTITION_ALLOCATOR_COMMIT_1:0:7}.tar.gz
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
https://chromium.googlesource.com/chromium/src/buildtools/+archive/${BUILDTOOLS_COMMIT_3:0:7}.tar.gz
	-> buildtools-${BUILDTOOLS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp/+archive/${ABSEIL_CPP_COMMIT_3:0:7}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp/+archive/${ABSEIL_CPP_COMMIT_4:0:7}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp/+archive/${ABSEIL_CPP_COMMIT_5:0:7}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT_5:0:7}.tar.gz
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
https://chromium.googlesource.com/chromium/src/third_party/jinja2/+archive/${JINJA2_COMMIT_3:0:7}.tar.gz
	-> jinja2-${JINJA2_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/jsoncpp/+archive/${JSONCPP_COMMIT_3:0:7}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/jsoncpp/+archive/${JSONCPP_COMMIT_4:0:7}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/markupsafe/+archive/${MARKUPSAFE_COMMIT_1:0:7}.tar.gz
	-> markupsafe-${MARKUPSAFE_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/markupsafe/+archive/${MARKUPSAFE_COMMIT_2:0:7}.tar.gz
	-> markupsafe-${MARKUPSAFE_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/markupsafe/+archive/${MARKUPSAFE_COMMIT_3:0:7}.tar.gz
	-> markupsafe-${MARKUPSAFE_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/protobuf/+archive/${PROTOBUF_COMMIT_1:0:7}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/Python-Markdown/+archive/${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz
	-> python-markdown-${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/six/+archive/${SIX_COMMIT:0:7}.tar.gz
	-> six-${SIX_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${ZLIB_COMMIT_1:0:7}.tar.gz
	-> zlib-${ZLIB_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${ZLIB_COMMIT_2:0:7}.tar.gz
	-> zlib-${ZLIB_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/third_party/zlib/+archive/${ZLIB_COMMIT_3:0:7}.tar.gz
	-> zlib-${ZLIB_COMMIT_3:0:7}.tar.gz




https://chromium.googlesource.com/chromium/src/testing/+archive/${TESTING_COMMIT_1:0:7}.tar.gz
	-> testing-${TESTING_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/testing/+archive/${TESTING_COMMIT_2:0:7}.tar.gz
	-> testing-${TESTING_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/testing/+archive/${TESTING_COMMIT_3:0:7}.tar.gz
	-> testing-${TESTING_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/android/+archive/${ANDROID_COMMIT:0:7}.tar.gz
	-> android-${ANDROID_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_1:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_2:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/clang/+archive/${CLANG_COMMIT_3:0:7}.tar.gz
	-> clang-${CLANG_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/mb/+archive/${MB_COMMIT_1:0:7}.tar.gz
	-> mb-${MB_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/mb/+archive/${MB_COMMIT_2:0:7}.tar.gz
	-> mb-${MB_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/mb/+archive/${MB_COMMIT_3:0:7}.tar.gz
	-> mb-${MB_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/md_browser/+archive/${MD_BROWSER_COMMIT:0:7}.tar.gz
	-> md_browser-${MD_BROWSER_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/memory/+archive/${MEMORY_COMMIT_1:0:7}.tar.gz
	-> memory-${MEMORY_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/memory/+archive/${MEMORY_COMMIT_2:0:7}.tar.gz
	-> memory-${MEMORY_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/memory/+archive/${MEMORY_COMMIT_3:0:7}.tar.gz
	-> memory-${MEMORY_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/perf/+archive/${PERF_COMMIT:0:7}.tar.gz
	-> perf-${PERF_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper/+archive/${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz
	-> protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper/+archive/${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz
	-> protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper/+archive/${PROTOC_WRAPPER_COMMIT_3:0:7}.tar.gz
	-> protoc_wrapper-${PROTOC_WRAPPER_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/python/+archive/${PYTHON_COMMIT:0:7}.tar.gz
	-> python-${PYTHON_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/rust/+archive/${RUST_COMMIT_2:0:7}.tar.gz
	-> rust-${RUST_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/rust/+archive/${RUST_COMMIT_4:0:7}.tar.gz
	-> rust-${RUST_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/valgrind/+archive/${VALGRIND_COMMIT_1:0:7}.tar.gz
	-> valgrind-${VALGRIND_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/valgrind/+archive/${VALGRIND_COMMIT_2:0:7}.tar.gz
	-> valgrind-${VALGRIND_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/valgrind/+archive/${VALGRIND_COMMIT_3:0:7}.tar.gz
	-> valgrind-${VALGRIND_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/valgrind/+archive/${VALGRIND_COMMIT_4:0:7}.tar.gz
	-> valgrind-${VALGRIND_COMMIT_4:0:7}.tar.gz
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
https://chromium.googlesource.com/chromiumos/third_party/libdrm/+archive/${LIBDRM_COMMIT_3:0:7}.tar.gz
	-> libdrm-${LIBDRM_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/anongit.freedesktop.org/git/wayland/wayland/+archive/${WAYLAND_COMMIT:0:7}.tar.gz
	-> wayland-${WAYLAND_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/colorama/+archive/${COLORAMA_COMMIT:0:7}.tar.gz
	-> colorama-${COLORAMA_COMMIT:0:7}.tar.gz


https://chromium.googlesource.com/chromium/src/tools/win/+archive/${WIN_COMMIT_1:0:7}.tar.gz
	-> win-${WIN_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/win/+archive/${WIN_COMMIT_2:0:7}.tar.gz
	-> win-${WIN_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/chromium/src/tools/win/+archive/${WIN_COMMIT_3:0:7}.tar.gz
	-> win-${WIN_COMMIT_3:0:7}.tar.gz


https://chromium.googlesource.com/external/github.com/ARM-software/astc-encoder/+archive/${ASTC_ENCODER_COMMIT:0:7}.tar.gz
	-> astc-encoder-${ASTC_ENCODER_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/glfw/glfw/+archive/${GLFW_COMMIT_1:0:7}.tar.gz
	-> glfw-${GLFW_COMMIT_1:0:7}.tar.gz
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
https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenGL-Registry/+archive/${OPENGL_REGISTRY_COMMIT_1:0:7}.tar.gz
	-> opengl-registry-${OPENGL_REGISTRY_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/OpenGL-Registry/+archive/${OPENGL_REGISTRY_COMMIT_2:0:7}.tar.gz
	-> opengl-registry-${OPENGL_REGISTRY_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Cross/+archive/${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz
	-> spirv-cross-${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers/+archive/${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers/+archive/${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers/+archive/${SPIRV_HEADERS_COMMIT_4:0:7}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools/+archive/${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools/+archive/${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools/+archive/${SPIRV_TOOLS_COMMIT_4:0:7}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/VK-GL-CTS/+archive/${VK_GL_CTS_COMMIT:0:7}.tar.gz
	-> vk-gl-cts-${VK_GL_CTS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/+archive/${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz
	-> VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/+archive/${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz
	-> VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/+archive/${VULKAN_MEMORY_ALLOCATOR_COMMIT_3:0:7}.tar.gz
	-> VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/gpuweb/cts/+archive/${WEBGPU_CTS_COMMIT_1:0:7}.tar.gz
	-> webgpu-cts-${WEBGPU_CTS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/gpuweb/cts/+archive/${WEBGPU_CTS_COMMIT_2:0:7}.tar.gz
	-> webgpu-cts-${WEBGPU_CTS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_1:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_4:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_5:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_5:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang/+archive/${GLSLANG_COMMIT_6:0:7}.tar.gz
	-> glslang-${GLSLANG_COMMIT_6:0:7}.tar.gz

https://chromium.googlesource.com/external/github.com/emscripten-core/emsdk/+archive/${EMSDK_COMMIT_1:0:7}.tar.gz
	-> emsdk-${EMSDK_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/emscripten-core/emsdk/+archive/${EMSDK_COMMIT_2:0:7}.tar.gz
	-> emsdk-${EMSDK_COMMIT_2:0:7}.tar.gz

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
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Loader/+archive/${VULKAN_LOADER_COMMIT_3:0:7}.tar.gz
	-> vulkan-loader-${VULKAN_LOADER_COMMIT_3:0:7}.tar.gz
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
https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-ValidationLayers/+archive/${VULKAN_VALIDATION_LAYERS_COMMIT_3:0:7}.tar.gz
	-> vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/+archive/${LLVM_COMMIT:0:7}.tar.gz
	-> llvm-${LLVM_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format/+archive/${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz
	-> clang-format-${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format/+archive/${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz
	-> clang-format-${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/clang/tools/clang-format/+archive/${CLANG_FORMAT_COMMIT_3:0:7}.tar.gz
	-> clang-format-${CLANG_FORMAT_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/compiler-rt/lib/fuzzer/+archive/${LIBFUZZER_COMMIT_1:0:7}.tar.gz
	-> libfuzzer-${LIBFUZZER_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx/+archive/${LIBCXX_COMMIT_1:0:7}.tar.gz
	-> libc++-${LIBCXX_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx/+archive/${LIBCXX_COMMIT_2:0:7}.tar.gz
	-> libc++-${LIBCXX_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx/+archive/${LIBCXX_COMMIT_3:0:7}.tar.gz
	-> libc++-${LIBCXX_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi/+archive/${LIBCXXABI_COMMIT_1:0:7}.tar.gz
	-> libc++abi-${LIBCXXABI_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi/+archive/${LIBCXXABI_COMMIT_2:0:7}.tar.gz
	-> libc++abi-${LIBCXXABI_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi/+archive/${LIBCXXABI_COMMIT_3:0:7}.tar.gz
	-> libc++abi-${LIBCXXABI_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libc.git/+archive/${LLVM_LIBC_COMMIT_1:0:7}.tar.gz
	-> llvm-libc-${LLVM_LIBC_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libc.git/+archive/${LLVM_LIBC_COMMIT_2:0:7}.tar.gz
	-> llvm-libc-${LLVM_LIBC_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libunwind/+archive/${LIBUNWIND_COMMIT:0:7}.tar.gz
	-> libunwind-${LIBUNWIND_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/LunarG/VulkanTools/+archive/${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz
	-> lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/LunarG/VulkanTools/+archive/${LUNARG_VULKANTOOLS_COMMIT_3:0:7}.tar.gz
	-> lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_3:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/LunarG/VulkanTools/+archive/${LUNARG_VULKANTOOLS_COMMIT_4:0:7}.tar.gz
	-> lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_4:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/Mesa3D/mesa/+archive/${MESA_COMMIT_1:0:7}.tar.gz
	-> mesa-${MESA_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/Mesa3D/mesa/+archive/${MESA_COMMIT_2:0:7}.tar.gz
	-> mesa-${MESA_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/mesonbuild/meson/+archive/${MESON_COMMIT_1:0:7}.tar.gz
	-> meson-${MESON_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/mesonbuild/meson/+archive/${MESON_COMMIT_2:0:7}.tar.gz
	-> meson-${MESON_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectX-Headers/+archive/${DXHEADERS_COMMIT:0:7}.tar.gz
	-> dxheaders-${DXHEADERS_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+archive/${DXC_COMMIT_1:0:7}.tar.gz
	-> dxc-${DXC_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+archive/${DXC_COMMIT_2:0:7}.tar.gz
	-> dxc-${DXC_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/Tencent/rapidjson/+archive/${RAPIDJSON_COMMIT:0:7}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/webgpu-native/webgpu-headers/+archive/${WEBGPU_HEADERS_COMMIT_1:0:7}.tar.gz
	-> webgpu-headers-${WEBGPU_HEADERS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/external/github.com/webgpu-native/webgpu-headers/+archive/${WEBGPU_HEADERS_COMMIT_2:0:7}.tar.gz
	-> webgpu-headers-${WEBGPU_HEADERS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/vulkan-deps/+archive/${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz
	-> vulkan-deps-${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz
https://chromium.googlesource.com/vulkan-deps/+archive/${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz
	-> vulkan-deps-${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz
https://chromium.googlesource.com/vulkan-deps/+archive/${VULKAN_DEPS_COMMIT_3:0:7}.tar.gz
	-> vulkan-deps-${VULKAN_DEPS_COMMIT_3:0:7}.tar.gz

https://dawn.googlesource.com/dawn/+archive/${DAWN_COMMIT_2:0:7}.tar.gz
	-> dawn-${DAWN_COMMIT_2:0:7}.tar.gz

https://github.com/google/dawn/archive/${DAWN_COMMIT_1}.tar.gz
	-> dawn-${DAWN_COMMIT_1}.tar.gz

https://github.com/google/langsvr/archive/${LANGSVR_COMMIT}.tar.gz
	-> langsvr-${LANGSVR_COMMIT:0:7}.tar.gz
https://github.com/google/libprotobuf-mutator/archive/${LIBPROTOBUF_MUTATOR_COMMIT_2}.tar.gz
	-> libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_2:0:7}.tar.gz

https://github.com/gpuweb/gpuweb/archive/${GPUWEB_COMMIT_1:0:7}.tar.gz
	-> gpuweb-${GPUWEB_COMMIT_1:0:7}.tar.gz
https://github.com/gpuweb/gpuweb/archive/${GPUWEB_COMMIT_2:0:7}.tar.gz
	-> gpuweb-${GPUWEB_COMMIT_2:0:7}.tar.gz

https://github.com/google/cppdap/archive/${CPPDAP_COMMIT}.tar.gz
	-> cppdap-${CPPDAP_COMMIT}.tar.gz

https://github.com/ianlancetaylor/libbacktrace/archive/${LIBBACKTRACE_COMMIT_2}.tar.gz
	-> libbacktrace-${LIBBACKTRACE_COMMIT_2:0:7}.tar.gz

https://github.com/nlohmann/json/archive/${JSON_COMMIT_1}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_1:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_2}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_2:0:7}.tar.gz

https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Headers/archive/${SPIRV_HEADERS_COMMIT_2}.tar.gz
	-> spirv-headers-${SPIRV_HEADERS_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/SPIRV-Tools/archive/${SPIRV_TOOLS_COMMIT_2}.tar.gz
	-> spirv-tools-${SPIRV_TOOLS_COMMIT_2}.tar.gz

https://github.com/llvm/llvm-project/archive/${LLVM_PROJECT_COMMIT}.tar.gz
	-> llvm-project-${LLVM_PROJECT_COMMIT:0:7}.tar.gz

https://github.com/microsoft/lsprotocol/archive/${LSPROTOCOL_COMMIT}.tar.gz
	-> lsprotocol-${LSPROTOCOL_COMMIT}.tar.gz

https://github.com/nodejs/node-addon-api/archive/${NODE_ADDON_API_COMMIT}.tar.gz
	-> node-addon-api-${NODE_ADDON_API_COMMIT:0:7}.tar.gz
https://github.com/nodejs/node-api-headers/archive/${NODE_API_HEADERS_COMMIT}.tar.gz
	-> node-api-headers-${NODE_API_HEADERS_COMMIT:0:7}.tar.gz

https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_COMMIT_2}.tar.gz
	-> jsoncpp-${JSONCPP_COMMIT_2:0:7}.tar.gz

https://github.com/powervr-graphics/Native_SDK/archive/${POWERVR_EXAMPLES_COMMIT}.tar.gz
	-> Native_SDK-${POWERVR_EXAMPLES_COMMIT:0:7}.tar.gz

https://swiftshader.googlesource.com/git-hooks/+archive/${GIT_HOOKS_COMMIT:0:7}.tar.gz
	-> git-hooks-${GIT_HOOKS_COMMIT:0:7}.tar.gz
https://swiftshader.googlesource.com/SwiftShader/+archive/${SWIFTSHADER_COMMIT_1:0:7}.tar.gz
	-> swiftshader-${SWIFTSHADER_COMMIT_1:0:7}.tar.gz
https://swiftshader.googlesource.com/SwiftShader/+archive/${SWIFTSHADER_COMMIT_2:0:7}.tar.gz
	-> swiftshader-${SWIFTSHADER_COMMIT_2:0:7}.tar.gz
	)
	benchmark? (
https://chromium.googlesource.com/external/github.com/google/benchmark/+archive/${BENCHMARK_COMMIT_5:0:7}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_5:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_2}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_2:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_6}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_6:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_7}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_7:0:7}.tar.gz
	)
	test? (
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_4}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_4:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_6}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_6:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_8}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_8:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_10}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_10:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_12}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_12:0:7}.tar.gz
	)
"
fi

SRC_URI+="
https://codeload.github.com/KhronosGroup/Vulkan-Headers/tar.gz/refs/tags/v1.4.344
	-> Vulkan-Headers-${VULKAN_HEADERS_PV}.tar.gz

https://github.com/apple/coremltools/archive/refs/tags/${COREMLTOOLS_PV}.tar.gz
	-> coremltools-${COREMLTOOLS_PV}.tar.gz
https://github.com/boostorg/mp11/archive/refs/tags/boost-${MP11_PV}.tar.gz
	-> mp11-${MP11_PV}.tar.gz
https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_PV}.tar.gz
	-> SafeInt-${SAFEINT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${DLPACK_COMMIT_2}.tar.gz
	-> dlpack-${DLPACK_COMMIT_2:0:7}.tar.gz
https://github.com/emscripten-core/emsdk/archive/refs/tags/${EMSDK_PV}.tar.gz
	-> emsdk-${EMSDK_PV}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz
	-> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/libprotobuf-mutator/archive/${LIBPROTOBUF_MUTATOR_COMMIT_1}.tar.gz
	-> libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_1:0:7}.tar.gz
https://github.com/google/re2/archive/refs/tags/${RE2_PV}.tar.gz
	-> re2-${RE2_PV}.tar.gz
https://github.com/HowardHinnant/date/archive/v${DATE_PV_1}.tar.gz
	-> HowardHinnant-date-${DATE_PV_1}.tar.gz
https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz
	-> cxxopts-${CXXOPTS_COMMIT:0:7}.tar.gz
https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v${DIRECTX_HEADERS_PV}.tar.gz
	-> DirectX-Headers-${DIRECTX_HEADERS_PV}.tar.gz
https://github.com/microsoft/GSL/archive/refs/tags/v${GSL_PV}.tar.gz
	-> microsoft-gsl-${GSL_PV}.tar.gz
https://github.com/microsoft/wil/archive/refs/tags/v${WIL_PV}.tar.gz
	-> microsoft-wil-${WIL_PV}.tar.gz
https://github.com/nlohmann/json/archive/refs/tags/v${JSON_PV}.tar.gz
	-> nlohmann-json-${JSON_PV}.tar.gz

https://github.com/onnx/onnx/archive/${ONNX_COMMIT_1}.tar.gz
	-> onnx-${ONNX_COMMIT_1:0:7}.tar.gz
https://github.com/onnx/onnx/archive/refs/tags/v${ONNX_PV_1}.tar.gz
	-> onnx-${ONNX_PV_1}.tar.gz

https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV_1}.tar.gz
	-> protobuf-${PROTOBUF_PV_1}.tar.gz
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-win32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-x86_32.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-linux-aarch_64.zip
https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV_1}/protoc-${PROTOBUF_PV_1}-osx-universal_binary.zip

https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT}.tar.gz
	-> pytorch-cpuinfo-${CPUINFO_COMMIT:0:7}.tar.gz
https://github.com/qualcomm/kleidiai/archive/${KLEIDIAI_QMX_COMMIT}.tar.gz
	-> kleidiai-qmx-${KLEIDIAI_QMX_COMMIT:0:7}.tar.gz
https://github.com/svaarala/duktape/releases/download/v${DUKTAPE_PV}/duktape-${DUKTAPE_PV}.tar.xz
	-> duktape-${DUKTAPE_PV}.tar.xz
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
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_3}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_3:0:7}.tar.gz
	)
	cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.tar.gz
	-> cudnn-frontend-${CUDNN_FRONTEND_PV}.tar.gz
https://github.com/NVIDIA/cutlass/archive/refs/tags/v${CUTLASS_PV}.tar.gz
	-> cutlass-${CUTLASS_PV}.tar.gz
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
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT_COMMIT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT_COMMIT:0:7}.tar.gz
	)
	test? (
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_5}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_5:0:7}.tar.gz
https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_PV_1}.tar.gz
	-> googletest-${GOOGLETEST_PV_1}.tar.gz
	)
	training? (
https://github.com/tensorflow/tensorboard/archive/${TENSORBOARD_COMMIT}.tar.gz
	-> tensorboard-${TENSORBOARD_COMMIT:0:7}.tar.gz
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
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CPU_FLAGS_X86[@]}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${OPENVINO_TARGETS[@]/#/openvino_targets_}
${ROCM_SLOTS[@]}
-abseil-cpp -benchmark -composable-kernel cpu -cuda cudnn debug doc -extensions
-javascript -llvm -lto -migraphx -mimalloc -mpi -onednn -openvino
+python -quant -rocm -system-eigen -system-composable-kernel test -tensorrt
-tensorrt-oss-parser -training training-ort -triton -webgpu -xnnpack

openvino-auto
openvino-hetero
openvino-multi
ebuild_revision_29
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
# For providers, see also https://github.com/microsoft/onnxruntime/blob/v1.26.0/onnxruntime/test/perftest/command_args_parser.cc#L40
# abseil-cpp is required for protobuf and still links to it if disabled.
# webgpu banned because the G repo servers removed tarball downloads.
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	!webgpu
	abseil-cpp
	composable-kernel? (
		amdgpu_targets_gfx90a
		rocm
	)
	cuda? (
		cudnn
		!lto
		^^ (
			${LIBCXX_COMPAT_CXX17_CUDA_12_6[@]}
		)
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
		llvm_slot_19
		migraphx
		^^ (
			${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]}
		)
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
		local s="0/"$(ver_cut 1-2 ${pv})
		local u=$(ver_cut 1-2 ${pv})
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				>=dev-libs/rccl-${pv}:${s}[$(get_rocm_usedep RCCL)]
				dev-libs/rccl:=
				>=dev-libs/rocr-runtime-${pv}:${s}
				dev-libs/rocr-runtime:=
				>=dev-util/hip-${pv}:${s}[rocm]
				dev-util/hip:=
				>=dev-util/rocm-smi-${pv}:${s}
				dev-util/rocm-smi:=
				>=dev-util/roctracer-${pv}:${s}
				dev-util/roctracer:=
				>=sci-libs/hipCUB-${pv}:${s}[$(get_rocm_usedep HIPCUB)]
				sci-libs/hipCUB:=
				>=sci-libs/hipFFT-${pv}:${s}[$(get_rocm_usedep HIPFFT)]
				sci-libs/hipFFT:=
				>=sci-libs/hipRAND-${pv}:${s}[rocm]
				sci-libs/hipRAND:=
				>=sci-libs/miopen-${pv}:${s}[$(get_rocm_usedep MIOPEN)]
				sci-libs/miopen:=
				>=sci-libs/rocBLAS-${pv}:${s}[$(get_rocm_usedep ROCBLAS)]
				sci-libs/rocBLAS:=
				system-composable-kernel? (
					sci-libs/composable-kernel:${s}[$(get_rocm_usedep COMPOSABLE_KERNEL)]
					sci-libs/composable-kernel:=
				)
			)
		"
		if use amdgpu_targets_gfx90a ; then
			echo "
				>=sci-libs/hipBLASLt-${pv}:${s}[$(get_rocm_usedep HIPBLASLT)]
				sci-libs/hipBLASLt:=
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
		>=dev-libs/protobuf-21.12:0/3.21
		dev-libs/protobuf:=
	)
	>=sci-ml/FP16-2021.03.16
	>=dev-libs/FXdiv-2020.12.08
	>=dev-libs/re2-0.2024.07.02:${RE2_SLOT}
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
				>=x11-drivers/nvidia-drivers-560.35
				=dev-util/nvidia-cuda-toolkit-12.6*
				!python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				cudnn? (
					>=dev-libs/cudnn-9.5
				)
				python? (
					>=sci-ml/pytorch-2.6.0[${PYTHON_SINGLE_USEDEP}]
				)
				virtual/cuda-compiler:0/12.6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			)
		)
		dev-util/nvidia-cuda-toolkit:=
		virtual/cuda-compiler:=
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
		rocm_6_4? (
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
	"${FILESDIR}/${PN}-1.26.0-onnx_proto-visibility.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup

	if use rocm_6_4 ; then
		LLVM_SLOT="19"
		ROCM_SLOT="6.4"
		export ROCM_VERSION="${HIP_6_4_VERSION}"
	fi

	use rocm && rocm_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
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
		"abseil-cpp-${ABSEIL_CPP_COMMIT_5:0:7}.tar.gz;abseil-cpp-${ABSEIL_CPP_COMMIT_5}"
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
		"buildtools-${BUILDTOOLS_COMMIT_3:0:7}.tar.gz;buildtools-${BUILDTOOLS_COMMIT_3}"
		"catapult-${CATAPULT_COMMIT_1:0:7}.tar.gz;catapult-${CATAPULT_COMMIT_1}"
		"catapult-${CATAPULT_COMMIT_2:0:7}.tar.gz;catapult-${CATAPULT_COMMIT_2}"
		"catapult-${CATAPULT_COMMIT_3:0:7}.tar.gz;catapult-${CATAPULT_COMMIT_3}"
		"cherry-${CHERRY_COMMIT:0:7}.tar.gz;cherry-${CHERRY_COMMIT}"
		"clang-${CLANG_COMMIT_1:0:7}.tar.gz;clang-${CLANG_COMMIT_1}"
		"clang-${CLANG_COMMIT_2:0:7}.tar.gz;clang-${CLANG_COMMIT_2}"
		"clang-${CLANG_COMMIT_3:0:7}.tar.gz;clang-${CLANG_COMMIT_3}"
		"clang-format-${CLANG_FORMAT_COMMIT_1:0:7}.tar.gz;clang-format-${CLANG_FORMAT_COMMIT_1}"
		"clang-format-${CLANG_FORMAT_COMMIT_2:0:7}.tar.gz;clang-format-${CLANG_FORMAT_COMMIT_2}"
		"clang-format-${CLANG_FORMAT_COMMIT_3:0:7}.tar.gz;clang-format-${CLANG_FORMAT_COMMIT_3}"
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
		"emsdk-${EMSDK_COMMIT_1:0:7}.tar.gz:emsdk-${EMSDK_COMMIT_1}"
		"emsdk-${EMSDK_COMMIT_2:0:7}.tar.gz:emsdk-${EMSDK_COMMIT_2}"
		"es-cts-${GLES1_CONFORM_COMMIT:0:7}.tar.gz;es-cts-${GLES1_CONFORM_COMMIT}"
		"flatbuffers-${FLATBUFFERS_COMMIT:0:7}.tar.gz;flatbuffers-${FLATBUFFERS_COMMIT}"
		"git-hooks-${GIT_HOOKS_COMMIT:0:7}.tar.gz;git-hooks-${GIT_HOOKS_COMMIT}"
		"glfw-${GLFW_COMMIT_1:0:7}.tar.gz;glfw-${GLFW_COMMIT_1}"
		"glmark2-${GLMARK2_COMMIT:0:7}.tar.gz;glmark2-${GLMARK2_COMMIT}"
		"glslang-${GLSLANG_COMMIT_1:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_1}"
		"glslang-${GLSLANG_COMMIT_4:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_4}"
		"glslang-${GLSLANG_COMMIT_5:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_5}"
		"glslang-${GLSLANG_COMMIT_6:0:7}.tar.gz;glslang-${GLSLANG_COMMIT_6}"
		"googletest-${GOOGLETEST_COMMIT_9:0:7}.tar.gz;googletest-${GOOGLETEST_COMMIT_9}"
		"ijar-${IJAR_COMMIT:0:7}.tar.gz;ijar-${IJAR_COMMIT}"
		"jinja2-${JINJA2_COMMIT_1:0:7}.tar.gz;jinja2-${JINJA2_COMMIT_1}"
		"jinja2-${JINJA2_COMMIT_2:0:7}.tar.gz;jinja2-${JINJA2_COMMIT_2}"
		"jinja2-${JINJA2_COMMIT_3:0:7}.tar.gz;jinja2-${JINJA2_COMMIT_3}"
		"jsoncpp-${JSONCPP_COMMIT_3:0:7}.tar.gz;jsoncpp-${JSONCPP_COMMIT_3}"
		"jsoncpp-${JSONCPP_COMMIT_4:0:7}.tar.gz;jsoncpp-${JSONCPP_COMMIT_4}"
		"libc++-${LIBCXX_COMMIT_1:0:7}.tar.gz;libc++-${LIBCXX_COMMIT_1}"
		"libc++-${LIBCXX_COMMIT_2:0:7}.tar.gz;libc++-${LIBCXX_COMMIT_2}"
		"libc++-${LIBCXX_COMMIT_3:0:7}.tar.gz;libc++-${LIBCXX_COMMIT_3}"
		"libc++abi-${LIBCXXABI_COMMIT_1:0:7}.tar.gz;libc++abi-${LIBCXXABI_COMMIT_1}"
		"libc++abi-${LIBCXXABI_COMMIT_2:0:7}.tar.gz;libc++abi-${LIBCXXABI_COMMIT_2}"
		"libc++abi-${LIBCXXABI_COMMIT_3:0:7}.tar.gz;libc++abi-${LIBCXXABI_COMMIT_3}"
		"libdrm-${LIBDRM_COMMIT_1:0:7}.tar.gz;libdrm-${LIBDRM_COMMIT_1}"
		"libdrm-${LIBDRM_COMMIT_2:0:7}.tar.gz;libdrm-${LIBDRM_COMMIT_2}"
		"libdrm-${LIBDRM_COMMIT_3:0:7}.tar.gz;libdrm-${LIBDRM_COMMIT_3}"
		"libfuzzer-${LIBFUZZER_COMMIT_1:0:7}.tar.gz;libfuzzer-${LIBFUZZER_COMMIT_1}"
		"libjpeg_turbo-${LIBJPEG_TURBO_COMMIT:0:7}.tar.gz;libjpeg_turbo-${LIBJPEG_TURBO_COMMIT}"
		"libpng-${LIBPNG_COMMIT:0:7}.tar.gz;libpng-${LIBPNG_COMMIT}"
		"libunwind-${LIBUNWIND_COMMIT:0:7}.tar.gz;libunwind-${LIBUNWIND_COMMIT}"
		"llvm-${LLVM_COMMIT:0:7}.tar.gz;llvm-${LLVM_COMMIT}"
		"llvm-libc-${LLVM_LIBC_COMMIT_1:0:7}.tar.gz;llvm-libc-${LLVM_LIBC_COMMIT_1}"
		"llvm-libc-${LLVM_LIBC_COMMIT_2:0:7}.tar.gz;llvm-libc-${LLVM_LIBC_COMMIT_2}"
		"lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1:0:7}.tar.gz;lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}"
		"lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_3:0:7}.tar.gz;lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_3}"
		"lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_4:0:7}.tar.gz;lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_4}"
		"markupsafe-${MARKUPSAFE_COMMIT_1:0:7}.tar.gz;markupsafe-${MARKUPSAFE_COMMIT_1}"
		"markupsafe-${MARKUPSAFE_COMMIT_2:0:7}.tar.gz;markupsafe-${MARKUPSAFE_COMMIT_2}"
		"markupsafe-${MARKUPSAFE_COMMIT_3:0:7}.tar.gz;markupsafe-${MARKUPSAFE_COMMIT_3}"
		"mb-${MB_COMMIT_1:0:7}.tar.gz;mb-${MB_COMMIT_1}"
		"mb-${MB_COMMIT_2:0:7}.tar.gz;mb-${MB_COMMIT_2}"
		"mb-${MB_COMMIT_3:0:7}.tar.gz;mb-${MB_COMMIT_3}"
		"md_browser-${MD_BROWSER_COMMIT:0:7}.tar.gz;md_browser-${MD_BROWSER_COMMIT}"
		"memory-${MEMORY_COMMIT_1:0:7}.tar.gz;memory-${MEMORY_COMMIT_1}"
		"memory-${MEMORY_COMMIT_2:0:7}.tar.gz;memory-${MEMORY_COMMIT_2}"
		"memory-${MEMORY_COMMIT_3:0:7}.tar.gz;memory-${MEMORY_COMMIT_3}"
		"mesa-${MESA_COMMIT_1:0:7}.tar.gz;mesa-${MESA_COMMIT_1}"
		"mesa-${MESA_COMMIT_2:0:7}.tar.gz;mesa-${MESA_COMMIT_2}"
		"meson-${MESON_COMMIT_1:0:7}.tar.gz;meson-${MESON_COMMIT_1}"
		"meson-${MESON_COMMIT_2:0:7}.tar.gz;meson-${MESON_COMMIT_2}"
		"nasm-${NASM_COMMIT:0:7}.tar.gz;nasm-${NASM_COMMIT}"
		"opencl-cts-${OPENCL_CTS_COMMIT:0:7}.tar.gz;opencl-cts-${OPENCL_CTS_COMMIT}"
		"opencl-docs-${OPENCL_DOCS_COMMIT:0:7}.tar.gz;opencl-docs-${OPENCL_DOCS_COMMIT}"
		"opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT:0:7}.tar.gz;opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT}"
		"opengl-registry-${OPENGL_REGISTRY_COMMIT_1:0:7}.tar.gz;opengl-registry-${OPENGL_REGISTRY_COMMIT_1}"
		"opengl-registry-${OPENGL_REGISTRY_COMMIT_2:0:7}.tar.gz;opengl-registry-${OPENGL_REGISTRY_COMMIT_2}"
		"partition_allocator-${PARTITION_ALLOCATOR_COMMIT_1:0:7}.tar.gz;partition_allocator-${PARTITION_ALLOCATOR_COMMIT_1}"
		"perf-${PERF_COMMIT:0:7}.tar.gz;perf-${PERF_COMMIT}"
		"perfetto-${PERFETTO_COMMIT:0:7}.tar.gz;perfetto-${PERFETTO_COMMIT}"
		"protobuf-${PROTOBUF_COMMIT_1:0:7}.tar.gz;protobuf-${PROTOBUF_COMMIT_1}"
		"protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1:0:7}.tar.gz;protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1}"
		"protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2:0:7}.tar.gz;protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2}"
		"protoc_wrapper-${PROTOC_WRAPPER_COMMIT_3:0:7}.tar.gz;protoc_wrapper-${PROTOC_WRAPPER_COMMIT_3}"
		"python-${PYTHON_COMMIT:0:7}.tar.gz;python-${PYTHON_COMMIT}"
		"python-markdown-${PYTHON_MARKDOWN_COMMIT:0:7}.tar.gz;python-markdown-${PYTHON_MARKDOWN_COMMIT}"
		"rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz;rapidjson-${RAPIDJSON_COMMIT}"
		"requests-${REQUESTS_COMMIT:0:7}.tar.gz;requests-${REQUESTS_COMMIT}"
		"rust-${RUST_COMMIT_2:0:7}.tar.gz;rust-${RUST_COMMIT_2}"
		"rust-${RUST_COMMIT_4:0:7}.tar.gz;rust-${RUST_COMMIT_4}"
		"six-${SIX_COMMIT:0:7}.tar.gz;six-${SIX_COMMIT}"
		"spirv-cross-${SPIRV_CROSS_COMMIT_1:0:7}.tar.gz;spirv-cross-${SPIRV_CROSS_COMMIT_1}"
		"spirv-headers-${SPIRV_HEADERS_COMMIT_1:0:7}.tar.gz;SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"
		"spirv-headers-${SPIRV_HEADERS_COMMIT_3:0:7}.tar.gz;SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}"
		"spirv-headers-${SPIRV_HEADERS_COMMIT_4:0:7}.tar.gz;SPIRV-Headers-${SPIRV_HEADERS_COMMIT_4}"
		"spirv-tools-${SPIRV_TOOLS_COMMIT_1:0:7}.tar.gz;SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"
		"spirv-tools-${SPIRV_TOOLS_COMMIT_3:0:7}.tar.gz;SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}"
		"spirv-tools-${SPIRV_TOOLS_COMMIT_4:0:7}.tar.gz;SPIRV-Tools-${SPIRV_TOOLS_COMMIT_4}"
		"swiftshader-${SWIFTSHADER_COMMIT_1:0:7}.tar.gz;swiftshader-${SWIFTSHADER_COMMIT_1}"
		"swiftshader-${SWIFTSHADER_COMMIT_2:0:7}.tar.gz;swiftshader-${SWIFTSHADER_COMMIT_2}"
		"testing-${TESTING_COMMIT_1:0:7}.tar.gz;testing-${TESTING_COMMIT_1}"
		"testing-${TESTING_COMMIT_2:0:7}.tar.gz;testing-${TESTING_COMMIT_2}"
		"testing-${TESTING_COMMIT_3:0:7}.tar.gz;testing-${TESTING_COMMIT_3}"
		"valgrind-${VALGRIND_COMMIT_1:0:7}.tar.gz;valgrind-${VALGRIND_COMMIT_1}"
		"valgrind-${VALGRIND_COMMIT_2:0:7}.tar.gz;valgrind-${VALGRIND_COMMIT_2}"
		"valgrind-${VALGRIND_COMMIT_3:0:7}.tar.gz;valgrind-${VALGRIND_COMMIT_3}"
		"valgrind-${VALGRIND_COMMIT_4:0:7}.tar.gz;valgrind-${VALGRIND_COMMIT_4}"
		"vk-gl-cts-${VK_GL_CTS_COMMIT:0:7}.tar.gz;vk-gl-cts-${VK_GL_CTS_COMMIT}"
		"vulkan-deps-${VULKAN_DEPS_COMMIT_1:0:7}.tar.gz;vulkan-deps-${VULKAN_DEPS_COMMIT_1}"
		"vulkan-deps-${VULKAN_DEPS_COMMIT_2:0:7}.tar.gz;vulkan-deps-${VULKAN_DEPS_COMMIT_2}"
		"vulkan-deps-${VULKAN_DEPS_COMMIT_3:0:7}.tar.gz;vulkan-deps-${VULKAN_DEPS_COMMIT_3}"
		"vulkan-headers-${VULKAN_HEADERS_COMMIT_1:0:7}.tar.gz;vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"
		"vulkan-headers-${VULKAN_HEADERS_COMMIT_2:0:7}.tar.gz;vulkan-headers-${VULKAN_HEADERS_COMMIT_2}"
		"vulkan-loader-${VULKAN_LOADER_COMMIT_1:0:7}.tar.gz;vulkan-loader-${VULKAN_LOADER_COMMIT_1}"
		"vulkan-loader-${VULKAN_LOADER_COMMIT_2:0:7}.tar.gz;vulkan-loader-${VULKAN_LOADER_COMMIT_2}"
		"vulkan-loader-${VULKAN_LOADER_COMMIT_3:0:7}.tar.gz;vulkan-loader-${VULKAN_LOADER_COMMIT_3}"
		"vulkan-tools-${VULKAN_TOOLS_COMMIT_1:0:7}.tar.gz;vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"
		"vulkan-tools-${VULKAN_TOOLS_COMMIT_2:0:7}.tar.gz;vulkan-tools-${VULKAN_TOOLS_COMMIT_2}"
		"vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1:0:7}.tar.gz;vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"
		"vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2:0:7}.tar.gz;vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}"
		"vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1:0:7}.tar.gz;vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}"
		"vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2:0:7}.tar.gz;vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}"
		"vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_3:0:7}.tar.gz;vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_3}"
		"VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1:0:7}.tar.gz;VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}"
		"VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2:0:7}.tar.gz;VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_2}"
		"VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_3:0:7}.tar.gz;VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_3}"
		"wayland-${WAYLAND_COMMIT:0:7}.tar.gz;wayland-${WAYLAND_COMMIT}"
		"webgpu-cts-${WEBGPU_CTS_COMMIT_1:0:7}.tar.gz;webgpu-cts-${WEBGPU_CTS_COMMIT_1}"
		"webgpu-cts-${WEBGPU_CTS_COMMIT_2:0:7}.tar.gz;webgpu-cts-${WEBGPU_CTS_COMMIT_2}"
		"webgpu-headers-${WEBGPU_HEADERS_COMMIT_1:0:7}.tar.gz;webgpu-headers-${WEBGPU_HEADERS_COMMIT_1}"
		"webgpu-headers-${WEBGPU_HEADERS_COMMIT_2:0:7}.tar.gz;webgpu-headers-${WEBGPU_HEADERS_COMMIT_2}"
		"win-${WIN_COMMIT_1:0:7}.tar.gz;win-${WIN_COMMIT_1}"
		"win-${WIN_COMMIT_2:0:7}.tar.gz;win-${WIN_COMMIT_2}"
		"win-${WIN_COMMIT_3:0:7}.tar.gz;win-${WIN_COMMIT_3}"
		"zlib-${ZLIB_COMMIT_1:0:7}.tar.gz;zlib-${ZLIB_COMMIT_1}"
		"zlib-${ZLIB_COMMIT_2:0:7}.tar.gz;zlib-${ZLIB_COMMIT_2}"
		"zlib-${ZLIB_COMMIT_3:0:7}.tar.gz;zlib-${ZLIB_COMMIT_3}"
	)

	local f
	for f in ${ARGS[@]} ; do
		local is_no_root_submodule=0
		local is_protoc_submodule=0
		local row

		[[ -e "${DISTDIR}/${f}" ]] || continue

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

src_unpack_external_modules() { # .gitmodules
# ${S}/cmake/external for https://github.com/microsoft/onnxruntime/blob/v1.26.0/.gitmodules
	dep_prepare_cp "${WORKDIR}/emsdk-${EMSDK_PV}"							"${S}/cmake/external/emsdk"
	dep_prepare_cp "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_1}"			"${S}/cmake/external/libprotobuf-mutator"
	dep_prepare_cp "${WORKDIR}/onnx-${ONNX_PV_1}"							"${S}/cmake/external/onnx"
}

src_unpack_external_deps() { # *cmake/deps.txt*
# ${S}/cmake/external for https://github.com/microsoft/onnxruntime/blob/v1.26.0/cmake/deps.txt
	dep_prepare_cp "${WORKDIR}/coremltools-${COREMLTOOLS_PV}"					"${S}/cmake/external/coremltools"
	dep_prepare_cp "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}"						"${S}/cmake/external/pytorch_cpuinfo"
	dep_prepare_cp "${WORKDIR}/date-${DATE_PV_1}"							"${S}/cmake/external/date-1"
	use webgpu && dep_prepare_cp "${WORKDIR}/dawn-${DAWN_COMMIT_1}"					"${S}/cmake/external/dawn"
	dep_prepare_cp "${WORKDIR}/DirectX-Headers-${DIRECTX_HEADERS_PV}"				"${S}/cmake/external/directx_headers"
	dep_prepare_cp "${WORKDIR}/duktape-${DUKTAPE_PV}"						"${S}/cmake/external/duktape"
	dep_prepare_cp "${WORKDIR}/dlpack-${DLPACK_COMMIT_2}"						"${S}/cmake/external/dlpack"
	dep_prepare_cp "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}"					"${S}/cmake/external/flatbuffers"
	dep_prepare_cp "${WORKDIR}/GSL-${GSL_PV}"							"${S}/cmake/external/microsoft_gsl"
	dep_prepare_cp "${WORKDIR}/json-${JSON_PV}"							"${S}/cmake/external/json"
	dep_prepare_cp "${WORKDIR}/kleidiai-v${KLEIDIAI_PV}"						"${S}/cmake/external/kleidiai"
	dep_prepare_cp "${WORKDIR}/kleidiai-${KLEIDIAI_QMX_COMMIT}"					"${S}/cmake/external/kleidiai-qmx"
	dep_prepare_cp "${WORKDIR}/mp11-boost-${MP11_PV}"						"${S}/cmake/external/mp11"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_PV_1}"						"${S}/cmake/external/protobuf"

	dep_prepare_cp "${WORKDIR}/protoc_win64-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_win64"
	dep_prepare_cp "${WORKDIR}/protoc_win32-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_win32"
	dep_prepare_cp "${WORKDIR}/protoc_linux_x64-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_linux_x64"
	dep_prepare_cp "${WORKDIR}/protoc_linux_x86-${PROTOBUF_PV_1}"					"${S}/cmake/external/protoc_linux_x86"
	dep_prepare_cp "${WORKDIR}/protoc_linux_aarch64-${PROTOBUF_PV_1}"				"${S}/cmake/external/protoc_linux_aarch64"
	dep_prepare_cp "${WORKDIR}/protoc_mac_universal-${PROTOBUF_PV_1}"				"${S}/cmake/external/protoc_mac_universal"

	dep_prepare_cp "${WORKDIR}/re2-${RE2_PV}"							"${S}/cmake/external/re2"
	dep_prepare_cp "${WORKDIR}/SafeInt-${SAFEINT_PV}"						"${S}/cmake/external/safeint"

	dep_prepare_cp "${WORKDIR}/Vulkan-Headers-${VULKAN_HEADERS_PV}"					"${S}/cmake/external/vulkan_headers"

	dep_prepare_cp "${WORKDIR}/wil-${WIL_PV}"							"${S}/cmake/external/microsoft_wil"

	if use abseil-cpp ; then
		dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV_2}"				"${S}/cmake/external/abseil_cpp"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_PV}"					"${S}/cmake/external/google_benchmark"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}"				"${S}/cmake/external/protobuf/third_party/benchmark"
	fi
	if use cuda ; then
		dep_prepare_cp "${WORKDIR}/cudnn-frontend-${CUDNN_FRONTEND_PV}"				"${S}/cmake/external/cudnn-frontend"
		dep_prepare_cp "${WORKDIR}/cutlass-${CUTLASS_PV}"					"${S}/cmake/external/cutlass"
	fi
	if ! use system-eigen ; then
		dep_prepare_cp "${WORKDIR}/eigen-${EIGEN_COMMIT}"					"${S}/cmake/external/eigen"
	fi
	if use extensions ; then
		dep_prepare_cp "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}"	"${S}/cmake/external/extensions"
	fi
	if use mimalloc ; then
		dep_prepare_cp "${WORKDIR}/mimalloc-${MIMALLOC_PV}"					"${S}/cmake/external/mimalloc"
	fi
	if use python ; then
		dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_PV}"					"${S}/cmake/external/pybind11"
	fi
	if use tensorrt-oss-parser ; then
		dep_prepare_cp "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT_COMMIT}"			"${S}/cmake/external/onnx_tensorrt"
	fi
	if use training ; then
		dep_prepare_cp "${WORKDIR}/tensorboard-${TENSORBOARD_COMMIT}"				"${S}/cmake/external/tensorboard"
	fi
	if use test || use training ; then
		dep_prepare_cp "${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}"					"${S}/cmake/external/cxxopts"
	fi
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_PV_1}"				"${S}/cmake/external/googletest" # For onnxruntime_external_deps.cmake
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_5}"				"${S}/cmake/external/protobuf/third_party/googletest"
	fi
	if use xnnpack ; then
		dep_prepare_cp "${WORKDIR}/FP16-${FP16_COMMIT}"						"${S}/cmake/external/fp16"
		dep_prepare_cp "${WORKDIR}/FXdiv-${FXDIV_COMMIT}"					"${S}/cmake/external/fxdiv"
		dep_prepare_cp "${WORKDIR}/psimd-${PSIMD_COMMIT}"					"${S}/cmake/external/psimd"
		dep_prepare_cp "${WORKDIR}/XNNPACK-${XNNPACK_COMMIT}"					"${S}/cmake/external/googlexnnpack"
		dep_prepare_cp "${WORKDIR}/pthreadpool-${PTHREADPOOL_COMMIT}"				"${S}/cmake/external/pthreadpool"
	fi

	if use tensorrt-oss-parser ; then
		dep_prepare_cp "${WORKDIR}/onnx-${ONNX_COMMIT_1}"					"${S}/cmake/external/onnx_tensorrt/third_party/onnx"
		dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}"				"${S}/cmake/external/onnx_tensorrt/third_party/onnx/third_party/pybind11"
	fi

	if use test ; then
# See https://github.com/google/flatbuffers/blob/v23.5.26/benchmarks/CMakeLists.txt
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"				"${S}/cmake/external/flatbuffers/third_party/googletest"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_2}"				"${S}/cmake/external/flatbuffers/third_party/googlebenchmark"
	fi
}

src_unpack_dawn() { # *dawn*
# ${S}/cmake/external/dawn for https://dawn.googlesource.com/dawn/+/ec7b457e5bb1fcec6f59733c4f3dd84d2f885a38/.gitmodules
	dep_prepare_cp "${WORKDIR}/build-${BUILD_COMMIT_1}"							"${S}/cmake/external/dawn/build"
	dep_prepare_cp "${WORKDIR}/clang-${CLANG_COMMIT_1}"							"${S}/cmake/external/dawn/tools/clang"
	dep_prepare_cp "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/depot_tools"
	dep_prepare_cp "${WORKDIR}/libc++-${LIBCXX_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/libc++/src"
	dep_prepare_cp "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/libc++abi/src"
	dep_prepare_cp "${WORKDIR}/libdrm-${LIBDRM_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/libdrm/src"
	dep_prepare_cp "${WORKDIR}/llvm-libc-${LLVM_LIBC_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/llvm-libc/src"
	dep_prepare_cp "${WORKDIR}/memory-${MEMORY_COMMIT_1}"							"${S}/cmake/external/dawn/tools/memory"
	dep_prepare_cp "${WORKDIR}/valgrind-${VALGRIND_COMMIT_2}"						"${S}/cmake/external/dawn/tools/valgrind"

	dep_prepare_cp "${WORKDIR}/win-${WIN_COMMIT_1}"								"${S}/cmake/external/dawn/tools/win"
	dep_prepare_cp "${WORKDIR}/mb-${MB_COMMIT_1}"								"${S}/cmake/external/dawn/tools/mb"
	dep_prepare_cp "${WORKDIR}/testing-${TESTING_COMMIT_1}"							"${S}/cmake/external/dawn/testing"
	dep_prepare_cp "${WORKDIR}/libfuzzer-${LIBFUZZER_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/libFuzzer/src"

	dep_prepare_cp "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_1}"						"${S}/cmake/external/dawn/buildtools"

	dep_prepare_cp "${WORKDIR}/catapult-${CATAPULT_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/catapult"

	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}"					"${S}/cmake/external/dawn/third_party/googletest"
	fi
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_5}"					"${S}/cmake/external/dawn/third_party/google_benchmark/src"
	fi
	dep_prepare_cp "${WORKDIR}/mesa-${MESA_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/mesa/src"
	dep_prepare_cp "${WORKDIR}/meson-${MESON_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/meson/src"
	dep_prepare_cp "${WORKDIR}/jinja2-${JINJA2_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/jinja2"
	dep_prepare_cp "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/markupsafe"
	dep_prepare_cp "${WORKDIR}/glfw-${GLFW_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/glfw"
	dep_prepare_cp "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}"			"${S}/cmake/external/dawn/third_party/vulkan_memory_allocator"
	dep_prepare_cp "${WORKDIR}/angle-${ANGLE_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/angle"
	dep_prepare_cp "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/swiftshader"
	dep_prepare_cp "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/vulkan-deps"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/glslang/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/vulkan-validation-layers/src"
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/zlib"
	dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/abseil-cpp"
	dep_prepare_cp "${WORKDIR}/dxc-${DXC_COMMIT_1}"								"${S}/cmake/external/dawn/third_party/dxc"
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}"						"${S}/cmake/external/dawn/third_party/dxheaders"
	dep_prepare_cp "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/khronos/OpenGL-Registry"
	dep_prepare_cp "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}"						"${S}/cmake/external/dawn/third_party/khronos/EGL-Registry"
	dep_prepare_cp "${WORKDIR}/webgpu-cts-${WEBGPU_CTS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/webgpu-cts"
	dep_prepare_cp "${WORKDIR}/emsdk-${EMSDK_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/emsdk"

	dep_prepare_cp "${WORKDIR}/node-api-headers-${NODE_API_HEADERS_COMMIT}"					"${S}/cmake/external/dawn/third_party/node-api-headers"
	dep_prepare_cp "${WORKDIR}/node-addon-api-${NODE_ADDON_API_COMMIT}"					"${S}/cmake/external/dawn/third_party/node-addon-api"
	dep_prepare_cp "${WORKDIR}/gpuweb-${GPUWEB_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/gpuweb"
	dep_prepare_cp "${WORKDIR}/webgpu-headers-${WEBGPU_HEADERS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/webgpu-headers/src"
	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/protobuf"
	dep_prepare_cp "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_1}"					"${S}/cmake/external/dawn/tools/protoc_wrapper"
	dep_prepare_cp "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/libprotobuf-mutator/src"
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/langsvr-${LANGSVR_COMMIT}"							"${S}/cmake/external/dawn/third_party/langsvr"
	dep_prepare_cp "${WORKDIR}/partition_allocator-${PARTITION_ALLOCATOR_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/partition_alloc"

	dep_prepare_cp "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/clang-format/script"

# See https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+/refs/heads/upstream/main/.gitmodules
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/dxc/external/SPIRV-Headers"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/dxc/external/SPIRV-Tools"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}"					"${S}/cmake/external/dawn/third_party/dxc/external/googletest" # Commit not logged, reused googltest commit from dawn
	fi
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}"						"${S}/cmake/external/dawn/third_party/dxc/external/DirectX-Headers"

# See https://github.com/google/langsvr/blob/303c526231a90049a3e384549720f3fbd453cf66/.gitmodules
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_6}"					"${S}/cmake/external/dawn/third_party/langsvr/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_4}"							"${S}/cmake/external/dawn/third_party/langsvr/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/lsprotocol-${LSPROTOCOL_COMMIT}"						"${S}/cmake/external/dawn/third_party/langsvr/third_party/lsprotocol"

# See https://swiftshader.googlesource.com/SwiftShader/+/b7b7fd22e5f28079b92412f47f6da4df43e4cd37/.gitmodules
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}"					"${S}/cmake/external/dawn/third_party/swiftshader/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/cppdap-${CPPDAP_COMMIT}"							"${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/"
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_1}"							"${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/third_party/json"
	dep_prepare_cp "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}"						"${S}/cmake/external/dawn/third_party/swiftshader/third_party/git-hooks"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/swiftshader/third_party/glslang"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}"					"${S}/cmake/external/dawn/third_party/swiftshader/third_party/cppdap/third_party/googletest"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/swiftshader/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/swiftshader/third_party/json"
	dep_prepare_cp "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/swiftshader/third_party/libbacktrace/src"
	dep_prepare_cp "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}"						"${S}/cmake/external/dawn/third_party/swiftshader/third_party/llvm-project"
	dep_prepare_cp "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}"					"${S}/cmake/external/dawn/third_party/swiftshader/third_party/PowerVR_Examples"

# See https://chromium.googlesource.com/vulkan-deps/+/a26b8836968dc480ad283234823e6ffc62052489/.gitmodules
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_6}"							"${S}/cmake/external/dawn/third_party/vulkan-deps/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/vulkan-deps/vulkan-validation-layers/src"
}

src_unpack_dawn_angle() { # dawn > *angle*
# ${S}/cmake/external/dawn/third_party/angle for https://chromium.googlesource.com/angle/angle/+/cce16dfb64c7525c6a417f98c67423330db8f3d7/.gitmodules
	dep_prepare_cp "${WORKDIR}/build-${BUILD_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/build"
	dep_prepare_cp "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/buildtools"
	dep_prepare_cp "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/clang-format/script"
	dep_prepare_cp "${WORKDIR}/testing-${TESTING_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/testing"
	dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_4}"					"${S}/cmake/external/dawn/third_party/angle/third_party/abseil-cpp"
	dep_prepare_cp "${WORKDIR}/android-deps-${ANDROID_DEPS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/android_deps"
	dep_prepare_cp "${WORKDIR}/android_build_tools-${ANDROID_BUILD_TOOLS_COMMIT}"			"${S}/cmake/external/dawn/third_party/angle/third_party/android_build_tools"
	dep_prepare_cp "${WORKDIR}/android_platform-${ANDROID_PLATFORM_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/android_platform"
	dep_prepare_cp "${WORKDIR}/android_sdk-${ANDROID_SDK_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/android_sdk"
	dep_prepare_cp "${WORKDIR}/astc-encoder-${ASTC_ENCODER_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/astc-encoder/src"
	if use test ; then
# See https://chromium.googlesource.com/external/github.com/ARM-software/astc-encoder/+/2319d9c4d4af53a7fc7c52985e264ce6e8a02a9b/.gitmodules
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/astc-encoder/src/Source/GoogleTest"
	fi
	dep_prepare_cp "${WORKDIR}/catapult-${CATAPULT_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/catapult"
	dep_prepare_cp "${WORKDIR}/cherry-${CHERRY_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/cherry"
	dep_prepare_cp "${WORKDIR}/colorama-${COLORAMA_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/colorama/src"
	dep_prepare_cp "${WORKDIR}/clspv-${CLSPV_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/clspv/src"
	dep_prepare_cp "${WORKDIR}/cpu_features-${CPU_FEATURES_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/cpu_features/src"
	dep_prepare_cp "${WORKDIR}/dawn-${DAWN_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn"

	dep_prepare_cp "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/depot_tools"
	dep_prepare_cp "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/EGL-Registry/src"
	dep_prepare_cp "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/flatbuffers/src"
	dep_prepare_cp "${WORKDIR}/es-cts-${GLES1_CONFORM_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/gles1_conform"						# private
	dep_prepare_cp "${WORKDIR}/glmark2-${GLMARK2_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/glmark2/src"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_9}"				"${S}/cmake/external/dawn/third_party/angle/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/ijar-${IJAR_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/third_party/ijar"
	dep_prepare_cp "${WORKDIR}/libdrm-${LIBDRM_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/angle/third_party/libdrm"
	dep_prepare_cp "${WORKDIR}/libjpeg_turbo-${LIBJPEG_TURBO_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/libjpeg_turbo"
	dep_prepare_cp "${WORKDIR}/libpng-${LIBPNG_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/libpng/src"
	dep_prepare_cp "${WORKDIR}/llvm-${LLVM_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/third_party/llvm/src"
	dep_prepare_cp "${WORKDIR}/jinja2-${JINJA2_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/jinja2"
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/libc++-${LIBCXX_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/libc++/src"
	dep_prepare_cp "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/libc++abi/src"
	dep_prepare_cp "${WORKDIR}/libunwind-${LIBUNWIND_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/libunwind/src"
	dep_prepare_cp "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/markupsafe"
	dep_prepare_cp "${WORKDIR}/mesa-${MESA_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/mesa/src"
	dep_prepare_cp "${WORKDIR}/meson-${MESON_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/meson"
	dep_prepare_cp "${WORKDIR}/nasm-${NASM_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/third_party/nasm"
	dep_prepare_cp "${WORKDIR}/opencl-cts-${OPENCL_CTS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-CTS/src"
	dep_prepare_cp "${WORKDIR}/opencl-docs-${OPENCL_DOCS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-Docs/src"
	dep_prepare_cp "${WORKDIR}/opencl-icd-loader-${OPENCL_ICD_LOADER_COMMIT}"			"${S}/cmake/external/dawn/third_party/angle/third_party/OpenCL-ICD-Loader/src"
	dep_prepare_cp "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/OpenGL-Registry/src"
	dep_prepare_cp "${WORKDIR}/perfetto-${PERFETTO_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/perfetto"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/protobuf"

	dep_prepare_cp "${WORKDIR}/python-markdown-${PYTHON_MARKDOWN_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/Python-Markdown"
	dep_prepare_cp "${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/rapidjson/src"
	if use test ; then
# See https://chromium.googlesource.com/external/github.com/Tencent/rapidjson/+/781a4e667d84aeedbeb8184b7b62425ea66ec59f/.gitmodules
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_10}"				"${S}/cmake/external/dawn/third_party/angle/third_party/rapidjson/src/thirdparty/gtest"
	fi
	dep_prepare_cp "${WORKDIR}/re2-${RE2_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/third_party/re2/src"
	dep_prepare_cp "${WORKDIR}/requests-${REQUESTS_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/requests/src"
	dep_prepare_cp "${WORKDIR}/rust-${RUST_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/rust"
	dep_prepare_cp "${WORKDIR}/six-${SIX_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/third_party/six"

	dep_prepare_cp "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader"
# See https://swiftshader.googlesource.com/SwiftShader/+/b7b7fd22e5f28079b92412f47f6da4df43e4cd37/.gitmodules
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}"				"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/cppdap-${CPPDAP_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/"
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/third_party/json"
	dep_prepare_cp "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/git-hooks"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/glslang"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}"				"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/cppdap/third_party/googletest"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/json"
	dep_prepare_cp "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/libbacktrace/src"
	dep_prepare_cp "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/llvm-project"
	dep_prepare_cp "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/SwiftShader/third_party/PowerVR_Examples"

	dep_prepare_cp "${WORKDIR}/vk-gl-cts-${VK_GL_CTS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/VK-GL-CTS/src"

	dep_prepare_cp "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_5}"						"${S}/cmake/external/dawn/third_party/angle/third_party/glslang/src"

# See https://chromium.googlesource.com/vulkan-deps/+/196a50babcaaf1ef57048ef5484693f0d59f21c0/.gitmodules
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_5}"						"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_3}"			"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"	"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_3}"	"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-deps/vulkan-validation-layers/src"

	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_1}"			"${S}/cmake/external/dawn/third_party/angle/third_party/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_1}"	"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_3}"	"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan-validation-layers/src"
	dep_prepare_cp "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/angle/third_party/vulkan_memory_allocator"
	dep_prepare_cp "${WORKDIR}/wayland-${WAYLAND_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/wayland"
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/zlib"
	dep_prepare_cp "${WORKDIR}/android-${ANDROID_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/tools/android"
	dep_prepare_cp "${WORKDIR}/clang-${CLANG_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/tools/clang"
	dep_prepare_cp "${WORKDIR}/mb-${MB_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/angle/tools/mb"
	dep_prepare_cp "${WORKDIR}/md_browser-${MD_BROWSER_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/tools/md_browser"
	dep_prepare_cp "${WORKDIR}/memory-${MEMORY_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/tools/memory"
	dep_prepare_cp "${WORKDIR}/perf-${PERF_COMMIT}"							"${S}/cmake/external/dawn/third_party/angle/tools/perf"
	dep_prepare_cp "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/tools/protoc_wrapper"
	dep_prepare_cp "${WORKDIR}/python-${PYTHON_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/tools/python"
	dep_prepare_cp "${WORKDIR}/rust-${RUST_COMMIT_4}"						"${S}/cmake/external/dawn/third_party/angle/tools/rust"
	dep_prepare_cp "${WORKDIR}/valgrind-${VALGRIND_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/tools/valgrind"
	dep_prepare_cp "${WORKDIR}/win-${WIN_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/angle/tools/win"



}

src_unpack_dawn_angle_dawn() { # dawn > angle > *dawn*
# ${S}/cmake/external/dawn/third_party/angle/third_party/dawn for https://dawn.googlesource.com/dawn/+/c1308bb3f17e9637f82be72f7ed0a75f3427dda4/.gitmodules
	dep_prepare_cp "${WORKDIR}/buildtools-${BUILDTOOLS_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/buildtools"
	dep_prepare_cp "${WORKDIR}/clang-format-${CLANG_FORMAT_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/clang-format/script"
	dep_prepare_cp "${WORKDIR}/depot_tools-${DEPOT_TOOLS_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/depot_tools"
	dep_prepare_cp "${WORKDIR}/libc++-${LIBCXX_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libc++/src"
	dep_prepare_cp "${WORKDIR}/libc++abi-${LIBCXXABI_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libc++abi/src"
	dep_prepare_cp "${WORKDIR}/llvm-libc-${LLVM_LIBC_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/llvm-libc/src"
	dep_prepare_cp "${WORKDIR}/libdrm-${LIBDRM_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libdrm/src"
	dep_prepare_cp "${WORKDIR}/build-${BUILD_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/build"
	dep_prepare_cp "${WORKDIR}/clang-${CLANG_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/clang"
	dep_prepare_cp "${WORKDIR}/memory-${MEMORY_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/memory"
	dep_prepare_cp "${WORKDIR}/valgrind-${VALGRIND_COMMIT_4}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/valgrind"
	dep_prepare_cp "${WORKDIR}/win-${WIN_COMMIT_3}"							"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/win"
	dep_prepare_cp "${WORKDIR}/mb-${MB_COMMIT_3}"							"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/mb"
	dep_prepare_cp "${WORKDIR}/testing-${TESTING_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/testing"
	dep_prepare_cp "${WORKDIR}/libfuzzer-${LIBFUZZER_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libFuzzer/src"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_12}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/catapult-${CATAPULT_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/catapult"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_7}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/google_benchmark/src"
	fi
	dep_prepare_cp "${WORKDIR}/jinja2-${JINJA2_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/jinja2"
	dep_prepare_cp "${WORKDIR}/markupsafe-${MARKUPSAFE_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/markupsafe"
	dep_prepare_cp "${WORKDIR}/glfw-${GLFW_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/glfw"
	dep_prepare_cp "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_MEMORY_ALLOCATOR_COMMIT_1}"		"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan_memory_allocator"
	dep_prepare_cp "${WORKDIR}/angle-${ANGLE_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/angle"

# See https://swiftshader.googlesource.com/SwiftShader/+/f474b0ce14a6e466ef84c510d9b779c74341bc3d/.gitmodules
	dep_prepare_cp "${WORKDIR}/swiftshader-${SWIFTSHADER_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader"
	if use benchmark ; then
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_6}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/benchmark"
	fi
	dep_prepare_cp "${WORKDIR}/cppdap-${CPPDAP_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/"
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_1}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/third_party/json"
	dep_prepare_cp "${WORKDIR}/git-hooks-${GIT_HOOKS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/git-hooks"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/glslang"
	if use test ; then
# See https://github.com/google/cppdap/blob/1fd23dda91e01550be1a421de307e6fedb2035a9/.gitmodules
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_8}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/cppdap/third_party/googletest"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/json-${JSON_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/json"
	dep_prepare_cp "${WORKDIR}/libbacktrace-${LIBBACKTRACE_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/libbacktrace/src"
	dep_prepare_cp "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/llvm-project"
	dep_prepare_cp "${WORKDIR}/Native_SDK-${POWERVR_EXAMPLES_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/swiftshader/third_party/PowerVR_Examples"

# See https://chromium.googlesource.com/vulkan-deps/+/3114945eb0e3ec087a805053f0e0030dc7d54261/.gitmodules
	dep_prepare_cp "${WORKDIR}/vulkan-deps-${VULKAN_DEPS_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_4}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/glslang/src"
	dep_prepare_cp "${WORKDIR}/lunarg-vulkantools-${LUNARG_VULKANTOOLS_COMMIT_4}"			"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/lunarg-vulkantools/src"
	dep_prepare_cp "${WORKDIR}/spirv-cross-${SPIRV_CROSS_COMMIT_1}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-cross/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}"	"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}"	"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-deps/vulkan-validation-layers/src"

	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_4}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/glslang/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/spirv-headers/src"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_3}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/spirv-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-headers-${VULKAN_HEADERS_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-headers/src"
	dep_prepare_cp "${WORKDIR}/vulkan-loader-${VULKAN_LOADER_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-loader/src"
	dep_prepare_cp "${WORKDIR}/vulkan-tools-${VULKAN_TOOLS_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-tools/src"
	dep_prepare_cp "${WORKDIR}/vulkan-utility-libraries-${VULKAN_UTILITY_LIBRARIES_COMMIT_2}"	"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-utility-libraries/src"
	dep_prepare_cp "${WORKDIR}/vulkan-validation-layers-${VULKAN_VALIDATION_LAYERS_COMMIT_2}"	"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/vulkan-validation-layers/src"
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT_3}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/zlib"
	dep_prepare_cp "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT_5}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/abseil-cpp"
	dep_prepare_cp "${WORKDIR}/dxc-${DXC_COMMIT_2}"							"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc"
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxheaders"
	dep_prepare_cp "${WORKDIR}/webgpu-headers-${WEBGPU_HEADERS_COMMIT_2}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/webgpu-headers"
	dep_prepare_cp "${WORKDIR}/opengl-registry-${OPENGL_REGISTRY_COMMIT_1}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/khronos/OpenGL-Registry"
	dep_prepare_cp "${WORKDIR}/egl-registry-${EGL_REGISTRY_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/khronos/EGL-Registry"
	dep_prepare_cp "${WORKDIR}/webgpu-cts-${WEBGPU_CTS_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/webgpu-cts"
	dep_prepare_cp "${WORKDIR}/emsdk-${EMSDK_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/emsdk"
	dep_prepare_cp "${WORKDIR}/node-api-headers-${NODE_API_HEADERS_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/node-api-headers"
	dep_prepare_cp "${WORKDIR}/node-addon-api-${NODE_ADDON_API_COMMIT}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/node-addon-api"
	dep_prepare_cp "${WORKDIR}/gpuweb-${GPUWEB_COMMIT_2}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/gpuweb"

	dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT_2}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/protobuf"

	dep_prepare_cp "${WORKDIR}/protoc_wrapper-${PROTOC_WRAPPER_COMMIT_3}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/tools/protoc_wrapper"
	dep_prepare_cp "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT_2}"			"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/libprotobuf-mutator/src"
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_4}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/jsoncpp"

	dep_prepare_cp "${WORKDIR}/langsvr-${LANGSVR_COMMIT}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr"
# See https://github.com/google/langsvr/blob/303c526231a90049a3e384549720f3fbd453cf66/.gitmodules
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_6}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/jsoncpp-${JSONCPP_COMMIT_4}"						"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/jsoncpp"
	dep_prepare_cp "${WORKDIR}/lsprotocol-${LSPROTOCOL_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/langsvr/third_party/lsprotocol"

	dep_prepare_cp "${WORKDIR}/partition_allocator-${PARTITION_ALLOCATOR_COMMIT_2}"			"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/partition_alloc"

# See https://chromium.googlesource.com/external/github.com/microsoft/DirectXShaderCompiler/+/eede01664e70e676186021aba3df7ee3b5f4a92b/.gitmodules
	dep_prepare_cp "${WORKDIR}/SPIRV-Headers-${SPIRV_HEADERS_COMMIT_4}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc/external/SPIRV-Headers"
	dep_prepare_cp "${WORKDIR}/SPIRV-Tools-${SPIRV_TOOLS_COMMIT_4}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc/external/SPIRV-Tools"
	if use test ; then
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_12}"				"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc/external/googletest" # Commit not logged, reused googltest commit from dawn
	fi
	dep_prepare_cp "${WORKDIR}/dxheaders-${DXHEADERS_COMMIT}"					"${S}/cmake/external/dawn/third_party/angle/third_party/dawn/third_party/dxc/external/DirectX-Headers"

}

src_unpack() {
	_unpack ${A}

	src_unpack_external_modules
	src_unpack_external_deps
	if use webgpu ; then
		src_unpack_dawn
		src_unpack_dawn_angle
		src_unpack_dawn_angle_dwan
	fi
}

src_prepare() {
	eapply ${_PATCHES[@]}

	CMAKE_USE_DIR="${S}/cmake"

	python-single-r1_pkg_setup

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

	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
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

	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include"
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_QUIET=OFF
		-DFETCHCONTENT_SOURCE_DIR_CXXOPTS="${S}/cmake/external/flatbuffers/third_party/cxxopts"
		-DFETCHCONTENT_SOURCE_DIR_DATE="${S}/cmake/external/date-1"
		-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS="${S}/cmake/external/flatbuffers"
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
		-Donnxruntime_USE_TVM=OFF
		-Donnxruntime_USE_VITISAI=OFF
		-Donnxruntime_USE_WINML=OFF
		-Donnxruntime_USE_WEBGPU=OFF
		-Donnxruntime_USE_XNNPACK=$(usex xnnpack)
		-Donnxruntime_TVM_USE_HASH=OFF
		-Donnxruntime_WEBASSEMBLY_RUN_TESTS_IN_BROWSER=OFF
	)

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		mycmakeargs+=(
			-Donnxruntime_ENABLE_LTO=OFF
		)
	else
		mycmakeargs+=(
			-Donnxruntime_ENABLE_LTO=$(usex lto)
		)
	fi
	filter-lto

	cflags-hardened_append

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
# find /var/tmp/portage/sci-ml/onnxruntime-1.26.0/work/onnxruntime-1.26.0/cmake/_deps -name "*.so*" | cut -f 9- -d "/"
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
