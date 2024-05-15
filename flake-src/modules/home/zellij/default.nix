{ pkgs
, config
, lib
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) std;
  cfg = config.xeta.zellij;
  dotfiles = config.xeta.dotfiles;

  zjharpoon = {
    path = "${pkgs.zjharpoon}/bin/zjharpoon.wasm";
  };
  zjstatus = {
    path = "${pkgs.zjstatus}/bin/zjstatus.wasm";
    dest = "${dotfiles}/zellij/layout/zjstatus-nix.kdl";
  };
  monocle = {
    path = "${pkgs.zjmonocle}/bin/zjmonocle.wasm";
  };
in
{
  options.xeta.zellij = {
    enable = mkEnableOption "Enable zellij.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ zellij ];
    home.file.${zjstatus.dest}.text = ''
      layout {
          default_tab_template {
            children
            pane size=1 borderless=true {
              plugin location="${zjstatus.path}" {
                format_left   "{mode} #[fg=#89B4FA,bold]{session}"
                format_center "{tabs}"
                format_right  "{command_git_branch} {datetime}"
                format_space  ""

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=#6C7086]{char}"
                border_position "top"

                hide_frame_for_single_pane "true"

                mode_normal  "#[bg=blue] "
                mode_tmux    "#[bg=#ffc387] "

                tab_normal   "#[fg=#6C7086] {name} "
                tab_active   "#[fg=#9399B2,bold,italic] {name} "

                command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                command_git_branch_format      "#[fg=blue] {stdout} "
                command_git_branch_interval    "10"
                command_git_branch_rendermode  "static"

                datetime        "#[fg=#6C7086,bold] {format} "
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "America/Toronto"
              }
            }
          }
        }
    '';

    programs.zellij =
      {
        enable = true;

        settings =
          {
            theme = "catppuccin-mocha";
            defaultLayout = "compact";
            defaultMode = "locked";

            # keybinds

            keybinds = {
              # normal = {
              #   "Tab" = "GoToNextTab";
              #   "Shift Tab" = "GoToPreviousTab";
              #
              #   "h" = "MoveFocus Left";
              #   "j" = "MoveFocus Down";
              #   "k" = "MoveFocus Up";
              #   "l" = "MoveFocus Right";
              #
              #   "Shift h" = "Resize Left";
              #   "Shift j" = "Resize Down";
              #   "Shift k" = "Resize Up";
              #   "Shift l" = "Resize Right";
              #
              #   "Ctrl h" = "NewPane Left";
              #   "Ctrl j" = "NewPane Down";
              #   "Ctrl k" = "NewPane Up";
              #   "Ctrl l" = "NewPane Right";
              #
              #   "Ctrl x" = "CloseFocus";
              #   "Ctrl n" = "NewTab";
              #   "Ctrl Shift x" = "CloseTab";
              # };
            };

            # plugins
            plugins = {
              zjharpoon = {
                path = "${pkgs.zjharpoon}/bin/zjharpoon.wasm";
              };
              zjstatus = {
                path = "${pkgs.zjstatus}/bin/zjstatus.wasm";
              };
              monocle = {
                path = "${pkgs.zjmonocle}/bin/zjmonocle.wasm";
              };
            };
          };
      };
  };
}
