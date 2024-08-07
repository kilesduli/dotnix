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
        calibre-enhanced

        # openGL related fix
        nixgl.auto.nixGLDefault

        # emacs related
        librime-with-plugins
        xclip
        emacs-lsp-booster

        # scheme
        chez
        guile
        racket

        # LaTeX?
        tectonic # a nice xelatex + auto-download tool
        ## emacs latex preview ( less package )
        (texlive.withPackages
          (ps: with ps; [
            dvisvgm
            xetex
            fontspec
            graphics # graphicx rotating
            tools # longtable
            wrapfig
            ulem
            amsmath
            amsfonts
            capt-of
            hyperref
          ])
        )
      ];

    file = { };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
}
