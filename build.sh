echo "# CONFIGURE"
. configure.sh

echo "# BUILD"
make

echo  "# INSTALL"
d=./build/install/
make install prefix=$d

if [ "$FPM_PLATFORM" == "linux" ]; then
    echo "-> Setting rpath for $FPM_LIBNAME$FPM_EXT."
    patchelf --set-rpath $ORIGIN/$FPM_LIBNAME.so build/install/lib/$FPM_LIBNAME.so
    patchelf --print-rpath build/install/lib/$FPM_LIBNAME.so
fi

for lib in ${FPM_LIBS[@]}; do
    if [ -f $FPM_ROOT$lib$FPM_EXT ]; then
        cp -v $FPM_ROOT$lib$FPM_EXT $d/lib/
        if [ $FPM_PLATFORM == "linux" ]; then
            echo "-> Setting rpath for $lib"
            patchelf --set-rpath $ORIGIN/$lib $d/lib/$lib$FPM_EXT
            patchelf --print-rpath $d/lib/$lib$FPM_EXT
        fi
    else
        echo -n $lib$EXT" -> "
        echo "Not found."
    fi
done

echo "COPY TO PYTHON"
cp -vf $d/bin/* py/src/$FPM_PYNAME/
cp -vf $d/include/$FPM_NAME*.h py/src/$FPM_PYNAME/
cp -vf $d/lib/* py/src/$FPM_PYNAME/

echo ""
