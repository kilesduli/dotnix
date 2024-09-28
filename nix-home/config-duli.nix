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
        menulibre
        pavucontrol
        screenkey
        vial
        vscode
        calibre-enhanced
        sioyek-patched

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

        # python
        pipx

        # ime-frontend
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        kdePackages.fcitx5-qt
      ];

    file = { };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
}
