#!/bin/bash

export NAME=$(cat fpm.toml | grep "name =" | awk -F '=' '{print $2}' | sed -E 's/[ "]//g')
export VERSION=$(cat VERSION)
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
export ARCH=$(uname -m)
export EXT=".so"

# libs
# export LIBSLINUX=("libgfortran.so.5" "libquadmath.so.0")
export LIBSLINUX=""
export LIBSDARWIN=("libgfortran.5" "libquadmath.0" "libgcc_s.1.1")
export LIBSWINDOWS=("libgfortran-5" "libquadmath-0" "libgcc_s_seh-1" "libwinpthread-1")

export ROOT="/usr/lib/x86_64-linux-gnu/"
export LIBS="${LIBSLINUX[@]}"

if [[ "$OSTYPE" == "msys" ]]; then
    DEFAULT_INSTALL_DIR="${APPDATA//\\//}/local"
    PLATFORM="windows"
    ARCH=$MSYSTEM_CARCH
    ROOT=$(dirname $(where gfortran))"\\"
    EXT=".dll"
    LIBS=( "${LIBSWINDOWS[@]}" )
    PY="py -"
    FPM_LDFLAGS="-static"
fi

if [[ "$OSTYPE" == "darwin"* ]];then
    PLATFORM="darwin"
    ROOT="/usr/local/opt/gcc/lib/gcc/current/"
    EXT=".dylib"
    LIBS=( "${LIBSDARWIN[@]}" )
    FPM_LDFLAGS="-static-libgfortran -static-libquadmath -static-libgcc"
fi

if [[ "$VERSION" == *"dev" ]]; then
    export VERSION=$(git rev-parse --short HEAD)
fi


echo "NAME=" $NAME
echo "LIBNAME=" $LIBNAME
echo "VERSION=" $VERSION

echo "PLATFORM=" $PLATFORM
echo "ARCH=" $ARCH
echo "FPM_FFLAGS=" $FPM_FFLAGS
echo "FPM_CFLAGS=" $FPM_CFLAGS
echo "FPM_LDFLAGS=" $FPM_LDFLAGS

echo "DEFAULT INSTALL DIR=" $DEFAULT_INSTALL_DIR
echo "BUILD DIR=" $BUILD_DIR
echo "INCLUDE_DIR=" $INCLUDE_DIR

echo "PYTHON SRC=" $PY_SRC
echo "PYNAME=" $PYNAME

echo "FC=" $FC
echo "CC=" $CC
echo "PY=" $PY

echo "LIBS=" ${LIBS[@]}
echo "ROOT=" $ROOT

tr -d '\r' < VERSION | tr -d '\n' > py/VERSION
cp -vf LICENSE ./py/LICENSE
