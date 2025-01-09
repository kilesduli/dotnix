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

      lib = inputs.nixpkgs.lib // import ./nix-pkgs/lib.nix { inherit (inputs.nixpkgs) lib; inherit system; };

      # This overlay do:
      #   * call all packages definition in ./nix-pkgs use callPackageFromDirectory
      nix-pkgs = final: prev:
        let
          sources = prev.callPackage ./nix-pkgs/_sources/generated.nix { };
        in
        lib.callPackageFromDirectory {
          callPackage = prev.lib.callPackageWith (prev // sources);
          directory = ./nix-pkgs;
        };

      # This overlay do:
      #   * merge inputs.xxxxx.packages."${system}" into pkgs
      #   * if only have packages."${system}".default, rename to xxxxx(inputs name)
      merge-inputs-packages = inputs: final: prev:
        with prev.lib;
        let
          inputs-packages = name: value:
            let
              isOnlyDefault = packages: (length (attrNames packages) == 1) && hasAttr "default" packages;
              packages = value.packages."${system}";
            in
            if isOnlyDefault packages
            then { "${name}" = packages.default; }
            else removeAttrs packages [ "default" ];
        in
        mergeAttrsList (mapAttrsToList inputs-packages inputs);

      overlays = [
        inputs.emacs-overlay.overlays.package
        inputs.nixgl.overlay
        inputs.nvfetcher.overlays.default
        nix-pkgs
        (merge-inputs-packages {
          inherit (inputs) ghostty;
        })
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

      packages."${system}" = {
        # boost build time
        emacs-master-test = pkgs.emacs-master.override { withNativeCompilation = false; };
        emacs-master-igc-test = pkgs.emacs-master-igc.override {  withNativeCompilation = false; };
      };
    };
}
