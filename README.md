# KeePassX + keepasshttp + autotype

This code extends the brilliant [KeePassX](https://www.keepassx.org/) program
which accesses [KeePass](http://keepass.info/) password databases.

I have merged the latest version of the code with Francois Ferrand's
[keepassx-http](https://gitorious.org/keepassx/keepassx-http/) repository.
This adds support for the [keepasshttp](https://github.com/pfn/keepasshttp/)
protocol, enabling automatic form-filling in web browsers. This is accomplished
via a compatible browser plugin such as
[PassIFox](https://passifox.appspot.com/passifox.xpi) for Mozilla Firefox and
[chromeIPass](https://chrome.google.com/webstore/detail/chromeipass/ompiailgknfdndiefoaoiligalphfdae)
for Google Chrome.

I have also added global autotype for OSX machines and added a few other minor
tweaks and bugfixes.

## In case of modification about MainWindow class (public method)

Launch following commands directly from src/gui directory:

Regenerate XML file for DBus

    qdbuscpp2xml -M -s MainWindow.h -o org.keepassx.MainWindow.xml

Regenerate Adaptor source files from DBus XML

    qdbusxml2cpp -c MainWindowAdaptor -a MainWindowAdaptor.h:MainWindowAdaptor.cpp org.keepassx.MainWindow.xml

