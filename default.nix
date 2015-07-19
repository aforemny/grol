rec {

  pkgs = import <nixpkgs> {};

  ghc = pkgs.haskell.packages.ghc784.ghcWithPackages ( pkgs: with pkgs;
    [ elm-reactor elm-compiler elm-make elm-package ]
  );

  env = pkgs.buildEnv {
    name = "grol";
    paths = [ ghc ];
  };

}
