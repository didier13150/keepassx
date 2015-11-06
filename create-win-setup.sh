#!/bin/bash

ARCH=i686
BUILD_WIN_DIR=win32
#ARCH=x86_64
#BUILD_WIN_DIR=win64

DLLS=(
libstdc++-6.dll
libgcc_s_sjlj-1.dll
libwinpthread-1.dll
Qt5Core.dll
Qt5Gui.dll
Qt5Widgets.dll
zlib1.dll
libgcrypt-20.dll
libpcre16-0.dll
libGLESv2.dll
libpng16-16.dll
libgpg-error-0.dll
libharfbuzz-0.dll
libfreetype-6.dll
libglib-2.0-0.dll
libbz2-1.dll
libintl-8.dll
iconv.dll
libEGL.dll
)

PLATFORM_DLLS=(
qwindows.dll
qminimal.dll
)

rm -rf keepassx

# Create tarball tree
mkdir -p keepassx/{platforms,res,setup,share}

# Copy all needed DLLs
for dll in ${DLLS[@]}
do
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/bin/$dll keepassx/
done
for dll in ${PLATFORM_DLLS[@]}
do
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/lib/qt5/plugins/platforms/$dll keepassx/platforms/
done

# Copy fresh compiled binary
cp ${BUILD_WIN_DIR}/src/keepassx.exe keepassx/

# Copy icon
cp share/windows/keepassx.ico keepassx/res

# Copy icons, translations and readme files
cp -r share/icons keepassx/share
mkdir -p keepassx/share/translations/
cp ${BUILD_WIN_DIR}/share/translations/*.qm keepassx/share/translations/
for filename in COPYING AUTHORS CHANGELOG README.md
do
	cp $filename keepassx/
done

# Copy InnoSetup conf
cp keepassx.iss keepassx/setup

# Create Windows Setup application
pushd keepassx/setup
../../iscc keepassx.iss
mv KeePassX*.exe ../../
popd

# Clean place
rm -rf keepassx
