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
        dotfiles =
          "${config.xeta.system.user.home}/070_dotfiles/010_nix-managed";
      };

      development = {
        rust = enabled;
        zig = enabled;
      };

      portals = enabled;
      desktop = {
        hyprland = enabled;
        greeter = enabled;
      };

      programs = {
        dconf = enabled;
        snowfall-utils = enabled;
        distrobox = enabled;
        rustdesk = {
          enable = true;
          relayIP = "24.141.46.69";
        };
      };

      graphics = {
        enable = true;
        nvidia = {
          enable = true;
          drivers = [ "nouveau" ];
          channel = "stable";
        };
        opengl = true;
        electron_support = enabled;
      };

      hostname = "xeta";
      fonts = enabled;
      env = enabled;
      networking = enabled;

      input = {
        kbd = {
          enable = true;
          layout = "us";
        };
      };

      services = {
        filesystem = enabled;
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
    security = {
      doas = enabled;
      keyring = enabled;
      tor = enabled;
    };
    crypto = {
      monero = {
        enable = true;
        mining = {
          enable = true;
          address =
            "83Dt82wJ8T98f39nMV11av8CePi4UPhfz1to5uCB6i5cUhWyJvgVRJGPuj1NVkYckPboqkKc7PVSiT4zUUQBaRZQ9qZXxEt";
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
  environment.shells = with pkgs; [ nushell zsh ];

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
    zoxide
    broot
    ripgrep
    fd
    bat
    github-copilot-cli
    gitoxide
    helix
    pzip
    nixfmt
    helvum
    webcord-vencord

    nushell
    alacritty
    ntfs3g
    fuseiso
    kitty

    nufmt

    xz
    jq
    fd
    jql
    jq-lsp
    zoxide
    apx

    obsidian
    grim
    grimblast
    slurp

    networkmanagerapplet
    polkit_gnome

    lcsync
    librespot
    libresprite

    # broken due to 'freeimage-unstable-2021-11-01',
    # see /overlays/librepcb-stable/default.nix
    librepcb

    chromium

    gtk3
    gtk3.dev
    gtk4

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
    steam = {
      enable = true;
      gamescopeSession = enabled;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  security.pam.services.tuigreet = {
    text = ''
      auth include login
    '';
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
