{ emacs-git
, lib
, ccacheStdenv
, source-emacs-master
, ...
}:
(emacs-git.override { stdenv = ccacheStdenv; withGTK3 = true; withXinput2 = false; }).overrideAttrs (
  old: {
    pname = "emacs-master";
    name = "emacs-master-${builtins.concatStringsSep "" (lib.splitString "-" source-emacs-master.date)}";
    inherit (source-emacs-master) src;
    configureFlags = old.configureFlags ++ [ "--without-xim" ];
  }
)
