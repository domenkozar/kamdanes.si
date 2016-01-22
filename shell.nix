{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7103" }:

let
   overrideCabal = drv: f: drv.override (args: args // {
     mkDerivation = drv: args.mkDerivation (drv // f drv);
   });
   kamdanes = import ./default.nix { };
in (overrideCabal kamdanes (drv: {
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ nixpkgs.pkgs.haskell.packages."${compiler}".reserve ];
    executableHaskellDepends = drv.executableHaskellDepends ++ [ nixpkgs.pkgs.haskell.packages."${compiler}".reserve ];
})).env
