. configure.sh

echo ""
d=./build/install
make
make install prefix=$d

echo ""
echo "DEPLOY GFORTRAN LIBS"
for lib in ${LIBS[@]}; do
    if [ -f $ROOT$lib$EXT ]; then
        cp -v $ROOT$lib$EXT $d/lib/
    else
        echo -n $lib$EXT" -> "
        echo "Not found."
    fi
done

echo ""
echo "DEPLOY LIBS TO PYTHON"
cp -vf $d/bin/* py/$PY_SRC/
cp -vf $d/include/$NAME*.h py/$PY_SRC/
cp -vf $d/lib/* py/$PY_SRC/

echo ""
echo "ZIP"
cd $d/
zip -r $NAME-$PLATFORM-$ARCH.zip .
cd ../../
mv $d/$NAME-$PLATFORM-$ARCH.zip ./build/

if [[ $PLATFORM == "darwin" ]]; then
    echo ""
    echo "CHECK RPATHS FOR DARWIN"
    for lib in ${LIBS[@]}; do
        otool -L $d/lib/$lib$EXT
        otool -L py/$PY_SRC/$lib$EXT
done

fi

