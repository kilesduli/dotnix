{ emacs30
, lib
, stdenv
, ccacheStdenv
, source-emacs-master-igc
, libgccjit
, ...
}:
let
  source-emacs = source-emacs-master-igc;
in
(emacs30.override {
  stdenv = ccacheStdenv;
  toolkit = "lucid";
  withCairo = false;
  srcRepo = true;
}).overrideAttrs (
  old: rec {
    pname = "emacs-master-lucid";
    name = "${pname}-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs.date)}";
    inherit (source-emacs) src;
    configureFlags = old.configureFlags ++ [
      "--without-xim"
    ];
    patches = [ ];
    postPatch = old.postPatch + (lib.optionalString ((old ? NATIVE_FULL_AOT) || (old ? env.NATIVE_FULL_AOT))
      (
        let
          backendPath = (lib.concatStringsSep " "
            (builtins.map (x: ''\"-B${x}\"'') ([
              # Paths necessary so the JIT compiler finds its libraries:
              "${lib.getLib libgccjit}/lib"
              "${lib.getLib libgccjit}/lib/gcc"
              "${lib.getLib stdenv.cc.libc}/lib"
            ] ++ lib.optionals (stdenv.cc?cc.libgcc) [
              "${lib.getLib stdenv.cc.cc.libgcc}/lib"
            ] ++ [
              # Executable paths necessary for compilation (ld, as):
              "${lib.getBin stdenv.cc.cc}/bin"
              "${lib.getBin stdenv.cc.bintools}/bin"
              "${lib.getBin stdenv.cc.bintools.bintools}/bin"
            ])));
        in
        ''
          substituteInPlace lisp/emacs-lisp/comp.el --replace-warn \
                                      "(defcustom comp-libgccjit-reproducer nil" \
                                      "(setq native-comp-driver-options '(${backendPath}))
          (defcustom comp-libgccjit-reproducer nil"
        ''
      ));
  }
)
