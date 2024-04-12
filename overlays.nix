{ inputs }:
[
  inputs.emacs-overlay.overlay
  (import ./emacs/overlay-without-im.nix)
]
