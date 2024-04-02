{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) enabled disabled;
  cfg = config.xeta.system.programs.distrobox;
in {
  options.xeta.system.programs.distrobox = {
    enable = mkEnableOption "Enable distrobox";
  };

  config = mkIf cfg.enable {

    services = {
      qemuGuest = enabled;
      spice-vdagentd = enabled;
      spice-webdavd = enabled;
    };

    environment.systemPackages = with pkgs; [ distrobox boxbuddy ];

    virtualisation = {
      # currently docker is disabled because
      # we are using podman with dockerCompat
      # which is a functional replacement
      docker = disabled;
      libvirtd = enabled;

      virtualbox = {
        host = {
          enable = true;
          enableExtensionPack = true;
        };
        guest = enabled;
      };

      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
