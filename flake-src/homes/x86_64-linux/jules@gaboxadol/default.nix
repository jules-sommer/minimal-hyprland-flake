{ lib, pkgs, config, systems, ... }:
# User information gathered by Snowfall Lib is available.
let
  inherit (lib.xeta) enabled;
  meta = (builtins.fromTOML
    (builtins.readFile (lib.snowfall.fs.get-file "systems.toml")));
  traced = builtins.trace meta "meta";
in {
  xeta = {
    home = {
      dotfiles = "/home/jules/020_config";
      starship = enabled;
      alacritty = enabled;
      nushell = enabled;
      desktop = {
        hyprland = {
          enable = true;
          theme = "synth-midnight-dark";
        };
      };
      misc = enabled;
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
