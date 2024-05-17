{ lib, inputs, pkgs, stdenv, ... }:
let
  mkNeovimPlugin = inputs.nixvim.lib.${pkgs.system}.helpers.mkNeovimPlugin;
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
in
(buildVimPlugin {
  pname = "supermaven-nvim";
  version = "2024-05-15";
  src = pkgs.fetchFromGitHub {
    owner = "supermaven-inc";
    repo = "supermaven-nvim";
    rev = "98c2821c985ec751df46c033c5494079dce61522";
    hash = "sha256-RDR0roywtO3brqj/78aBxsxjiUWrn4Yxx5y7TlgQirI=";
  };
  meta.homepage = "https://github.com/supermaven-inc/supermaven-nvim";
})


