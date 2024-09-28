{ qt6 }:
let
  fn =
    { lib
    , ccacheStdenv
    , installShellFiles
    , fetchFromGitHub
    , freetype
    , gumbo
    , harfbuzz
    , jbig2dec
    , mujs
    , mupdf
    , openjpeg
    , qt3d
    , qtbase
    , qmake
    , qtspeech
    , wrapQtAppsHook
    }:
    ccacheStdenv.mkDerivation (finalAttrs: {
      pname = "sioyek";
      version = "2.0.0-unstable-2024-09-27";

      src = fetchFromGitHub {
        owner = "ahrm";
        repo = "sioyek";
        rev = "ae733e927a4bddc49abe81b96a1d96361736ea52";
        hash = "sha256-kErb8PZmp670D7/+oJfKllVD/ypgNNFdx74kIaYiXsw=";
      };

      buildInputs = [
        gumbo
        harfbuzz
        jbig2dec
        mujs
        mupdf
        openjpeg
        qt3d
        qtbase
        qtspeech
      ]
      ++ lib.optionals ccacheStdenv.isDarwin [ freetype ];

      nativeBuildInputs = [
        installShellFiles
        qmake
        wrapQtAppsHook
      ];

      qmakeFlags = lib.optionals ccacheStdenv.isDarwin [ "CONFIG+=non_portable" ];

      postPatch = ''
        substituteInPlace pdf_viewer_build_config.pro \
          --replace "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2" \
          --replace "-lmupdf-third" ""
        substituteInPlace pdf_viewer/main.cpp \
          --replace "/usr/share/sioyek" "$out/share" \
          --replace "/etc/sioyek" "$out/etc"
      '';

      postInstall =
        if ccacheStdenv.isDarwin then ''
          cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
          cp pdf_viewer/{prefs,prefs_user,keys,key_user}.config tutorial.pdf sioyek.app/Contents/MacOS/

          mkdir -p $out/Applications $out/bin
          cp -r sioyek.app $out/Applications
          ln -s $out/Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek
        '' else ''
          install -Dm644 tutorial.pdf $out/share/tutorial.pdf
          cp -r pdf_viewer/shaders $out/share/
          install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
          installManPage resources/sioyek.1
        '';

      meta = with lib; {
        homepage = "https://sioyek.info/";
        description = "A PDF viewer designed for research papers and technical books";
        changelog = "https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}";
        license = licenses.gpl3Only;
        maintainers = with maintainers; [ podocarp xyven1 ];
        platforms = platforms.unix;
      };
    });
in
qt6.callPackage fn {}
