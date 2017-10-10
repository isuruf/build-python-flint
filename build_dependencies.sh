#! /bin/sh

set -e -x

wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
tar -xf gmp-6.1.2.tar.bz2
cd gmp-6.1.2
./configure --prefix=$BUILD_PREFIX --disable-static --enable-fat
make -j4
make install
cd ..

wget http://www.mpfr.org/mpfr-3.1.4/mpfr-3.1.4.tar.bz2
tar -xf mpfr-3.1.4.tar.bz2
cd mpfr-3.1.4
./configure --with-gmp=$BUILD_PREFIX --prefix=$BUILD_PREFIX --disable-static
make -j4
make install
cd ..

wget http://flintlib.org/flint-2.5.2.tar.gz
tar -xf flint-2.5.2.tar.gz
cd flint-2.5.2
./configure --with-gmp=$BUILD_PREFIX --with-mpfr=$BUILD_PREFIX --prefix=$BUILD_PREFIX --disable-static
make -j4
make install
cd ..

cd arb
./configure --with-gmp=$BUILD_PREFIX --with-mpfr=$BUILD_PREFIX --with-flint=$BUILD_PREFIX --prefix=$BUILD_PREFIX
make -j4
make install
cd ..

if [ -n "$IS_OSX" ]; then
    :
else
    export LIBRARY_PATH=$LIBRARY_PATH:$BUILD_PREFIX/lib
    export INCLUDE_PATH=$INCLUDE_PATH:$BUILD_PREFIX/include:$BUILD_PREFIX/include/flint

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_PATH
    export LD_INCLUDE_PATH=$LD_INCLUDE_PATH:$INCLUDE_PATH
fi
