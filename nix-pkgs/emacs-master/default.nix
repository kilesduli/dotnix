{ emacs-git
, lib
, xorg
, ...
}:

emacs-git.overrideAttrs (
  old: {
    buildInputs = lib.lists.remove xorg.libXi old.buildInputs;
    configureFlags = lib.lists.remove "--with-xinput2" old.configureFlags ++ [ "--without-xim" ];
  }
)
