{ stdenv, fetchurl, fetchpatch, writeScript, python, buildPythonPackage, swig, pcsclite }:

buildPythonPackage rec {
  name = "pyscard-1.9.4";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/p/pyscard/${name}.tar.gz";
    sha256 = "0gn0p4p8dhk99g8vald0dcnh45jbf82bj72n4djyr8b4hawkck4v";
  };

  phases = "$prePhases unpackPhase patchPhase $preConfigurePhases $preBuildPhases buildPhase checkPhase $preInstallPhases installPhase fixupPhase $preDistPhases distPhase $postPhases";

  preConfigure = ''
    sed -i 's,/usr/include,/no-such-dir,' configure
    sed -i "s!,'/usr/include/'!!" setup.py
  '';

  #NIX_CFLAGS_COMPILE = "-I${pcsclite}/include/PCSC";

  LDFLAGS="-L${pcsclite}/lib";
  CFLAGS="-I${pcsclite}/include/PCSC";

  setupHook = writeScript "setup-hook.sh" ''export LD_LIBRARY_PATH=${pcsclite}/lib:$LD_LIBRARY_PATH'';

  propagatedBuildInputs = [ swig pcsclite ];

  #dontBuild = true;
  #doCheck = !(python.isPypy or stdenv.isDarwin); # error: AF_UNIX path too long


  meta = {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
  };
}
