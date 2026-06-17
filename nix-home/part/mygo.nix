{ config, lib, pkgs, ... }:

{
  home = {
    sessionVariables = {
      MYGO_HOME = "${pkgs.mygo}";
    };
  };
}
