{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkEnableOption recursiveUpdate;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.starship;

in {
  options.xeta.starship = {
    enable = mkEnableOption "Enable starship prompt";
    theme = mkOpt types.str "mocha"
      "Starship prompt theme ( one of: `latte`, `frappe`, `macchiato`, or `mocha` )";
  };

  config = let
    # define the catppuccin palette which is merged into programs.starship.settings
    cattpuccin_palette = (builtins.fromTOML (builtins.readFile
      (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "starship";
        rev = "5629d23";
        sha256 = "nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      } + /palettes/${cfg.theme}.toml)));
    config = (builtins.fromTOML (builtins.readFile ./starship.toml));
  in lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = (recursiveUpdate (cattpuccin_palette // config) {
        # Other config here
        format =
          "[╭─ ](#ff3311)$directory$container$all$cmd_duration$line_break[╰─](#ff3311)$jobs$status$username$hostname$character"; # Remove this line to disable the default prompt format
        right_format = "$time$shell$sudo";
        palette = "catppuccin_${cfg.theme}";
      });
    };
  };
}
