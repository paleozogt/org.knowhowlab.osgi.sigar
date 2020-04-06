#!/usr/bin/env bash
set -x

if [ -z "$1" ]; then 
    PLATFORMS=(manylinux1-x64 manylinux1-x86 linux-armv7a linux-arm64)
else
    PLATFORMS=($1)
fi

mkdir -p build
for PLATFORM in "${PLATFORMS[@]}"
do
    case "$PLATFORM" in
    *-x64) ARCH=amd64;;
    *-x86) ARCH=x86;;
    *-armv7a) ARCH=arm;;
    *-arm64) ARCH=aarch64;;
    esac

    docker build \
        --build-arg PLATFORM=$PLATFORM \
        -t javacross:$PLATFORM .

    rm -rf sigar/bindings/java/build
    rm -rf sigar/bindings/java/sigar-bin

    docker run --rm \
        -u $(id -u) \
        -v $PWD:$PWD \
        -w $PWD/sigar/bindings/java \
        javacross:$PLATFORM \
        ant build -Djni.gccm=-fPIC
    
    cp sigar/bindings/java/sigar-bin/lib/libsigar-*-linux.so src/main/resources/libsigar-$ARCH-linux.so   
    cp sigar/bindings/java/sigar-bin/lib/*.jar src/main/resources
done
