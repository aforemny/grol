rec {

  pkgs = import <nixpkgs> {};

  env = pkgs.buildEnv {
    name = "grol";
    paths = with pkgs.haskellPackages; [
      elm-compiler elm-reactor elm-make elm-package elm-repl
    ];
  };

}
