{ lib, pkgs, config, systems, ... }:
# User information gathered by Snowfall Lib is available.
let
  meta = (builtins.fromTOML
    (builtins.readFile (lib.snowfall.fs.get-file "systems.toml")));
  traced = builtins.trace meta "meta";
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
    username = lib.mkDefault "meta.systems.gaboxadol.username";
    packages = with pkgs; [
      vesktop
      github-desktop
      warp-terminal
      vscode-with-extensions
      bitwarden
      bitwarden-cli
      floorp
    ];
    shellAliases = { vimdiff = "nvim -d"; };
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
      userName = "jule-ssommer";
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
