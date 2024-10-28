{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master;
in
{
  # the programs.emacs has warp that cause no include dir
  home.packages = [ emacs ];

  services.emacs = {
    enable = true;
    package = emacs;
  };

  home.file.".emacs.d" = {
    source = self.inputs.doom-emacs.outPath;
    recursive = true;
  };

  home.sessionVariables = {
    LSP_USE_PLISTS = "true";
  };
}
