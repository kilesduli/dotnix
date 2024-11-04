{ config, lib, pkgs, ... }:

{
  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };
}
