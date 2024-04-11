{
  description = "Nix configuration of duli";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ emacs-overlay.overlays.emacs ] ++ (import ./overlays.nix); };
    in {
      homeConfigurations.duli = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home/home.nix ./emacs/emacs.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
