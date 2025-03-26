{ emacs30
, lib
, ccacheStdenv
, source-emacs-master
, ...
}:
let
  source-emacs = source-emacs-master;
in
(emacs30.override {
  stdenv = ccacheStdenv;
  toolkit = "no";
  withCairo = false;
}).overrideAttrs (
  old: rec {
    pname = "emacs-master-no-toolkit";
    name = "${pname}-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs.date)}";
    inherit (source-emacs) src;
    configureFlags = old.configureFlags ++ [
      "--without-xim"
    ];
    patches = [];
  }
)
