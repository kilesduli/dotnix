{
  description = "Nix configuration of duli";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.11";

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

    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nvfetcher.follows = "nvfetcher";
      };
    };

    doom-emacs = {
      url = "github:kilesduli/doomemacs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs-unstable, home-manager, emacs-overlay, ... }@from:
    let
      system = "x86_64-linux";
      overlays = (import ./overlays { inputs = self.inputs; });
      pkgs = import nixpkgs-unstable { inherit system overlays; config.allowUnfree = true; };
    in {
      homeConfigurations.duli = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home/duli.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit self; };
      };
    };
}
