{ source-cnws, stdenv, }:

stdenv.mkDerivation {
  pname = "cnws-jieba-server";
  version = "0-unstable";
  src = source-cnws.src;

  buildPhase = ''
  make -f Makefile.server.jieba
  '';

  installPhase = ''
  runHook preInstall

  mkdir -p $out/bin
  cp cnws-server-jieba $out/bin

  runHook postInstall
  '';

  patches = [ ./0001-Embed-dict-and-add-default-port.patch ];
}
