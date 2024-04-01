{ pkgs, config, lib, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  palette = lib.xeta.getTheme (config.xeta.desktop.hyprland.theme);
in {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    cycle = true;
    font = "JetBrains Mono";
    package = pkgs.rofi-wayland;
    theme = {
      "*" = {
        bg = mkLiteral
          "#${palette.base00}"; # Replace with your ${palette.base00} value
        "background-color" = mkLiteral "@bg";
      };

      configuration = {
        "show-icons" = true;
        "icon-theme" = "Papirus";
        location = 0;
        font = "JetBrains Mono";
        "display-drun" = "Launch:";
      };

      window = {
        width = mkLiteral "35%";
        transparency = "real";
        orientation = "vertical";
        "border-color" = mkLiteral
          "#${palette.base0B}"; # Replace with your ${palette.base0B} value
        "border-radius" = 10;
      };

      mainbox = { children = map mkLiteral [ "inputbar" "listview" ]; };

      element = {
        padding = mkLiteral "4 12";
        "text-color" = mkLiteral
          "#${palette.base05}"; # Replace with your ${palette.base05} value
        "border-radius" = 5;
      };

      "element selected" = {
        "text-color" = mkLiteral
          "#${palette.base01}"; # Replace with your ${palette.base01} value
        "background-color" = mkLiteral
          "#${palette.base0B}"; # Replace with your ${palette.base0B} value
      };

      "element-text" = {
        "background-color" = mkLiteral "inherit";
        "text-color" = mkLiteral "inherit";
      };

      "element-icon" = {
        size = mkLiteral "16 px";
        "background-color" = mkLiteral "inherit";
        padding = mkLiteral "0 6 0 0";
        alignment = "vertical";
      };

      listview = {
        columns = 2;
        lines = 9;
        padding = mkLiteral "8 0";
        "fixed-height" = true;
        "fixed-columns" = true;
        "fixed-lines" = true;
        border = mkLiteral "0 10 6 10";
      };

      entry = {
        "text-color" = mkLiteral
          "#${palette.base05}"; # Replace with your ${palette.base05} value
        padding = mkLiteral "10 10 0 0";
        margin = mkLiteral "0 -2 0 0";
      };

      inputbar = {
        "background-image" =
          mkLiteral ''url("~/.config/rofi/rofi.jpg", width)'';
        padding = mkLiteral "180 0 0";
        margin = mkLiteral "0 0 0 0";
      };

      prompt = {
        "text-color" = mkLiteral
          "#${palette.base0D}"; # Replace with your ${palette.base0D} value
        padding = mkLiteral "10 6 0 10";
        margin = mkLiteral "0 -2 0 0";
      };
    };
    plugins = with pkgs; [
      rofimoji
      rofi-vpn
      rofi-rbw-wayland
      rofi-file-browser
      rofi-power-menu
      rofi-pulse-select
      rofi-systemd
      rofi-screenshot
      rofi-calc
    ];
  };

  home.file.${"${config.xeta.dotfiles}/rofi/config.rasi"}.text = ''
    @theme "/dev/null"

    * {
        bg: #${palette.base00};
        background-color: @bg;
    }

    configuration {
      show-icons: true;
      icon-theme: "Papirus";
      location: 0;
      font: "Ubuntu 12";	
      display-drun: "Launch:";
    }

    window { 
      width: 35%;
      transparency: "real";
      orientation: vertical;
      border-color: #${palette.base0B};
        border-radius: 10px;
    }

    mainbox {
      children: [inputbar, listview];
    }


    // ELEMENT
    // -----------------------------------

    element {
      padding: 4 12;
      text-color: #${palette.base05};
        border-radius: 5px;
    }

    element selected {
      text-color: #${palette.base01};
      background-color: #${palette.base0B};
    }

    element-text {
      background-color: inherit;
      text-color: inherit;
    }

    element-icon {
      size: 16 px;
      background-color: inherit;
      padding: 0 6 0 0;
      alignment: vertical;
    }

    listview {
      columns: 2;
      lines: 9;
      padding: 8 0;
      fixed-height: true;
      fixed-columns: true;
      fixed-lines: true;
      border: 0 10 6 10;
    }

    // INPUT BAR 
    //------------------------------------------------

    entry {
      text-color: #${palette.base05};
      padding: 10 10 0 0;
      margin: 0 -2 0 0;
    }

    inputbar {
      background-image: url("~/.config/rofi/rofi.jpg", width);
      padding: 180 0 0;
      margin: 0 0 0 0;
    } 

    prompt {
      text-color: #${palette.base0D};
      padding: 10 6 0 10;
      margin: 0 -2 0 0;
    }
  '';
}
