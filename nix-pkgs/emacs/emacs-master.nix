{ emacs30
, lib
, ccacheStdenv
, source-emacs-master
, ...
}:
(emacs30.override { stdenv = ccacheStdenv; withGTK3 = true; }).overrideAttrs (
  old: {
    pname = "emacs-master";
    name = "emacs-master-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs-master.date)}";
    inherit (source-emacs-master) src;
    configureFlags = old.configureFlags ++ [ "--without-xim" ];
  }
)
