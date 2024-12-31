# Copyright 2022-2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EOL_DATE="Jun 2025"
RELEASE_TYPE="lts"
VARIANT="stable"

inherit blender-v3.6

# For current version, see
# https://download.blender.org/source/
# https://builder.blender.org/download/daily/

# See eclass below for implementation:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-multibuild.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-v3.6.eclass

# For version bumps see,
# https://download.blender.org/release/Blender3.6/

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  turned-into-split-eclasses
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 3.6.0 (20230715)
# USE="X abi10-compat alembic boost build_creator bullet collada
# color-management cycles cycles-path-guiding dds draco elbeem embree ffmpeg
# fftw gmp jack jemalloc jpeg2k llvm llvm-15 man materialx nanovdb ndof nls
# openal opencl openexr openimagedenoise openimageio openmp opensubdiv openvdb
# openxr osl pdf potrace release sdl sndfile tbb tiff usd wayland webp -aom
# -asan -build_headless -cpudetection -cuda -cycles-device-oneapi -cycles-hip
# -dbus (-debug) -doc -ebolt -epgo -flac -llvm-12 -llvm-13 -llvm-14 -mp3 -nvcc
# -nvrtc -optix -opus -pulseaudio -r1 -test -theora -valgrind -vorbis -vpx -webm
# -x264 -xvid"
# PYTHON_SINGLE_TARGET="python3_11 -python3_10"
# cycles render cube:  passed with workaround
# eevee render cube:   passed
# wayland:             passed
# X:                   passed
