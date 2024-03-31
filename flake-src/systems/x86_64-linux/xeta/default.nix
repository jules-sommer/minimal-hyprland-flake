{ pkgs, lib, config, ... }:
let inherit (lib.xeta) enabled;
in {

  imports = [ ./hardware.nix ];

  # our custom namespace where we defined
  # config settings for modularity :3
  xeta = {
    system = {
      user = {
        username = "jules";
        fullname = "Jules Sommer";
        home = "/home/jules";
        dotfiles = "${config.xeta.system.user.home}/020_config";
      };

      development = { rust = { fenix = enabled; }; };
      desktop = { hyprland = enabled; };
      programs = {
        snowfall-utils = enabled;
        distrobox = enabled;
        rustdesk = {
          enable = true;
          relayIP = "24.141.46.69";
        };
      };

      graphics = {
        opengl = true;
        drivers = [ "nvidia" ];
        nvidiaDriverChannel = "stable";
      };

      hostname = "xeta";
      fonts = enabled;
      env = enabled;
      networking = enabled;

      kbd = {
        enable = true;
        layout = "us";
      };

      services = {
        polkit = enabled;
        audio.pipewire = {
          enable = true;
          support = {
            alsa = true;
            pulse = true;
            jack = true;
          };
        };
      };
    };
  };

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        editor = false;
        netbootxyz = enabled;
        memtest86 = enabled;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      font =
        "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
  };

  users.defaultUserShell = pkgs.nushell;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    busybox
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jujutsu
    git
    lazygit
    starship
    rnr
    btop
    gh
    nil
    github-copilot-cli
    gitoxide
    helix
    pzip
    nixfmt
    nushell
    alacritty
    ntfs3g
    fuseiso
    kitty

    deploy-rs
    nixfmt
    nix-index
    nix-prefetch-git
    nix-output-monitor
    flake-checker

  ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs = {
    xfconf = enabled;
    dconf = enabled;
    mtr = enabled;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      gamescopeSession = enabled;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion =
    "23.11"; # This is not the system version, don't change it!!
}
