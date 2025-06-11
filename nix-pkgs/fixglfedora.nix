{ linkFarm
, rpm
, runCommand
, writeScriptBin
, runtimeShell
, pcre
, lib
, ...
}:
let
  inherit (lib) splitString;
  inherit (builtins) concatStringsSep readFile;
in
let
  grabPackageLibraryPath = pkgs:
    let
      pkgstr = concatStringsSep " " pkgs;
    in
    runCommand "gl-lib-path-from-fedora-rpm"
      { __noChroot = true; }
      ''
        ${rpm}/bin/rpm -ql ${pkgstr} | ${pcre}/bin/pcregrep "^/usr/lib(64)?/.*\.so\.\d" > $out || touch "$out"
      '';

  mkLinkFarmEntryFromFile = libraryPathFile:
    let
      lines = builtins.filter (s: s != "") (splitString "\n" (builtins.readFile libraryPathFile));
    in
    if lines != [ ]
    then map (line: { name = baseNameOf line; path = line; }) lines
    else throw "found 0 libpath, build failure.";


  writeGLScript = { name, ldpath }:
    writeScriptBin name
      ''
        #!${runtimeShell}

        export LD_LIBRARY_PATH=${ldpath}"''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec "$@"
      '';
in
writeGLScript {
  name = "fix-gl-fedora-wrapper";
  ldpath = linkFarm "fake-gl-lib-path-for-fedora"
    (mkLinkFarmEntryFromFile
      (grabPackageLibraryPath
        [
          "libglvnd"
          "libglvnd-egl"
          "libglvnd-gles"
          "libglvnd-glx"
          "libglvnd-opengl"
          "xorg-x11-drv-nvidia-cuda-libs"
          "xorg-x11-drv-nvidia-libs"
          "libXext"
        ]));
}
