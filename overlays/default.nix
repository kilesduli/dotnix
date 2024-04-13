{ inputs }:
[
  inputs.emacs-overlay.overlay
  inputs.nur-xddxdd.overlays.default
  (import ./emacs-overlay-without-im.nix)
  (import ./librime-overlay-with-lua54.nix)
]
