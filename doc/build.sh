#!/usr/bin/env bash

DOC_MAIN=00-main
DOC_SRC_DIR=src
DOC_BUILD_DIR=build
DOC_DEP_DIR=build/dependencies
DOC_FORMATS="man txt latex pdf html"
DOC_TEX=pdflatex
DOC_BIB=biber
DOC_NCL=makeindex
DOC_MK4CFG=make4ht.cfg
DOC_MK4BUILD=make4ht.mk4
DOC_TEXINFO=makeinfo
PREP_DOC_DIR=../prep/doc
DOC_NAME=$FPM_NAME

GIT="bibfiles drawings"

FLAGS_RM=-rfv
FLAGS_MV=-fv

FLAG_INFO=0
FLAG_PDF=0
FLAG_HTML=0

args=($*)
for arg in ${args[@]}; do
    case $arg in
        "info")
            FLAG_INFO=1
            ;;
        "pdf")
            FLAG_PDF=1
            ;;
        "html")
            FLAG_HTML=1
            ;;
        *)
            ;;
    esac
done

make_dirs (){
    echo "[INFO]: Generating folders."
    for format in $DOC_FORMATS; do
        mkdir -p $DOC_BUILD_DIR/$format
        mkdir -p $DOC_DEP_DIR
    done
    echo "[INFO]: Folders created."
}


dowload_dependencies () {
    echo "[INFO]: Downloading dependencies."
    for i in $GIT;do
        url="https://github.com/MilanSkocic/$i.git"
        if [[ ! -d $DOC_DEP_DIR/$i/ ]]; then 
            git clone $url $DOC_DEP_DIR/$i; 
            if [[ $?>0 ]]; then 
                echo "The repo $i could not be retrieved."; 
            fi
        fi
    done
    url=$DOC_DEP_DIR/drawings/figures/png
    target=PEC-*.png
    cp -fv $url/$target ./src/figures/

    url=$DOC_DEP_DIR/drawings/figures/png
    target=EIS-*.png
    cp -fv $url/$target ./src/figures/

    url=$DOC_DEP_DIR/bibfiles
    target=references.bib
    cp -fv $url/$target ./src/references.bib
    echo "[INFO]: Dependencies downloaded."
}

