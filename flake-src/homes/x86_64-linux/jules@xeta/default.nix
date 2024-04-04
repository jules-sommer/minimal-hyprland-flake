{ lib, pkgs, config, ... }:
# User information gathered by Snowfall Lib is available.
let
  inherit (lib.xeta) enabled mkOpt;
  inherit (lib) types;
in {

  xeta = {
    home = "/home/jules";
    dotfiles = "${config.xeta.home}/070_dotfiles/010_nix-managed";
    starship = enabled;
    alacritty = enabled;
    nushell = enabled;
    misc = enabled;

    services.pueued = enabled;

    desktop = {
      hyprland = {
        enable = true;
        theme = "synth-midnight-dark";
      };
    };
  };

  home = {
    username = lib.mkDefault "jules";
    packages = with pkgs; [
      vesktop
      github-desktop
      neofetch
      warp-terminal
      vscode-with-extensions
      bitwarden
      bitwarden-cli
      floorp
    ];
    shellAliases = { };
  };

  programs = {
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "github_dark_high_contrast";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "jules-sommer";
      userEmail = "jules@rcsrc.shop";
    };
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.stateVersion = "23.11";
}
