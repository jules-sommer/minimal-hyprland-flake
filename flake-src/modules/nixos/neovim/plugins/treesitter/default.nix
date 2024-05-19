{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;
  inherit (pkgs.xeta) treesitter-nu;

  home = config.xeta.system.user.home;
  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  cfg = config.xeta.nixvim.plugins.treesitter;
in
{
  options.xeta.nixvim.plugins.treesitter = {
    enable = mkEnableOption "enable treesitter";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;
        nixGrammars = true;
        nixvimInjections = true;
        indent = true;
        languageRegister.nu = "nu";
        parserInstallDir = "${home}/.local/share/treesitter/parsers";
        grammarPackages = plugins.nvim-treesitter.passthru.allGrammars ++ [
          treesitter-nu
        ];
      };
      extraFiles = {
        "queries/nu/highlights.scm" = builtins.readFile "${treesitter-nu}/queries/nu/highlights.scm";
        "queries/nu/injections.scm" = builtins.readFile "${treesitter-nu}/queries/nu/injections.scm";
      };
    };
  };
}


