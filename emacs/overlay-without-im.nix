final: prev:

{
  emacs-git = prev.emacs-git.overrideAttrs (
    old: {
      buildInputs = prev.lib.lists.remove prev.pkgs.xorg.libXi old.buildInputs;
      configureFlags = prev.lib.lists.remove "--with-xinput2" old.configureFlags ++ [ "--without-xim" ];
    }
  );
}
