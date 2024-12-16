{
  description = "Nix configuration of duli";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixos-stable";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # use nix offcial lib make it easy to use;
      nix-pkgs = final: prev:
        let
          sources = prev.callPackage ./nix-pkgs/_sources/generated.nix { };
          packages = prev.lib.packagesFromDirectoryRecursive {
            callPackage = prev.lib.callPackageWith (prev // sources);
            directory = ./nix-pkgs;
          };
        in
        prev.lib.removeAttrs packages [ "_sources" ];

      merge-inputs-packages = inputs: final: prev:
        let
          inputs-packages = name: value:
            let
              isOnlyDefault = packages: (with builtins; length (attrNames packages) == 1) && packages.getAttr "default" packages;
              packages = value.packages."${system}";
            in
            if isOnlyDefault packages
            then { name = packages.default; }
            else prev.lib.removeAttrs packages [ "default" ];
          packagesList = prev.lib.mapAttrsToList inputs-packages inputs;
        in
        prev.lib.mergeAttrsList packagesList;

      overlays = [
        inputs.emacs-overlay.overlay
        inputs.nixgl.overlay
        nix-pkgs
        (merge-inputs-packages {
          inherit (inputs) ghostty;
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
      lib = pkgs.lib;
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
