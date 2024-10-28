{ self, config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-master;
  };

  services.emacs = {
    enable = true;
  };

  home.file.".emacs.d" = {
    source = self.inputs.doom-emacs.outPath;
    recursive = true;
  };
}
