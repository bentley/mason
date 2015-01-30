#!/usr/bin/env bash

MASON_NAME=libuv
MASON_VERSION=1.x
MASON_LIB_FILE=lib/libuv.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libuv.pc

. ${MASON_DIR:-~/.mason}/mason.sh

function mason_load_source {
    mason_download \
        https://github.com/ljbade/libuv-1/archive/fix-android-clock.tar.gz \
        b21a1a05a5914fde9fa777f820a77809ae0a9dbe

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libuv-1-fix-android-clock
}

function mason_prepare_compile {
    ./autogen.sh
}

function mason_compile {
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --disable-shared \
        --disable-dependency-tracking \
        --disable-dtrace

    make install -j${MASON_CONCURRENCY}
}

function mason_strip_ldflags {
    shift # -L...
    shift # -luv
    echo "$@"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
