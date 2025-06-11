{ self, config, lib, pkgs, ... }:

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
        tokei
        atuin
        zoxide
        pyenv

        # go related
        go
        golangci-lint
        gomodifytags
        gopls
        gore
        gotests

        # nix
        nixd
        nixpkgs-fmt
        nix-output-monitor
        nvfetcher

        # gui tools and sofeware
        menulibre
        pavucontrol
        screenkey
        vial
        vscode
        calibre
        sioyek

        # openGL related fix
        nixgl.auto.nixGLDefault
        fixglfedora

        # emacs related
        librime-with-plugins
        xclip
        emacs-lsp-booster
        tdlib

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

        # go
        spicetify-cli

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
