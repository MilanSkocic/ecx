echo "# CONFIGURE"
. configure.sh

echo "# BUILD"
make

echo  "# INSTALL"
make install prefix=./build/install/

d=build/install/
mkdir -p $d/bin
mkdir -p $d/include
mkdir -p $d/lib
for lib in ${FPM_LIBS[@]}; do
    if [ -f $FPM_ROOT$lib$FPM_EXT ]; then
        cp -v $FPM_ROOT$lib$FPM_EXT $d/lib/
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
