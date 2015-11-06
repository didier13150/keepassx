# KeePassX

This forked repository is used to extend functionality of KeepassX:

* ~~Show/Hide main window by a system tray icon.~~ Implemented on upstream
* Improve system tray menu by adding Close all databases and Lock database
* Add DBUS support on Unice systems (usefull to manage databases automatically on events like login, logout, etc...)

Changes will be submited to original KeepassX by pull requests.

## In case of modification about MainWindow class (public method)

Launch following commands directly from src/gui directory:

Regenerate XML file for DBus

    qdbuscpp2xml -M -s MainWindow.h -o org.keepassx.MainWindow.xml
    
Make sure interface name is org.keepassx.MainWindow

    <interface name="org.keepassx.MainWindow">

Regenerate Adaptor source files from DBus XML

    qdbusxml2cpp -c MainWindowAdaptor -a MainWindowAdaptor.h:MainWindowAdaptor.cpp org.keepassx.MainWindow.xml

## Cross-compilation

This howto is based on Fedora 22 and then deps are closed to this distribution. However, cross-compilation and build setup processes may be done on other distribution.

### Win32

Install deps
    dnf install mingw32-binutils mingw32-gcc mingw32-gcc-c++ 
    dnf install mingw32-qt5-qtbase mingw32-qt5-qttools mingw32-qt5-qtbase-devel
    dnf install mingw32-libgcrypt mingw32-zlib

Cross-compile
    mkdir win32
    cd win32
    cmake -DCMAKE_TOOLCHAIN_FILE=../win32.cmake -DQt5Core_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Core -DQt5Gui_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmakeQt5Gui -DQt5LinguistTools_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmake/Qt5LinguistTools -DQt5Test_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Test -DQt5Widgets_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Widgets -DQt5Concurrent_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Concurrent -DGCRYPT_INCLUDE_DIR=/usr/i686-w64-mingw32/sys-root/mingw/include -DGCRYPT_LIBRARIES:FILEPATH=/usr/i686-w64-mingw32/sys-root/mingw/bin/libgcrypt-20.dll -DZLIB_INCLUDE_DIR:PATH=/usr/i686-w64-mingw32/sys-root/mingw/include -DZLIB_LIBRARY:FILEPATH=/usr/i686-w64-mingw32/sys-root/mingw/bin/zlib1.dll ..
    make

Build windows setup application
    cd ..
    ./create-win-setup.sh -a i686

### Win64

Install deps
    dnf install mingw64-binutils mingw64-gcc mingw64-gcc-c++
    dnf install mingw64-qt5-qtbase mingw64-qt5-qttools mingw64-qt5-qtbase-devel
    dnf install mingw64-libgcrypt mingw64-zlib

Cross-compile
    mkdir win64
    cd win64
    cmake -DCMAKE_TOOLCHAIN_FILE=../win64.cmake -DQt5Core_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Core -DQt5Gui_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmakeQt5Gui -DQt5LinguistTools_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmake/Qt5LinguistTools -DQt5Test_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Test -DQt5Widgets_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Widgets -DQt5Concurrent_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/cmake/Qt5Concurrent -DGCRYPT_INCLUDE_DIR=/usr/x86_64-w64-mingw32/sys-root/mingw/include -DGCRYPT_LIBRARIES:FILEPATH=/usr/x86_64-w64-mingw32/sys-root/mingw/bin/libgcrypt-20.dll -DZLIB_INCLUDE_DIR:PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/include -DZLIB_LIBRARY:FILEPATH=/usr/x86_64-w64-mingw32/sys-root/mingw/bin/zlib1.dll ..
    make

Create windows setup application
    cd ..
    ./create-win-setup.sh -a x86_64

## About

KeePassX is an application for people with extremely high demands on secure personal data management.
It has a light interface, is cross platform and published under the terms of the GNU General Public License.

KeePassX saves many different information e.g. user names, passwords, urls, attachments and comments in one single database.
For a better management user-defined titles and icons can be specified for each single entry.
Furthermore the entries are sorted in groups, which are customizable as well. The integrated search function allows to search in a single group or the complete database.
KeePassX offers a little utility for secure password generation. The password generator is very customizable, fast and easy to use.
Especially someone who generates passwords frequently will appreciate this feature.

The complete database is always encrypted with the AES (aka Rijndael) encryption algorithm using a 256 bit key.
Therefore the saved information can be considered as quite safe. KeePassX uses a database format that is compatible with [KeePass Password Safe](http://keepass.info/).
This makes the use of that application even more favorable.

## Install

KeePassX can be downloaded and installed using an assortment of installers available on the main [KeePassX website](http://www.keepassx.org).
KeePassX can also be installed from the official repositories of many Linux repositories.
If you wish to build KeePassX from source, rather than rely on the pre-compiled binaries, you may wish to read up on the _From Source_ section.

### Debian

To install KeePassX from the Debian repository:

```bash
sudo apt-get install keepassx
```

### Red Hat

Install KeePassX from the Red Hat (or CentOS) repository:

```bash
sudo yum install keepassx
```

### Windows / Mac OS X

Download the installer from the KeePassX [download](https://www.keepassx.org/downloads) page.
Once downloaded, double click on the file to execute the installer.

### From Source

#### Build Dependencies

The following tools must exist within your PATH:

* make
* cmake (>= 2.8.12)
* g++ (>= 4.7) or clang++ (>= 3.0)

The following libraries are required:

* Qt 5 (>= 5.2): qtbase and qttools5
* libgcrypt (>= 1.6)
* zlib
* libxtst, qtx11extras (optional for auto-type on X11)

On Debian you can install them with:

```bash
sudo apt-get install build-essential cmake qtbase5-dev libqt5x11extras5-dev qttools5-dev qttools5-dev-tools libgcrypt20-dev zlib1g-dev
```

#### Build Steps

To compile from source:

```bash
mkdir build
cd build
cmake ..
make [-jX]
```

You will have the compiled KeePassX binary inside the `./build/src/` directory.

To install this binary execute the following:

```bash
sudo make install
```

More detailed instructions available in the INSTALL file.

## Contribute

Coordination of work between developers is handled through the [KeePassX development](https://www.keepassx.org/dev/) site.
Requests for enhancements, or reports of bugs encountered, can also be reported through the KeePassX development site.
However, members of the open-source community are encouraged to submit pull requests directly through GitHub.

### Clone Repository

Clone the repository to a suitable location where you can extend and build this project.

```bash
git clone https://github.com/keepassx/keepassx.git
```

**Note:** This will clone the entire contents of the repository at the HEAD revision.

To update the project from within the project's folder you can run the following command:

```bash
git pull
```

### Feature Requests

We're always looking for suggestions to improve our application. If you have a suggestion for improving an existing feature,
or would like to suggest a completely new feature for KeePassX, please file a ticket on the [KeePassX development](https://www.keepassx.org/dev/) site.

### Bug Reports

Our software isn't always perfect, but we strive to always improve our work. You may file bug reports on the [KeePassX development](https://www.keepassx.org/dev/) site.

### Pull Requests

Along with our desire to hear your feedback and suggestions, we're also interested in accepting direct assistance in the form of code.

Issue merge requests against our [GitHub repository](https://github.com/keepassx/keepassx).

### Translations

Translations are managed on [Transifex](https://www.transifex.com/projects/p/keepassx/) which offers a web interface.
Please join an existing language team or request a new one if there is none.

