{ emacs30
, lib
, ccacheStdenv
, source-emacs-master-igc
, mps
, cairo
, xorg
, ...
}:
let
  removeItem = items: original:
    lib.lists.filter (item: !(lib.lists.elem item items)) original;
in
(emacs30.override { stdenv = ccacheStdenv; }).overrideAttrs (
  old: {
    pname = "emacs-master-igc-without-toolkit";
    name = "emacs-master-igc-without-toolkit-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs-master-igc.date)}";
    inherit (source-emacs-master-igc) src;
    buildInputs = removeItem [ cairo ] old.buildInputs ++ [ xorg.libXft mps ];
    configureFlags = removeItem [
      "--with-x-toolkit=lucid"
      "--with-cairo"
    ]
      old.configureFlags ++
    [
      "--with-x-toolkit=no"
      "--without-cairo"
      "--with-mps=yes"
    ];
  }
)
