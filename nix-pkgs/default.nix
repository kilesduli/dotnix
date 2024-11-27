with builtins;
let
  mapPackages =
    let
      filterDir = dir:
        (filter (v: v != null)
                (attrValues (mapAttrs (k: v:
                                          if v == "directory" && k != "_sources"
                                          then k
                                          else null)
                                      dir)));
    in
    callPackage:
    (listToAttrs (map (name: { inherit name; value = (callPackage name); })
                      (filterDir (readDir ./.))));
in
rec {
  overlay =
    final: prev:
    mapPackages (
      name:
      let
        sources = final.callPackage ./_sources/generated.nix { };
        package = import ./${name};
        args = builtins.intersectAttrs (builtins.functionArgs package) sources;
      in
      final.callPackage package args
    );
}
