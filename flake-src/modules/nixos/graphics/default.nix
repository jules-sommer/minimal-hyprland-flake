{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkMerge;
  inherit (lib.lists) optional;
  inherit (lib.xeta) enabled mkOpt mkListOf mkBoolOpt;

  cfg = config.xeta.system.graphics or { };
in {
  options.xeta.system.graphics = with types; {
    nvidia = {
      enable = mkEnableOption "Enable nvidia drivers, either open-source nouveau or proprietary.";
      drivers = mkOpt (nullOr (listOf str)) [ ] "If nvidia drivers are enabled, this setting specifies a list of driver pkgs to use.";
      channel = mkOpt (nullOr (types.enum (["stable" "beta" "production" "vulkan_beta"]))) null "Nvidia driver channel to track, must be stable, beta, or production.";
    };
    opengl = mkEnableOption "Enable OpenGL support";
  };

  config = mkMerge [
    (mkIf cfg.opengl {
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    })

    (mkIf (cfg.nvidia.drivers != null) {
      services.xserver.videoDrivers = cfg.nvidia.drivers; # "nvidia" or "nouveau"
      boot.blacklistedKernelModules =
        mkIf (lib.lists.elem "nvidia" cfg.nvidia.drivers) [ "nouveau" ];
      hardware.nvidia = mkIf (lib.lists.elem "nvidia" cfg.nvidia.drivers) {
        # Modesetting is required.
        modesetting.enable = true;
        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        powerManagement.enable = false;
        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;
        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;
        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;
        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.nvidia.channel};
      };
    })
  ];
}
