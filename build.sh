. configure.sh
make clean
make
make install prefix=./build/install/

for lib in ${FPM_LIBS[@]}; do
    echo -n $lib$EXT" -> "
    if [ -f $FPM_ROOT$lib$FPM_EXT ]; then
        echo "Found."
        cp -v $FPM_ROOT$lib$FPM_EXT $d
    else
        echo "Not found."
    fi
done