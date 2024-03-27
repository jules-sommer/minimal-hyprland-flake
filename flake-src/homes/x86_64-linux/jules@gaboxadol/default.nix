{ lib, pkgs, config, ... }:
# User information gathered by Snowfall Lib is available.
let
in {
  xeta = {
    home = {
      desktop = {
        hyprland = {
          enable = true;
          theme = "synth-midnight-dark";
        };
      };
    };
  };
  home = {

    packages = with pkgs; [ neovim firefox ];

    sessionVariables = { EDITOR = "nvim"; };

    shellAliases = { vimdiff = "nvim -d"; };

    stateVersion = "23.11";
  };
}
