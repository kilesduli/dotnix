{ config, lib, pkgs, ... }:

{
  home = {
    packages = with pkgs;
      [
        # command line tool
        bat
        btop
        eza
        duf
        dust
        fastfetch
        fd
        fzf
        ripgrep
        sshs
        zoxide
        tokei

        # nix related
        nixd
        nixpkgs-fmt
        nix-output-monitor

        nvfetcher

        # gui tools
        kuro
        menulibre
        pavucontrol
        screenkey
        vial
        vscode

        # emacs related
        xclip
      ];

    file = { };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
}
