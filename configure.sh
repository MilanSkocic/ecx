#!/bin/bash

export FPM_NAME="ecx"
export FPM_LIBNAME="lib$FPM_NAME"
export FPM_PYNAME="py$FPM_NAME"
export FPM_PY="python"
export FPM_PY_SRC="./src/$FPM_PYNAME"

# environment variables
export FPM_FC=gfortran
export FPM_CC=gcc
export FPM_BUILD_DIR="./build"
export FPM_INCLUDE_DIR="./include"
export FPM_FFLAGS="-std=f2008 -pedantic -Wall -Wextra"
export FPM_CFLAGS="-std=c11 -pedantic -Wall -Wextra"
export FPM_LDFLAGS=""
export FPM_DEFAULT_INSTALL_DIR="$HOME/.local"
export FPM_PLATFORM="linux"
export FPM_EXT=""
export FPM_ARCH="$(uname -m)"

# libs
LIBSLINUX=("libgfortran.so.5" "libquadmath.so.0")
LIBSDARWIN=("libgfortran.5" "libquadmath.0" "libgcc_s.1.1")
LIBSWINDOWS=("libgfortran-5" "libquadmath-0" "libgcc_s_seh-1" "libwinpthread-1")

ROOTLINUX="/usr/lib/x86_64-linux-gnu/"
ROOTDARWIN="/usr/local/opt/gcc/lib/gcc/current/"
ROOTWINDOWS="C:/msys64/mingw64/bin/"

export FPM_LIBS="${LIBSLINUX[@]}"
export FPM_ROOT="$ROOTLINUX"

if [[ "$OSTYPE" == "msys" ]]; then
    FPM_DEFAULT_INSTALL_DIR="${APPDATA//\\//}/local"
    FPM_PLATFORM="windows"
    FPM_ROOT=$ROOTWINDOWS
    FPM_EXT=".dll"
    FPM_LIBS=( "${LIBSWINDOWS[@]}" )
    PY="py -"
fi

if [[ "$OSTYPE" == "darwin"* ]];then
    FPM_PLATFORM="darwin"
    FPM_ROOT=$ROOTDARWIN
    FPM_EXT=".dylib"
    FPM_LIBS=( "${LIBSDARWIN[@]}" )
fi

cp -f VERSION ./py/VERSION
cp -f LICENSE ./py/LICENSE

echo "$(printenv | grep "FPM_")"
