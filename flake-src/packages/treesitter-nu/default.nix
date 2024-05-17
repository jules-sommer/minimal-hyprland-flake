{ lib, inputs, pkgs, stdenv, ... }:
(pkgs.tree-sitter.buildGrammar {
  version = "0.0.1";
  language = "nu";
  src = (pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = "a58513279e98dc3ff9ed149e3b4310cbb7e11068";
    hash = "sha256-LCY/DM0GqWpJJgwjZEPOadEElrFc+nsKX2eSqBTidwM=";
  });
})


