{ nixpkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/6b9c67333fe62c38f1231dd5339b776c7c3d7172.tar.gz) {}
, compiler ? "ghc7103" }:

let
   overrideCabal = drv: f: drv.override (args: args // {
     mkDerivation = drv: args.mkDerivation (drv // f drv);
   });
   kamdanes = nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./kamdanes.nix { };
in kamdanes
