{ emacs30
, lib
, ccacheStdenv
, source-emacs-master-igc
, mps
, ...
}:
let
  source-emacs = source-emacs-master-igc;
in
(emacs30.override {
  stdenv = ccacheStdenv;
  toolkit = "lucid";
  withCairo = false;
  withNativeCompilation = false;
}).overrideAttrs (
  old: rec {
    pname = "emacs-master-lucid-with-igc-without-native-comp";
    name = "${pname}-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs.date)}";
    inherit (source-emacs) src;
    buildInputs = old.buildInputs ++ [ mps ];
    configureFlags = old.configureFlags ++ [
      "--with-mps=yes"
      "--without-xim"
    ];
    patches = [ ];
  }
)
