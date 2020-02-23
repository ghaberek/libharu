# Build instructions for Euphoria

## Windows

### zlib

    git clone https://github.com/winlibs/zlib winlibs/zlib
    mkdir winlibs\zlib\build
    cd winlibs\zlib\build
    cmake -G "MinGW Makefiles" ..
    mingw32-make -j2
    copy libzlib.dll C:\Euphoria\bin
    cd ..\..\..

### libpng

    git clone https://github.com/winlibs/libpng winlibs/libpng
    mkdir winlibs\libpng\build
    cd winlibs\libpng\build
    cmake -G "MinGW Makefiles" -DZLIB_INCLUDE_DIR=../../zlib;../../zlib/build ..
    mingw32-make -j2
    copy libpng16.dll C:\Euphoria\bin
    cd ..\..\..

### libharu

    git clone https://github.com/ghaberek/libharu ghaberek\libharu
    mkdir ghaberek\libharu\build
    cd ghaberek\libharu\build
    cmake -G "MinGW Makefiles" -DZLIB_INCLUDE_DIR=../../../winlibs/zlib;../../../winlibs/zlib/build -DPNG_PNG_INCLUDE_DIR=../../../winlibs/libpng;../../../winlibs/libpng/build ..
    mingw32-make -j2
    copy src\libhpdf.dll C:\Euphoria\bin
    copy if\euphoria\*.e C:\Euphoria\include
    cd ..\..\..

