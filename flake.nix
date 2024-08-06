{
  description = "Nix configuration of duli";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    doom-emacs = {
      url = "github:doomemacs/doomemacs/master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      selfhostpkgs = import ./nix-pkgs;
      overlays = [
        inputs.emacs-overlay.overlay
        selfhostpkgs.overlay
      ];
      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
    in
    {
      homeConfigurations.duli = home-manager.lib.homeManagerConfiguration {
        inherit lib pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./nix-home/duli.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit self; };
      };
    };
}
