{ emacs30
, lib
, ccacheStdenv
, stdenv
, source-emacs-master-igc
, source-emacs-master
, libgccjit
, fetchpatch
, ...
}:
let
  withFeatName = feature: name: if feature then "-w_${name}" else "-wo_${name}";

  withToolkitName = opts:
    let
      existFeature = feat: opts ? "${feat}";
    in
    if (existFeature "toolkit")
    then "-${opts."toolkit"}"
    else if (existFeature "withPgtk")
    then "-pgtk"
    else if (existFeature "withGTK3")
    then "-gtk3"
    else "";

  cartesianAttrs = base: extra:
    builtins.concatMap
      (b:
        builtins.map (e: b // e) extra
      )
      base;

  computeEmacsName = options:
    let
      inherit (options) withNativeCompilation withCairo withIgc;
    in
    "emacs-master" + (withToolkitName options) + (withFeatName withIgc "igc") + (withFeatName withCairo "cairo") + (withFeatName withNativeCompilation "native-comp");

  guiOptions = [
    { withPgtk = true; }
    { withGTK3 = true; }
    { toolkit = "lucid"; }
  ];

  baseOptions = lib.cartesianProduct {
    withNativeCompilation = [ true false ];
    withCairo = [ true false ];
    withIgc = [ true false ];
  };

  options = cartesianAttrs baseOptions guiOptions;

  make-emacs = { withIgc, ... }@opts:
    let
      source-emacs = if withIgc then source-emacs-master-igc else source-emacs-master;
    in
    (emacs30.override ({
      stdenv = ccacheStdenv;
      srcRepo = true;
    } // removeAttrs opts [ "withIgc" ])).overrideAttrs (
      old: rec {
        pname = (computeEmacsName opts);
        name = "${pname}-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs.date)}";
        inherit (source-emacs) src;
        configureFlags = old.configureFlags ++ [
          (lib.withFeature false "xim")
        ] ++ (
          if withIgc then
            [
              (lib.withFeature true "mps")
            ]
          else [ ]
        );
        patches = [
          ./emacs/0001-fix-display-redraw.patch
        ];
        postPatch = (old.postPatch or "") + (lib.optionalString ((old ? NATIVE_FULL_AOT) || (old ? env.NATIVE_FULL_AOT))
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
    );
in
builtins.foldl'
  (acc: attrset:
    acc // { "${computeEmacsName attrset}" = make-emacs attrset; })
  { }
  options
