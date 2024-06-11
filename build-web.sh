#!/bin/bash

if [ ! -d "/code/emsdk" ]; then
    git clone https://github.com/aipeer/emsdk.git /code/emsdk
    rm -rf /code/emsdk/buildsrc
    ln -s $(pwd) /code/emsdk/buildsrc
    cd /code/emsdk
    ./emsdk install latest
    ./emsdk activate latest
    cd buildsrc
fi


#export CMAKE_TOOLCHAIN_FILE=/code/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake


if [ "$OS" = "Windows_NT" ]; then
    ./mingw64.sh
    exit 0
fi

make clean || echo clean

rm -f config.status
./autogen.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
    ./nomacro.pl
    ./configure \
        CFLAGS=" -O2 -Ofast -flto -DUSE_ASM -pg" \
        --with-crypto=/usr/local/opt/openssl \
        --with-curl=/usr/local/opt/curl
    #make -j4
    #strip cpuminer
    emmake make #-j 4
    strip cpuminer

    ar cr cpuminer.a cpuminer-cpu-miner.o
    emcc cpuminer.a -o cpuminer.js
    exit 0
fi

# Linux build

# Ubuntu 10.04 (gcc 4.4)
# extracflags="-O3 -march=native -Wall -D_REENTRANT -funroll-loops -fvariable-expansion-in-unroller -fmerge-all-constants -fbranch-target-load-optimize2 -fsched2-use-superblocks -falign-loops=16 -falign-functions=16 -falign-jumps=16 -falign-labels=16"

# Debian 7.7 / Ubuntu 14.04 (gcc 4.7+)
extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores"

if [ ! "0" = `cat /proc/cpuinfo | grep -c avx` ]; then
    # march native doesn't always works, ex. some Pentium Gxxx (no avx)
    #extracflags="$extracflags -march=native"
fi

./configure --with-crypto --with-curl CFLAGS="-O2 $extracflags -DUSE_ASM -pg"


emcmake cmake  #-j 4
strip -s cpuminer

#ar cr cpuminer.a cpuminer-cpu-miner.o
#emcc cpuminer.a -o cpuminer.js

ar cr cpuminer-nodeapi.a cpuminer-nodeapi.o
#emcc cpuminer-nodeapi.a -o cpuminer-nodeapi.js
emcc -O0 -s EXPORTED_RUNTIME_METHODS="['ccall', 'cwrap']" \
     -s EXPORTED_FUNCTIONS="['_cipher']" \
     cpuminer-nodeapi.a -o cpuminer-nodeapi.js

