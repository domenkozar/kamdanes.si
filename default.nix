{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, bytestring, cabal-install
      , configurator, hspec, hspec-wai, http-types, lens, lens-aeson
      , monad-logger, persistent, persistent-postgresql
      , persistent-template, resourcet, scotty, stdenv, text, time
      , timeit, transformers, wai, wai-extra, wai-middleware-static, warp
      , wreq
      }:
      mkDerivation {
        pname = "kamdanes";
        version = "0.0.1";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          aeson base bytestring configurator hspec hspec-wai http-types lens
          lens-aeson monad-logger persistent persistent-postgresql
          persistent-template resourcet scotty text time timeit transformers
          wai wai-extra wai-middleware-static warp wreq
        ];
        testHaskellDepends = [ cabal-install hspec ];
        homepage = "https://github.com/iElectric/kamdanes.si";
        description = "kamdanes.si website";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                      then pkgs.haskellPackages
                      else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
