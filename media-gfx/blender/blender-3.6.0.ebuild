# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit blender-v3.6

# For current version, see https://download.blender.org/source/

# See eclass below for implementation:
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-multibuild.eclass
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/blender-v3.6.eclass

# For version bumps see,
# https://download.blender.org/release/Blender3.6/

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  turned-into-split-eclasses
# OILEDMACHINE-OVERLAY-TEST:  PASSED with workarounds (interactive) 3.6.0 (20230714) with USE+=" -osl"
# OILEDMACHINE-OVERLAY-TEST:  FAIL (interactive) 3.6.0 (20230714) with USE+=" osl" ; segfaults
# USE="X abi10-compat alembic boost build_creator bullet collada
# color-management cycles cycles-path-guiding dds draco elbeem embree ffmpeg
# fftw gmp jack jemalloc jpeg2k llvm llvm-13 man materialx nanovdb ndof nls
# openal opencl openexr openimageio openmp opensubdiv openvdb openxr pdf potrace
# sdl sndfile tbb tiff usd wayland webp -aom -asan -build_headless -cpudetection
# -cuda -cycles-device-oneapi -cycles-hip -dbus (-debug) -doc -ebolt -epgo -flac
# -llvm-12 -llvm-14 -llvm-15 -mp3 -nvcc -nvrtc -openimagedenoise -optix -opus
# -osl -pulseaudio -r1 -release -test -theora -valgrind -vorbis -vpx -webm -x264
# -xvid"
# PYTHON_SINGLE_TARGET="python3_11 -python3_10"
# cycles render cube:  passed with workaround
# eevee render cube:   passed
