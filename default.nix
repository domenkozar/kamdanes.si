with import <nixpkgs> { };
with haskellPackages;

cabal.mkDerivation (self: {
   pname = "kamdanes";
   version = "0.0.1";
   src = ./.;
   buildDepends = [ scotty wai warp text persistent monadLogger waiMiddlewareStatic
                    persistentPostgresql persistentTemplate basePrelude aeson
                    hspecWai wreq lensAeson configurator ]
                    ++ lib.optionals lib.inNixShell [ reserve hlint ];
   buildTools = [ cabalInstall ];
   isExecutable = true;
   isLibrary = false;
   postInstall = ''
     cp -R static $out/
   '';
 })
