{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:

let
   overrideCabal = drv: f: drv.override (args: args // {
     mkDerivation = drv: args.mkDerivation (drv // f drv);
   });
   kamdanes = nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./kamdanes.nix { };
in overrideCabal kamdanes (drv: {
  postInstall = ''
    cp -R static $out/
  '';
})
