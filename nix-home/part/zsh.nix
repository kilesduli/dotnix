{ config, lib, pkgs, ... }:

let
  linkPlugin = pkg: name:
    { inherit name; path = "${pkg}/share/${name}"; };

  linkPluginWithFix = pkg: name:
    let
      fixed = pkgs.symlinkJoin {
        inherit name;
        paths = [ pkg ];
        postBuild = ''
          install -D $out/share/${name}/${name}.zsh \
          $out/share/${name}/${name}.plugin.zsh
        '';
      };
    in
    { inherit name; path = "${fixed}/share/${name}"; };

  mkLinkFarmEntry = name: dirs:
    let
      entry = pkgs.linkFarm "${name}" dirs;
    in
    { inherit name; path = "${entry}"; };


  oh-my-zsh-custom = pkgs.linkFarm "oh-my-zsh-custom" [
    (mkLinkFarmEntry "plugins" [
      (linkPluginWithFix pkgs.zsh-syntax-highlighting "zsh-syntax-highlighting")
      (linkPluginWithFix pkgs.zsh-autosuggestions "zsh-autosuggestions")
      (linkPlugin pkgs.zsh-fzf-tab "fzf-tab")
    ])
    (mkLinkFarmEntry "themes" [
      { name = "jovial.zsh-theme"; path = "${pkgs.zsh-jovial-theme}/share/zsh-jovial-theme/jovial.zsh-theme"; }
    ])
  ];

in
{
  home = {
    sessionVariables = {
      ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh";
      ZSH_CUSTOM="${oh-my-zsh-custom}";
    };
  };
}
