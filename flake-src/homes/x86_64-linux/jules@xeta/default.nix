{ lib
, pkgs
, config
, ...
}:
# User information gathered by Snowfall Lib is available.
let
  inherit (lib.xeta) enabled mkOpt;
  inherit (lib) types;
in
{
  xeta = {
    home = "/home/jules";
    dotfiles = "${config.xeta.home}/070_dotfiles/010_nix-managed";
    starship = enabled;
    tty = {
      kitty = enabled;
      alacritty = enabled;
    };
    zellij = enabled;
    nushell = enabled;
    misc = enabled;
    gnome = enabled;

    services.pueued = enabled;

    desktop = {
      waybar = enabled;
      hyprland = {
        enable = true;
        theme = "tokyo-night-dark";
      };
      pyprland = enabled;
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
      wl-clipboard
      wl-clip-persist
      pavucontrol
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
