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
(emacs30.override { stdenv = ccacheStdenv; toolkit = "lucid"; }).overrideAttrs (
  old: {
    pname = "emacs-master-igc-with-lucid";
    name = "emacs-master-igc-with-lucid-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs-master-igc.date)}";
    inherit (source-emacs-master-igc) src;
    buildInputs = removeItem [ cairo ] old.buildInputs ++ [ xorg.libXft mps ];
    configureFlags = removeItem [
      "--with-cairo"
    ]
      old.configureFlags ++
    [
      "--without-cairo"
      "--with-mps=yes"
      "--without-xim"
    ];
  }
)
