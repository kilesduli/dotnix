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

    fixGL = {
      url = "github:kilesduli/fixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
          # HACK: splice.nix is called as an overlay, where callPackage is
          # final.newScope { }, thus encountering infinite recursion when
          # evaluating prev in advance. So we need remove callPackage in
          # pkgsforCall to avoid this.
          noCallPackagePrev = (removeAttrs prev [ "callPackage" ]);
          sources = prev.lib.callPackageWith noCallPackagePrev ./nix-pkgs/_sources/generated.nix { };
        in
        lib.callPackageFromDirectory {
          callPackage = prev.lib.callPackageWith (noCallPackagePrev // sources);
          directory = ./nix-pkgs;
        };

      overlays = [
        inputs.emacs-overlay.overlays.package
        inputs.nixgl.overlay
        inputs.nvfetcher.overlays.default
        inputs.fixGL.overlay
        nix-pkgs
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

      packages."${system}" = pkgs;
    };
}
