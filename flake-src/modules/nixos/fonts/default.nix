{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkEnableOption;
  inherit (lib.xeta) enabled mkOpt;
  cfg = config.xeta.system.fonts;
  fonts_pkgs = with pkgs; [
    font-awesome
    jetbrains-mono
    fira-code
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
in {
  options.xeta.system.fonts = {
    enable = mkEnableOption "Enable theming and fonts";
    fonts = mkOpt (types.nullOr types.enum [ "JetBrainsMono" "FiraCode" ])
      "JetBrainsMono"
      "Which Nerdfonts to install on the system. Default is JetBrainsMono";
  };

  config = lib.mkIf cfg.enable {
    # Enable the user's custom fonts
    # in the user's home configuration
    snowfallorg.user.xeta.home.config = {
      home.packages = fonts_pkgs;
      fonts.fontconfig = enabled;
    };

    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;

      packages = with pkgs; [ ubuntu_font_family jetbrains-mono fira-code ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Ubuntu" ];
          sansSerif = [ "Ubuntu" ];
          monospace = [ "JetBrains Mono Nerd Font" ];
        };
      };
    };

    environment.systemPackages = fonts_pkgs;
  };
}
