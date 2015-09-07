{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:

let
   overrideCabal = drv: f: drv.override (args: args // {
     mkDerivation = drv: args.mkDerivation (drv // f drv);
   });
   kamdanes = import ./default.nix { };
in (overrideCabal kamdanes (drv: {
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ nixpkgs.pkgs.haskell.packages.ghc7102.reserve ];
    executableHaskellDepends = drv.executableHaskellDepends ++ [ nixpkgs.pkgs.haskell.packages.ghc7102.reserve ];
})).env
