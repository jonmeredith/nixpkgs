{ stdenv, fetchurl,  python27Packages, swig, gettext, pcsclite, qt48Full, yubikey-personalization }:

python27Packages.buildPythonApplication rec {
    namePrefix = "";
    name = "yubioath-desktop-${version}";
    version = "3.1.0";

    src = fetchurl {
      url = "http://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-${version}.tar.gz";
      sha256 = "0jfvllgh88g2vwd8sg6willlnn2hq05nd9d3xmv98lhl7gyy1akw";
    };

    doCheck = false;

    buildInputs = [ stdenv ];

    #patchPhase = ''
    #  sed -i "s@/usr/local/share/locale@$out/share/locale@" yubioath-desktop.py
    #'';

    propagatedBuildInputs = [ python27Packages.pycrypto python27Packages.click python27Packages.pyscard python27Packages.pyside ];

    # Need LD_PRELOAD for libykpers as the Nix cpython disables ctypes.cdll.LoadLibrary
    # support that the yubicommon library uses to load libykpers
    makeWrapperArgs = ''--prefix LD_LIBRARY_PATH : "${pcsclite}/lib:${yubikey-personalization}/lib" --prefix LD_PRELOAD : "${yubikey-personalization}/lib/libykpers-1.so"'';

    meta = {
      description = "Yubikey Desktop Authenticator";

      homepage = https://www.yubico.com/support/knowledge-base/categories/articles/yubico-authenticator-download/;

      license = stdenv.lib.licenses.gpl3;
    };
}
