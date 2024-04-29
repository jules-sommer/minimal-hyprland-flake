{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  options.xeta.git = {
    enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf config.xeta.git.enable {
    environment.systemPackages = with pkgs; [
      git-lfs
      git
      lazygit
      github-copilot-cli
      gitoxide
      nix-prefetch-git
    ];

    programs.git = {
      enable = true;
    };
  };
}
