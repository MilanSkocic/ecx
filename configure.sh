#!/bin/bash

export NAME="ecx"
export LIBNAME="lib$NAME"
export PYNAME="py$NAME"
export PY_SRC="./src/$PYNAME"

# environment variables
export FC=gfortran
export CC=gcc
export PY=python
export BUILD_DIR="./build"
export INCLUDE_DIR="./include"
export FPM_FFLAGS="-std=f2008 -pedantic -Wall -Wextra"
export FPM_CFLAGS="-std=c11 -pedantic -Wall -Wextra"
export FPM_LDFLAGS=""
export DEFAULT_INSTALL_DIR="$HOME/.local"
export PLATFORM="linux"
export EXT=".so"

# libs
# export LIBSLINUX=("libgfortran.so.5" "libquadmath.so.0")
export LIBSLINUX=""
export LIBSDARWIN=("libgfortran.5" "libquadmath.0" "libgcc_s.1.1")
export LIBSWINDOWS=("libgfortran-5" "libquadmath-0" "libgcc_s_seh-1" "libwinpthread-1")

export ROOTLINUX="/usr/lib/x86_64-linux-gnu/"
export ROOTDARWIN="/usr/local/opt/gcc/lib/gcc/current/"
export ROOTWINDOWS="C:/msys64/mingw64/bin/"

export LIBS="${LIBSLINUX[@]}"
export ROOT="$ROOTLINUX"

echo -n "Detecting platform..."
if [[ "$OSTYPE" == "msys" ]]; then
    DEFAULT_INSTALL_DIR="${APPDATA//\\//}/local"
    PLATFORM="windows"
    ROOT=$ROOTWINDOWS
    EXT=".dll"
    LIBS=( "${LIBSWINDOWS[@]}" )
    PY="py -"
fi

if [[ "$OSTYPE" == "darwin"* ]];then
    PLATFORM="darwin"
    ROOT=$ROOTDARWIN
    EXT=".dylib"
    LIBS=( "${LIBSDARWIN[@]}" )
fi
echo "OK"


echo "##### COMMON SETTINGS #####"
echo "* LIBNAME=" $LIBNAME
echo "* NAME=" $NAME

echo "##### FPM SETTINGS #####"
echo "* PLATFORM=" $PLATFORM
echo "* FPM_FFLAGS=" $FPM_FFLAGS
echo "* FPM_CFLAGS=" $FPM_CFLAGS
echo "* FPM_LDFLAGS=" $FPM_LDFLAGS

echo "##### INSTALLATION SETTINGS #####"
echo "* DEFAULT INSTALL DIR=" $DEFAULT_INSTALL_DIR
echo "* BUILD DIR=" $BUILD_DIR
echo "* INCLUDE_DIR=" $INCLUDE_DIR

echo "##### PYTHON SETTINGS #####"
echo "* PYTHON SRC=" $PY_SRC
echo "* PYNAME=" $PYNAME

echo "##### COMPILERS #####"
echo "* FC=" $FC
echo "* CC=" $CC
echo "* PY=" $PY

echo "##### LIBS #####"
echo "LIBS=" $LIBS
echo "ROOT=" $ROOT
echo ""


echo -n "Copying VERSION and LICENSE to py..."
cp -f VERSION ./py/VERSION
cp -f LICENSE ./py/LICENSE
echo "OK"
echo ""
