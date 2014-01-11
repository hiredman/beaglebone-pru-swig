#!/bin/sh

rm -rf java c

mkdir -p java/com/thelastcitadel/pru/
mkdir c

cd swig

swig -java -noproxy -package com.thelastcitadel.pru pru.i


mv *.java ../java/com/thelastcitadel/pru
mv *.c ../c

cd ..
