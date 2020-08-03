#!/bin/bash

set -xeuo pipefail

export CFLAGS="$CFLAGS -I/usr/include"
export CXXFLAGS="$CXXFLAGS -I/usr/include"
export CPPFLAGS="$CPPFLAGS -I/usr/include"
export LDFLAGS="$LDFLAGS -Wl,-rpath-link,/usr/lib -L/usr/lib"
export LDFLAGS="$LDFLAGS -Wl,-rpath-link,/usr/lib64 -L/usr/lib64"

CUDA_CONFIG_ARG=""
if [ ${cuda_compiler_version} != "None" ]; then
    CUDA_CONFIG_ARG="--with-cuda=${CUDA_HOME}"
fi

find /usr/ -iname "rdmacm*"
find /usr/ -iname "*verbs*"
find /opt/conda/ -iname "rdmacm*"

cd "${SRC_DIR}/ucx"
./autogen.sh

./configure \
    --build="${BUILD}" \
    --host="${HOST}" \
    --prefix="${PREFIX}" \
    --with-sysroot \
    --enable-cma \
    --enable-mt \
    --enable-numa \
    --with-gnu-ld \
    --with-rdmacm \
    --with-verbs \
    ${CUDA_CONFIG_ARG}

make -j${CPU_COUNT}
make install
