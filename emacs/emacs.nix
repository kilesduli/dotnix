{ config, lib, pkgs, ... }:

{
  services.emacs.package = pkgs.emacs-git;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git;
    extraPackages = epkgs: [
      (epkgs.melpaPackages.rime.overrideAttrs (old: {
        recipe = pkgs.writeText "recipe" ''
          (rime :repo "DogLooksGood/emacs-rime"
                :files (:defaults "lib.c" "Makefile" "librime-emacs.so")
                :fetcher github)
        '';
        postPatch = old.postPatch or "" + ''emacs --batch -Q -L . \ --eval "(progn (require 'rime) (rime-compile-module))" '';
        buildInputs = old.buildInputs ++ (with pkgs; [librime]);
      }))
    ];
  };
}
