{
  lib,
  pkgs,
  config,
  systems,
  ...
}:
# User information gathered by Snowfall Lib is available.
let
  inherit (lib.xeta) enabled;
  meta = (builtins.fromTOML (builtins.readFile (lib.snowfall.fs.get-file "systems.toml")));
  traced = builtins.trace meta "meta";
in
{
  xeta = {
    dotfiles = "/home/jules/020_config";
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
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          indent-guides = {
            render = true;
            character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
            skip-levels = 1;
          };
        };
        language = [
          {
            name = "rust";
            autopairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";
              "\"" = "\"";
              "`" = "`";
              "<" = ">";
            };
          }
        ];
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
