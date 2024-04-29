{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    mkMerge
    ;
  inherit (lib.lists) optional;
  inherit (lib.xeta) mkOpt;

  cfg = config.xeta.system.graphics;
in
{
  options.xeta.system.graphics = with types; {
    enable = mkEnableOption "Enable graphics config.";
    amd = {
      enable = mkEnableOption "Enable amdgpu drivers, either open-source or proprietary.";
    };
    nvidia = {
      enable = mkEnableOption "Enable nvidia drivers, either open-source nouveau or proprietary.";
      modesetting = mkEnableOption "Enable modesetting support for nvidia drivers.";
      drivers = mkOpt (nullOr (listOf str)) [
        "nvidia" # default
      ] "If nvidia drivers are enabled, this setting specifies a list of driver pkgs to use.";
      channel = mkOpt (nullOr (
        types.enum ([
          "stable"
          "beta"
          "production"
          "vulkan_beta"
        ])
      )) "beta" "Nvidia driver channel to track, must be stable, beta, or production.";
      nuclearPowerAlwaysOn = mkEnableOption "Enable nuclear power management, which will always turn on the GPU when the system is idle.";
    };
    opengl = mkEnableOption "Enable OpenGL support";
  };

  config = mkIf cfg.enable {
    hardware.opengl = mkIf cfg.opengl ({
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages32 = (mkIf cfg.amd.enable [ pkgs.driversi686Linux.amdvlk ]);
      extraPackages =
        with pkgs;
        mkMerge [
          (mkIf cfg.amd.enable [
            amdvlk
            rocmPackages.clr.icd
          ])
          (mkIf cfg.nvidia.enable [
            nvidia-vaapi-driver
            vaapiVdpau
            libvdpau-va-gl
            libva-utils
          ])
          (mkIf cfg.opengl [
            meson
            vulkan-tools
          ])
        ];
    });

    environment = {
      variables = {
        ROC_ENABLE_PRE_VEGA = "1";
      };
      systemPackages =
        with pkgs;
        mkMerge [
          (mkIf cfg.amd.enable [
            nvtopPackages.amd
            clinfo
            radeontop
          ])
          (mkIf cfg.nvidia.enable [ nvtopPackages.nvidia ])
        ];
    };
    boot.initrd.kernelModules = (mkIf cfg.amd.enable [ "amdgpu" ]);

    # Fixing suspend/wakeup issues with Nvidia drivers
    # "https://wiki.hyprland.org/Nvidia/"
    boot.kernelParams = (
      mkMerge [
        (mkIf (cfg.amd.enable) [ "amdgpu" ])
        (mkIf (cfg.nvidia.enable) [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ])
      ]
    );

    # Most software has the HIP libraries hard-coded. Workaround:
    systemd.tmpfiles.rules = mkIf cfg.amd.enable [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # Disabling power management for now, nuclear option for fixing graphics issues.
    # More info on hyprland wiki: https://wiki.hyprland.org/Nvidia/

    boot.extraModprobeConfig = mkIf cfg.nvidia.nuclearPowerAlwaysOn (''
      options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3;"
    '');

    services.xserver.videoDrivers = (
      mkMerge [
        (mkIf cfg.amd.enable [ "modesetting" ])
        (mkIf cfg.nvidia.enable [ "nvidia" ])
      ]
    );

    boot.blacklistedKernelModules = mkIf cfg.nvidia.enable [ "nvidia" ];
    hardware.nvidia = (
      mkIf cfg.nvidia.enable {
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
      }
    );
  };
}
