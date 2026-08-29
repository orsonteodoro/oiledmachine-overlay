# Copyright 2022-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# CI:  R8.10
# Inferred from source:  D13 F43-F44 U26

# CI should tag with v510-code-daily-linux-x86_64

# Contains AI generated synthetic data in metadata.xml

RELEASE_TYPE="release"
VARIANT="stable"

inherit blender-v5.2

# For current version, see
# https://download.blender.org/source/
# https://builder.blender.org/download/daily/

# See eclass below for implementation:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-multibuild.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-v5.2.eclass

# For version bumps see,
# https://download.blender.org/release/Blender5.2/

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  turned-into-split-eclasses
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 3.6.0 (20230715)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 4.5.3 (20251011) with Clang 18
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.0.0 (20251130) with Clang 18
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 5.2.1 (20260828) with Clang 21
#USE="X abi12-compat alembic build_creator bullet clang color-management cycles
#dds draco elbeem embree fftw gmp jack jpeg2k llvm man materialx ndof nls openal
#opencl openexr openimagedenoise openimageio opensubdiv openvdb openxr osl pdf
#potrace sdl sndfile tbb tiff usd wayland webp -aot -asan -build_headless
#-cineon -cpudetection -cuda -cycles-path-guiding -dbus (-debug) -doc -ffmpeg
#-flac -gcc -heif -hiprt -hydra -icc -libaom -meshoptimizer -mp3 -nanovdb -nvcc
#-optix -opus -pipewire -pulseaudio -rav1e -release -rocm -rocm_7_2 -rubberband
#-svt-av1 -sycl -tbb-malloc-proxy -test -theora -uv-slim -valgrind -vorbis -vpx
#-webm -x264 -x265 -xvid"
#AMDGPU_TARGETS="-gfx1010 -gfx1011 -gfx1012 -gfx1030 -gfx1031 -gfx1032 -gfx1034
#-gfx1035 -gfx1036 -gfx1100 -gfx1101 -gfx1102 -gfx1103 -gfx1150 -gfx1151
#-gfx1152 -gfx1200 -gfx1201"
#CPU_FLAGS_MIPS="-msa"
#CPU_FLAGS_S390="-zvector"
#CPU_FLAGS_X86="<redacted>"
#CUDA_TARGETS="-compute_75 -sm_50 -sm_52 -sm_60 -sm_61 -sm_70 -sm_75 -sm_86
#-sm_89 -sm_120"
#EBUILD_REVISION="-37"
#GCC_SLOT="13_4 -14_3 -15_3 -16_1"
#LLVM_SLOT="21 -22"
#PATENT_STATUS="-nonfree"
#PYTHON_SINGLE_TARGET="python3_13 -python3_14"
# cycles render cube:  passed with workaround
# eevee render cube:   passed
# wayland:             passed
# X:                   passed
