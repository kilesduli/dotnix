{ inputs }:
[
  inputs.emacs-overlay.overlay
  inputs.nur-xddxdd.overlays.default
  (import ./emacs-overlay-without-im.nix)
]
