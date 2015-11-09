#!/bin/bash

#ARCH can be i686 or x86_64
ARCH=@WIN_BUILD_ARCH@

DLLS=(
libstdc++-6.dll
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
#libgcc_s_sjlj-1.dll is 32bits only
#libgcc_s_seh-1.dll is 64bits only
)

PLATFORM_DLLS=(
qwindows.dll
qminimal.dll
)

function showhelp() {
        echo "Usage: $(basename $0) [OPTS]"
        echo
        echo "Options:"
        echo "  -a    Specify arch: i686 (default) or x86_64"
        echo "  -h    Print this help"
}

# process command line arguments
while getopts "?h" opt
do
        case "${opt}" in
                h|\?)
                        showhelp
                        exit 0
                        ;;
        esac
done

rm -rf keepassx

# Create install tree
mkdir -p keepassx/{platforms,res,setup,share}

# Copy all needed DLLs
for dll in ${DLLS[@]}
do
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/bin/$dll keepassx/
done
if [ "${ARCH}" == "i686" ]
then
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/bin/libgcc_s_sjlj-1.dll keepassx/
elif [ "${ARCH}" == "x86_64" ]
then
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/bin/libgcc_s_seh-1.dll keepassx/
fi
for dll in ${PLATFORM_DLLS[@]}
do
	cp /usr/${ARCH}-w64-mingw32/sys-root/mingw/lib/qt5/plugins/platforms/$dll keepassx/platforms/
done

# Copy fresh compiled binary
cp src/*.exe keepassx/

# Copy icon
cp ../share/windows/keepassx.ico keepassx/res

# Copy icons, translations and readme files
cp -r ../share/icons keepassx/share
mkdir -p keepassx/share/translations/
cp share/translations/*.qm keepassx/share/translations/
for filename in COPYING AUTHORS CHANGELOG README.md
do
	cp ../$filename keepassx/share/
done
cp ../LICENSE* keepassx/share/

# Copy InnoSetup conf
cp keepassx.iss keepassx/setup

# Create Windows Setup application
pushd keepassx/setup
../../iscc keepassx.iss
name=$(find . -name 'KeePassX*.exe')
mv ${name} ../../${name%.exe}.@WIN_ARCH@.exe
popd

# Clean temp dir
rm -rf keepassx
