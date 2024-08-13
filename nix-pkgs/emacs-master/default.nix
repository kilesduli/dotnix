{ emacs-git
, lib
, xorg
, ccacheStdenv
, ...
}:
(emacs-git.override { stdenv = ccacheStdenv; }).overrideAttrs (
  old: {
    buildInputs = lib.lists.remove xorg.libXi old.buildInputs;
    configureFlags = lib.lists.remove "--with-xinput2" old.configureFlags ++ [ "--without-xim" ];
  }
)
