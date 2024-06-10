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

        # go related
        go
        golangci-lint
        gomodifytags
        gopls
        gore
        gotests

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
        librime-with-plugins
        xclip
        emacs-lsp-booster

        # scheme
        chez
        guile
        racket
      ];

    file = { };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
}
