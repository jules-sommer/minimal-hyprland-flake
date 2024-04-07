{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkMerge;
  inherit (lib.lists) optional;
  inherit (lib.xeta) enabled mkOpt mkListOf mkBoolOpt;

  cfg = config.xeta.system.graphics;
in {
  options.xeta.system.graphics = with types; {
    enable = mkEnableOption "Enable graphics config.";
    nvidia = {
      enable = mkEnableOption
        "Enable nvidia drivers, either open-source nouveau or proprietary.";
      drivers = mkOpt (nullOr (listOf str)) [ ]
        "If nvidia drivers are enabled, this setting specifies a list of driver pkgs to use.";
      channel = mkOpt
        (nullOr (types.enum ([ "stable" "beta" "production" "vulkan_beta" ])))
        "beta"
        "Nvidia driver channel to track, must be stable, beta, or production.";
    };
    opengl = mkEnableOption "Enable OpenGL support";
  };

  config = mkIf cfg.enable {
    hardware.opengl = mkIf cfg.opengl ({
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    });

    environment.systemPackages = with pkgs; [ nvtop ];

    # Fixing suspend/wakeup issues with Nvidia drivers
    # "https://wiki.hyprland.org/Nvidia/"
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
    boot.extraModprobeConfig = ''
      options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3;"
    '';

    services.xserver.videoDrivers = [ "nouveau" ];
    boot.blacklistedKernelModules = [ "nvidia" ];
    hardware.nvidia = {
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
  };
}
