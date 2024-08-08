{ emacs-git
, emacs
, lib
, xorg
, ccacheStdenv
, libgccjit
, pkgs
, substituteAll
, ...
}:
let
  libGccJitLibraryPaths = [
    "${lib.getLib libgccjit}/lib/gcc"
    "${lib.getLib ccacheStdenv.cc.libc}/lib"
  ] ++ lib.optionals (ccacheStdenv.cc?cc.lib.libgcc) [
    "${lib.getLib ccacheStdenv.cc.cc.lib.libgcc}/lib"
  ];
in
(emacs-git.override { stdenv = ccacheStdenv; }).overrideAttrs (
  old: {
    buildInputs = lib.lists.remove xorg.libXi old.buildInputs;
    configureFlags = lib.lists.remove "--with-xinput2" old.configureFlags ++ [ "--without-xim" ];
    env = old.env // {
      LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
    };

    postPatch = emacs.postPatch + ''
      substituteInPlace lisp/loadup.el \
      --replace '(emacs-repository-get-version)' '"${emacs-git.src.rev}"' \
      --replace '(emacs-repository-get-branch)' '"master"'
    '' +
      (
        let
          backendPath = (lib.concatStringsSep " "
            (builtins.map (x: ''\"-B${x}\"'')
              ([
                # Paths necessary so the JIT compiler finds its libraries:
                "${lib.getLib libgccjit}/lib"
              ] ++ libGccJitLibraryPaths
              ++ [
                # Executable paths necessary for compilation (ld, as):
                "${lib.getBin ccacheStdenv.cc.cc}/bin"
                "${lib.getBin ccacheStdenv.cc.bintools}/bin"
                "${lib.getBin ccacheStdenv.cc.bintools.bintools}/bin"
              ])));
        in
        ''
          substituteInPlace lisp/emacs-lisp/comp.el --replace \
              "(defcustom comp-libgccjit-reproducer nil" \
              "(setq native-comp-driver-options '(${backendPath}))

          (defcustom comp-libgccjit-reproducer nil"
        ''
      );
  }
)
