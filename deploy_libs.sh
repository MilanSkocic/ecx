d=./build/install/
mkdir -p $d/bin/
mkdir -p $d/include/
mkdir -p $d/lib/

# libs
# LIBSLINUX=("libgfortran.so.5" "libquadmath.so.0")
LIBSLINUX=""
LIBSDARWIN=("libgfortran.5" "libquadmath.0" "libgcc_s.1.1")
LIBSWINDOWS=("libgfortran-5" "libquadmath-0" "libgcc_s_seh-1" "libwinpthread-1")

ROOTLINUX="/usr/lib/x86_64-linux-gnu/"
ROOTDARWIN="/usr/local/opt/gcc/lib/gcc/current/"
ROOTWINDOWS="C:/msys64/mingw64/bin/"

export FPM_LIBS="${LIBSLINUX[@]}"
export FPM_ROOT="$ROOTLINUX"

echo "COPY GFORTRAN LIBS"
for lib in ${FPM_LIBS[@]}; do
    if [ -f $FPM_ROOT$lib$FPM_EXT ]; then
        cp -v $FPM_ROOT$lib$FPM_EXT $d/lib/
    else
        echo -n $lib$EXT" -> "
        echo "Not found."
    fi
done

echo "COPY TO PYTHON"
cp -vf $d/bin/* py/src/$PYNAME/
cp -vf $d/include/$NAME*.h py/src/$PYNAME/
cp -vf $d/lib/* py/src/$PYNAME/
echo ""