make_man () {
    echo "[INFO]: Generating man pages."
    files=$(ls $PREP_DOC_DIR/*.prepdoc)
    for file in $files; do
        man_name=$(basename -s .prepdoc $file)
        man_section=$(echo $man_name | cut -d "." -f 2)
        man_name_nosec=$(echo $man_name | cut -d "." -f 1)
        man_title=$(echo $man_name_nosec | sed "s/$DOC_NAME\_//g")
        man_number=${man_section:0:1}
        
        fp_man=$( echo $file | sed "s/.prepdoc//g")
        fp_man=$( echo $fp_man | sed "s:$PREP_DOC_DIR:$DOC_BUILD_DIR/man:g")
        
        fp_mantxt="$fp_man.txt"
        fp_mantxt=$( echo $fp_mantxt | sed "s:$DOC_BUILD_DIR/man:$DOC_BUILD_DIR/txt:g")
        
        fp_manhtml="$fp_man.html"
        fp_manhtml=$( echo $fp_manhtml | sed "s:$DOC_BUILD_DIR/man:$DOC_BUILD_DIR/html:g")
        
        fp_mantex="$fp_man.tex"
        fp_mantex=$( echo $fp_mantex | sed "s:$DOC_BUILD_DIR/man:$DOC_BUILD_DIR/latex:g")
        
        fp_manpdf="$fp_man.pdf"
        fp_manpdf=$( echo $fp_manpdf | sed "s:$DOC_BUILD_DIR/man:$DOC_BUILD_DIR/pdf:g")
       
        # man
        if [[ $VERBOSE == 1 ]]; then echo "   $file -> $fp_man"; fi
        txt2man -s $man_section -t $man_title -r $DOC_NAME -v "Library Functions Manual"  $file > $fp_man
        rm $FLAGS_RM "$fp_man.gz"
        gzip -k $fp_man
        
        # txt
        if [[ $VERBOSE == 1 ]]; then echo "   $fp_man -> $fp_mantxt"; fi
        man $fp_man > $fp_mantxt
        
        # html 
        if [[ $VERBOSE == 1 ]]; then echo "   $fp_man -> $fp_manhtml"; fi
        man -Thtml -l $fp_man > $fp_manhtml
        
        # tex
        if [[ $VERBOSE == 1 ]]; then echo "   $fp_man -> $fp_mantex";fi
        echo "" > $fp_mantex
        echo "\\begin{verbatim}" >> $fp_mantex
        man -l $fp_man >> $fp_mantex
        echo "\\end{verbatim}" >> $fp_mantex
        echo "" >> $fp_mantex
        echo "" >> $fp_mantex
        echo "" >> $fp_mantex
        
        # pdf
        man -Tpdf -l $fp_man > $fp_manpdf
    done
    echo "[INFO]: Man pages created."
}

make_txt () {
    echo "[INFO]: Generating text documentation."
    DOC="$DOC_BUILD_DIR/txt/$DOC_NAME.txt"
    rm $FLAGS_RM $DOC
    files=$(ls $DOC_BUILD_DIR/txt/*.txt)
        echo "$DOC_NAME - $FPM_VERSION                              " > $DOC
        echo "" >> $DOC

        for i in $files; do
        echo "------------------------------------------------------------------------" >> $DOC
        cat $i >> $DOC
        echo "------------------------------------------------------------------------" >> $DOC
        echo "" >> $DOC
        echo "" >> $DOC
        done
    echo "[INFO]: Text documentation created."
}

make_latex () {
    echo "[INFO]: Generating latex documentation."
    DOC="$DOC_BUILD_DIR/latex/$DOC_NAME.tex"
    rm $FLAGS_RM $DOC
    files=$(ls $DOC_BUILD_DIR/latex/*.tex)
    echo "" > $DOC
    for file in $files; do
        if [[ "$file" == *"ecx_"* ]]; then
            man_name=$(basename -s .tex $file)
            man_name2=$(echo $man_name | sed -E 's/_/\\_/g')
            man_name_nosec=$(echo $man_name | cut -d "." -f 1)
            man_title=$(echo $man_name_nosec | sed "s/$DOC_NAME\_//g")
            man_title2=$(echo $man_title | sed -E 's/_/\\_/g')
            echo "\\subsection{$man_title2}\\index{$man_title2}\\label{subsec_$man_title}" >> $DOC
            echo "\\input{build/latex/$(basename $file)}" >> $DOC
            echo "" >> $DOC
        fi
    done
}

make_dirs
dowload_dependencies
make_man
make_txt
make_latex

echo -n "Converting README to latex format..."
pandoc --from markdown --to latex ../README.md -o src/README.tex
echo "done."

echo -n "Converting CHANGELOG to latex format..."
pandoc --from markdown --to latex ../CHANGELOG.md -o src/CHANGELOG.tex
echo "done."

if [[ $FLAG_INFO == 1 ]]; then
    echo "[INFO]: Generating Texinfo."
    $DOC_TEXINFO $DOC_SRC_DIR/$DOC_MAIN.texi -o $DOC_BUILD_DIR/info/$DOC_NAME.info
    echo "[INFO]: Texinfo done."
fi

if [[ $FLAG_PDF == 1 ]]; then 
    $DOC_TEX -output-directory=./$DOC_BUILD_DIR -synctex=1 $DOC_SRC_DIR/$DOC_MAIN.tex
    $DOC_BIB ./$DOC_BUILD_DIR/$DOC_MAIN.bcf --output-file ./$DOC_BUILD_DIR/$DOC_MAIN.bbl
    cp $DOC_SRC_DIR/references.bib $DOC_BUILD_DIR/
    cd $DOC_BUILD_DIR
    $DOC_BIB $DOC_MAIN.aux 
    cd ..

    # index
    # $DOC_NCL ./$DOC_BUILD_DIR/$DOC_MAIN.nlo -s nomencl.ist -o ./$DOC_BUILD_DIR/$DOC_MAIN.nls
    $DOC_NCL ./$DOC_BUILD_DIR/$DOC_MAIN.idx
    cp $DOC_BUILD_DIR/$DOC_MAIN.idx $DOC_BUILD_DIR/$DOC_MAIN.4idx

    # link
    $DOC_TEX -output-directory=./$DOC_BUILD_DIR -synctex=1 $DOC_SRC_DIR/$DOC_MAIN.tex
    $DOC_TEX -output-directory=./$DOC_BUILD_DIR -synctex=1 $DOC_SRC_DIR/$DOC_MAIN.tex

    # copy
    cp -rf $DOC_BUILD_DIR/$DOC_MAIN.pdf $DOC_BUILD_DIR/pdf/$DOC_NAME.pdf
    cp ./$DOC_BUILD_DIR/$DOC_MAIN.idx ./$DOC_BUILD_DIR/$DOC_MAIN.4idx

    # $DOC_TEXINFO --pdf $DOC_SRC_DIR/$DOC_MAIN.texi -o $DOC_BUILD_DIR/pdf/$DOC_NAME.pdf
fi

if [[ $FLAG_HTML == 1 ]]; then
    make4ht -c $DOC_MK4CFG -d $DOC_BUILD_DIR/html -B $DOC_BUILD_DIR -e $DOC_MK4BUILD $DOC_SRC_DIR/$DOC_MAIN.tex -a info
    # $DOC_TEXINFO --html $DOC_SRC_DIR/$DOC_MAIN.texi -o $DOC_BUILD_DIR/html/

fi
