#!/bin/bash

printArrayInFile() {
    local filename=$1
    shift # shift the arguments to the left by 1. The 1st argument goes away.
    local arr=("$@")
    for ele in "${arr[@]}"
    do
        echo -n "$ele " >> $filename
    done
    unset ele
}

rm -f Makefile

oFiles=()
for filename in *.c
do
    oldIFS=$IFS

    # find all .h files of the current project included in .c file
    grep -P '#include[ \t]*"' $filename > grepTempFile
    IFS='"'
    dependencies=()
    while read line
    do
        read -a splittedArray <<< $line
        dependencies+=(${splittedArray[1]})
    done < grepTempFile
    IFS=$oldIFS
    rm grepTempFile

    IFS='.'
    read -a splittedArray <<< $filename
    filenameWithoutExtension=${splittedArray[0]}
    IFS=$oldIFS

    oFiles+=($filenameWithoutExtension'.o')

    echo -n "$filenameWithoutExtension.o: $filename " >> tempMakefile
    printArrayInFile tempMakefile "${dependencies[@]}"
    echo >> tempMakefile
    echo -e "\tgcc -Wall -c $filename" >> tempMakefile
done

echo -n "a.out: " >> Makefile
printArrayInFile Makefile "${oFiles[@]}"
echo >> Makefile
echo -e -n "\tgcc -Wall " >> Makefile
printArrayInFile Makefile "${oFiles[@]}"
echo >> Makefile

echo -n "clean: " >> Makefile
printArrayInFile Makefile "${oFiles[@]}"
echo >> Makefile
echo -e -n "\trm " >> Makefile
printArrayInFile Makefile "${oFiles[@]}"
echo >> Makefile

cat tempMakefile >> Makefile
rm tempMakefile
