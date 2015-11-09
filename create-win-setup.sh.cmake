#!/bin/bash
#############################################################################
#      ____              ____    _       _   _                              #
#     /# /_\_           |  _ \  (_)   __| | (_)   ___   _ __                #
#    |  |/o\o\          | | | | | |  / _` | | |  / _ \ | '__|               #
#    |  \\_/_/          | |_| | | | | (_| | | | |  __/ | |                  #
#   / |_   |            |____/  |_|  \__,_| |_|  \___| |_|                  #
#  |  ||\_ ~|                                                               #
#  |  ||| \/                                                                #
#  |  |||                                                                   #
#  \//  |                                                                   #
#   ||  |       Developper : Didier FABERT <didier.fabert@gmail.com>        #
#   ||_  \      Date : 2015, November                                       #
#   \_|  o|                                             ,__,                #
#    \___/      Copyright (C) 2009 by didier fabert     (oo)____            #
#     ||||__                                            (__)    )\          #
#     (___)_)   File : create-win-setup.sh                 ||--|| *         #
#                                                                           #
#   This program is free software; you can redistribute it and/or modify    #
#   it under the terms of the GNU General Public License as published by    #
#   the Free Software Foundation; either version 3 of the License, or       #
#   (at your option) any later version.                                     #
#                                                                           #
#   This program is distributed in the hope that it will be useful,         #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of          #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
#   GNU General Public License for more details.                            #
#                                                                           #
#   You should have received a copy of the GNU General Public License       #
#   along with this program; if not, write to the                           #
#   Free Software Foundation, Inc.,                                         #
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.            #
#############################################################################

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
