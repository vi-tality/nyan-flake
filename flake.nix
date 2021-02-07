{
  description = "Free (as in freedom) open source clone of the Age of Empires II engine";

  inputs = {
    nyan = { url = github:SFTtech/nyan; flake = false; };
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages."${system}";
    let
      nyan = nixpkgs.legacyPackages."${system}".stdenv.mkDerivation {

        pname = "nyan";
        version = "master";
        src = inputs.nyan;

        buildInputs = [
          flex
          git
          cmake
          eigen
          epoxy
          fontconfig
          freetype
          harfbuzz
          libogg
          libpng
          lz4
          SDL2
          SDL2_image
          opusfile
          (qtEnv "nyan-qt-env" (with qt5; [
            qtquick1
            #qmake
            qtcharts
            qtconnectivity
            qtdeclarative
            qtdoc
            #qtgamepad
            qtgraphicaleffects
            qtimageformats
            qtlocation
            qtmultimedia
            qtnetworkauth
            qtquickcontrols
            qtquickcontrols2
            qtscript
            qtscxml
            qtsensors
            qtserialport
            qtspeech
            qtsvg
            qttools
            qttranslations
            qtvirtualkeyboard
            #qtwayland
            qtwebchannel
            qtwebengine
            qtwebglplugin
            qtwebkit
            qtwebsockets
            qtwebview
            qtx11extras
            qtxmlpatterns
          ]))
        ];
        propagatedBuildInputs = [
          (python3.buildEnv.override {
            extraLibs = with pkgs.python3Packages; [
              cython
              numpy
              jinja2
              lz4
              pillow
              pygments
              toml
            ];
          })
          dejavu_fonts
          git
        ];

      };
    in
    rec {
      defaultPackage = nyan;

      apps = {
        nyan = flake-utils.lib.mkApp {
          drv = defaultPackage;
          name = "nyan";
        };
      };

    });
}
