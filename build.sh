. configure.sh

echo ""
d=./build/install
make
make install prefix=$d

# echo ""
# echo "DEPLOY GFORTRAN LIBS"
# for lib in ${LIBS[@]}; do
#     if [ -f $ROOT$lib$EXT ]; then
#         cp -v $ROOT$lib$EXT $d/lib/
#     else
#         echo -n $lib$EXT" -> "
#         echo "Not found."
#     fi
# done


echo ""
echo "DEPLOY LIBS TO PYTHON"
cp -vf $d/bin/* py/$PY_SRC/
cp -vf $d/include/$NAME*.h py/$PY_SRC/
cp -vf $d/lib/* py/$PY_SRC/


if [[ $PLATFORM == "darwin" ]]; then
    echo ""
    echo "CHECK RPATHS FOR DARWIN"
    # for lib in ${LIBS[@]}; do
    #     install_name_tool -change /usr/local/opt/gcc@10/lib/gcc/10/$lib$EXT @loader_path/$lib$EXT $d/lib/$LIBNAME$EXT
    #     install_name_tool -change /usr/local/opt/gcc@10/lib/gcc/10/$lib$EXT @loader_path/$lib$EXT py/$PY_SRC/$LIBNAME$EXT
    # done
    otool -L $d/lib/$LIBNAME$EXT
fi

echo ""
echo "ZIP"
cd $d/
zip -r $NAME-$PLATFORM-$ARCH.zip .
cd ../../
mv $d/$NAME-$PLATFORM-$ARCH.zip ./build/


