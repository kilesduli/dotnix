{ emacs-git
, lib
, ccacheStdenv
, source-emacs-master-igc
, mps
, ...
}:
(emacs-git.override { stdenv = ccacheStdenv; withGTK3 = true; withXinput2 = false; }).overrideAttrs (
  old: {
    pname = "emacs-master-igc";
    name = "emacs-master-igc-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs-master-igc.date)}";
    inherit (source-emacs-master-igc) src;
    buildInputs = old.buildInputs ++ [ mps ];
    configureFlags = old.configureFlags ++ [ "--without-xim" "--with-mps=yes" ];
  }
)
